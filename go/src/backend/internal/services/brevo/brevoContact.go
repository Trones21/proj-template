package brevo

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

// NewContact adds a new contact to Brevo
func (c *BrevoClient) NewContact(email, signupLink string) error {
	url := "https://api.brevo.com/v3/contacts"

	data := map[string]interface{}{
		"updateEnabled": true,
		"email":         email,
		"signup_link":   signupLink,
	}

	// Serialize payload to JSON
	jsonData, err := json.Marshal(data)
	if err != nil {
		fmt.Println("Error marshaling JSON:", err)
		return err
	}

	// Prepare the request
	req, err := c.prepareRequest("POST", url, jsonData)
	if err != nil {
		fmt.Println("Error creating HTTP request:", err)
		return err
	}

	// Make the API call
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Println("Error making HTTP request:", err)
		return err
	}
	defer res.Body.Close()

	// Read and log the response body
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return err
	}

	fmt.Printf("Response status: %d\n", res.StatusCode)
	fmt.Printf("Response body: %s\n", string(body))

	// Check for non-2xx status codes
	if res.StatusCode < 200 || res.StatusCode > 299 {
		fmt.Printf("Request failed with status code: %d\n", res.StatusCode)
		return fmt.Errorf("failed to add contact: status code %d", res.StatusCode)
	}

	fmt.Printf("Contact added successfully: %s\n", email)
	return nil
}

// type NewContactPayload struct {
// 	UpdateEnabled bool   `json:"updateEnabled"`
// 	Email         string `json:"email"`
// 	SignupLink    string `json:"signup_link"`
// }

// func NewContact(email string, signupLink string) error {

// 	url := "https://api.brevo.com/v3/contacts"

// 	data := NewContactPayload{
// 		UpdateEnabled: true,
// 		Email:         email,
// 		SignupLink:    signupLink,
// 	}

// 	jsonData, err := json.Marshal(data)
// 	if err != nil {
// 		fmt.Println("Error marshaling JSON:", err)
// 		return err
// 	}
// 	fmt.Println(string(jsonData))
// 	requestBody := bytes.NewReader(jsonData)

// 	req, err := http.NewRequest("POST", url, requestBody)
// 	if err != nil {
// 		fmt.Println("Error creating HTTP request:", err)
// 		return err
// 	}

// 	req.Header.Add("accept", "application/json")
// 	req.Header.Add("content-type", "application/json")
// 	brevo_api_key := os.Getenv("BREVO_API_KEY")
// 	req.Header.Add("api-key", brevo_api_key)

// 	res, err := http.DefaultClient.Do(req)
// 	if err != nil {
// 		fmt.Println("Error making HTTP request:", err)
// 		return err
// 	}

// 	defer res.Body.Close()

// 	if res.StatusCode < 200 || res.StatusCode > 299 {
// 		fmt.Printf("Request failed with status code: %d\n", res.StatusCode)
// 		return err
// 	}

// 	body, err := io.ReadAll(res.Body)
// 	if err != nil {
// 		fmt.Println("Error reading response body:", err)
// 		return err
// 	}
// 	fmt.Println(body)
// 	return nil

// }
