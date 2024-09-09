build: 
	rm -rf bin
	GOOS=linux GOARCH=amd64 go build -o bin/bootstrap ./*.go
	cd bin && zip app.zip bootstrap