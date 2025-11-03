postgres:
	docker run --name postgres -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres dropdb --username=root --owner=root simple_bank

DB_HOST ?= localhost
DB_PORT ?= 5433
DB_USER ?= root
DB_PASSWORD ?= secret
DB_NAME ?= simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable" -verbose up 1


migratedown:
	migrate -path db/migration -database "postgresql://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover $$(go list -f '{{if or .TestGoFiles .XTestGoFiles}}{{.ImportPath}}{{end}}' ./...)

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/pkpkvac/simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown migratedown1 migrateup1 sqlc test server