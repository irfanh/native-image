# Multi-stage build for GraalVM native image
FROM --platform=linux/amd64 ghcr.io/graalvm/graalvm-community:17-ol8 AS builder

# Install native-image
RUN gu install native-image

# Copy source code
COPY . /app
WORKDIR /app

# Build native image for linux/amd64
# Increase memory limits for GraalVM compilation
RUN export MAVEN_OPTS="-Xmx8g" && \
    ./mvnw clean package -Pnative -DskipTests \
    -Dspring.aot.jvmArguments="-Xmx6g"

# Runtime stage - minimal distroless image
FROM --platform=linux/amd64 gcr.io/distroless/base-debian11:nonroot

# Copy the native executable
COPY --from=builder /app/target/janus-native-test /app/janus-native-test

# Expose port
EXPOSE 8080

# Set working directory
WORKDIR /app

# Run the native image
CMD ["./janus-native-test"] 