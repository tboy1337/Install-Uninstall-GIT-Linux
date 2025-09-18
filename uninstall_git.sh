#!/bin/bash

set -e

check_root() {
    if [ -n "$TERMUX_VERSION" ]; then
        return 0
    fi
    
    if [ "$PACKAGE_MANAGER" = "brew" ]; then
        return 0
    fi
    
    if [ "$(id -u)" != "0" ]; then
        echo "Error: This script must be run as root for $PACKAGE_MANAGER operations"
        exit 1
    fi
}

detect_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif type lsb_release &> /dev/null; then
        OS=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    elif [ "$(uname -o)" == "Android" ]; then
        OS="android"
    elif [ "$(uname)" == "Darwin" ]; then
        OS="darwin"
        if ! command -v brew >/dev/null 2>&1; then
            echo "Error: Homebrew is not installed. Please install it first."
            exit 1
        fi
    elif [ -f /etc/debian_version ]; then
        OS="debian"
    elif [ -f /etc/fedora-release ]; then
        OS="fedora"
    elif [ -f /etc/centos-release ]; then
        OS="centos"
    elif [ -f /etc/arch-release ]; then
        OS="arch"
    elif [ -f /etc/gentoo-release ]; then
        OS="gentoo"
    else
        OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    fi

    if [ "$OS" == "ubuntu" ] || [ "$OS" == "debian" ]; then
        PACKAGE_MANAGER="apt"
    elif [ "$OS" == "fedora" ]; then
        PACKAGE_MANAGER="dnf"
    elif [ "$OS" == "centos" ]; then
        if command -v dnf &> /dev/null; then
            PACKAGE_MANAGER="dnf"
        else
            PACKAGE_MANAGER="yum"
        fi
    elif [ "$OS" == "arch" ]; then
        PACKAGE_MANAGER="pacman"
    elif [ "$OS" == "gentoo" ]; then
        PACKAGE_MANAGER="emerge"
    elif [ "$OS" == "darwin" ]; then
        PACKAGE_MANAGER="brew"
    elif [ "$OS" == "android" ]; then
        PACKAGE_MANAGER="pkg"
    else
        PACKAGE_MANAGER="unknown"
    fi
}

check_git() {
    if ! command -v git &> /dev/null; then
        echo "Git is not installed on this system."
        exit 0
    else
        echo "Git is installed, current version:"
        git --version
    fi
}

uninstall_git() {
    local package_manager=$1
    local exit_code=0
    
    echo "Uninstalling Git..."
    
    case $package_manager in
        "apt")
            apt-get update || exit_code=$?
            [ $exit_code -eq 0 ] && apt-get remove --purge git git-core git-man git-doc -y || exit_code=$?
            [ $exit_code -eq 0 ] && apt-get autoremove -y || exit_code=$?
            [ $exit_code -eq 0 ] && apt-get autoclean || exit_code=$?
            ;;
        "dnf")
            dnf remove git git-core git-doc -y || exit_code=$?
            [ $exit_code -eq 0 ] && dnf clean all || exit_code=$?
            ;;
        "yum")
            yum remove git git-core git-doc -y || exit_code=$?
            [ $exit_code -eq 0 ] && yum clean all || exit_code=$?
            ;;
        "pacman")
            pacman -Sy || exit_code=$?
            [ $exit_code -eq 0 ] && pacman -Rns git --noconfirm || exit_code=$?
            [ $exit_code -eq 0 ] && pacman -Sc --noconfirm || exit_code=$?
            ;;
        "emerge")
            emerge --sync || exit_code=$?
            [ $exit_code -eq 0 ] && emerge -C dev-vcs/git || exit_code=$?
            [ $exit_code -eq 0 ] && emerge --depclean || exit_code=$?
            ;;
        "brew")
            brew update || exit_code=$?
            [ $exit_code -eq 0 ] && brew uninstall git || exit_code=$?
            ;;
        "pkg")
            pkg update || exit_code=$?
            [ $exit_code -eq 0 ] && pkg uninstall git -y || exit_code=$?
            [ $exit_code -eq 0 ] && pkg clean -y || exit_code=$?
            ;;
        *)
            echo "Error: Package manager '$package_manager' not supported."
            exit 1
            ;;
    esac

    if [ $exit_code -ne 0 ]; then
        echo "Error: Failed to uninstall git using $package_manager"
        exit $exit_code
    fi
    
    echo "Git uninstallation completed successfully using $package_manager."
}

main() {
    detect_system

    if [ "$PACKAGE_MANAGER" = "unknown" ]; then
        echo "Error: No supported package manager found (brew, apt, yum, dnf, pacman, emerge or pkg)."
        exit 1
    fi

    check_root
    check_git
    uninstall_git "$PACKAGE_MANAGER"

    if ! command -v git &> /dev/null; then
        echo "Verification: Git has been successfully removed."
        exit 0
    else
        echo "Warning: Git might still be installed, please check manually."
        exit 1
    fi
}

main
