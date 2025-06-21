# 🚀 Spring Boot Native Image - AMD64

A high-performance Spring Boot application compiled to native binary using GraalVM, optimized for Linux AMD64 deployment.

[![Build Native AMD64 Image](https://github.com/irfanh/native-image/actions/workflows/native-build.yml/badge.svg)](https://github.com/irfanh/native-image/actions/workflows/native-build.yml)

## ✨ Features

- **⚡ Ultra-fast startup**: ~90ms startup time
- **🔥 Low memory usage**: Native binary with minimal footprint  
- **🐳 Docker ready**: Multi-stage builds for production
- **☸️ Kubernetes optimized**: Health checks and non-root containers
- **🏗️ CI/CD automated**: GitHub Actions for AMD64 builds

## 🏃‍♂️ Quick Start

### Pull and Run the Pre-built Image

```bash
# Pull the latest native AMD64 image
docker pull hub.marschall.systems/observability/janus-native:latest

# Run the container
docker run -p 8080:8080 hub.marschall.systems/observability/janus-native:latest
```

### Test the Application

```bash
# Health check
curl http://localhost:8080/actuator/health

# Application endpoints
curl http://localhost:8080/api/health
curl http://localhost:8080/api/info

# Proxy endpoint (POST)
curl -X POST http://localhost:8080/api/proxy \
  -H "Content-Type: application/json" \
  -d '{"message": "test"}'
```

## 🔧 Local Development

### Prerequisites

- Java 17+
- GraalVM (for native compilation)
- Docker (for containerization)

### Build Native Binary

```bash
# Build native image (macOS/Linux)
./mvnw clean package -Pnative -DskipTests

# Run the native binary
./target/janus-native-test
```

### Build Docker Image

```bash
# Build for local platform
docker build -f Dockerfile.k8s -t janus-native:local .

# Build for AMD64 (cross-platform)
docker build --platform=linux/amd64 -f Dockerfile.k8s -t janus-native:amd64 .
```

## 🚀 Deployment

### Docker Compose

```yaml
version: '3.8'
services:
  janus-native:
    image: hub.marschall.systems/observability/janus-native:latest
    ports:
      - "8080:8080"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: janus-native
spec:
  replicas: 3
  selector:
    matchLabels:
      app: janus-native
  template:
    metadata:
      labels:
        app: janus-native
    spec:
      containers:
      - name: janus-native
        image: hub.marschall.systems/observability/janus-native:latest
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
```

## 📊 Performance Metrics

| Metric | Native Image | JVM |
|--------|-------------|-----|
| **Startup Time** | ~90ms | ~3-5s |
| **Memory Usage** | ~25MB | ~150MB |
| **Binary Size** | ~77MB | ~180MB (with JRE) |
| **CPU Usage** | Lower | Higher |

## 🔄 CI/CD Pipeline

The project uses GitHub Actions to automatically:

1. **Build** native AMD64 binary using GraalVM
2. **Test** the application endpoints
3. **Package** into optimized Docker image
4. **Push** to GitHub Container Registry
5. **Tag** with branch name and commit SHA

## 📁 Project Structure

```
.
├── src/main/java/com/evoila/janus/
│   ├── JanusNativeTestApplication.java    # Main application
│   └── ProxyController.java               # REST controller
├── .github/workflows/
│   └── native-build.yml                   # CI/CD pipeline
├── Dockerfile.k8s                         # Production Dockerfile
├── k8s/                                   # Kubernetes manifests
└── README.md                              # This file
```

## 🛠️ Available Scripts

```bash
# Local development
./mvnw spring-boot:run

# Build JAR
./mvnw clean package

# Build native image
./mvnw clean package -Pnative

# Test native binary
./test-native.sh
```

## 📝 Configuration

The application uses `application.yml` for configuration:

```yaml
server:
  port: 8080

management:
  endpoints:
    web:
      exposure:
        include: health,info
  endpoint:
    health:
      show-details: always
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🔗 Links

- [GraalVM Native Image](https://www.graalvm.org/native-image/)
- [Spring Boot Native Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/native-image.html)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry) 