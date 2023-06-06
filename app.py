###################################  Links Extractor      ###################################
import subprocess
import re

def get_nostr_user_notes_request(user_key):
    bookmark_key = "b6f094686ad9b28c378d12eb507690b0"
    return f'echo \'["REQ", "{bookmark_key}", {{"kinds": [1], "authors": ["{user_key}"]}}]\''

def get_links_from_string(string):
    url_extract_pattern = "https?:\\/\\/(?:www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b(?:[-a-zA-Z0-9()@:%_\\+.~#?&\\/=]*)"
    return re.findall(url_extract_pattern, string)

def extract_links_from_user(user_key):
    request = get_nostr_user_notes_request(user_key)
    command =  request + ' | nostcat wss://relay.damus.io'

    nostr_events = subprocess.check_output(command, shell=True).decode('utf-8')
    return get_links_from_string(nostr_events)


###################################     Server        ###################################

from flask import Flask, request, jsonify

app = Flask(__name__)

# Given a user's public_key, returns all the links in his notes
@app.route('/links', methods=['POST'])
def run_command():
    user_key = request.json.get('public_key')
    links = extract_links_from_user(user_key)

    return jsonify({'links': links})

if __name__ == '__main__':
    # Start the Flask app on port 5005
    app.run(host='0.0.0.0', port=5005)