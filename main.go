package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/pkpkvac/simplebank/api"
	db "github.com/pkpkvac/simplebank/db/sqlc"
	"github.com/pkpkvac/simplebank/util"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}
