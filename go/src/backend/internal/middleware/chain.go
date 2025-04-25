package middleware

import (
	"net/http"
)

// Middleware type for chaining
type Middleware func(http.Handler) http.Handler

// ChainMiddleware to chain multiple middlewares
func Chain(handler http.Handler, middlewares ...Middleware) http.Handler {
	for i := len(middlewares) - 1; i >= 0; i-- {
		handler = middlewares[i](handler)
	}
	return handler
}
