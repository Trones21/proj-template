package utils

import (
	"database/sql"

	"github.com/google/uuid"
)

func ToNullString(s *string) sql.NullString {
	if s != nil {
		return sql.NullString{String: *s, Valid: true}
	}
	return sql.NullString{Valid: false}
}

func ToNullUUID(u *uuid.UUID) uuid.NullUUID {
	if u != nil {
		return uuid.NullUUID{UUID: *u, Valid: true}
	}
	return uuid.NullUUID{Valid: false}
}
