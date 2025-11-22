package util

import (
	"fmt"
	"os"
	"time"

	"github.com/spf13/viper"
)

type Config struct {
	DBDriver             string        `mapstructure:"DB_DRIVER"`
	DBSource             string        `mapstructure:"DB_SOURCE"`
	ServerAddress        string        `mapstructure:"SERVER_ADDRESS"`
	TokenSymmetricKey    string        `mapstructure:"TOKEN_SYMMETRIC_KEY"`
	AccessTokenDuration  time.Duration `mapstructure:"ACCESS_TOKEN_DURATION"`
	RefreshTokenDuration time.Duration `mapstructure:"REFRESH_TOKEN_DURATION"`
}

func LoadConfig(path string) (config Config, err error) {
	viper.AddConfigPath(path)
	viper.SetConfigName("app")
	viper.SetConfigType("env")

	viper.AutomaticEnv()

	err = viper.ReadInConfig()
	if err != nil {
		return Config{}, err
	}

	err = viper.Unmarshal(&config)
	if err != nil {
		return Config{}, err
	}

	// If individual DB environment variables are set, construct DBSource from them
	// This allows CI/CD to set individual variables instead of the full connection string
	if dbHost := os.Getenv("DB_HOST"); dbHost != "" {
		dbPort := os.Getenv("DB_PORT")
		if dbPort == "" {
			dbPort = "5432" // default PostgreSQL port
		}
		dbUser := os.Getenv("DB_USER")
		if dbUser == "" {
			dbUser = "root"
		}
		dbPassword := os.Getenv("DB_PASSWORD")
		if dbPassword == "" {
			dbPassword = "secret"
		}
		dbName := os.Getenv("DB_NAME")
		if dbName == "" {
			dbName = "simple_bank"
		}

		config.DBSource = fmt.Sprintf("postgresql://%s:%s@%s:%s/%s?sslmode=disable",
			dbUser, dbPassword, dbHost, dbPort, dbName)
	}

	return
}
