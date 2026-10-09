//! List every dependency renovate detects in the repo in $PWD, with its current
//! version. Faithful port of the original zsh function, made reliable.

use std::io::{BufRead, BufReader, Read};
use std::path::Path;
use std::process::{Command, Stdio};
use std::thread;

use serde_json::Value;

const HELP: &str = "\
renovate-list — list every dependency renovate detects in the repo in $PWD

USAGE:
    renovate-list

Prints one tab-separated row per dependency: manager, package file, dependency,
current value (sorted, deduped). Requires `renovate` and `gh` on PATH; uses
`gh auth token` for GitHub access.";

// Scraped from renovate's debug log; `config` is keyed by manager and holds the
// detected package files and their deps. Emitted whenever package files exist.
const REPORT_MSG: &str = "packageFiles with updates";

fn main() {
    if let Err(e) = run() {
        eprintln!("error: {e}");
        std::process::exit(1);
    }
}

fn run() -> Result<(), String> {
    if std::env::args().skip(1).any(|a| a == "-h" || a == "--help") {
        println!("{HELP}");
        return Ok(());
    }

    if !on_path("renovate") {
        return Err("`renovate` not found on PATH (mise: npm:renovate)".into());
    }
    if !on_path("gh") {
        return Err("`gh` not found on PATH".into());
    }
    let token = capture("gh", &["auth", "token"])
        .map_err(|e| format!("could not get a GitHub token via `gh auth token`: {e}"))?;
    if token.is_empty() {
        return Err("`gh auth token` returned empty — run `gh auth login`".into());
    }

    eprintln!("→ running renovate (local platform, dry-run lookup)…");

    // GITHUB_COM_TOKEN (not RENOVATE_TOKEN) authenticates github.com datasource
    // lookups under --platform=local; without it they hit the anonymous rate limit.
    // Both via env, never argv.
    let mut child = Command::new("renovate")
        .arg("--platform=local")
        .arg("--dry-run=lookup")
        .env("RENOVATE_TOKEN", &token)
        .env("GITHUB_COM_TOKEN", &token)
        .env("LOG_FORMAT", "json")
        .env("LOG_LEVEL", "debug")
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .map_err(|e| format!("failed to start renovate: {e}"))?;

    let stdout = child.stdout.take().ok_or("renovate stdout pipe missing")?;
    let stderr = child.stderr.take().ok_or("renovate stderr pipe missing")?;

    let stderr_thread = thread::spawn(move || {
        for_each_line(stderr, |line| {
            let line = line.trim();
            if !line.is_empty() {
                eprintln!("  {line}");
            }
        });
    });

    let mut report: Option<Value> = None;
    for_each_line(stdout, |line| {
        let trimmed = line.trim();
        if trimmed.is_empty() {
            return;
        }
        let Ok(record) = serde_json::from_str::<Value>(trimmed) else {
            eprintln!("  {trimmed}");
            return;
        };
        let msg = record.get("msg").and_then(Value::as_str).unwrap_or("");
        let level = record.get("level").and_then(Value::as_u64).unwrap_or(0);
        if level >= 40 && !msg.is_empty() {
            eprintln!("  {} {msg}", if level >= 50 { "ERROR" } else { "WARN " });
        }
        if msg == REPORT_MSG {
            report = record.get("config").cloned();
        }
    });

    let status = child
        .wait()
        .map_err(|e| format!("waiting for renovate: {e}"))?;
    if stderr_thread.join().is_err() {
        eprintln!("warning: stderr reader thread panicked; some log output may be missing");
    }

    if !status.success() {
        return Err(format!(
            "renovate exited unsuccessfully ({status}); see the log above"
        ));
    }

    // Clean exit with no report = no package files here, not a failure.
    let Some(config) = report else {
        eprintln!("renovate found no package files here — nothing to check.");
        return Ok(());
    };

    let mut rows = collect(&config);
    rows.sort();
    rows.dedup();
    let mut out = String::new();
    for row in &rows {
        out.push_str(row);
        out.push('\n');
    }
    print!("{out}");
    Ok(())
}

// Lossy per-line decode so a non-UTF-8 byte degrades to U+FFFD instead of aborting
// the scan, which `lines()` would do on the first decode error.
fn for_each_line<R: Read>(src: R, mut f: impl FnMut(&str)) {
    for chunk in BufReader::new(src).split(b'\n') {
        match chunk {
            Ok(bytes) => f(&String::from_utf8_lossy(&bytes)),
            Err(e) => {
                eprintln!("  WARN  error reading renovate output: {e}");
                break;
            }
        }
    }
}

// One tab-separated row per dep: manager, packageFile, depName, current value.
fn collect(config: &Value) -> Vec<String> {
    let mut rows = Vec::new();
    let Some(managers) = config.as_object() else {
        return rows;
    };
    for (manager, package_files) in managers {
        let Some(files) = package_files.as_array() else {
            continue;
        };
        for pf in files {
            let file = str_field(pf, "packageFile").unwrap_or_default();
            let Some(deps) = pf.get("deps").and_then(Value::as_array) else {
                continue;
            };
            for dep in deps {
                let name = str_field(dep, "depName").unwrap_or_default();
                let current = str_field(dep, "currentValue")
                    .or_else(|| str_field(dep, "currentVersion"))
                    .unwrap_or_default();
                rows.push(format!("{manager}\t{file}\t{name}\t{current}"));
            }
        }
    }
    rows
}

fn str_field(v: &Value, key: &str) -> Option<String> {
    v.get(key).and_then(Value::as_str).map(str::to_string)
}

/// True if `name` resolves to an executable file on `$PATH`.
fn on_path(name: &str) -> bool {
    let Some(paths) = std::env::var_os("PATH") else {
        return false;
    };
    std::env::split_paths(&paths).any(|dir| {
        let candidate = dir.join(name);
        candidate.is_file() && is_executable(&candidate)
    })
}

#[cfg(unix)]
fn is_executable(p: &Path) -> bool {
    use std::os::unix::fs::PermissionsExt;
    p.metadata()
        .map(|m| m.permissions().mode() & 0o111 != 0)
        .unwrap_or(false)
}

#[cfg(not(unix))]
fn is_executable(_p: &Path) -> bool {
    true
}

/// Run `cmd args...` and return its trimmed stdout, or an error string on spawn
/// failure, non-zero exit, or non-UTF-8 output.
fn capture(cmd: &str, args: &[&str]) -> Result<String, String> {
    let out = Command::new(cmd)
        .args(args)
        .output()
        .map_err(|e| format!("failed to run `{cmd}`: {e}"))?;
    if !out.status.success() {
        return Err(format!(
            "`{cmd}` exited with {}: {}",
            out.status,
            String::from_utf8_lossy(&out.stderr).trim()
        ));
    }
    String::from_utf8(out.stdout)
        .map(|s| s.trim().to_string())
        .map_err(|_| format!("`{cmd}` produced non-UTF-8 output"))
}
