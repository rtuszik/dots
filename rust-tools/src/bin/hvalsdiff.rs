//! Diff a Helm chart's default values between two versions, via delta.
//! Faithful port of the `hvalsdiff` zsh function, made reliable.

use std::io::Write;
use std::path::{Path, PathBuf};
use std::process::Command;

const HELP: &str = "\
hvalsdiff — diff a Helm chart's default values between two versions

USAGE:
    hvalsdiff <chart> <repo-url> <ver1> <ver2>     # HTTP repo
    hvalsdiff oci://<ref> <ver1> <ver2>            # OCI ref

EXAMPLES:
    hvalsdiff kube-prometheus-stack https://prometheus-community.github.io/helm-charts 70.7.0 84.5.0
    hvalsdiff oci://dhi.io/kube-prometheus-stack-chart 70.7.0 84.5.0";

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
    for tool in ["helm", "delta"] {
        if !on_path(tool) {
            return Err(format!("`{tool}` not found on PATH"));
        }
    }

    // The `helm show values` arg lists for each of the two versions.
    let (a1, a2): (Vec<&str>, Vec<&str>) = if args[0].starts_with("oci://") {
        if args.len() < 3 {
            return Err("OCI ref requires <ref> <ver1> <ver2> (see --help)".into());
        }
        let r = args[0].as_str();
        (
            vec!["show", "values", r, "--version", args[1].as_str()],
            vec!["show", "values", r, "--version", args[2].as_str()],
        )
    } else {
        if args.len() < 4 {
            return Err("HTTP repo requires <chart> <repo-url> <ver1> <ver2> (see --help)".into());
        }
        let (c, repo) = (args[0].as_str(), args[1].as_str());
        (
            vec![
                "show",
                "values",
                c,
                "--repo",
                repo,
                "--version",
                args[2].as_str(),
            ],
            vec![
                "show",
                "values",
                c,
                "--repo",
                repo,
                "--version",
                args[3].as_str(),
            ],
        )
    };

    let v1 = capture_bytes("helm", &a1)?;
    let v2 = capture_bytes("helm", &a2)?;

    let f1 = TempFile::with_contents("hvalsdiff-a", &v1)?;
    let f2 = TempFile::with_contents("hvalsdiff-b", &v2)?;

    let status = Command::new("delta")
        .arg(f1.path())
        .arg(f2.path())
        .status()
        .map_err(|e| format!("failed to start delta: {e}"))?;
    // delta (like `diff`/`git diff --no-index`) exits 1 when the files differ —
    // that's the normal case here, not an error. Only >1 signals a real failure.
    if matches!(status.code(), Some(c) if c > 1) {
        return Err(format!(
            "delta exited with status {}",
            status.code().unwrap()
        ));
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

/// A temp file that is removed from disk when dropped.
struct TempFile {
    path: PathBuf,
}

impl TempFile {
    /// Create a uniquely-named temp file holding `contents`.
    fn with_contents(tag: &str, contents: &[u8]) -> Result<Self, String> {
        let dir = std::env::temp_dir();
        let pid = std::process::id();
        for n in 0..1000u32 {
            let path = dir.join(format!("cli-tools-{tag}-{pid}-{n}.tmp"));
            match std::fs::OpenOptions::new()
                .write(true)
                .create_new(true)
                .open(&path)
            {
                Ok(mut f) => {
                    f.write_all(contents)
                        .map_err(|e| format!("writing {}: {e}", path.display()))?;
                    return Ok(TempFile { path });
                }
                Err(e) if e.kind() == std::io::ErrorKind::AlreadyExists => continue,
                Err(e) => return Err(format!("creating temp file in {}: {e}", dir.display())),
            }
        }
        Err("could not allocate a unique temp file".into())
    }

    fn path(&self) -> &Path {
        &self.path
    }
}

impl Drop for TempFile {
    fn drop(&mut self) {
        let _ = std::fs::remove_file(&self.path);
    }
}
