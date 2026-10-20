import os
import socket
from datetime import datetime

from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    """Health check and home page."""
    return jsonify({
        "message": "Hello from the DevOps challenge!",
        "hostname": socket.gethostname(),
        "timestamp": datetime.utcnow().isoformat() + "z",
        "version": os.getenv("APP_VERSION", "unknown"),
    })
@app.route("/health")
def health():
    """Dedicated health endpoint for ALB target group check."""
    return jsonify({"status": "healthy"}), 200

@app.route("/ready")
def ready():
    """Readiness probe - used by orchestrators to know when to send traffic."""
    return jsonify({"status": "ready"}), 200

if __name__ == "__main__":
    # only used for local dev. production uses gunicorn (see Dockerfile).
    port = int(os.getenv("PORT", 8080))
    app.run(host="0.0.0.0", port=port)


