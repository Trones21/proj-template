
# Stage 1: Build the Binary (Using Golang Image)
FROM golang:1.23 AS builder

WORKDIR /app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o ./dist/talkback ./cmd/app/

#Stage 2: Create the Final Clean Image (No Source Code)
FROM debian:12

WORKDIR /dist

# Copy only the built binary from the builder stage
COPY --from=builder /app/dist/talkback .

#Install tools
RUN apt update && apt install -y curl net-tools iputils-ping procps nano

# Set executable permissions
RUN chmod +x /dist/talkback


# Run the application (again it know it's weird because we are only creating the image here...)
CMD ["/dist/talkback"]


# not sure what this was for 
# FROM golang:1.23

# WORKDIR /app
# COPY . .
# SHELL ["/bin/bash", "-c"]
# #RUN go mod tidy
# RUN go build -o ./dist/talkback ./cmd/app/

# # Use a lightweight image
# FROM alpine:latest
# WORKDIR /root/
# COPY --from=builder /app/main .
# EXPOSE 8080
# CMD ["./main"]

