package user_onboard

import (
	"database/sql"
	"net/http"
	"time"

	"github.com/google/uuid"
	marketing "github.com/trones21/pk_projName/backend/db/sqlcgen/marketing"
)

func trackLinkClickHandler(w http.ResponseWriter, r *http.Request, dbConn *sql.DB) {
	link := r.URL.Query().Get("token")
	if link == "" {
		http.Error(w, "Invalid or missing token", http.StatusBadRequest)
		return
	}

	uuidlink, err := uuid.Parse(link)
	if err != nil {
		http.Error(w, "Unable to parse link into uuid", http.StatusBadRequest)
		return
	}

	referrer := r.Referer()

	// Update link click tracking
	queries := marketing.New(dbConn)
	_, err = queries.InsertSignupLinkClick(r.Context(), marketing.InsertSignupLinkClickParams{
		Link:      uuidlink,
		ClickedAt: sql.NullTime{Time: time.Now(), Valid: true},
		Referrer:  sql.NullString{String: referrer, Valid: true},
	})
	if err != nil {
		http.Error(w, "Failed to track link click", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}
