#!/usr/bin/env python3
"""
Đọc Teams payload JSON và POST lên webhook URL.
Usage: python3 send-to-teams.py <payload_json_file> <webhook_url>
"""
import sys
import json
import urllib.request
import urllib.error


def send_to_teams(payload_file: str, webhook_url: str) -> bool:
    try:
        with open(payload_file, "r", encoding="utf-8") as f:
            payload = json.load(f)
    except FileNotFoundError:
        print(f"ERROR: Payload file not found: {payload_file}", file=sys.stderr)
        return False
    except json.JSONDecodeError as e:
        print(f"ERROR: Invalid JSON in payload file: {e}", file=sys.stderr)
        return False

    if "error" in payload:
        print(f"ERROR: Payload contains error: {payload['error']}", file=sys.stderr)
        return False

    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        webhook_url,
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            body = resp.read().decode("utf-8")
            if resp.status == 200 and body.strip() == "1":
                print(f"OK: Message sent to Teams ({len(data)} bytes)")
                return True
            else:
                print(f"WARNING: Unexpected response {resp.status}: {body}", file=sys.stderr)
                return False
    except urllib.error.HTTPError as e:
        print(f"ERROR: HTTP {e.code} — {e.read().decode('utf-8', errors='replace')}", file=sys.stderr)
        return False
    except urllib.error.URLError as e:
        print(f"ERROR: Network error — {e.reason}", file=sys.stderr)
        return False
    except TimeoutError:
        print("ERROR: Request timed out (15s)", file=sys.stderr)
        return False


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: send-to-teams.py <payload_json_file> <webhook_url>", file=sys.stderr)
        sys.exit(1)

    success = send_to_teams(sys.argv[1], sys.argv[2])
    sys.exit(0 if success else 1)
