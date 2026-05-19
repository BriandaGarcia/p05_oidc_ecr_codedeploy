#!/bin/bash
set -euo pipefail

# Despliega siempre la imagen más reciente publicada en ECR.
APP_VERSION="latest"
export APP_VERSION

cd /opt/mi-app

# Autentica Docker con ECR usando el rol de la instancia (sin credenciales hardcodeadas)
AWS_REGION="${AWS_REGION:-us-east-1}"
ECR_REGISTRY="${ECR_REGISTRY:?La variable ECR_REGISTRY no está definida}"

aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin \
  "$ECR_REGISTRY"

# Descarga las nuevas imágenes (backend + frontend)
docker compose -f docker-compose.yml pull

# Detiene los contenedores actuales y levanta los nuevos
docker compose -f docker-compose.yml down --remove-orphans
docker compose -f docker-compose.yml up -d

# Limpia imágenes antiguas para no llenar el disco
docker image prune -f