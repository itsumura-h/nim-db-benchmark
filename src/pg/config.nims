import os

# DB Connection
putEnv("DB_DRIVER", "postgres")
putEnv("DB_CONNECTION", "tfb-database-pg:5432")
putEnv("DB_USER", "benchmarkdbuser")
putEnv("DB_PASSWORD", "benchmarkdbpass")
putEnv("DB_DATABASE", "hello_world")

# Logging
putEnv("LOG_IS_DISPLAY", "false")
putEnv("LOG_IS_FILE", "false")
putEnv("LOG_DIR", "/root/project/src/init/logs")
