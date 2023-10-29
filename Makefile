# Services
SERVICES = telegraf influxdb grafana

# Dirs
CONF_DIR := ./conf
ENV_DIR := ./envs
SSL_DIR := $(CONF_DIR)/nginx/ssl

# Files
SSL_CERT := $(SSL_DIR)/ssl.crt
SSL_KEY := $(SSL_DIR)/ssl.pem

# tools
D = docker
DC = docker-compose

# Run `make all` to perform both prepare and generate-env-files
all: dirs envs ssl build 

# Create the data directory and subdirectories for services
dirs:
	@mkdir -p $(ENV_DIR)
	@mkdir -p $(SSL_DIR)

envs:
	@$(foreach service,$(SERVICES), touch $(ENV_DIR)/$(service).env;)


# Generate empty .env files for each service

ssl:
	@if [ -e $(SSL_CERT) ]; then \
        echo "SSL exists"; \
    else \
        mkdir -p $(SSL_DIR);\
		openssl req -new -newkey rsa:4096 -days 365 -nodes -x509  -keyout $(SSL_KEY) -out $(SSL_CERT); \
    fi

build: ssl envs
	$(DC) up -d --build

up: ssl envs
	$(DC) up -d

down:
	$(DC) down


ps:
	$(D) ps -a

shr@i:
	$(D) exec -it -u root influxdb /bin/bash

shr@g:
	$(D) exec -it -u root grafana /bin/bash


# Clean up the generated data directory and .env files
clean:


# Run `make` or `make help` to display available targets
help:
	@echo "Available targets: all up down clean"

.PHONY: all build up down ps clean help