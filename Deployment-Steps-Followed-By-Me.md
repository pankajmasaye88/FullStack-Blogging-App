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
<img width="467" height="521" alt="Untitled desifyhgn" src="https://github.com/user-attachments/assets/b3c6b606-9b23-4b81-917b-bc3c86540a7f" />

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
<img width="1920" height="356" alt="Screenshot (154)" src="https://github.com/user-attachments/assets/2aa1a8d2-bac1-4a2f-ba6e-2d8daa4ca15d" />
<img width="1920" height="476" alt="Screenshot (155)" src="https://github.com/user-attachments/assets/40da6893-0242-4acd-b8a7-769419e0bd37" />


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
<img width="761" height="675" alt="Screenshot (171)" src="https://github.com/user-attachments/assets/e182b267-d05b-4409-b779-4655e2c128b7" />
<img width="1896" height="678" alt="Screenshot (158)" src="https://github.com/user-attachments/assets/2b0de9dc-850f-4131-b83e-9518615bd7f1" />
<img width="1865" height="686" alt="Screenshot (162)" src="https://github.com/user-attachments/assets/2a8794d5-302a-4ece-bc3a-a063b52c2e4f" />
<img width="928" height="703" alt="Screenshot (167)" src="https://github.com/user-attachments/assets/fab63cf0-cb9a-4b74-a3b5-0b0f6f50c5ad" />
<img width="1289" height="324" alt="Screenshot (175)" src="https://github.com/user-attachments/assets/e9c16d75-a2dc-40ce-b261-48830707c62f" />

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
<img width="822" height="352" alt="Screenshot (168)" src="https://github.com/user-attachments/assets/30790581-0d08-4a08-81b6-58281ca19af7" />
<img width="1897" height="268" alt="Screenshot (170)" src="https://github.com/user-attachments/assets/0e341b0a-d838-4e4a-be38-5e68b9d9ccdb" />
<img width="1920" height="405" alt="Screenshot (159)" src="https://github.com/user-attachments/assets/239ed354-e5a5-48de-887c-f26dffc0563e" />
<img width="1920" height="416" alt="Screenshot (160)" src="https://github.com/user-attachments/assets/fcd2160c-7426-44dd-87c1-fea68be1e577" />
<img width="1920" height="440" alt="Screenshot (161)" src="https://github.com/user-attachments/assets/d9d80f3f-0469-47d5-8d11-220b9c9939cb" />

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
<img width="1771" height="405" alt="Screenshot (157)" src="https://github.com/user-attachments/assets/306f1d20-fd8d-4f30-8ba3-8e13c23b2a26" />


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
<img width="1920" height="753" alt="Screenshot (156)" src="https://github.com/user-attachments/assets/9eba8596-0042-40a1-aeba-6fb0c72f849b" />
<img width="1903" height="749" alt="Screenshot (169)" src="https://github.com/user-attachments/assets/bab4acdd-c9a0-4648-b338-27342472ab1b" />
<img width="1635" height="732" alt="Screenshot (180)" src="https://github.com/user-attachments/assets/7d4edb99-1baa-4b5b-9cb5-10da1c867c34" />
<img width="1629" height="758" alt="Screenshot (181)" src="https://github.com/user-attachments/assets/90a319d6-14f3-411c-9e17-a39fac913def" />
<img width="1585" height="599" alt="Screenshot (182)" src="https://github.com/user-attachments/assets/322c8e0f-1b73-411a-bac1-801dfcaee32d" />

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
<img width="1249" height="553" alt="Screenshot (176)" src="https://github.com/user-attachments/assets/6f36f63a-ffe3-43b8-8dde-b0cfac1bca7f" />

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
<img width="562" height="782" alt="Screenshot (172)" src="https://github.com/user-attachments/assets/90cbf7fd-6731-42ed-afee-9953c2cea871" />
<img width="489" height="850" alt="Screenshot (173)" src="https://github.com/user-attachments/assets/6b83780e-9659-431d-b80f-7c3b24f87cf7" />
<img width="1431" height="196" alt="Screenshot (177)" src="https://github.com/user-attachments/assets/4f9eb3d6-e72a-4661-9518-54e60e470a3e" />
<img width="1470" height="386" alt="Screenshot (178)" src="https://github.com/user-attachments/assets/b5b22c8f-3428-4570-800f-ec6a21e244b5" />
<img width="1466" height="392" alt="Screenshot (179)" src="https://github.com/user-attachments/assets/33cd2b5b-c7a6-414f-b0d6-1eb7db4b9016" />

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
<img width="1920" height="691" alt="Screenshot (165)" src="https://github.com/user-attachments/assets/5fc47391-d422-447f-a120-ce25b77c80f6" />
<img width="950" height="857" alt="Screenshot (166)" src="https://github.com/user-attachments/assets/387ff8a5-1cab-48dc-8fb3-ba19bbe36602" />

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
<img width="1691" height="643" alt="Screenshot (163)" src="https://github.com/user-attachments/assets/dd9d87f1-af5e-4b57-99b7-70cc627ff3f8" />

Monitoring dashboards available in:

```
Grafana
Prometheus
```


