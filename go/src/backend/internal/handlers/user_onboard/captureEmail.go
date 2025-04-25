package user_onboard

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/google/uuid"
	"github.com/trones21/pk_projName/backend/internal/helpers"
	"github.com/trones21/pk_projName/backend/internal/services/brevo"
	"github.com/trones21/pk_projName/backend/internal/utils"
)

func CaptureEmailHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req struct {
			Email           string     `json:"email"`
			LandingPage     string     `json:"landing_page"`
			Referrer        *string    `json:"referrer"`
			DeviceSessionID *uuid.UUID `json:"device_session_id"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			fmt.Print(err.Error())
			http.Error(w, "See backend", http.StatusBadRequest)
			return
		}

		// Insert email capture
		queries := marketing.New(dbConn)
		capture, err := queries.InsertEmailCapture(r.Context(), marketing.InsertEmailCaptureParams{
			Email:           req.Email,
			LandingPage:     req.LandingPage,
			Referrer:        utils.ToNullString(req.Referrer),
			DeviceSessionID: utils.ToNullUUID(req.DeviceSessionID),
		})

		if err != nil {
			fmt.Print(err.Error())
			if helpers.IsUniqueConstraintError(err) {
				w.WriteHeader(http.StatusOK)
				w.Write([]byte("Thank you for signing up!"))
				return
			}
			http.Error(w, "Failed to save email", http.StatusInternalServerError)
			return
		}

		// Generate signup link
		signupLink := fmt.Sprintf("https://pk_host/signup?token=%s", capture.LinkID)

		//Create the contact in brevo (with their unique signup link)
		brevoClient := brevo.NewClient()
		err = brevoClient.NewContact(req.Email, signupLink)
		if err != nil {
			http.Error(w, "Failed to add to email list", http.StatusInternalServerError)
			return
		}

		w.WriteHeader(http.StatusCreated)
	}
}
