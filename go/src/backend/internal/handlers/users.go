package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/google/uuid"
	db "github.com/trones21/pk_projName/backend/db/sqlcgen"
)

type User struct {
	ID        int64  `json:"id"`
	Name      string `json:"name"`
	Email     string `json:"email"`
	CreatedAt string `json:"created_at"`
}

func UsersHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			getUserHandler(w, r, dbConn)
		case http.MethodPost:
			createUserHandler(w, r, dbConn)
		default:
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	}
}

func getUserHandler(w http.ResponseWriter, r *http.Request, dbConn *sql.DB) {
	idStr := r.URL.Query().Get("id")
	if idStr == "" {
		http.Error(w, "Missing id parameter", http.StatusBadRequest)
		return
	}

	id, err := uuid.Parse(idStr)
	if err != nil {
		http.Error(w, "Invalid UUID", http.StatusBadRequest)
		return
	}

	queries := db.New(dbConn)
	user, err := queries.GetUserByID(r.Context(), id)
	if err != nil {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}

	json.NewEncoder(w).Encode(user)
}


//Figure this out later -- ensure it works with all the scenarios laid out below

/* 
create account - never signed up with pre launch email
create account - pre-launch, used link
create account - on pre-launch did not use link 

ensure that session id is kept and mapped to user so that user actions are "migrated"

e.g. anon user does:
- clikc link
- comment
- upvote something
(not saying that anon users will be able to do all these actions)



// func createUserHandler(w http.ResponseWriter, r *http.Request, dbConn *sql.DB) {
// 	var user db.CreateUserParams
// 	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
// 		http.Error(w, "Invalid request body", http.StatusBadRequest)
// 		return
// 	}

// 	user.IsMarketingUser = true // Pre-launch user
// 	user.PasswordHash = nil     // No password yet

// 	queries := db.New(dbConn)
// 	row, err := queries.CreateUser(r.Context(), user)
// 	if err != nil {
// 		http.Error(w, "Failed to create user", http.StatusInternalServerError)
// 		return
// 	}

// 	w.WriteHeader(http.StatusCreated)
// }

// func completeSignupHandler(w http.ResponseWriter, r *http.Request, dbConn *sql.DB) {
// 	token := r.URL.Query().Get("token")
// 	if token == "" {
// 		http.Error(w, "Invalid or missing token", http.StatusBadRequest)
// 		return
// 	}

// 	queries := db.New(dbConn)
// 	user, err := queries.GetUserBySignupToken(r.Context(), token)
// 	if err != nil {
// 		http.Error(w, "Invalid or expired token", http.StatusUnauthorized)
// 		return
// 	}

// 	var signupData struct {
// 		Password string `json:"password"`
// 		Username string `json:"username"`
// 	}
// 	if err := json.NewDecoder(r.Body).Decode(&signupData); err != nil {
// 		http.Error(w, "Invalid request body", http.StatusBadRequest)
// 		return
// 	}

// 	// Update user record
// 	updateParams := db.UpdateUserParams{
// 		UserID:          user.UserID,
// 		DefaultUsername: sql.NullString{String: signupData.Username, Valid: true},
// 		PasswordHash:    hashPassword(signupData.Password),      // Your hash logic here
// 		IsMarketingUser: sql.NullBool{Bool: false, Valid: true}, // No longer a marketing user
// 		SignupToken:     nil,                                    // Clear the token after use
// 	}
// 	if err := queries.UpdateUser(r.Context(), updateParams); err != nil {
// 		http.Error(w, "Failed to complete signup", http.StatusInternalServerError)
// 		return
// 	}

// 	w.WriteHeader(http.StatusOK)
// }