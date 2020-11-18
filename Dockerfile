FROM golang:1.15-alpine3.12 AS builder

ENV CGO_ENABLED 0

ENV TZ=Europe/Moscow

RUN apk update && \
    apk upgrade && \
    apk --no-cache add ca-certificates tzdata && \
    cp -r -f /usr/share/zoneinfo/$TZ /etc/localtime

WORKDIR /app

COPY . .

RUN go build -mod=vendor -o /winnie ./...

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY --from=builder /etc/localtime /etc/localtime

COPY --from=builder /winnie /winnie

ENTRYPOINT ["/winnie"]