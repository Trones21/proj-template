package utils

import (
	"encoding/json"
	"fmt"
	"os"
)

func LoadJSON(filepath string) map[string]interface{} {
	file, err := os.Open(filepath)
	if err != nil {
		panic(fmt.Sprintf("Failed to open JSON file: %v", err))
	}
	defer file.Close()

	var data map[string]interface{}
	if err := json.NewDecoder(file).Decode(&data); err != nil {
		panic(fmt.Sprintf("Failed to decode JSON: %v", err))
	}

	return data
}
