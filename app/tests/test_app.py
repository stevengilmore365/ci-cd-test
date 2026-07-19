"""Tests for the CI/CD test app."""

import json

import pytest

from app.main import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_index_returns_service_info(client):
    resp = client.get("/")
    assert resp.status_code == 200
    data = json.loads(resp.data)
    assert data["service"] == "ci-cd-test"
    assert data["status"] == "running"


def test_health_returns_healthy(client):
    resp = client.get("/health")
    assert resp.status_code == 200
    data = json.loads(resp.data)
    assert data["status"] == "healthy"
