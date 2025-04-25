package flows

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	config "requestflows/config"
)

type EmailCaptureData struct {
	Email       string            `json:"email"`
	LandingPage string            `json:"landing_page"`
	Metadata    map[string]string `json:"metadata"`
}

func EmailCapture() {

	data := EmailCaptureData{
		Email:       "trones.rds@gmail.com",
		LandingPage: "/allidoiswin",
	}
	err := EmailCaputureReq(nil, data)
	if err != nil {
		fmt.Println(err)
		return
	}

}

func EmailCaputureReq(token, data interface{}) error {
	body, _ := json.Marshal(data)
	req, err := http.NewRequest("POST", fmt.Sprintf("%s/api/captureEmail", config.BaseURL), bytes.NewBuffer(body))
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}

	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", token))
	req.Header.Set("Content-Type", "application/json")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return fmt.Errorf("failed to make email capture request: %w", err)
	}
	defer resp.Body.Close()

	// Read the response body
	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return fmt.Errorf("failed to read response body: %w", err)
	}

	if resp.StatusCode != http.StatusCreated {
		return fmt.Errorf("email capture failed: \nStatus:%s \nBody:%s", resp.Status, respBody)
	}

	fmt.Println("Object created successfully.")
	return nil
}
