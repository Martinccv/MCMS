from flask import Blueprint, jsonify, request
from app import mysql

# Define el Blueprint
example_blueprint = Blueprint('example_routes', __name__)

@example_blueprint.route('/materials', methods=['GET'])
def get_materials():
    """Devuelve una lista de materiales desde la base de datos."""
    cursor = None
    try:
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM Materiales;")  # Ajusta la consulta a tus tablas
        rows = cursor.fetchall()
        return jsonify(rows)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()

@example_blueprint.route('/materials', methods=['POST'])
def add_material():
    """Agrega un nuevo material a la base de datos."""
    data = request.json
    nombre = data.get('nombre')
    descripcion = data.get('descripcion')

    cursor = None
    try:
        cursor = mysql.connection.cursor()
        query = "INSERT INTO materiales (nombre, descripcion) VALUES (%s, %s);"
        cursor.execute(query, (nombre, descripcion))
        mysql.connection.commit()
        return jsonify({"message": "Material agregado correctamente"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()
