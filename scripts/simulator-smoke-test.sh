#!/usr/bin/env bash
set -euo pipefail
DEVICE_ID="$(xcrun simctl list devices available -j | python3 -c '
import json,sys
data=json.load(sys.stdin)
devices=[x for entries in data["devices"].values() for x in entries if x.get("isAvailable") and "iPhone" in x.get("name","")]
if not devices:
    sys.exit("No iPhone simulator available")
print(devices[0]["udid"])
')"
echo "Simulator: $DEVICE_ID"
xcrun simctl boot "$DEVICE_ID" || true
xcrun simctl bootstatus "$DEVICE_ID" -b
xcrun simctl install "$DEVICE_ID" "$APP_PATH"
xcrun simctl launch "$DEVICE_ID" dev.francis.FreeSwiftUIStarter
sleep 5
mkdir -p output
xcrun simctl io "$DEVICE_ID" screenshot output/iphone-simulator.png
xcrun simctl shutdown "$DEVICE_ID" || true
