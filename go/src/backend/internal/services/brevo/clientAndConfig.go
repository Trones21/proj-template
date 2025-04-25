package brevo

import (
	"bytes"
	"fmt"
	"net/http"
	"os"
)

// Config struct for Brevo settings
type Config struct {
	APIKey      string
	SandboxMode bool
}

// NewConfig initializes the Brevo configuration
func NewConfig() *Config {
	return &Config{
		APIKey:      os.Getenv("BREVO_API_KEY"),
		SandboxMode: os.Getenv("BREVO_SANDBOX_MODE") == "true",
	}
}

// BrevoClient handles Brevo API requests
type BrevoClient struct {
	Config *Config
}

// NewClient creates a new BrevoClient
func NewClient() *BrevoClient {
	return &BrevoClient{
		Config: NewConfig(),
	}
}

// prepareRequest prepares an HTTP request with common headers
func (c *BrevoClient) prepareRequest(method, url string, body []byte) (*http.Request, error) {
	req, err := http.NewRequest(method, url, bytes.NewReader(body))
	if err != nil {
		return nil, err
	}

	// Add common headers
	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("api-key", c.Config.APIKey)

	// Enable sandbox mode if configured
	if c.Config.SandboxMode {
		req.Header.Add("X-Sib-Sandbox", "drop")
		fmt.Println("Sandbox mode enabled: No actual emails will be sent")
	}

	return req, nil
}
