from flask import Flask, jsonify
from flask_mysqldb import MySQL
from config import Config

# Inicializa MySQL
mysql = MySQL()

def create_app():
    """Fábrica de aplicaciones para crear instancias de Flask."""
    app = Flask(__name__)
    app.config.from_object(Config)

    # Inicializa MySQL
    mysql.init_app(app)

    # Ruta de prueba para verificar el backend
    @app.route('/ping', methods=['GET'])
    def ping():
        return jsonify({"message": "¡Backend en Flask funcionando correctamente!"})

    # Registrar Blueprints
    from routes.example_routes import example_blueprint
    app.register_blueprint(example_blueprint, url_prefix='/api')
    
    # Registra el blueprint de db_check
    from routes.db_check import db_check_blueprint
    app.register_blueprint(db_check_blueprint, url_prefix='/api')  # Usa el prefijo /api
    
    return app
