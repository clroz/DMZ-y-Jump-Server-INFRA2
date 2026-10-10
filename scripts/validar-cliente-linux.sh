#!/usr/bin/env bash
# Pruebas de lectura para ejecutar desde PC-STANDARD o PC-PRIVILEGED.
# Uso: bash scripts/validar-cliente-linux.sh standard|privileged
set -u

if [[ $# -ne 1 || ( "$1" != "standard" && "$1" != "privileged" ) ]]; then
  echo "Uso: $0 standard|privileged" >&2
  exit 2
fi

role="$1"
jump="10.17.45.138"
web="10.17.45.130"

echo "== PC-${role^^}: HTTPS al Jump Server (${jump}) =="
curl -k --connect-timeout 3 --max-time 5 -sS -o /dev/null \
  -w 'HTTP %{http_code}\n' "https://${jump}/"

if [[ "$role" == "standard" ]]; then
  echo "== PC-STANDARD: intento SSH al Jump (se espera rechazo) =="
  ssh -o BatchMode=yes -o ConnectTimeout=3 "admin@${jump}"
  ssh_status=$?
  echo "Código SSH: ${ssh_status} (un valor distinto de cero es esperado si SSH está bloqueado)"
fi

echo "== PC-${role^^}: HTTPS directo al Web Server (${web}) (se espera bloqueo/timeout) =="
curl -k --connect-timeout 3 --max-time 5 -sS -o /dev/null \
  -w 'HTTP %{http_code}\n' "https://${web}/"
