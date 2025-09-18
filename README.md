# Install-Uninstall-GIT-Linux 🚀

![Git Logo](https://git-scm.com/images/logos/downloads/Git-Logo-2Color.png)

A simple yet powerful set of Bash scripts to install, update, and uninstall Git on Linux systems. Perfect for automating Git setup in your development environment!

## 🌟 Features
- **Easy Installation**: One-command setup for the latest Git version.
- **Seamless Updates**: Quickly update Git to the newest release.
- **Clean Uninstall**: Remove Git completely without leaving traces.
- **Linux-Focused**: Optimized for popular distributions like Ubuntu, Debian, etc.

## 📋 Prerequisites
- A Linux system (tested on Ubuntu 20.04+)
- Root privileges (scripts use sudo)
- Internet connection for downloading packages

## 🚀 Quick Start

### Install or Update Git
Run the installation script:
```bash
sudo bash install_update_git.sh
```

This script will:
1. Add the official Git PPA (for Ubuntu/Debian).
2. Update package lists.
3. Install or upgrade Git to the latest version.

### Uninstall Git
To remove Git:
```bash
sudo bash uninstall_git.sh
```

This will:
1. Remove Git packages.
2. Clean up any residual files.
3. Remove the PPA if added.

## 📖 Detailed Usage
- **install_update_git.sh**: Checks if Git is installed, adds PPA if needed, and installs/updates Git.
- **uninstall_git.sh**: Safely uninstalls Git and removes configurations.

## ⚠️ Warnings
- Always back up important data before running uninstall scripts.
- These scripts require sudo; use with caution.

## 📄 License
This project is licensed under the terms of the LICENSE.md file included in the repository. See [LICENSE.md](LICENSE.md) for details.

## 🤝 Contributing
Feel free to fork, submit issues, or pull requests! Let's make Git management even easier.

Happy coding! 🎉
