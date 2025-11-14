docker run --name simplebank --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:secret@postgres:5432/simple_bank?sslmode=disable" simplebank:latest

416536262341.dkr.ecr.us-west-2.amazonaws.com/simplebank
