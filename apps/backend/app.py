import os

from azure.monitor.opentelemetry import configure_azure_monitor

connection_string = os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING")

if connection_string:
    configure_azure_monitor(
        connection_string=connection_string,
    )

import logging
from datetime import datetime, timezone

from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
from azure.storage.blob import BlobServiceClient
from flask import Flask, jsonify, request

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

storage_account = os.environ["STORAGE_ACCOUNT_NAME"]
container_name = os.getenv("BLOB_CONTAINER_NAME", "messages")
key_vault_url = os.environ["KEY_VAULT_URL"]

credential = DefaultAzureCredential()

blob_service = BlobServiceClient(
    account_url=f"https://{storage_account}.blob.core.windows.net",
    credential=credential,
)

secret_client = SecretClient(
    vault_url=key_vault_url,
    credential=credential,
)


@app.get("/health")
def health():
    return jsonify(
        status="healthy",
        service="backend",
        timestamp=datetime.now(timezone.utc).isoformat(),
    )


@app.get("/api/info")
def info():
    try:
        secret = secret_client.get_secret("application-message")

        return jsonify(
            service="backend",
            secret_message=secret.value,
            storage_account=storage_account,
            authentication="Managed Identity",
        )
    except Exception:
        app.logger.exception("Unable to retrieve Key Vault secret")
        return jsonify(error="Unable to retrieve dependency information"), 500


@app.post("/api/messages")
def create_message():
    body = request.get_json(silent=True) or {}
    message = body.get("message", "").strip()

    if not message:
        return jsonify(error="message is required"), 400

    timestamp = datetime.now(timezone.utc)
    blob_name = f"{timestamp.strftime('%Y%m%d-%H%M%S-%f')}.txt"

    try:
        blob_client = blob_service.get_blob_client(
            container=container_name,
            blob=blob_name,
        )

        blob_client.upload_blob(message, overwrite=False)

        app.logger.info("Created blob %s", blob_name)

        return jsonify(
            status="created",
            blob_name=blob_name,
            timestamp=timestamp.isoformat(),
        ), 201
    except Exception:
        app.logger.exception("Unable to create blob")
        return jsonify(error="Unable to store message"), 500


@app.get("/api/messages")
def list_messages():
    try:
        container_client = blob_service.get_container_client(container_name)

        messages = []

        for blob in container_client.list_blobs():
            blob_client = container_client.get_blob_client(blob.name)
            content = blob_client.download_blob().readall().decode("utf-8")

            messages.append(
                {
                    "blob_name": blob.name,
                    "message": content,
                }
            )

        return jsonify(messages=messages)
    except Exception:
        app.logger.exception("Unable to list blobs")
        return jsonify(error="Unable to retrieve messages"), 500