DBT = .venv/bin/dbt
DBT_ARGS = --project-dir dbt --profiles-dir dbt

.PHONY: install up deps load build test docs serve lint

install:
	python3 -m venv .venv
	.venv/bin/pip install -r requirements.txt

up:
	docker compose up -d --wait

deps:
	$(DBT) deps $(DBT_ARGS)

load:
	.venv/bin/python scripts/load_data.py "$(CSV)"

build:
	$(DBT) seed $(DBT_ARGS)
	$(DBT) run $(DBT_ARGS)

test:
	$(DBT) test $(DBT_ARGS)

docs:
	$(DBT) docs generate $(DBT_ARGS)

serve:
	$(DBT) docs serve $(DBT_ARGS) --port 18080

lint:
	.venv/bin/sqlfluff lint dbt/models dbt/tests
