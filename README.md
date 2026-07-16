# spamassassin-custom-list

Complete, drop-in custom SpamAssassin ruleset for `/etc/spamassassin`.

Designed for:

- SpamAssassin 4.0.0
- Perl 5.38.2
- Single LAN: `192.168.1.0/24`
- Rule-based filtering **without Bayesian learning**
- `required_score 6.0`

## Features

- DNSBL/RBL lookups (Spamhaus ZEN, SpamCop, Abuse.ch)
- URIBL reputation checks
- SPF, DKIM, DMARC validation
- Body, header, URI, and composite meta rules
- Turkish-language spam detection
- Editable whitelist/blacklist lists
- Hardened scoring with Bayes disabled

## Installation

This ruleset is kept in its own subfolder under `/etc/spamassassin` and is
**never** copied over your existing SpamAssassin configuration.  A small
include file is created so SpamAssassin loads the custom rules.

### Clone and register

```bash
cd /etc/spamassassin
git clone https://github.com/oytunistrator/spamassassin-custom-list oytunistrator-custom-list
bash oytunistrator-custom-list/install.sh
```

`install.sh` creates `/etc/spamassassin/zz_oytun_custom_list.cf`, which
includes all `.cf` files from the cloned subfolder in alphabetical order.  No
existing files in `/etc/spamassassin` are modified or overwritten.

To disable the ruleset later, simply remove the include file:

```bash
rm /etc/spamassassin/zz_oytun_custom_list.cf
```

### Restart services

```bash
systemctl restart spamassassin
# or
systemctl restart postfix
```

## Configuration

Edit the plain-text files under `lists/` to customize without touching `.cf`
files:

- `lists/whitelisted_domains.txt`
- `lists/blacklisted_domains.txt`
- `lists/blacklisted_ips.txt`
- `lists/turkish_spam_phrases.txt`
- etc.

To change `required_score`, trusted networks, or locale settings, edit
`local.cf` or `00_global.cf`.

## Testing

```bash
spamassassin --lint
spamassassin -t < tests/sample_spam_tr.eml
spamassassin -t < tests/sample_ham.eml
```

Or run the provided test script:

```bash
bash tests/test.sh
```

## Design Notes

- Bayes/learning is disabled (`use_bayes 0`).
- Shortened URLs and generic TLDs are **not** standalone spam indicators.
  They receive only a small heuristic score; real reputation checks come
  from URIBL/DNSBL lookups.
- Whitelists are strongly weighted to avoid false positives from banks,
  government sites, and major global services.

## File Loading Order

SpamAssassin loads `.cf` files alphabetically. Numeric prefixes enforce a
stable order:

1. `local.cf`
2. `00_global.cf`
3. `05_plugins.cf`
4. `10_dnsbl.cf`
5. `15_uribl.cf`
6. `20_auth.cf`
7. `30_body_rules.cf`
8. `35_turkish_body_rules.cf`
9. `40_header_rules.cf`
10. `50_uri_rules.cf`
11. `60_meta_rules.cf`
12. `70_whitelist.cf`
13. `80_blacklist.cf`
14. `90_scores.cf`
15. `99_final_actions.cf`

## License

MIT
