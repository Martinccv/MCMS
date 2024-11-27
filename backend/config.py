import os
from dotenv import load_dotenv

# Cargar variables del archivo .env
load_dotenv()

class Config:
    MYSQL_HOST = os.getenv('MYSQL_HOST', 'localhost')
    MYSQL_USER = os.getenv('MYSQL_USER', 'root')
    MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD', '123456')
    MYSQL_DB = os.getenv('MYSQL_DATABASE', 'MCMS')
    MYSQL_CURSORCLASS = 'DictCursor'  # Para devolver resultados como diccionarios
