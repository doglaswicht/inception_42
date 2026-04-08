[VM]
    update and upgrade.
    Setup user:
        usermod -aG sudo dleite-b
        adduser dleite-b sudo
    Configure user in etc/sudoers.
    Install openssh-server.
        systemctl status ssh (to verify ssh)
    verify if need configure wfw to ports.
    Setup ports in VM:
        SSH / TCP / 127.0.0.1 / PORT 2222 /GUEST PORT 22
    Configure name dns to program in /etc/hosts
    


[DOCKER]
    Read Docker docs to install.
    Basic commands:
        docker run <app> [BUILD IMAGE OS]
        docker ps -a [SHOW CONTAINERS IN SERVICE]
        docker compose up --build  [BUILD CONTAINER]
        docker compose down -v [DOWN CONTAINER]
        docker exec -it <app> <command> [EXECUTE COMMAND IN CONTAINER]
        docker images [SHOW DOWNLOADED IMAGES IN DOCKER]

[MARIADB]
[WORDPRESS]