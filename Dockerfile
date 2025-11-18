# Stage 1: Build / Стадия 1: Сборка
FROM golang:1.22 AS builder

# Set working directory / Установка рабочей директории
WORKDIR /app

# Copy go mod files / Копирование файлов go mod
COPY go.mod go.sum ./

# Download dependencies / Загрузка зависимостей
RUN go mod download

# Copy source code / Копирование исходного кода
COPY *.go ./

# Build the application / Сборка приложения
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /my_app .

# Stage 2: Runtime / Стадия 2: Runtime
FROM alpine:latest

# Create app directory / Создание директории приложения
WORKDIR /app

# Copy binary from builder stage / Копирование бинарника из стадии сборки
COPY --from=builder /my_app .

# Set executable permissions / Установка прав на выполнение
RUN chmod +x /my_app

# Run the application / Запуск приложения
CMD ["./my_app"]

