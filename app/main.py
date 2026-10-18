"""Sample Python application used to demonstrate the CI/CD pipeline."""

from __future__ import annotations

import os
import socket

from flask import Flask, jsonify

APP_NAME = os.getenv("APP_NAME", "cicd-sample-app")
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")

app = Flask(__name__)


@app.get("/")
def root():
    return jsonify(
        {
            "service": APP_NAME,
            "version": APP_VERSION,
            "hostname": socket.gethostname(),
        }
    )


@app.get("/health")
def health():
    return jsonify({"status": "healthy"}), 200


if __name__ == "__main__":  # pragma: no cover
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8000")))
