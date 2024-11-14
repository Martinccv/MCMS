from flask import Flask, jsonify, request
from flask_mysqldb import MySQL
import os

app = Flask(__name__)
app.config['MYSQL_HOST'] = os.getenv('DB_HOST')
app.config['MYSQL_USER'] = os.getenv('DB_USER')
app.config['MYSQL_PASSWORD'] = os.getenv('DB_PASSWORD')
app.config['MYSQL_DB'] = os.getenv('DB_NAME')

mysql = MySQL(app)

@app.route('/api/pedidos', methods=['POST'])
def create_pedido():
    # Lógica para crear un pedido usando un procedimiento almacenado
    pass

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
