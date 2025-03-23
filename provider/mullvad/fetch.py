import re
import json
import requests
import os
import shutil
from collections import defaultdict

def extract_relays_array(js_text):
    # Find where the relays array starts
    start = js_text.find("relays:[")
    if start == -1:
        return None

    sliced = js_text[start + len("relays:"):]
    
    # Match brackets to extract the full array
    bracket_count = 0
    end_index = 0
    for i, c in enumerate(sliced):
        if c == "[":
            bracket_count += 1
        elif c == "]":
            bracket_count -= 1
            if bracket_count == 0:
                end_index = i + 1
                break

    return sliced[:end_index]

def js_to_json(js_array_text):
    # Convert JS-style object to valid JSON
    js_array_text = re.sub(r'([{,]\s*)(\w+)\s*:', r'\1"\2":', js_array_text)
    js_array_text = js_array_text.replace("undefined", "null")
    js_array_text = js_array_text.replace("true", "true").replace("false", "false")
    return js_array_text

# Fetch the Mullvad server page
url = "https://mullvad.net/en/servers"
html = requests.get(url).text

# Extract all <script> blocks
script_blocks = re.findall(r'<script[^>]*>(.*?)</script>', html, re.DOTALL)
target_block = next((block for block in script_blocks if "relays:[" in block), None)

if not target_block:
    print("Could not find any <script> block containing relays:[")
    exit(1)

raw_array = extract_relays_array(target_block)

if not raw_array:
    print("Could not extract the relays array.")
    exit(1)

json_text = js_to_json(raw_array)

try:
    relays = json.loads(json_text)
except json.JSONDecodeError as e:
    print("JSON parsing error:", e)
    print("Preview of extracted text:\n", json_text[:300])
    exit(1)

# Filter relays
filtered_relays = [relay for relay in relays if relay.get("type") == "wireguard"]
filtered_relays = [relay for relay in filtered_relays if relay.get("active") == True]
filtered_relays = [relay for relay in filtered_relays if relay.get("owned") == True]
filtered_relays = [relay for relay in filtered_relays if relay.get("status_messages") == []]

script_dir = os.path.dirname(os.path.abspath(__file__))
output_dir = os.path.join(script_dir, "owned_stable")
if os.path.exists(output_dir):
    shutil.rmtree(output_dir)
os.makedirs(output_dir)

# Save all
filename = os.path.join(output_dir, f"all.json")
with open(filename, "w", encoding="utf-8") as f:
    json.dump(filtered_relays, f, indent=2)
print(f"Saved {len(filtered_relays)} servers to " + filename)

# Save by country_code
grouped = defaultdict(list)
for relay in filtered_relays:
    country = relay.get("country_code", "UNKNOWN")
    grouped[country].append(relay)
for country, relays_list in grouped.items():
    filename = os.path.join(output_dir, f"{country}.json")
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(relays_list, f, indent=2)
    print(f"Saved {len(relays_list)} servers to {filename}")