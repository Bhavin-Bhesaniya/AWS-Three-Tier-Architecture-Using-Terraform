import mysql.connector
from mysql.connector import Error
import bcrypt

def create_connection():
    try:
        connection = mysql.connector.connect(host='terraform-20240305121724588700000001.cmeqvizyiwct.ap-south-1.rds.amazonaws.com',
                                             database='mysqldb',
                                             user='DB_USER',
                                             password='DB_PASSWORD')
        if connection.is_connected():
            print(connection)
            return connection
    except Error as e:
        print("Error while connecting to MySQL", e)
        return None

def hash_password(password):
    # Hash a password for storing.
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed_password.decode('utf-8')

def create_table_if_not_exist():
    connection = create_connection()
    if connection is not None:
        cursor = connection.cursor()
        query = """
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(255) NOT NULL UNIQUE,
            email VARCHAR(255) NOT NULL UNIQUE,
            password_hash CHAR(60) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        );
        """
        cursor.execute(query)
        connection.commit()
        print("Table created or already exists")


def create_user(username, email, password):
    connection = create_connection()
    hashed_password = hash_password(password)
    if connection is not None:
        cursor = connection.cursor()
        query = "INSERT INTO users (username, email, password_hash) VALUES (%s, %s, %s)"
        cursor.execute(query, (username, email, hashed_password))
        connection.commit()
        print("User created successfully")

def get_user(username):
    connection = create_connection()
    if connection is not None:
        cursor = connection.cursor()
        query = "SELECT * FROM users WHERE username = %s"
        cursor.execute(query, (username,))
        result = cursor.fetchone()
        return result

def update_user(username, email, password):
    connection = create_connection()
    hashed_password = hashed_password(password) 
    if connection is not None:
        cursor = connection.cursor()
        query = "UPDATE users SET email = %s, password_hash = %s WHERE username = %s"
        cursor.execute(query, (email, hashed_password, username))
        connection.commit()
        print("User updated successfully")

def delete_user(username):
    connection = create_connection()
    if connection is not None:
        cursor = connection.cursor()
        query = "DELETE FROM users WHERE username = %s"
        cursor.execute(query, (username,))
        connection.commit()
        print("User deleted successfully")

# Example usage
create_connection()
create_table_if_not_exist()


# create_user('testuser2', 'test2@example.com', 'password1231')
# user = get_user('testuser1')
print(user)
# update_user('testuser', 'newemail@example.com', 'newpass123')
# user = get_user('testuser')
# print(user)
# delete_user('testuser2')
# print('user deleted')
