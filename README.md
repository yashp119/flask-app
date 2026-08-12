# Flask Docker App

A lightweight Flask API, containerized, with automated CI/CD to Docker Hub and
a local Docker Compose deployment workflow.

1. Bug Fix Explanation

The starter app.py called app.run(host="127.0.0.1", port=port). Binding
to 127.0.0.1 makes Flask listen only on the container's internal loopback
interface, so even though the port was exposed and mapped correctly, the app
was unreachable from the host machine (or anywhere outside the container).
The fix was changing the bind address to app.run(host="0.0.0.0", port=port),
so the app accepts connections from any interface, including the mapped
Docker port.

2. Docker Hub Link & GitHub Link

- GitHub:      https://github.com/yashp119/flask-app.git
- Docker Hub:  https://hub.docker.com/repository/docker/yashp119/flask-docker-app

3. Local Setup & Execution Guide

Clone and configure

git clone https://github.com/yashp119/flask-app.git
cd flask-app

Run locally with Docker Compose

docker compose up -d --build

 Run tests -

pip install -r requirements.txt
python -m pytest test_app.py -v

Verify it's running

curl http://localhost:5000/
curl http://localhost:5000/health

Pull the published image from Docker Hub instead of building locally

docker pull <your-dockerhub-username>/flask-docker-app:latest
docker run -d -p 5000:5000 --env-file .env <your-dockerhub-username>/flask-docker-app:latest

Deploy / redeploy with minimal downtime -
./deploy.sh

Monitor health -

./health-monitor.sh
# logs HTTP code + timestamp every 10s to health-monitor.log

4. Architecture & Design Choices

Deployment method — Option A (Docker Compose scripting): chosen over Kubernetes manifests because the target environment is a single local machine with no need for multi-node scheduling, and Docker Compose is
faster to set up and verify within the assessment's 2-day window while still demonstrating build → deploy → health-check automation. deploy.sh builds the new image, recreates only the web service, and waits for a
200 from /health before declaring success — avoiding the downtime gap of a naive down && up.


