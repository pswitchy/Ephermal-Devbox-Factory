# Ephemeral DevBox Factory (Automated CDE Pipeline)

![Build Status](https://img.shields.io/github/actions/workflow/status/pswitchy/devbox-factory/ci.yml?label=Build&style=flat-square)
![Tools](https://img.shields.io/badge/Tools-Packer%20%7C%20Cloud--init%20%7C%20PHP-blue?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Linux%20(Ubuntu)-orange?style=flat-square)

## 📖 Overview
**Ephemeral DevBox Factory** is an Infrastructure-as-Code (IaC) pipeline designed to generate "Golden Images" for remote Cloud Development Environments (CDEs). 

Inspired by cloud marketplace offerings, this project automates the creation of hardened, pre-configured Linux Virtual Machine images. It transforms a raw Ubuntu ISO into a "Dev-Ready" environment containing **VS Code Server**, **Docker**, and language runtimes, reducing developer onboarding time from hours to minutes.

## 🏗 Architecture
The pipeline consists of three distinct phases:
1.  **Build Phase (Packer):** Orchestrates the creation of the VM image, injecting Bash scripts to perform unattended software installation.
2.  **Hardening Phase (Bash):** Configures OS-level security, including UFW firewalls, SSH hardening, and systemd service management.
3.  **Provisioning Phase (PHP + Cloud-init):** A custom PHP CLI tool generates dynamic `cloud-init` user-data to inject SSH keys and configure user permissions upon the very first boot.

## 🚀 Key Features
- **Automated Image Build:** Uses **HashiCorp Packer** to build QEMU/KVM images from source ISOs.
- **Unattended Installation:** **Bash scripts** handle the installation of Docker, Zsh, and VS Code Server without human intervention.
- **Dynamic Configuration Engine:** A **PHP-based CLI utility** generates `cloud-init` YAML configurations to bootstrap user credentials securely.
- **OS Hardening:** pre-configured **UFW Firewall** rules and non-root user setup for security compliance.
- **CI/CD Validation:** **GitHub Actions** pipeline automatically validates Packer templates and PHP syntax on every commit.

## 🛠 Tech Stack
| Component | Technology | Role |
| :--- | :--- | :--- |
| **Image Builder** | **HashiCorp Packer** | Orchestrates the VM build and export process. |
| **Configuration** | **Cloud-init** | Handles instance initialization (users, keys) at boot time. |
| **Scripting** | **Bash** | Automates software installation and system tuning. |
| **Tooling** | **PHP** | CLI tool for generating dynamic YAML configurations. |
| **OS** | **Ubuntu 22.04 LTS** | The base operating system. |
| **Automation** | **GitHub Actions** | Continuous Integration for template validation. |

## 📂 Project Structure
```text
devbox-factory/
├── packer/
│   └── devbox.pkr.hcl        # The Packer Configuration (IaC)
├── scripts/
│   ├── install-base.sh       # Bash: Installs Docker, Zsh, Utilities
│   └── install-vscode.sh     # Bash: Installs VS Code Server & Systemd setup
├── tools/
│   └── gen-cloud-init.php    # PHP: CLI tool to generate Cloud-init config
├── .github/
│   └── workflows/            # CI/CD Pipeline
└── README.md
```

## ⚡ How to Run

### Prerequisites
- HashiCorp Packer
- PHP 8.0+
- QEMU/KVM (for local emulation)

### 1. Generate the Cloud-Init Config
Use the custom PHP tool to generate a configuration for a specific developer. This simulates how a Marketplace app would configure itself for a user.

```bash
# Usage: php tools/gen-cloud-init.php --user=[USERNAME] --github=[GITHUB_HANDLE]
php tools/gen-cloud-init.php --user=vultr-admin --github=pswitchy
```
*Output:* A valid YAML configuration that can be passed to the VM instance data.

### 2. Validate the Packer Template
Ensure the Infrastructure code is syntactically correct.

```bash
packer init packer/devbox.pkr.hcl
packer validate packer/devbox.pkr.hcl
```

### 3. Build the Image
*Note: This requires QEMU/KVM installed locally.*
```bash
packer build packer/devbox.pkr.hcl
```

## 🔄 CI/CD Pipeline
This project implements a Continuous Integration pipeline using **GitHub Actions**. On every push to `main`:
1.  **PHP Linting:** Checks `gen-cloud-init.php` for syntax errors.
2.  **Packer Format:** Checks if the HCL file follows HashiCorp standards.
3.  **Packer Validate:** Ensures the template logic is valid.
