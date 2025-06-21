#!/bin/bash

echo "🧪 Testing Native Image Compilation"
echo "===================================="
echo ""
echo "📋 Project Structure:"
echo "  ✅ Single module (no multi-module complexity)"
echo "  ✅ Spring MVC (no WebFlux/Netty)"
echo "  ✅ Minimal dependencies"
echo "  ✅ Simple proxy functionality"
echo ""

echo "🔨 Step 1: Regular build test..."
./mvnw clean compile
if [ $? -ne 0 ]; then
    echo "❌ Regular build failed!"
    exit 1
fi
echo "✅ Regular build successful!"
echo ""

echo "🔨 Step 2: Package test..."
./mvnw clean package -DskipTests
if [ $? -ne 0 ]; then
    echo "❌ Package build failed!"
    exit 1
fi
echo "✅ Package build successful!"
echo ""

echo "🚀 Step 3: Attempting native compilation..."
echo "⚠️  This may take 10-20 minutes and use 4-8GB RAM"
echo "⚠️  Press Ctrl+C to cancel if needed"
echo ""

./mvnw clean package -Pnative -DskipTests

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! Native image compiled!"
    echo ""
    echo "📊 Native executable info:"
    ls -lh target/janus-native-test
    echo ""
    echo "🎯 Next steps:"
    echo "  1. Try Docker build: docker build -t janus-native ."
    echo "  2. Apply learnings to main project"
else
    echo ""
    echo "❌ Native compilation failed"
    echo ""
    echo "🔍 This tells us about the complexity of native compilation"
fi
