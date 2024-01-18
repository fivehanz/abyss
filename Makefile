MAKEFLAGS += -j2

default: build-sass
compose: compose-dev
deps: deps-cms
dev: dev-sass dev-cms
migrate: cms-make-migrate
recreate: compose-restart
stop: compose-stop
prod: prod-release

# ! do not run as root
prod-release:
	sudo make prod-rebuild
	sudo make prod-restart
	sudo make prod-migrate
	make prod-static-release
	sudo nginx -s reload

prod-rebuild:
	docker compose --env-file .env --file ./deployment/docker/docker-compose.yml up -d --build
prod-restart:
	docker compose --env-file .env --file ./deployment/docker/docker-compose.yml up -d --force-recreate
prod-migrate:
	docker exec -it abyss_prod_app make migrate

prod-static-release:
	python3 -m pipenv install
	python3 -m pipenv run python manage.py collectstatic --noinput --clear
	python3 -m pipenv run python manage.py sass -t compressed ./website/static/website/src/custom.scss ./website/static/website/css/custom.min.css
	python3 -m pipenv run python manage.py collectstatic --noinput

build-sass:
	python manage.py sass -t compressed ./website/static/website/src/custom.scss ./website/static/website/css/custom.min.css

deps-cms:
	python -m pipenv install

dev-cms:
	python manage.py runserver

cms-make-migrate:
	python manage.py makemigrations && python manage.py migrate

dev-sass:
	python manage.py sass -t compressed ./website/static/website/src/custom.scss ./website/static/website/css/custom.min.css --watch

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
