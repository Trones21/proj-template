
# Stage 1: Build the Binary (Using Golang Image)
FROM golang:1.23 AS builder

WORKDIR /app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o ./dist/pk_projName ./cmd/app/

#Stage 2: Create the Final Clean Image (No Source Code)
FROM debian:12

WORKDIR /dist

# Copy only the built binary from the builder stage
COPY --from=builder /app/dist/pk_projName .

#Install tools
RUN apt update && apt install -y curl net-tools iputils-ping procps nano

# Set executable permissions
RUN chmod +x /dist/pk_projName


# Run the application (again it know it's weird because we are only creating the image here... this is essentially saying what to run on startup)
CMD ["/dist/pk_projName"]


