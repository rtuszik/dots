//! Show a Helm chart's default values (YAML), syntax-highlighted via bat.
//! Faithful port of the `hvals` zsh function, made reliable.

use std::io::Write;
use std::path::Path;
use std::process::{Command, Stdio};

const HELP: &str = "\
hvals — show a Helm chart's default values (YAML), highlighted with bat

USAGE:
    hvals <chart> <repo-url>      # HTTP repo
    hvals oci://<ref>             # OCI ref

EXAMPLES:
    hvals kube-prometheus-stack https://prometheus-community.github.io/helm-charts
    hvals oci://dhi.io/kube-prometheus-stack-chart";

fn main() {
    if let Err(e) = run() {
        eprintln!("error: {e}");
        std::process::exit(1);
    }
}

fn run() -> Result<(), String> {
    let args: Vec<String> = std::env::args().skip(1).collect();
    if args.is_empty() || args.iter().any(|a| a == "-h" || a == "--help") {
        println!("{HELP}");
        return Ok(());
    }
    if !on_path("helm") {
        return Err("`helm` not found on PATH".into());
    }

    let helm_args: Vec<&str> = if args[0].starts_with("oci://") {
        vec!["show", "values", args[0].as_str()]
    } else {
        if args.len() < 2 {
            return Err("HTTP repo requires both <chart> and <repo-url> (see --help)".into());
        }
        vec![
            "show",
            "values",
            args[0].as_str(),
            "--repo",
            args[1].as_str(),
        ]
    };

    let values = capture_bytes("helm", &helm_args)?;
    pipe_to_bat(&values)
}

// Stream the values through `bat -l yaml`; fall back to plain stdout if bat is
// absent so the command still works on a minimal box.
fn pipe_to_bat(values: &[u8]) -> Result<(), String> {
    if !on_path("bat") {
        std::io::stdout()
            .write_all(values)
            .map_err(|e| format!("writing stdout: {e}"))?;
        return Ok(());
    }

    let mut child = Command::new("bat")
        .args(["-l", "yaml"])
        .stdin(Stdio::piped())
        .spawn()
        .map_err(|e| format!("failed to start bat: {e}"))?;

    child
        .stdin
        .take()
        .ok_or("bat stdin pipe missing")?
        .write_all(values)
        .map_err(|e| format!("writing to bat: {e}"))?;

    let status = child.wait().map_err(|e| format!("waiting for bat: {e}"))?;
    if !status.success() {
        return Err(format!("bat exited with {status}"));
    }
    Ok(())
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

/// Run `cmd args...` and return its raw stdout bytes, or an error string on spawn
/// failure or non-zero exit.
fn capture_bytes(cmd: &str, args: &[&str]) -> Result<Vec<u8>, String> {
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
    Ok(out.stdout)
}
