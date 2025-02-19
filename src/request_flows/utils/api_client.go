package utils

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	config "requestflows/config"
)

// LoginResponse represents the response from the login endpoint
type LoginResponse struct {
	AccessToken string `json:"access"`
}

// Login performs a user login and returns an access token
func Login(username, password string) (string, error) {
	data := map[string]string{
		"username": username,
		"password": password,
	}
	body, _ := json.Marshal(data)

	resp, err := http.Post(fmt.Sprintf("%s/token/", config.BaseURL), "application/json", bytes.NewBuffer(body))
	if err != nil {
		return "", fmt.Errorf("failed to make login request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("login failed with status: %s", resp.Status)
	}

	var loginResp LoginResponse
	if err := json.NewDecoder(resp.Body).Decode(&loginResp); err != nil {
		return "", fmt.Errorf("failed to decode login response: %w", err)
	}

	return loginResp.AccessToken, nil
}

// CreateObject sends a POST request to create an object
func CreateObject(token, endpoint string, data interface{}) error {
	body, _ := json.Marshal(data)

	req, err := http.NewRequest("POST", fmt.Sprintf("%s/%s/", config.BaseURL, endpoint), bytes.NewBuffer(body))
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}

	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", token))
	req.Header.Set("Content-Type", "application/json")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return fmt.Errorf("failed to make create request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusCreated {
		return fmt.Errorf("create object failed with status: %s", resp.Status)
	}

	fmt.Println("Object created successfully.")
	return nil
}

// ReadObject sends a GET request to retrieve an object or list of objects
func ReadObject(token, endpoint string, objectID *string) (interface{}, error) {
	url := fmt.Sprintf("%s/%s/", config.BaseURL, endpoint)
	if objectID != nil {
		url += *objectID + "/"
	}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", token))
	req.Header.Set("Content-Type", "application/json")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to make read request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("read object failed with status: %s", resp.Status)
	}

	var result interface{}
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("failed to decode response: %w", err)
	}

	return result, nil
}

// UpdateObject sends a PUT request to update an object
func UpdateObject(token, endpoint string, objectID string, data interface{}) error {
	body, _ := json.Marshal(data)

	req, err := http.NewRequest("PUT", fmt.Sprintf("%s/%s/%s/", config.BaseURL, endpoint, objectID), bytes.NewBuffer(body))
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}

	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", token))
	req.Header.Set("Content-Type", "application/json")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return fmt.Errorf("failed to make update request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("update object failed with status: %s", resp.Status)
	}

	fmt.Println("Object updated successfully.")
	return nil
}

// DeleteObject sends a DELETE request to delete an object
func DeleteObject(token, endpoint string, objectID string) error {
	req, err := http.NewRequest("DELETE", fmt.Sprintf("%s/%s/%s/", config.BaseURL, endpoint, objectID), nil)
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}

	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", token))
	req.Header.Set("Content-Type", "application/json")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return fmt.Errorf("failed to make delete request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("delete object failed with status: %s", resp.Status)
	}

	fmt.Println("Object deleted successfully.")
	return nil
}
