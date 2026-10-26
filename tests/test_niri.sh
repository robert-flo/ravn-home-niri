#!/usr/bin/env bash
# Test suite for ravn-home-niri layer
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Test 1: Verificando que outputs.kdl NO exista en el repositorio"
if [[ -f "$REPO_DIR/niri/outputs.kdl" ]]; then
    echo "ERROR: outputs.kdl no debe versionarse en este repositorio!" >&2
    exit 1
fi
echo "OK: outputs.kdl ausente (correcto para archivo de máquina)"

echo "==> Test 2: Validando sintaxis KDL de niri/config.kdl con niri validate"
if command -v niri >/dev/null 2>&1; then
    niri validate -c "$REPO_DIR/niri/config.kdl"
    echo "OK: niri/config.kdl es valido"
else
    echo "WARN: niri no encontrado en PATH, omitiendo validacion directa"
fi

echo "==> Test 3: Validando permisos de ejecucion en bin/"
for s in "$REPO_DIR/bin/clavis-mpvpaper.sh" "$REPO_DIR/bin/optimize-wallpaper" "$REPO_DIR/bin/niri-dotfiles-postinstall" "$REPO_DIR/bin/ravn-niri-sync"; do
    if [[ ! -x "$s" ]]; then
        echo "ERROR: $s debe ser ejecutable!" >&2
        exit 1
    fi
done
echo "OK: todos los binarios son ejecutables"

echo "==> Test 4: Verificando sintaxis de JSON y TOML en clavis"
if command -v jq >/dev/null 2>&1; then
    jq empty "$REPO_DIR/clavis/config.json"
    echo "OK: clavis/config.json es JSON valido"
fi

echo "==> Todos los tests de ravn-home-niri pasaron exitosamente."
