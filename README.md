This project has been created as part of the 42 curriculum by dleite-b.


Description

Apresentação clara do projeto.

Instructions

Informações sobre:

compilação

instalação

execução

Resources

Referências:

documentação

artigos

tutoriais


Uso do Docker

Fontes usadas

E comparar:

Virtual Machines vs Docker

Secrets vs Environment Variables

Docker Network vs Host Network

Docker Volumes vs Bind Mounts




# inception_42
```
Build a web struct with Docker
inception/
│
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
│
├── secrets/
│   ├── db_password.txt
│   ├── db_root_password.txt
│
└── srcs/
    │
    ├── .env
    ├── docker-compose.yml
    │
    └── requirements/
        │
        ├── mariadb/
        │   ├── Dockerfile
        │   └── conf/
        │
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        │
        └── wordpress/
            ├── Dockerfile
            └── conf/
```

Cette struct offre de la securité, Escalabilité e arquitetura de microservices. 

Domaine obrigatoire pour la vm:
/etc/hosts
ADD : 127.0.0.1 login.42.fr

https://login.42.fr


.env
docker network
docker volumes
TLS (HTTPS)

