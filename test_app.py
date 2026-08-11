import pytest

from app import app as flask_app


@pytest.fixture
def client():
    flask_app.config["TESTING"] = True
    with flask_app.test_client() as client:
        yield client


def test_index_returns_200(client):
    response = client.get("/")
    assert response.status_code == 200


def test_index_returns_status_ok(client):
    response = client.get("/")
    data = response.get_json()
    assert data["status"] == "ok"


def test_health_returns_200(client):
    response = client.get("/health")
    assert response.status_code == 200


def test_health_returns_healthy_status(client):
    response = client.get("/health")
    data = response.get_json()
    assert data["status"] == "healthy"
    assert "timestamp" in data
