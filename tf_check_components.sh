#!/bin/bash

echo "=== Verification Script ==="

# Function to check command and print error if it fails
check_command() {
  "$@"
  status=$?
  if [ $status -ne 0 ]; then
    echo "❌ Error: $1 failed. Please check your installation." >&2
    exit 1
  fi
}

echo "✓ Checking Colima..."
check_command colima status

echo "✓ Checking Terraform..."
check_command terraform version

echo "✓ Checking Kind..."
check_command kind version

echo "✓ Checking kubectl..."
check_command kubectl version --client

echo "✓ Checking LocalStack..."
check_command localstack --version

echo "✓ Checking Helm..."
check_command helm version

echo "=== All tools ready! ==="
