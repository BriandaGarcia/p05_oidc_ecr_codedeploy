# AWS Elastic Container Repository (ECR)

Por cada imágen se debe crear un repositorio de ECR para eso deben ejecutar los siguientes comandos:

```bash
aws ecr create-repository --repository-name calculadora/frontend --region us-east-1
aws ecr create-repository --reposiroty-name calculadora/backend --region us-east-1
```

Cada comando devolverá una URI con el siguiente formato:
```
123456789012.dkr.ecr.us-east-1.amazonaws.com/mi-app/api
```
Se debe guardar dado que se utilizará más adelante.

### [Regresar](./../README.md#configuracion-de-iam)