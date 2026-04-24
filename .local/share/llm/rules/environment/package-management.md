# Package Management

Use the **system package manager** for system-wide installations. Never install system-wide packages through language-specific package managers (pip, npm, gem) or by running downloaded scripts.

**Identifying the system package manager:**
- macOS: MacPorts (`sudo port install`)
- Linux: check `/etc/os-release` for `ID` or `ID_LIKE`:
  - `debian` / `ubuntu`: `apt`
  - `fedora` / `rhel` / `centos`: `dnf` (or `yum` on older systems)
  - `arch`: `pacman`
  - `alpine`: `apk`
  - `opensuse`: `zypper`
  - `nixos`: `nix`

**No curl | bash installs.** Never download and execute installation scripts from the internet.

**Project dependencies belong in project-local environments:**
- Python: virtualenvs — never `pip install` outside one
- Node: project-local `node_modules` via `package.json` — never global installs
- Ruby: Gemfiles and bundler within the project directory

This separation prevents version conflicts between projects and keeps the system environment stable.
