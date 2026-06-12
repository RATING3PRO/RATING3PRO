#!/usr/bin/env bash
set -euo pipefail

PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDxk0ko2AxWTnUCNaP+smXQ2U77BGsTARB3CvxmUSrSF RATING3PRO"

# 校验公钥格式
if ! echo "$PUBKEY" | grep -qE '^(ssh-(rsa|ed25519|dss)|ecdsa-sha2-nistp(256|384|521)|sk-(ssh-ed25519|ecdsa-sha2-nistp256)@openssh\.com) [A-Za-z0-9+/=]+'; then
    echo "错误: 公钥格式无效，请检查脚本内 PUBKEY 变量" >&2
    exit 1
fi

SSH_DIR="$HOME/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

# 确保目录和文件存在，权限正确
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
touch "$AUTH_KEYS"
chmod 600 "$AUTH_KEYS"

# 幂等: 按 key 类型 + 主体比对，忽略注释差异
KEY_BODY=$(echo "$PUBKEY" | awk '{print $1" "$2}')
if grep -qF "$KEY_BODY" "$AUTH_KEYS"; then
    echo "公钥已存在，跳过添加"
else
    echo "$PUBKEY" >> "$AUTH_KEYS"
    echo "公钥已添加到 $AUTH_KEYS"
fi
