---

# 🚀 Production Level CI/CD Pipeline Project – FullStack Blogging App

This project demonstrates a **Production-level CI/CD pipeline implementation for a FullStack Blogging Application** and the **steps** i have followed.

The pipeline automates the complete workflow from **code commit → build → security scan → artifact storage → containerization → Kubernetes deployment → monitoring**.

---

# 📌 Project Architecture

The pipeline includes the following major stages:

```
GitHub Repository
      ↓
Jenkins Pipeline
      ↓
Maven Compile
      ↓
Unit Testing
      ↓
Trivy Security Scan (Source Code)
      ↓
SonarQube Code Quality & Coverage
      ↓
Maven Package (JAR)
      ↓
Artifact Push to Nexus Repository
      ↓
Docker Image Build & Tag
      ↓
Trivy Docker Image Scan
      ↓
Push Docker Image to DockerHub
      ↓
Deploy Application to Kubernetes (EKS cluster configure using Terraform)
      ↓
Expose using LoadBalancer
     ↓
Added Email confirmation
      ↓
Map Custom Domain
      ↓
Monitoring (Prometheus + Blackbox Exporter + Grafana)
```

---

# 🛠️ DevOps Tools Used

| Tool              | Purpose                         |
| ----------------- | ------------------------------- |
| GitHub            | Source Code Repository          |
| Jenkins           | CI/CD Automation                |
| Maven             | Build & Dependency Management   |
| SonarQube         | Code Quality & Coverage         |
| Trivy             | Security Vulnerability Scanning |
| Nexus             | Artifact Repository             |
| Docker            | Containerization                |
| DockerHub         | Container Registry              |
| Kubernetes (EKS)  | Container Orchestration         |
| Terraform         | Infrastructure Provisioning     |
| Prometheus        | Monitoring & Metrics            |
| Blackbox Exporter | Endpoint Monitoring             |
| Grafana           | Visualization Dashboards        |

---

# ⚙️ Project Workflow

### 1️⃣ Setup Code Repository

Create a GitHub repository and push the FullStack Blogging App code.

Example:

```
git clone <repo-url>
git add .
git commit -m "initial commit"
git push origin main
```

---

# 🖥️ Server Setup (AWS EC2 Instances)

Separate servers were created for each DevOps tool.

| Server            | Purpose                  |
| ----------------- | ------------------------ |
| Jenkins Server    | CI/CD pipeline execution |
| SonarQube Server  | Code quality analysis    |
| Nexus Server      | Artifact storage         |
| Monitoring Server | Prometheus + Grafana     |
| Terraform Server  | EKS cluster provisioning |

---

# 🔐 Step 1: Create Security Group

Create a **common security group** allowing required ports:

| Port | Service    |
| ---- | ---------- |
| 22   | SSH        |
| 8080 | Jenkins    |
| 9000 | SonarQube  |
| 8081 | Nexus      |
| 3000 | Grafana    |
| 9090 | Prometheus |
| 465  | SMTPS       |
---

# ⚙️ Step 2: Jenkins Server Setup

## Install Jenkins

```
sudo apt update
sudo apt install openjdk-17-jdk -y
```

Install Jenkins.

---

## Install Docker

```
sudo apt install docker.io -y
```

Give permission to Jenkins user:

```
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

## Install Trivy

```
sudo apt install wget apt-transport-https gnupg lsb-release -y

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -

echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt update
sudo apt install trivy -y
```

---

## Jenkins Plugins Installed

```
Eclipse Temurin Installer
SonarQube Scanner
Maven Integration
Pipeline Maven Integration
Config File Provider
Docker
Kubernetes
Pipeline Stage View
```

---

## Configure Jenkins Tools

Navigate to:

```
Manage Jenkins → Global Tool Configuration
```

Configure:

```
JDK
Maven
Docker
SonarQube Scanner
```

---

## Jenkins Credentials

Store credentials securely:

```
SonarQube Token
Nexus Credentials
DockerHub Credentials
Kubernetes Secret
App password for jenkins from Google Account
```

Also configure:

```
Manage Jenkins → System → SonarQube Servers
```

---

# 📦 Step 3: Nexus Repository Setup

Install Docker.

Run Nexus container:

```
docker run -d -p 8081:8081 --name nexus sonatype/nexus3
```

Retrieve default password:

```
docker exec -it container_id /bin/bash cat /sonatype-work/nexus3/admin.password
```

Then configure:

```
Maven Releases Repository
Maven Snapshots Repository
```

Update `pom.xml` repository URLs.

---

# 🔎 Step 4: SonarQube Server Setup

Install Docker.

Run SonarQube container:

```
docker run -d -p 9000:9000 sonarqube:lts-community
```

Open:

```
http://server-ip:9000
```

Configure:

* Create project
* Generate **SonarQube Token**
* Add token to Jenkins credentials

---

# ☁️ Step 5: Terraform & Kubernetes Setup

Install required tools.

### Install AWS CLI

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Configure AWS:

```
aws configure
```

---

### Install Terraform

```
sudo apt install terraform
```

---

### Install Kubectl

```
sudo apt install kubectl
```

---

### Create EKS Cluster

Clone Terraform files:

```
main.tf
variables.tf
outputs.tf
```

Run:

```
terraform init
terraform plan
terraform apply
```

---

### Configure Kubeconfig

```
aws eks update-kubeconfig --region <region> --name <cluster-name>
```

Verify cluster:

```
kubectl get nodes
```

---

# ☸️ Kubernetes Deployment

Create Kubernetes resources.

### Service YAML

```
service.yml
```

### Role YAML

```
role.yml
```
### Bind Role to Jenkins Service Account YAML

```
bind-role.yml
```

Create Kubernetes secret:

```
kubectl create secret docker-registry dockerhub-secret \
--docker-username=<username> \
--docker-password=<password> \
--docker-email=<email>
```

Add **deployment-service.yml** step in Jenkins pipeline.

---

# 📧 Jenkins Email Notification Setup

##  Configure Email Settings

Go to:

```text
Manage Jenkins → System Configuration
```

### 📌 Configure SMTP

Example (Gmail):

```text
SMTP Server: smtp.gmail.com
Port: 465
Use TLS: Yes
Username: your-email@gmail.com
Password: app-password
```

⚠️ Generate app password for jenkins and use **App Password**, not your Gmail password.

---

### 📌 Default Email Settings

```text
Default Recipients: your-email@gmail.com
```

# 📊 Step 6: Monitoring Setup

Monitoring stack includes:

```
Prometheus
Blackbox Exporter
Grafana
```

---

## Install Prometheus

Download and extract Prometheus.

Start service.

---

## Install Blackbox Exporter

Download exporter and configure it.

Update `prometheus.yml`.

Example:

```
- job_name: 'blackbox'
  metrics_path: /probe
  params:
    module: [http_2xx]
```

---

## Install Grafana

Start Grafana server.

Access:

```
http://server-ip:3000
```

Import dashboards.

---

# 📈 Monitoring Verification

Check Prometheus target:

```
Status → Targets
```

Target health should be:

```
UP
```

Grafana dashboards will display:

```
Application availability
Endpoint metrics
HTTP status monitoring
```

---

# 🌐 Step 7: Domain Mapping

Map a **custom domain** to the application.

In your DNS provider:

Add **CNAME record**.

Example:

```
Type: CNAME
Name: blog
Value: <EKS-load-balancer-url>
```

# 📊 Final Output

Your application will be accessible via:

```
Load Balancer URL
Custom Domain
```

Monitoring dashboards available in:

```
Grafana
Prometheus
```
