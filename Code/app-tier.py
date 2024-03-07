from flask import Flask, jsonify, request, render_template
import pymysql
import bcrypt

app = Flask(__name__)

def get_db_connection():
    connection = pymysql.connect(
        host='terraform-20240305121724588700000001.cmeqvizyiwct.ap-south-1.rds.amazonaws.com',
        user='dbuser',
        password='dbpassword',
        db='mysqldb',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )
    return connection

def hash_password(password):
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed_password.decode('utf-8')

@app.route('/health')
def health():
    return "Up & Running"

@app.route('/create_table', methods=['POST'])
def create_table():
    connection = get_db_connection()
    cursor = connection.cursor()
    create_table_query = """
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(255) NOT NULL UNIQUE,
            email VARCHAR(255) NOT NULL UNIQUE,
            password_hash CHAR(60) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        );
        """
    cursor.execute(create_table_query)
    connection.commit()
    connection.close()
    return "Table created or already exists"

@app.route('/create', methods=['POST'])
def create_record():
    data = request.json
    username = data.get('username')
    email = data.get('email')
    password = hash_password(data.get('password'))
    if not username or not email or not password:
        return jsonify({'error': 'All fields are required'}), 400

    connection = get_db_connection()
    cursor = connection.cursor()
    insert_query = "INSERT INTO users (username, email, password_hash) VALUES (%s, %s, %s)"
    cursor.execute(insert_query, (username, email, password))
    connection.commit()
    connection.close()
    return jsonify({'message': 'Record created successfully'}), 201

@app.route('/update', methods=['POST'])
def update_record():
    data = request.json
    id = data.get('id')
    username = data.get('username')
    email = data.get('email')
    password = hash_password(data.get('password'))
    if not id or not username or not email or not password:
        return jsonify({'error': 'All fields are required'}), 400

    connection = get_db_connection()
    cursor = connection.cursor()
    update_query = "UPDATE users SET username = %s, email = %s, password_hash = %s WHERE id = %s"
    cursor.execute(update_query, (username, email, password, id))
    connection.commit()
    connection.close()
    return jsonify({'message': 'Record updated successfully'}), 200

@app.route('/delete', methods=['POST'])
def delete_record():
    id = request.json.get('id')
    if not id:
        return jsonify({'error': 'id is required'}), 400

    connection = get_db_connection()
    cursor = connection.cursor()
    delete_query = "DELETE FROM users WHERE id = %s"
    cursor.execute(delete_query, (id,))
    connection.commit()
    connection.close()
    return jsonify({'message': 'Record deleted successfully'}), 200

@app.route('/data', methods=['GET'])
def get_all_data():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM users')
    result = cursor.fetchall()
    connection.close()
    return jsonify(result)

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)
