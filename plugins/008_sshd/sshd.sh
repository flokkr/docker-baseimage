#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -n "$SSHD_ENABLE" ]; then
   echo "Installing and starting sshd server..."
   if [ -n "$SSHD_ROOT_PUBLIC_KEY" ]; then
      sudo mkdir -p /root/.ssh
		sudo chmod 700 /root.ssh
		echo "$SSHD_ROOT_PUBLIC_KEY" > /tmp/authorized_keys
		sudo mv /tmp/authorized_keys /root/.ssh/
		sudo chmod 600 /root/.ssh/authorized_keys
   fi
	sudo apk add --update openssh openssh-client
   sudo ssh-keygen -A
	sudo /usr/sbin/sshd
fi

call-next-plugin "$@"
