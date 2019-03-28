#! /bin/bash
# Download the vault-ssh-helper
$ wget https://releases.hashicorp.com/vault-ssh-helper/0.1.4/vault-ssh-helper_0.1.4_linux_amd64.zip

# Unzip the vault-ssh-helper in /user/local/bin
$ sudo unzip -q vault-ssh-helper_0.1.4_linux_amd64.zip -d /usr/local/bin

# Make sure that vault-ssh-helper is executable
$ sudo chmod 0755 /usr/local/bin/vault-ssh-helper

# Set the usr and group of vault-ssh-helper to root
$ sudo chown root:root /usr/local/bin/vault-ssh-helper

# Create a Vault SSH Helper configuration file, /etc/vault-ssh-helper.d/config.hcl
sudo cat << EOF >> /etc/vault-ssh-helper.d/config.hcl
vault_addr = "https://192.168.1.214:8200"
ssh_mount_point = "ssh"
ca_cert = "/etc/vault-ssh-helper.d/vault.crt"
tls_skip_verify = false
allowed_roles = "*"
EOF

#
# Modify the /etc/pam.d/sshd file
#
sudo sed -i -e '$a\
auth requisite pam_exec.so quiet expose_authtok log=/tmp/vaultssh.log /usr/local/bin/vault-ssh-helper -dev -config=/etc/vault-ssh-helper.d/config.hcl \
auth optional pam_unix.so not_set_pass use_first_pass nodelay' /etc/pam.d/sshd

# Enables the keyboard-interactive authentication and PAM authentication modules. 
# The password authentication is disabled
#
sudo sed -i -e '$a\
ChallengeResponseAuthentication yes \
PasswordAuthentication no \
UsePAM yes' /etc/ssh/sshd_config

sudo systemctl restart sshd
