<?php
// tools/gen-cloud-init.php
// Usage: php gen-cloud-init.php --user=parth --github=pswitchy

$options = getopt("", ["user:", "github:"]);

if (!isset($options['user']) || !isset($options['github'])) {
    fwrite(STDERR, "Error: Missing required arguments.\n");
    fwrite(STDERR, "Usage: php gen-cloud-init.php --user=USERNAME --github=GITHUB_HANDLE\n");
    exit(1);
}

$user = $options['user'];
$github = $options['github'];

// This is the Cloud-Init YAML format
// It runs when the VM boots for the first time
$cloud_config = <<<YAML
#cloud-config
users:
  - name: $user
    groups: sudo, docker
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_import_id:
      - gh:$github

package_update: true
packages:
  - git
  - curl
  - htop

write_files:
  - path: /etc/motd
    content: |
      Welcome to your ephemeral DevBox, $user!
      Docker and VS Code Server are ready.
      
runcmd:
  - systemctl enable --now code-server@$user
YAML;

echo $cloud_config;
?>