#!/bin/bash

echo "🐧 Building Native Image for Linux AMD64"
echo "======================================="
echo ""

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "❌ This script must be run on Linux to build linux/amd64 native image"
    echo "💡 Consider using:"
    echo "   - GitHub Actions (.github/workflows/native-build.yml)"
    echo "   - Docker build (with more memory)"
    echo "   - Linux VM or server"
    exit 1
fi

# Check for GraalVM
if ! command -v native-image &> /dev/null; then
    echo "❌ GraalVM native-image not found"
    echo "💡 Install GraalVM and native-image tool first"
    exit 1
fi

echo "🔨 Building native image..."
export MAVEN_OPTS="-Xmx8g"
./mvnw clean package -Pnative -DskipTests \
    -Dspring.aot.jvmArguments="-Xmx6g"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! Linux AMD64 native image built!"
    echo ""
    echo "📊 Binary info:"
    ls -lh target/janus-native-test
    file target/janus-native-test
    echo ""
    echo "🧪 Testing startup..."
    timeout 30s ./target/janus-native-test &
    sleep 5
    curl -s http://localhost:8080/actuator/health | jq . || echo "Health check failed"
    pkill -f janus-native-test
else
    echo "❌ Build failed"
    exit 1
fi 