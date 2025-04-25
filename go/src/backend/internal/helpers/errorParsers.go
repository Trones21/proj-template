package helpers

import (
	"strings"
)

// isUniqueConstraintError checks if the error is a unique constraint violation.
func IsUniqueConstraintError(err error) bool {
	if err == nil {
		return false
	}
	// Check if the error contains the phrase for unique constraint violations
	return strings.Contains(err.Error(), "duplicate key value violates unique constraint")
}
