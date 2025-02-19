package main

import (
	"fmt"
	"os"
	"requestflows/config"
	"requestflows/flows"
)

func main() {
	// Retrieve the BASE_URL from environment variables
	config.BaseURL = os.Getenv("BASE_URL")
	if config.BaseURL == "" {
		fmt.Println("Error: BASE_URL environment variable is not set")
		os.Exit(1)
	}

	// Example: Pass the baseURL to flows if needed
	fmt.Printf("Using BASE_URL: %s\n", config.BaseURL)

	//hanlde flow selection
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run main.go <flow_name>")
		return
	}

	flowName := os.Args[1]

	switch flowName {
	case "email_capture":
		flows.EmailCapture()
	default:
		fmt.Printf("Unknown flow: %s\n", flowName)
	}
}
