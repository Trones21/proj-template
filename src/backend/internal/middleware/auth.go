package middleware

import (
	"log"
	"net/http"
)

// AuthenticationMiddleware applies fake authentication (example)
func Authentication(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("[GLOBAL] AuthenticationMiddleware: Checking token...")
		// Add actual authentication logic here
		next.ServeHTTP(w, r)
	})
}
