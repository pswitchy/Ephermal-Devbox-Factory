packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

# Variable definitions
variable "iso_url" {
  type    = string
  # Using Ubuntu 22.04 Live Server
  default = "https://releases.ubuntu.com/22.04.4/ubuntu-22.04.4-live-server-amd64.iso"
}

variable "iso_checksum" {
  type    = string
  default = "file:https://releases.ubuntu.com/22.04.4/SHA256SUMS"
}

source "qemu" "ubuntu" {
  iso_url           = var.iso_url
  iso_checksum      = var.iso_checksum
  output_directory  = "output_devbox"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  disk_size         = "10G"
  format            = "qcow2"
  accelerator       = "hvf" # Use 'hvf' for Mac, 'kvm' for Linux
  http_directory    = "http" # Serves the autoinstall config
  ssh_username      = "ubuntu"
  ssh_password      = "ubuntu"
  ssh_timeout       = "20m"
  vm_name           = "devbox-golden-image"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "5s"
  
  # Automated Install Command (Simulates a physical keyboard typing)
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot<enter>"
  ]
}

build {
  sources = ["source.qemu.ubuntu"]

  # 1. Upload scripts to the VM
  provisioner "file" {
    source      = "../scripts"
    destination = "/tmp/scripts"
  }

  # 2. Run the Install Scripts (Bash)
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/scripts/*.sh",
      "sudo /tmp/scripts/install-base.sh",
      "sudo /tmp/scripts/install-vscode.sh"
    ]
  }
}