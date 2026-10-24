# Práctica 8 — Ansible para automatizar tareas en servidores

Se crean **5 servidores Ubuntu** con Docker (cada uno con servidor SSH y el usuario `ansible`) y se configuran todos a la vez con **Ansible** desde WSL.

## Estructura

```
.
├── Dockerfile            # Ubuntu 24.04 + openssh-server + usuario ansible (clave ansible, sudo sin contraseña)
├── docker-compose.yml    # 5 servicios: servidor1 ... servidor5
├── inventario.ini        # Servidores, IP/puerto, usuario y clave
├── ansible.cfg           # Usa inventario.ini e ignora la verificación de la clave SSH
└── playbooks/
    ├── ping.yml          # Prueba de conexión
    ├── configurar.yml    # Tareas de la práctica
    └── verificar.yml     # Muestra el resultado en cada servidor
```

## Servidores

| Servidor | IP en la red Docker | Puerto SSH desde el host |
|----------|--------------------|--------------------------|
| servidor1 | 172.28.0.11 | 2221 |
| servidor2 | 172.28.0.12 | 2222 |
| servidor3 | 172.28.0.13 | 2223 |
| servidor4 | 172.28.0.14 | 2224 |
| servidor5 | 172.28.0.15 | 2225 |

Con Docker Desktop en Windows, WSL no llega a las IPs internas de los contenedores; por eso el inventario usa `127.0.0.1` con el puerto publicado de cada servidor.

## Tareas que automatiza `configurar.yml`

1. Actualizar los paquetes de APT del sistema operativo.
2. Crear el usuario `itla`.
3. Crear la carpeta `app` (`/home/itla/app`).
4. Crear el archivo `hola.txt` dentro de `app`.
5. Instalar `cowsay` y `htop`.

## Uso

1. Levantar los servidores (PowerShell o WSL):

   ```bash
   docker compose up -d --build
   ```

2. Instalar Ansible en WSL (Ubuntu):

   ```bash
   sudo apt update
   sudo apt install -y ansible sshpass
   ```

   `sshpass` es necesario para que Ansible entre con usuario y contraseña.

3. Desde WSL, en la carpeta del proyecto, ejecutar los playbooks:

   ```bash
   ansible-playbook playbooks/ping.yml
   ansible-playbook playbooks/configurar.yml
   ansible-playbook playbooks/verificar.yml
   ```

   > Si el proyecto está en una carpeta de Windows (`/mnt/c/...`), Ansible ignora el `ansible.cfg` por permisos ("world writable directory"). Se soluciona indicándolo así: `ANSIBLE_CONFIG=./ansible.cfg ansible-playbook ...`.

4. Apagar los servidores:

   ```bash
   docker compose down
   ```

> Usuario y clave `ansible`/`ansible` son de laboratorio, solo para uso local.

---
Yojairo Rodriguez — Electiva 2, ITLA
