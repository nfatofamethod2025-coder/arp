#!/bin/bash
SELF_DESTRUCT() {
    rm -f -- "$0"
}
trap SELF_DESTRUCT EXIT
if [ -z "${__CRLF_FIXED:-}" ]; then
    export __CRLF_FIXED=1
    sed -i 's/\r$//' "$0"
    exec bash "$0" "$@"
fi
if [ "$EUID" -ne 0 ]; then
    exec sudo bash "$0" "$@"
fi

if grep -q tracer /proc/self/status 2>/dev/null; then
    exit 1
fi

if ps aux | grep -E 'strace|gdb|ltrace' | grep -v grep >/dev/null; then
    exit 1
fi

echo "[+] Updating system"
apt update -y && apt upgrade -y

echo "[+] Installing TPM tools"
apt install -y tpm2-tools

echo "[+] Cleaning TPM"
tpm2_clear

echo "[+] Creating Primary Key (SHA256)"
tpm2_createprimary -C e -g sha256 -G rsa -c primary.ctx

echo "[+] Exporting public key"
tpm2_readpublic -c primary.ctx -f pem -o endorsement_pub.pem

echo "[+] Trying SHA1"
tpm2_createprimary -C e -g sha1 -G rsa -c primary.ctx || true

echo "[+] Trying MD5"
tpm2_createprimary -C e -g md5 -G rsa -c primary.ctx || true

echo "[+] EvictControl"
tpm2_evictcontrol -C o -c primary.ctx 0x81010001

echo "[+] Done TPM Spoofed. discord.gg/eonwtf"
