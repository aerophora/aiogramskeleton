
project_dir := .

# Reformat code
.PHONY: reformat
reformat:
	@poetry run black $(project_dir)
	@poetry run ruff check $(project_dir) --fix

# Lint code
.PHONY: lint
lint: reformat
	@poetry run mypy $(project_dir)

# Make database migration
.PHONY: migration
migration:
	@poetry run alembic revision \
	--autogenerate \
	--rev-id $(shell python migrations/_get_revision_id.py) \
	--message $(message)

# Apply database migrations
.PHONY: migrate
migrate:
	@poetry run alembic upgrade head

# Run bot
.PHONY: run
run:
	@poetry run python -O -m $(shell poetry version | awk '{print $$1}')

# Initialize .ftl files
.PHONY: init-ftl
init-ftl:
	@chmod +x ./scripts/extract_ftl.sh \
	&& ./scripts/extract_ftl.sh

# Build bot image
.PHONY: app-build
app-build:
	@docker-compose build

# Run bot database containers
.PHONY: app-run-db
app-run-db:
	@docker-compose up -d --remove-orphans postgres redis

# Rebuild bot in docker container
.PHONY: app-rebuild
app-rebuild: app-stop app-build app-start

# Restart bot in docker container
.PHONY: app-restart
app-restart: app-stop app-start

# Run bot in docker container
.PHONY: app-start
app-start:
	@docker-compose up -d --remove-orphans

# Stop docker containers
.PHONY: app-stop
app-stop:
	@docker-compose stop

# Down docker containers
.PHONY: app-down
app-down:
	@docker-compose down

# Destroy docker containers
.PHONY: app-destroy
app-destroy:
	@docker-compose down -v --remove-orphans

# Show bot logs
.PHONY: app-logs
app-logs:
	@docker-compose logs -f bot

# Build, run and log the bot with a single command
.PHONY: app-force
app-force: app-build app-start app-logs

# Deleting and building anew with logs 
.PHONY: app-anew
app-anew: app-destroy app-force