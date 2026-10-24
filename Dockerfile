FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Servidor SSH, sudo y python3 (Ansible lo necesita en los nodos)
RUN apt-get update && \
    apt-get install -y openssh-server sudo python3 && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd

# Usuario ansible con clave ansible y sudo sin contraseña
RUN useradd -m -s /bin/bash ansible && \
    echo 'ansible:ansible' | chpasswd && \
    echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible && \
    chmod 440 /etc/sudoers.d/ansible

# Permitir login por contraseña
RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
