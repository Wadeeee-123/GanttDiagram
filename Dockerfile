# === 第 1 階段：建置 Go 程式 ===
FROM golang:1.24 AS builder

WORKDIR /app

# 複製 go.mod / go.sum 先下載 dependency（加速建置）
COPY go.mod go.sum ./
RUN go mod download

# 複製所有程式碼
COPY . .

# 編譯 binary
RUN CGO_ENABLED=0 GOOS=linux go build -o server main.go

# === 第 2 階段：建立最小化運行環境 ===
FROM alpine

WORKDIR /app

# 複製 index.html
COPY index.html .

# 複製第一階段的 binary
COPY --from=builder /app/server .

# 對外開放 port
EXPOSE 8080

# 啟動
CMD ["./server"]
