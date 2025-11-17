# Build stage
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

RUN apk add curl

# Use TARGETARCH build arg for multi-platform support, fallback to uname -m
ARG TARGETARCH
RUN ARCH=${TARGETARCH:-$(uname -m)} && \
    if [ "$ARCH" = "amd64" ] || [ "$ARCH" = "x86_64" ]; then \
        MIGRATE_ARCH="amd64"; \
    elif [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then \
        MIGRATE_ARCH="arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    curl -L https://github.com/golang-migrate/migrate/releases/download/v4.12.2/migrate.linux-${MIGRATE_ARCH}.tar.gz | tar xvz && \
    mv migrate.linux-${MIGRATE_ARCH} migrate && \
    chmod +x migrate && \
    ls -la migrate && \
    ./migrate -version


# Run stage
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main . 
COPY --from=builder /app/migrate ./migrate
COPY app.env .

COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./migration
# document which port the app will run on, see app.env
EXPOSE 8080

CMD ["/app/main"]

ENTRYPOINT ["/app/start.sh"]