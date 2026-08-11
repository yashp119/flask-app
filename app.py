import os
from datetime import datetime, timezone

from flask import Flask, jsonify

app = Flask(__name__)

APP_NAME = os.environ.get("APP_NAME", "flask-docker-app")


@app.route("/", methods=["GET"])
def index():
    return jsonify(
        {
            "message": f"Hello from {APP_NAME}!",
            "status": "ok",
        }
    )


@app.route("/health", methods=["GET"])
def health():
    return jsonify(
        {
            "status": "healthy",
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }
    ), 200


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    # FIX: bind to 0.0.0.0 so the app accepts connections from outside the
    # container (from the host machine), not just from within the container
    # itself. 127.0.0.1 only listens on the container's internal loopback.
    app.run(host="0.0.0.0", port=port)
