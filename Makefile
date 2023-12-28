MAKEFLAGS += -j2

default: build-sass
# clean: clean-tailwind clean-cms
deps: deps-cms
dev: dev-sass dev-cms
migrate: cms-make-migrate
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
