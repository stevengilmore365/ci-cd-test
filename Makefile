.PHONY: install test lint docker-run kind-up kind-down clean

install:
	pip install -r app/requirements.txt

test:
	pytest app/tests/ --cov=app --cov-report=term -v

lint:
	black --check app/
	flake8 app/ --max-line-length=88

docker-run:
	docker build -t ci-cd-test .
	docker run --rm -p 5000:5000 ci-cd-test

kind-up:
	kind create cluster --name ci-cd-test || true
	kind load docker-image ci-cd-test:latest --name ci-cd-test
	kubectl apply -f k8s/

kind-down:
	kind delete cluster --name ci-cd-test || true

clean:
	rm -rf .pytest_cache __pycache__ */__pycache__ */*/__pycache__
