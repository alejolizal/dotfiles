#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Construyendo sii-dev-base:latest ==="
echo "Directorio: $SCRIPT_DIR"
echo ""

docker build -t sii-dev-base:latest "$SCRIPT_DIR"

echo ""
echo "=== Imagen construida exitosamente ==="
docker images sii-dev-base:latest
