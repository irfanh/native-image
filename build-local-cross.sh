#!/bin/bash

echo "🔧 Attempting Cross-compilation for Linux AMD64"
echo "==============================================="
echo ""

# Check if we have Maven and native-image
if ! command -v mvn &> /dev/null && ! command -v ./mvnw &> /dev/null; then
    echo "❌ Maven not found"
    exit 1
fi

echo "🏗️  Building JAR first..."
./mvnw clean package -DskipTests

if [ $? -ne 0 ]; then
    echo "❌ JAR build failed"
    exit 1
fi

echo ""
echo "🧪 Testing different native build approaches..."
echo ""

# Try with reduced memory
echo "📦 Attempt 1: Conservative memory settings"
export MAVEN_OPTS="-Xmx6g"
./mvnw spring-boot:build-image -DskipTests \
    -Dspring-boot.build-image.imageName=janus-native-local:latest \
    2>/dev/null

echo ""
echo "📦 Attempt 2: Cloud Native Buildpacks (if available)"
pack build janus-native-pack --builder gcr.io/buildpacks/builder:v1 2>/dev/null || echo "Pack not available"

echo ""
echo "📦 Attempt 3: Try Podman (if available)"
if command -v podman &> /dev/null; then
    podman build --platform=linux/amd64 -f Dockerfile.minimal -t janus-native-podman:latest .
else
    echo "Podman not available"
fi

echo ""
echo "💡 Alternative options:"
echo "  1. Use GitHub Actions (free, reliable)"
echo "  2. Use a cloud Linux VM temporarily"
echo "  3. Use Lima/Colima for better Docker performance"
echo "  4. Try native compilation on your Mac (ARM64 only)" 