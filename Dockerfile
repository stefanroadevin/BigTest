FROM golang:1.19.2

WORKDIR /go/src/app

COPY api.go .

RUN go mod init api &&\
     go mod tidy && \
     go get -u github.com/go-sql-driver/mysql github.com/gin-gonic/gin && \
     go build -o goapi api.go

CMD ["./goapi"]