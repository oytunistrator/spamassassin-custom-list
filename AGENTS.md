# Agent Notes: spamassassin-custom-list

## Project Purpose
A complete, drop-in custom SpamAssassin ruleset designed to be cloned into
`/etc/spamassassin`. It disables Bayesian learning and relies entirely on
hand-written rules, DNSBL/URIBL lookups, SPF/DKIM/DMARC checks, and Turkish
language spam detection.

## Target Environment
- SpamAssassin 4.0.0
- Perl 5.38.2
- Single LAN: `192.168.1.0/24`
- `required_score 6.0`
- Bayes/learning disabled

## File Loading Order
SpamAssassin loads `.cf` files in `/etc/spamassassin` alphabetically. The
numeric prefixes in this repo enforce a deterministic order:

1. `local.cf` - site-wide defaults
2. `00_global.cf` - network, DNS, locale settings
3. `05_plugins.cf` - plugin activation/options
4. `10_dnsbl.cf` - DNS blocklists
5. `15_uribl.cf` - URI blocklists
6. `20_auth.cf` - SPF/DKIM/DMARC
7. `30_body_rules.cf` - general body rules
8. `35_turkish_body_rules.cf` - Turkish language spam phrases
9. `40_header_rules.cf` - header analysis rules
10. `50_uri_rules.cf` - URI/domain heuristics
11. `60_meta_rules.cf` - composite/meta rules
12. `70_whitelist.cf` - address/domain whitelist
13. `80_blacklist.cf` - address/domain/IP blacklist
14. `90_scores.cf` - central scoring overrides
15. `99_final_actions.cf` - headers, rewriting, report_safe

## Editable Lists
The `lists/` directory contains plain-text lists used by `include` directives
or referenced in rules. They are intended to be updated without editing `.cf`
files directly:

- `blacklisted_domains.txt`
- `blacklisted_ips.txt`
- `blacklisted_senders.txt`
- `whitelisted_domains.txt`
- `whitelisted_senders.txt`
- `suspicious_tlds.txt`
- `short_url_services.txt`
- `turkish_spam_phrases.txt`

## Installation Note
This repo is designed to be cloned into a subfolder under `/etc/spamassassin`
and registered with SpamAssassin via `install.sh`.  The installer creates a
single include file in `/etc/spamassassin` that loads the rules from the
subfolder.  No existing SpamAssassin configuration files are overwritten.

## Testing
Run `tests/test.sh` or manually after installing:

```bash
spamassassin --lint
spamassassin -t < tests/sample_spam_tr.eml
spamassassin -t < tests/sample_ham.eml
```

## Important Design Decision
Shortened URLs and generic TLDs are **not** treated as standalone spam
indicators. They only add a small heuristic score and are primarily evaluated
through URIBL/DNSBL reputation lookups, per project requirements.
