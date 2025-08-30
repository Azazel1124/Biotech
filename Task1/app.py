from flask import Flask, render_template
import os
import socket
from dotenv import load_dotenv

load_dotenv()
author_name = os.environ.get("AUTHOR", "Студент")

app = Flask(__name__)

@app.route('/')
def index():
    hostname = socket.gethostname()
    server_ip = socket.gethostbyname(hostname)
    return render_template('index.html',
        hostname=hostname,
        ip_address=server_ip,
        author=author_name)

@app.route('/health')
def health():
    return {'status': 'healthy', 'author': author_name}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=32777, debug=True)
