FROM golang:1.11.1
WORKDIR /go/src/github.com/twistlock/cloud-discovery/
COPY . .
RUN go fmt ./...
RUN go vet ./...
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app cmd/server/main.go

FROM registry.redhat.io/ubi7/ubi:7.6-123
WORKDIR /licenses
COPY /licenses/* ./
WORKDIR /root/
COPY --from=0 /go/src/github.com/twistlock/cloud-discovery/app .
CMD ["./app"]
LABEL vendor=Twistlock
LABEL description="Cloud Discovery provides a point in time enumeration of all the cloud native platform services"
LABEL name="twistlock/cloud-discovery"
LABEL summary="Twistlock Cloud Discovery"
