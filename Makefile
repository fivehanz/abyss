MAKEFLAGS += -j2

default: build-sass
compose: compose-dev
deps: deps-cms
dev: dev-sass dev-cms
migrate: cms-make-migrate
recreate: compose-restart
stop: compose-stop
# deploy: deploy-api

rtx:
	# brew install libb2 openssl readline gettext
	env PYTHON_CONFIGURE_OPTS="--enable-optimizations --disable-ipv6" env LDFLAGS="-fuse-ld=lld" ARCHFLAGS="-arch arm64" rtx i

build-sass:
	python manage.py sass ./website/static/website/src/custom.scss ./website/static/website/css/custom.css

deps-cms:
	python -m pip install -r requirements-dev.txt

dev-cms:
	python manage.py runserver

cms-make-migrate:
	python manage.py makemigrations && python manage.py migrate

dev-sass:
	python manage.py sass ./website/static/website/src/custom.scss ./website/static/website/css/custom.css --watch

# deploy-backend:
	# cd api && bunx wrangler deploy src/index.ts --minify
	#

logs-db:
	docker logs abyss_dev_postgres_db

logs-web:
	docker logs abyss_app_dev

logs-nginx:
	docker logs nginx_server

compose-migrate:
	docker exec -it abyss_app_dev make migrate

compose-dev:
	docker compose --file docker-compose.dev.yml up -d

compose-restart:
	docker compose --file docker-compose.dev.yml up -d --force-recreate

compose-start:
	docker compose --file docker-compose.dev.yml up -d

compose-stop:
	docker compose --file docker-compose.dev.yml down

compose-rebuild:
	docker compose --file docker-compose.dev.yml up -d --build
