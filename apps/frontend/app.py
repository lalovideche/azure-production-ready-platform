import os

from azure.monitor.opentelemetry import configure_azure_monitor

connection_string = os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING")

if connection_string:
    configure_azure_monitor(
        connection_string=connection_string,
    )

import requests
from flask import Flask, jsonify, render_template, request

app = Flask(__name__)

backend_url = os.environ["BACKEND_URL"].rstrip("/")


@app.get("/")
def home():
    return render_template("index.html")


@app.get("/health")
def health():
    return jsonify(status="healthy", service="frontend")


@app.get("/health/dependencies")
def dependency_health():
    try:
        response = requests.get(f"{backend_url}/health", timeout=5)
        response.raise_for_status()

        return jsonify(
            status="healthy",
            frontend="healthy",
            backend=response.json(),
        )
    except requests.RequestException as error:
        app.logger.exception("Backend health check failed")
        return jsonify(
            status="unhealthy",
            backend_error=str(error),
        ), 503


@app.get("/api/info")
def info():
    response = requests.get(f"{backend_url}/api/info", timeout=10)
    return response.content, response.status_code, {
        "Content-Type": "application/json"
    }


@app.get("/api/messages")
def list_messages():
    response = requests.get(f"{backend_url}/api/messages", timeout=10)
    return response.content, response.status_code, {
        "Content-Type": "application/json"
    }


@app.post("/api/messages")
def create_message():
    response = requests.post(
        f"{backend_url}/api/messages",
        json=request.get_json(silent=True),
        timeout=10,
    )

    return response.content, response.status_code, {
        "Content-Type": "application/json"
    }