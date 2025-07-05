# DevOps Prueba Técnica – Demo DevOps Python

## Descripción

Este proyecto es una solución integral para la prueba técnica DevOps. Consiste en una aplicación Python (Django REST) dockerizada, con pipeline CI/CD, análisis de código, despliegue automatizado en Kubernetes y documentación completa.

---

## Tabla de Contenidos

- [Arquitectura y Diagrama](#arquitectura-y-diagrama)
- [Requerimientos y Solución](#requerimientos-y-solución)
- [Ejecución Local](#ejecución-local)
- [Dockerización](#dockerización)
- [Pipeline CI/CD](#pipeline-cicd)
- [Despliegue en Kubernetes](#despliegue-en-kubernetes)
- [Recursos Kubernetes](#recursos-kubernetes)
- [Variables de Entorno](#variables-de-entorno)
- [Pruebas y Cobertura](#pruebas-y-cobertura)
- [Acceso Público y Resultados](#acceso-público-y-resultados)
- [Referencias](#referencias)

---

## Arquitectura y Diagrama

```mermaid
flowchart TD
    A[Dev] -->|Git Push| B[GitHub]
    B --> C{CI/CD Pipeline}
    C --> D[Test Stage]
    C --> E[Build Stage]
    C --> F[Deploy Stage]
    D --> D1[Unit Tests]
    D --> D2[Integration Tests]
    D --> D3[Linting]
    D --> D4[Coverage]
    E --> E1[Build Multi-arch]
    E --> E2[Trivy Scan]
    E --> E3[Push to DockerHub]
    F --> F1[GKE Auth]
    F --> F2[K8s Deployment]
    F --> F3[Auto-scaling]
    F --> F4[Monitoring]
```

---

## Requerimientos y Solución

- **Dockerización:**  
  - Usuario no root, variables de entorno, healthcheck, puerto configurable.
- **Pipeline CI/CD:**  
  - Build, test, lint, cobertura, build/push Docker, escaneo de vulnerabilidades, despliegue automático en Kubernetes.
- **Kubernetes:**  
  - 2+ réplicas, HPA, ConfigMap, Secret, Ingress, Service, Namespace.
- **Documentación:**  
  - Este README, diagramas, instrucciones, justificación de decisiones.

---

## Ejecución Local

1. **Clonar el repositorio:**
    ```bash
    git clone https://github.com/Freperush/freperush-devsu-devops-test.git
    cd demo-devops-python
    ```

2. **Variables de entorno:**  
   Edita `.env` según tus necesidades.

3. **Levantar con Docker Compose:**
    ```bash
    docker-compose up --build
    ```

4. **Acceso:**  
   - API: [http://localhost:8765/api/](http://localhost:8765/api/)

---

## Dockerización

- Archivo [`dockerfile`](dockerfile)
- Usuario seguro (`appuser`)
- Variables de entorno vía `.env`
- Healthcheck HTTP
- Exposición de puerto configurable
- docker push freperush/demo-devops-python:lastest

---

## Pipeline CI/CD

- Archivo: [`.github/workflows/ci.yml`](.github/workflows/ci.yml)
- **Etapas:**
  - Checkout, build, test, lint (flake8), cobertura (coverage), build/push Docker, escaneo (Trivy), despliegue en Kubernetes.
- **Resultados:**  

  - [Enlace a ejecución exitosa del pipeline](https://github.com/Freperush/freperush-devsu-devops-test/actions/runs/16066805790)  

  Arquitectura CI/CD para Django con Kubernetes

## 🚀 Pipeline CI/CD

### 📌 Configuración
- **Archivo:** [`.github/workflows/ci.yml`](.github/workflows/ci.yml)
- **Última ejecución exitosa:** [Ver detalles](https://github.com/Freperush/freperush-devsu-devops-test/actions/runs/16066805790)

### 🔄 Flujo del Pipeline
```mermaid
---
config:
  layout: dagre
  rankDir: LR
---
flowchart TD
    GH["GitHub Repository"] --> Test["Test Job"] & Deploy["Deploy Job"] & Docker["Docker Job"]
    
    %% Left side - Test Job
    Test --> T1["• Checkout Code"]
    T1 --> Dep5a["• Setup Python 3.11"]
    Dep5a --> Dep5b["• Install Dependencies"]
    Dep5b --> Dep5c["• Run Migrations"]
    Dep5c --> Dep5d["• Run Tests"]
    Dep5d --> Dep5e["• Coverage"]
    Dep5e --> Dep5f["• flake8"]
    Dep5f --> T8["Services: PostgreSQL Container"]
    
    %% Center - Deploy Job
    Deploy --> n4["• Checkout Code"]
    n4 --> Dep5g["• Setup Docker Buildx"]
    Dep5g --> D4a["• Login to DockerHub"]
    D4a --> n1["• Build & Push Image\n- Multi-arch build\n- Tag with SHA/latest"]
    n1 --> D4b["• Scan with Trivy"]
    
    %% Right side - Docker Job
    Docker --> n3["• Checkout Code"]
    n3 --> n2["• Setup gcloud CLI"]
    n2 --> n5["• Authenticate GCP"]
    n5 --> n6["• Get GKE Credentials"]
    n6 --> n7["• Apply K8s Manifests"]
    n7 --> GKE["Google Kubernetes Engine"]
    
    %% GKE details (puede moverse a la derecha también)
    GKE --> GKE1["• Dev Cluster"]
    GKE1 --> GKE2["• us-central1"]
    GKE2 --> GKE3["• Auto-scaling"]
    GKE3 --> GKE4["• Ingress Controller"]

    classDef repo fill:#24292f,stroke:#444,color:#fff,stroke-width:2px
    classDef job fill:#2b3137,stroke:#444,color:#fff,stroke-width:1px
    classDef step fill:#f6f8fa,stroke:#d0d7de,color:#000,stroke-width:1px
    classDef cluster fill:#f0fff4,stroke:#2b3137,color:#000,stroke-width:2px
    
    GH:::repo
    Test:::job
    Deploy:::job
    Docker:::job
    GKE:::cluster
    GKE1:::step
```
---

## Despliegue en Kubernetes

- Compatible con Minikube, Docker Desktop o GKE.
- Manifiestos en [`k8s/`](k8s/)
- Recursos:
  - Namespace, Deployment (2+ réplicas), Service, Ingress, ConfigMap, Secret, HPA.
- Despliegue automático desde el pipeline.

### Despliegue manual local (Minikube):

```bash
kubectl apply -f k8s/Local/namespace.yaml
kubectl apply -f k8s/Local/configmap.yaml -n namespace-devops-python
kubectl apply -f k8s/Local/secret.yaml -n namespace-devops-python
kubectl apply -f k8s/Local/deployment.yaml -n namespace-devops-python
kubectl apply -f k8s/Local/service.yaml -n namespace-devops-python
kubectl apply -f k8s/Local/hpa.yaml -n namespace-devops-python
kubectl apply -f k8s/Local/ingress.local.yaml -n namespace-devops-python
```

---

## Recursos Kubernetes

- [`k8s/Local/namespace.yaml`](k8s/Local/namespace.yaml)
- [`k8s/Local/deployment.yaml`](k8s/Local/deployment.yaml)
- [`k8s/Local/service.yaml`](k8s/Local/service.yaml)
- [`k8s/Local/ingress.local.yaml`](k8s/Local/ingress.local.yaml)
- [`k8s/Local/configmap.yaml`](k8s/Local/configmap.yaml)
- [`k8s/Local/secret.yaml`](k8s/Local/secret.yaml)
- [`k8s/Local/hpa.yaml`](k8s/Local/hpa.yaml)

---

## Variables de Entorno

Se gestionan vía `.env`, ConfigMap y Secret.  
Ejemplo:

```env
DJANGO_PORT=8765
DJANGO_SECRET_KEY=...
DATABASE_NAME=db.sqlite3
PYTHONUNBUFFERED=1
```

---

##  Pruebas y Cobertura

###  Suite de Pruebas
- **Pruebas Unitarias**: Django Test Framework
- **Pruebas API**: DRF TestClient
- **Integración**: PostgreSQL en contenedor
- **Linting**: Flake8 con estándar PEP8
- **Cobertura**: Reporte HTML/XML con `coverage`

###  Métricas de Calidad
```mermaid
pie
    title Cobertura de Código (96.42%)
    "Cubiertas" : 108
    "No cubiertas" : 4
```

Ver reporte completo: [https://codecov.io/gh/Freperush/freperush-devsu-devops-test](https://codecov.io/gh/Freperush/freperush-devsu-devops-test)

### Reporte de Seguridad Trivy
| Componente       | Críticas | Altas | Medias | Bajas | Parcheadas |
|------------------|----------|-------|--------|-------|------------|
| Django           | 2        | 8     | 12     | 0     | 18         |
| DRF              | 0        | 0     | 0      | 1     | 1          |
| Sistema (Debian) | 0        | 0     | 0      | 0     | -          |


---

## Acceso Público y Resultados

- **Repositorio GitHub:**  
  [https://github.com/Freperush/freperush-devsu-devops-test](https://github.com/Freperush/freperush-devsu-devops-test)
- **Pipeline:**  
  [GitHub Actions](https://github.com/Freperush/freperush-devsu-devops-test/actions)
- **Endpoint público:**  
    Para acceder correctamente al endpoint `http://demo-devops-python.local/api/users/`, es necesario agregar una entrada al archivo `/etc/hosts` de tu sistema.
    ### Paso 1: Editar el archivo /etc/hosts
    Agrega la siguiente línea al final del archivo:
    34.128.153.213       demo-devops-python.local
    > Nota: Este archivo requiere permisos de administrador. Puedes editarlo con:
    > sudo nano /etc/hosts
    ### Paso 2: Probar el acceso
    Luego de guardar los cambios, puedes acceder desde el navegador o usar curl:
    http://demo-devops-python.local/api/users/
---


---

## Referencias

- [Documentación Django](https://docs.djangoproject.com/)
- [Documentación Kubernetes](https://kubernetes.io/docs/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Docker](https://docs.docker.com/)



---

**¡Gracias por revisar este ejercicio!**
