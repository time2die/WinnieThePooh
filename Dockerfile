FROM golang:1.15-alpine3.12 AS builder

ENV CGO_ENABLED 0

ENV TZ=Europe/Moscow

WORKDIR /winnie

COPY . .

RUN go build -mod=vendor -o /winnie ./cmd/winnie

FROM scratch

COPY --from=builder /winnie /winnie

ENTRYPOINT ["/winnie"]