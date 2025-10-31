package api

import (
	"github.com/gin-gonic/gin"
	db "github.com/pkpkvac/simplebank/db/sqlc"
)

// serves http requests for our banking service.
type Server struct {
	store  *db.Store
	router *gin.Engine
}

// NewServer creates a new HTTP server and sets up routing.
func NewServer(store *db.Store) *Server {
	server := &Server{store: store}
	server.router = gin.Default()

	server.router.POST("/accounts", server.createAccount)
	server.router.GET("/accounts/:id", server.getAccount)

	return server
}

// start runs the HTTP server on a specific address.
func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}
