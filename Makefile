# DevOps Lab - Makefile para Automação de Tarefas
# Autor: [Edison Tezolin]
# Versão: 1.0.0

.PHONY: help init setup verify clean docker-build docker-push docker-cleanup k8s-deploy k8s-forward k8s-logs tf-plan tf-apply tf-destroy

# Variáveis
PROJECT_NAME := devops-lab
DOCKER_REGISTRY := localhost:5000
TERRAFORM_DIR := infrastructure/terraform
KUBERNETES_DIR := kubernetes
NAMESPACE := devops-lab

# Cores para output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Help - mostra comandos disponíveis
help: ## Mostra esta mensagem de ajuda
	@echo "$(BLUE)DevOps Lab - Comandos Disponíveis$(NC)"
	@echo "=================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

# Setup e Inicialização
init: ## Inicializa o projeto (primeira execução)
	@echo "$(YELLOW)Inicializando o DevOps Lab...$(NC)"
	@chmod +x scripts/setup/*.sh
	@./scripts/setup/init.sh

setup: ## Configura o ambiente completo
	@echo "$(YELLOW)Configurando ambiente...$(NC)"
	@./scripts/setup/setup.sh

verify: ## Verifica se todos os componentes estão funcionando
	@echo "$(YELLOW)Verificando instalação...$(NC)"
	@./scripts/setup/verify.sh

clean: ## Limpa recursos temporários e cache
	@echo "$(YELLOW)Limpando recursos temporários...$(NC)"
	@docker system prune -f
	@kubectl delete pods --field-selector=status.phase=Succeeded -n $(NAMESPACE) || true
	@terraform -chdir=$(TERRAFORM_DIR) refresh

# Docker Commands
docker-build: ## Builda todas as imagens Docker
	@echo "$(YELLOW)Buildando imagens Docker...$(NC)"
	@docker-compose -f containers/compose/docker-compose.yml build

docker-push: ## Faz push das imagens para o registry
	@echo "$(YELLOW)Fazendo push das imagens...$(NC)"
	@docker-compose -f containers/compose/docker-compose.yml push

docker-cleanup: ## Limpa imagens e containers não utilizados
	@echo "$(YELLOW)Limpando recursos Docker...$(NC)"
	@docker system prune -af
	@docker volume prune -f

docker-logs: ## Mostra logs dos containers
	@echo "$(YELLOW)Logs dos containers:$(NC)"
	@docker-compose -f containers/compose/docker-compose.yml logs -f

# Kubernetes Commands
k8s-deploy: ## Faz deploy das aplicações no Kubernetes
	@echo "$(YELLOW)Fazendo deploy no Kubernetes...$(NC)"
	@kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	@kubectl apply -f $(KUBERNETES_DIR)/manifests/ -n $(NAMESPACE)

k8s-forward: ## Configura port forwarding para desenvolvimento
	@echo "$(YELLOW)Configurando port forwarding...$(NC)"
	@kubectl port-forward -n $(NAMESPACE) svc/grafana 3000:3000 &
	@kubectl port-forward -n $(NAMESPACE) svc/prometheus 9090:9090 &
	@kubectl port-forward -n $(NAMESPACE) svc/jenkins 8080:8080 &

k8s-logs: ## Mostra logs dos pods
	@echo "$(YELLOW)Logs dos pods:$(NC)"
	@kubectl logs -f -l app=$(PROJECT_NAME) -n $(NAMESPACE)

k8s-status: ## Mostra status do cluster
	@echo "$(YELLOW)Status do cluster:$(NC)"
	@kubectl get nodes
	@kubectl get pods -n $(NAMESPACE)
	@kubectl get services -n $(NAMESPACE)

k8s-cleanup: ## Remove todos os recursos do Kubernetes
	@echo "$(YELLOW)Removendo recursos do Kubernetes...$(NC)"
	@kubectl delete namespace $(NAMESPACE) || true

# Terraform Commands
tf-init: ## Inicializa o Terraform
	@echo "$(YELLOW)Inicializando Terraform...$(NC)"
	@terraform -chdir=$(TERRAFORM_DIR) init

tf-plan: ## Gera plano de execução do Terraform
	@echo "$(YELLOW)Gerando plano Terraform...$(NC)"
	@terraform -chdir=$(TERRAFORM_DIR) plan

tf-apply: ## Aplica as configurações do Terraform
	@echo "$(YELLOW)Aplicando configurações Terraform...$(NC)"
	@terraform -chdir=$(TERRAFORM_DIR) apply -auto-approve

tf-destroy: ## Destrói recursos criados pelo Terraform
	@echo "$(RED)Destruindo recursos Terraform...$(NC)"
	@terraform -chdir=$(TERRAFORM_DIR) destroy -auto-approve

tf-validate: ## Valida configurações do Terraform
	@echo "$(YELLOW)Validando Terraform...$(NC)"
	@terraform -chdir=$(TERRAFORM_DIR) validate
	@terraform -chdir=$(TERRAFORM_DIR) fmt -check

# Ansible Commands
ansible-ping: ## Testa conectividade com hosts
	@echo "$(YELLOW)Testando conectividade Ansible...$(NC)"
	@ansible all -i infrastructure/ansible/inventory -m ping

ansible-deploy: ## Executa playbooks de deploy
	@echo "$(YELLOW)Executando playbooks Ansible...$(NC)"
	@ansible-playbook -i infrastructure/ansible/inventory infrastructure/ansible/site.yml

ansible-check: ## Executa playbooks em modo check
	@echo "$(YELLOW)Verificando playbooks Ansible...$(NC)"
	@ansible-playbook -i infrastructure/ansible/inventory infrastructure/ansible/site.yml --check

# Monitoring Commands
monitoring-up: ## Sobe stack de monitoramento
	@echo "$(YELLOW)Subindo stack de monitoramento...$(NC)"
	@docker-compose -f monitoring/docker-compose.yml up -d

monitoring-down: ## Para stack de monitoramento
	@echo "$(YELLOW)Parando stack de monitoramento...$(NC)"
	@docker-compose -f monitoring/docker-compose.yml down

monitoring-logs: ## Mostra logs do monitoramento
	@echo "$(YELLOW)Logs do monitoramento:$(NC)"
	@docker-compose -f monitoring/docker-compose.yml logs -f

# Security Commands
security-scan: ## Executa scan de segurança
	@echo "$(YELLOW)Executando scan de segurança...$(NC)"
	@trivy fs .
	@docker run --rm -v $(PWD):/app securecodewarrior/docker-security-checker /app

vault-init: ## Inicializa HashiCorp Vault
	@echo "$(YELLOW)Inicializando Vault...$(NC)"
	@./scripts/security/vault-init.sh

# Development Commands
dev-up: ## Sobe ambiente de desenvolvimento
	@echo "$(YELLOW)Subindo ambiente de desenvolvimento...$(NC)"
	@make docker-build
	@make monitoring-up
	@make k8s-deploy

dev-down: ## Para ambiente de desenvolvimento
	@echo "$(YELLOW)Parando ambiente de desenvolvimento...$(NC)"
	@make k8s-cleanup
	@make monitoring-down
	@make docker-cleanup

dev-logs: ## Mostra todos os logs
	@echo "$(YELLOW)Logs do ambiente:$(NC)"
	@make docker-logs &
	@make k8s-logs &
	@make monitoring-logs

# Testing Commands
test: ## Executa todos os testes
	@echo "$(YELLOW)Executando testes...$(NC)"
	@./scripts/tests/run-tests.sh

test-infra: ## Testa infraestrutura
	@echo "$(YELLOW)Testando infraestrutura...$(NC)"
	@terraform -chdir=$(TERRAFORM_DIR) validate
	@ansible-playbook --syntax-check infrastructure/ansible/site.yml

test-k8s: ## Testa deployments Kubernetes
	@echo "$(YELLOW)Testando Kubernetes...$(NC)"
	@kubectl apply --dry-run=client -f $(KUBERNETES_DIR)/manifests/

# Backup Commands
backup: ## Cria backup completo
	@echo "$(YELLOW)Criando backup...$(NC)"
	@./scripts/backup/backup.sh

restore: ## Restaura backup
	@echo "$(YELLOW)Restaurando backup...$(NC)"
	@./scripts/backup/restore.sh

# Documentation Commands
docs-serve: ## Serve documentação localmente
	@echo "$(YELLOW)Servindo documentação...$(NC)"
	@mkdocs serve -a 127.0.0.1:8000

docs-build: ## Builda documentação
	@echo "$(YELLOW)Buildando documentação...$(NC)"
	@mkdocs build

# Utility Commands  
status: ## Mostra status geral do ambiente
	@echo "$(BLUE)Status Geral do DevOps Lab$(NC)"
	@echo "=========================="
	@echo "$(GREEN)Docker:$(NC)"
	@docker version --format "{{.Server.Version}}" 2>/dev/null || echo "Não instalado"
	@echo "$(GREEN)Kubernetes:$(NC)"
	@kubectl version --client --short 2>/dev/null || echo "Não instalado"
	@echo "$(GREEN)Terraform:$(NC)"
	@terraform version -json 2>/dev/null | jq -r '.terraform_version' || echo "Não instalado"
	@echo "$(GREEN)Ansible:$(NC)"
	@ansible --version 2>/dev/null | head -1 || echo "Não instalado"

update: ## Atualiza dependências
	@echo "$(YELLOW)Atualizando dependências...$(NC)"
	@docker pull alpine:latest
	@docker pull nginx:latest
	@helm repo update

install-tools: ## Instala ferramentas necessárias
	@echo "$(YELLOW)Instalando ferramentas...$(NC)"
	@./scripts/setup/install-tools.sh

# Default target
all: init setup verify ## Executa setup completo do projeto

# Comandos para diferentes ambientes
dev: dev-up ## Alias para dev-up
prod: tf-apply k8s-deploy monitoring-up ## Setup ambiente de produção
staging: ## Setup ambiente de staging
	@echo "$(YELLOW)Configurando ambiente de staging...$(NC)"
	@NAMESPACE=staging make k8s-deploy