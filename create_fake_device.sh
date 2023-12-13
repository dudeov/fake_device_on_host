#!/bin/bash

FAKE_USER="cisco"
FAKE_HOME="/home/${FAKE_USER}"
ROOT_HOME=${HOME}

## Should be root
USER=$(whoami)
if [[ ${USER} != "root" ]]; then
    echo "ERROR: User must be root"
    exit 1
fi

## Generate keys
mkdir ${ROOT_HOME}/.ssh
chown -R 700 ${ROOT_HOME}/.ssh
ssh-keygen -t ed25519 -q -f "${ROOT_HOME}/.ssh/id_ed25519" -N ""

echo "Generated keys check:"
ls -l "${ROOT_HOME}/.ssh"

# Create the fake user:
# -U to create a new group with the same name as the user
# -s to assign a specific shell; file must be available
# -p to create a password to unlock the user
useradd -U\
 -d ${FAKE_HOME}\
 -s ${FAKE_HOME}/fake_shell.sh\
 -p "DummyPassword"\
 ${FAKE_USER}

# Copy the fake shell to the user's home dir
cp ${ROOT_HOME}/fake_device_on_host/fake_shell.sh ${FAKE_HOME}
chown ${FAKE_USER}:${FAKE_USER} ${FAKE_HOME}/fake_shell.sh
chmod 777 ${FAKE_HOME}/fake_shell.sh

# Create user's ssh dir
mkdir ${FAKE_HOME}/.ssh

# Add roots OPEN SSH keys to the new user's allowed
cat ${ROOT_HOME}/.ssh/id_ed25519.pub > ${FAKE_HOME}/.ssh/authorized_keys

# And finally start the SSHD for the fake user: it'll listen to the port 2222
# Might require OpenSSH installation: yum –y install openssh-server openssh-clients
/usr/sbin/sshd -f ${ROOT_HOME}/fake_device_on_host/sshd_config_fake_device -h ${ROOT_HOME}/.ssh/id_ed25519
