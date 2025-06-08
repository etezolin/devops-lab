# 🚀 Laboratório de Infraestrutura e DevOps Local

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-blue.svg)](https://kubernetes.io/)
[![Terraform](https://img.shields.io/badge/Terraform-Ready-purple.svg)](https://www.terraform.io/)

## 📋 Visão Geral

Este repositório contém a implementação completa de um laboratório local para estudos e experimentação com tecnologias modernas de infraestrutura, containerização, orquestração e práticas DevOps. O projeto transforma uma máquina local em um servidor multifuncional que simula ambientes de produção reais.

## 🎯 Objetivos

- **Containerização Avançada**: Docker, Kubernetes, Helm, Service Mesh
- **Infraestrutura como Código**: Terraform, Ansible, Vagrant
- **Virtualização**: VirtualBox, VMware, LXC/LXD
- **CI/CD**: Jenkins, GitLab CI, GitHub Actions, ArgoCD
- **Monitoramento**: Prometheus, Grafana, ELK Stack
- **Segurança**: Vault, RBAC, Network Policies

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                    Host System (Linux)                      │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │   Virtualization │  │   Containerization │  │   Monitoring │  │
│  │   (VMs/LXC)     │  │   (Docker/K8s)    │  │   Stack     │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 🗂️ Estrutura do Projeto

```
devops-lab/
├── docs/                    # Documentação detalhada
│   ├── setup/              # Guias de instalação
│   ├── tutorials/          # Tutoriais passo-a-passo
│   └── troubleshooting/    # Solução de problemas
├── infrastructure/         # Infraestrutura como código
│   ├── terraform/          # Módulos Terraform
│   ├── ansible/            # Playbooks Ansible
│   └── vagrant/            # Configurações Vagrant
├── kubernetes/             # Manifests e Helm charts
│   ├── manifests/          # YAML manifests
│   ├── helm-charts/        # Charts customizados
│   └── operators/          # Custom operators
├── containers/             # Dockerfiles e compose
│   ├── applications/       # Apps containerizadas
│   ├── services/           # Serviços de infraestrutura
│   └── compose/            # Docker compose files
├── monitoring/             # Stack de monitoramento
│   ├── prometheus/         # Configurações Prometheus
│   ├── grafana/            # Dashboards Grafana
│   └── logging/            # ELK/Loki configs
├── ci-cd/                  # Pipelines CI/CD
│   ├── jenkins/            # Jenkins pipelines
│   ├── github-actions/     # GitHub Actions workflows
│   └── gitops/             # ArgoCD/Flux configs
├── security/               # Configurações de segurança
│   ├── vault/              # HashiCorp Vault
│   ├── policies/           # Security policies
│   └── certificates/       # SSL/TLS configs
├── scripts/                # Scripts de automação
│   ├── setup/              # Scripts de instalação
│   ├── maintenance/        # Scripts de manutenção
│   └── backup/             # Scripts de backup
└── examples/               # Exemplos práticos
    ├── microservices/      # Apps de exemplo
    ├── data-pipelines/     # Pipelines de dados
    └── workshops/          # Workshops hands-on
```

## 💻 Requisitos de Sistema

### Hardware Recomendado
- **CPU**: Intel i5 13600k (ou equivalente)
- **RAM**: 32GB DDR5 4800MHz
- **Storage**: 1TB SSD NVMe
- **Rede**: Gigabit Ethernet

### Software Base
- **OS**: Ubuntu 24.04 LTS
- **Hypervisor**: VirtualBox 7.0+ ou VMware
- **Container Runtime**: Docker Engine 24.0+
- **Orchestration**: Kubernetes 1.28+

## 🚀 Quick Start

### 1. Clone o Repositório
```bash
git clone https://github.com/etezolin/devops-lab.git
cd devops-lab
```

### 2. Execute o Setup Inicial
```bash
chmod +x scripts/setup/init.sh
./scripts/setup/init.sh
```

### 3. Verifique a Instalação
```bash
./scripts/setup/verify.sh
```

## 📚 Roadmap de Implementação

### ✅ Fase 1: Fundação (Semanas 1-2)
- [x] Configuração do repositório
- [ ] Setup do sistema base
- [ ] Implementação de virtualização
- [ ] Configuração de rede e storage

### 🔄 Fase 2: Containerização (Semanas 3-4)
- [ ] Docker Engine otimizado
- [ ] Kubernetes cluster local
- [ ] Registry privado
- [ ] Primeiros deployments

### ⏳ Fase 3: Infraestrutura como Código (Semanas 5-6)
- [ ] Terraform modules
- [ ] Ansible playbooks
- [ ] Vagrant boxes
- [ ] Integration testing

### ⏳ Fase 4: DevOps e CI/CD (Semanas 7-8)
- [ ] Jenkins setup
- [ ] GitHub Actions
- [ ] GitOps implementation
- [ ] Deployment strategies

### ⏳ Fase 5: Monitoramento e Otimização (Semanas 9-10)
- [ ] Prometheus + Grafana
- [ ] Logging stack
- [ ] Alerting rules
- [ ] Performance tuning

## 🛠️ Comandos Úteis

### Docker
```bash
# Build e push de imagens
make docker-build
make docker-push

# Limpeza de recursos
make docker-cleanup
```

### Kubernetes
```bash
# Deploy de aplicações
make k8s-deploy

# Port forwarding para desenvolvimento
make k8s-forward

# Logs e debug
make k8s-logs
```

### Terraform
```bash
# Planejamento e aplicação
make tf-plan
make tf-apply

# Limpeza de recursos
make tf-destroy
```

## 📖 Documentação

- [Guia de Instalação](docs/setup/README.md)
- [Tutoriais](docs/tutorials/README.md)
- [Troubleshooting](docs/troubleshooting/README.md)
- [API Reference](docs/api/README.md)
- [Contributing Guide](CONTRIBUTING.md)

## 🔒 Segurança

Este projeto implementa múltiplas camadas de segurança:

- Segmentação de rede com VLANs
- Criptografia end-to-end
- Gerenciamento de secrets com Vault
- RBAC granular no Kubernetes
- Auditoria completa de ações
- Scanning de vulnerabilidades

## 🤝 Contribuição

Contribuições são bem-vindas! Por favor, leia o [guia de contribuição](CONTRIBUTING.md) antes de submeter PRs.

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📊 Status do Projeto

![GitHub last commit](https://img.shields.io/github/last-commit/etezolin/devops-lab)
![GitHub issues](https://img.shields.io/github/issues/etezolin/devops-lab)
![GitHub pull requests](https://img.shields.io/github/issues-pr/etezolin/devops-lab)

## 🙏 Agradecimentos

- Comunidade Open Source
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Terraform Documentation](https://www.terraform.io/docs/)

## 📞 Contato

- **Autor**: [Edison Tezolin]
- **Email**: [tezolin.edison@gmail.como]
- **LinkedIn**: [linkedin.com/in/etezolin](https://www.linkedin.com/in/etezolin)]
- **Homepage**: [etezolin.dev](https://etezolin.dev/)]

---

⭐ **Se este projeto foi útil para você, considere dar uma estrela!** ⭐