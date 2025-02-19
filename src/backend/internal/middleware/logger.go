package middleware

import (
	"log"
	"net/http"
	"time"
)

// LoggerMiddleware logs incoming HTTP requests
func Logger(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()

		// Log request details
		log.Printf("Incoming request: Method=%s, Path=%s, RemoteAddr=%s", r.Method, r.URL.Path, r.RemoteAddr)

		// Call the next handler
		next.ServeHTTP(w, r)

		// Log duration
		duration := time.Since(start)
		log.Printf("Completed: Path=%s, Duration=%v", r.URL.Path, duration)
	})
}
