from flask import Blueprint, jsonify
from app import mysql

# Define el Blueprint para la ruta db-check
db_check_blueprint = Blueprint('db_check', __name__)

# Ruta para verificar la conexión a la base de datos
@db_check_blueprint.route('/db_check', methods=['GET'])
def db_check():
    try:
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT 1;")
        return jsonify({"message": "Conexión exitosa a la base de datos"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()
