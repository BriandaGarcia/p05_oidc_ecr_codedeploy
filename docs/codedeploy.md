### AWS Code Deploy

En esta sección se realizarán los siguientes pasos:

- Una aplicación de CodeDeploy
- Un Service Role para CodeDeploy
- Un Deployment Group
- Asociar instancias EC2 mediante Tags

**Variables utilizadas**

```bash
AWS_REGION="us-east-1"

APPLICATION_NAME="mi-app"
DEPLOYMENT_GROUP_NAME="produccion"

SERVICE_ROLE_NAME="CodeDeployServiceRole"

EC2_TAG_KEY="Name"
EC2_TAG_VALUE="mi-servidor"

INSTANCE_ID="i-xxxxxxxxxxxxxxxxx"
```

1. Crear la aplicación CodeDeploy

    ```bash
    aws deploy create-application \
        --application-name $APPLICATION_NAME \
        --compute-platform Server \
        --region $AWS_REGION
    ```

2. Verificar la aplicación

    ```bash
    aws deploy get-application \
        --application-name $APPLICATION_NAME
    ```

3. Asociar la política administrada de CodeDeploy

    ```bash
    aws iam attach-role-policy \
        --role-name $SERVICE_ROLE_NAME \
        --policy-arn arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole
    ```

4. Obtener el ARN del Service Role

    ```bash
    aws iam get-role \
        --role-name $SERVICE_ROLE_NAME \
        --query "Role.Arn" \
        --output text
    ```

    Resultado esperado:

    ```text
    arn:aws:iam::123456789012:role/CodeDeployServiceRole
    ```

    Guarda el ARN:

    ```bash
    SERVICE_ROLE_ARN="arn:aws:iam::123456789012:role/CodeDeployServiceRole"
    ```

5. Agregar Tag a la instancia EC2

    ```bash
    aws ec2 create-tags \
        --resources $INSTANCE_ID \
        --tags Key=$EC2_TAG_KEY,Value=$EC2_TAG_VALUE
    ```

    **Verificar tags**

    ```bash
    aws ec2 describe-tags \
        --filters "Name=resource-id,Values=$INSTANCE_ID"
    ```

6. Crear el Deployment Group

    ```bash
    aws deploy create-deployment-group \
        --application-name $APPLICATION_NAME \
        --deployment-group-name $DEPLOYMENT_GROUP_NAME \
        --service-role-arn $SERVICE_ROLE_ARN \
        --deployment-style deploymentType=IN_PLACE,deploymentOption=WITHOUT_TRAFFIC_CONTROL \
        --ec2-tag-filters Key=$EC2_TAG_KEY,Value=$EC2_TAG_VALUE,Type=KEY_AND_VALUE \
        --deployment-config-name CodeDeployDefault.AllAtOnce \
        --region $AWS_REGION
    ```

7. Verificar el Deployment Group

    ```bash
    aws deploy get-deployment-group \
        --application-name $APPLICATION_NAME \
        --deployment-group-name $DEPLOYMENT_GROUP_NAME
    ```

8. Resultado esperado

    | Recurso | Nombre |
    |---|---|
    | Aplicación CodeDeploy | `mi-app` |
    | Deployment Group | `produccion` |
    | Service Role | `CodeDeployServiceRole` |
    | Estrategia | `CodeDeployDefault.AllAtOnce` |
    | Tipo de despliegue | In-place |
    | Instancias objetivo | EC2 con tag `Name=mi-servidor` |

### [Regresar](./../README.md#configuracion-de-iam)