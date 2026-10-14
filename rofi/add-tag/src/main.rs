use std::fs;
use std::io;
use std::path::PathBuf;
fn main() -> io::Result<()> {
    let target: PathBuf = dirs::data_dir()
        .expect("can't detect home directory")
        .join("applications");
    for entry in fs::read_dir(&target)? {
        let path = entry?.path();
        if path.is_file() && path.extension().is_some_and(|ext| ext == "desktop") {
            let content = fs::read_to_string(&path)?;
            if is_game(&content) {
                let updated = add_keywords(&content);
                if updated != content {
                    let backup = path.with_extension("desktop.bak");
                     if !backup.exists() {
                         fs::copy(&path, &backup)?;
                     }
                     fs::write(&path, updated)?;
                }
            }
        }
    }
    Ok(()) 
}

fn is_game(content: &str) -> bool {
    let mut in_desktop_entry = false;
    for line in content.lines() {
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        if line.starts_with('[') && line.ends_with(']') {
            in_desktop_entry = line == "[Desktop Entry]";
            continue;
        }
        if !in_desktop_entry {
            continue;
        }
        if let Some(categories) = line.strip_prefix("Categories=") {
            return categories
                .split(';')
                .any(|category| category.trim() == "Game");
        };
    }
    false
}
fn add_keywords(content: &str) -> String {
    let mut lines: Vec<String> = content.lines().map(String::from).collect();

    let Some(start) = lines
        .iter()
        .position(|line| line.trim() == "[Desktop Entry]")
    else {
        return content.to_owned();
    };

    let end = (start + 1..lines.len())
        .find(|&i| {
            let line = lines[i].trim();
            line.starts_with('[') && line.ends_with(']')
        })
        .unwrap_or(lines.len());

    for i in start + 1..end {
        if let Some(value) = lines[i].trim().strip_prefix("Keywords=") {
            let mut keywords: Vec<&str> = value
                .split(';')
                .map(str::trim)
                .filter(|word| !word.is_empty())
                .collect();

            if keywords.contains(&"/games") {
                return content.to_owned();
            }

            keywords.push("/games");
            lines[i] = format!("Keywords={};", keywords.join(";"));

            return lines.join("\n") + "\n";
        }
    }

    lines.insert(start + 1, "Keywords=/games;".to_owned());

    lines.join("\n") + "\n"
}
