from flask import Flask, render_template, request, jsonify
import requests

app = Flask(__name__)

endpoint = input('Provide endpoint ip')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/process', methods=['POST'])
def process_data():
    data = request.form
    response = requests.post('http://{endpoint}/process', data=data)  # Forward the request to the app tier
    return jsonify(response.json()), response.status_code

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
