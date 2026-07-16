#!/usr/bin/env bash
# tests/test.sh - validate rules and run sample messages
set -e

echo "=== SpamAssassin lint ==="
spamassassin --lint

echo ""
echo "=== Turkish spam sample ==="
spamassassin -t < tests/sample_spam_tr.eml

echo ""
echo "=== Turkish phishing sample ==="
spamassassin -t < tests/sample_spam_phishing.eml

echo ""
echo "=== Ham sample ==="
spamassassin -t < tests/sample_ham.eml

echo ""
echo "=== Tests completed ==="
