# Terraform criando IaaS no GCP e fazendo deploy de Java 11 e MySQL 8

Pré-requisitos

- gcloud instalado
- Terraform instalado

Logar no GCP usando gcloud com o comando abaixo

```sh
gcloud auth login
```

Gerar chave pública e privada para acessar a VM, com nome "id_rsa" na raiz do projeto

```sh
ssh-keygen -t rsa -b 4096
```

Inicializar o Terraform

```sh
terraform init
```

Executar o Terraform

```sh
terraform apply -auto-approve
```
