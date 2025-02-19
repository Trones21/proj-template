package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"

	_ "github.com/lib/pq" // Postgres driver
	"github.com/trones21/pk_projName/backend/internal/handlers/user_onboard"
	"github.com/trones21/pk_projName/backend/internal/middleware"
)

func main() {
	// Access environment variables
	env := os.Getenv("ENV") // e.g., "development" or "production" (For switches here such as CORS, maybe logging, responses, etc.)

	// For DB connection
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbUser := os.Getenv("DB_USER")
	dbPass := os.Getenv("DB_PASS")
	dbName := os.Getenv("DB_NAME")

	dbConnStr := fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=require", dbUser, dbPass, dbHost, dbPort, dbName) // e.g., "postgres://user:password@localhost:5432/dbname?sslmode=disable"
	fmt.Println(dbConnStr)

	//Setup db connection
	db, err := sql.Open("postgres", dbConnStr)
	if err != nil {
		log.Fatalf("sql.open error (syntax, driver, etc.): %v", err)
	}
	defer db.Close()

	// Test connection
	if err := db.Ping(); err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Allowed origins for production
	allowedOrigins := []string{
		"https://pk_host",
	}

	// New Mux
	mux := http.NewServeMux()

	//It's idiomatic to register routes before doing global middleware
	mux.Handle("/captureEmail", http.HandlerFunc(user_onboard.CaptureEmailHandler(db)))

	//if there is route specific middleware we would wrap that route with it (see comment at EOF)

	// Chain multiple global middlewares
	globalMux := middleware.Chain(mux,
		middleware.CorsMiddleware(env, allowedOrigins), //
		middleware.Recovery,
		middleware.Logger,
	)

	// Start the server
	port := "8080"
	log.Printf("Server running on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, globalMux))
	if err != nil {
		log.Fatal(err)
	}
}

// Register routes
// mux.Handle("/hello", http.HandlerFunc(HelloHandler)) // No extra route-specific middleware
//mux.Handle("/users", middleware.Authentication(http.HandlerFunc(handlers.UsersHandler(db))))

//Wrap individual routes
//mux.Handle("/users", middleware.Logger(http.HandlerFunc(handlers.UsersHandler(db))))
