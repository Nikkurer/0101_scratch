# Start by building the application.
FROM golang:1.19-alpine as builder
WORKDIR /go/src/app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 go build -o /go/bin/app cmd/main.go


FROM scratch
USER nobody
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
WORKDIR /upload
VOLUME [ "/upload" ]
COPY --from=builder --chown=nobody /go/bin/app /upload/app
COPY --from=builder --chown=nobody /go/src/app/upload /upload/uploads
ENTRYPOINT ["/upload/app"]