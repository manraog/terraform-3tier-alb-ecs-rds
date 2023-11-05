import os

import pymysql
from fastapi import FastAPI

app = FastAPI()

def get_mysql_version():
    """Connect to a MySQL instance and return the version."""
    try:
        connection = pymysql.connect(
            host = os.environ.get('DB_HOST'),
            user = os.environ.get('DB_USER'), 
            password = os.environ.get('DB_PASSWORD'), 
            db = 'sys')
        print("Connection correct")
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM sys.version;")
            rows = cursor.fetchall()
            mysql_version = rows[0][1]
            mensaje = f"mysql_version: {mysql_version}"
            print(mensaje)
            return mensaje
    except (pymysql.err.OperationalError, pymysql.err.InternalError) as e:
        print("Connection error: ", e)

@app.get("/test")  
async def test():  
    """Exposes and HTTP endpoint wich return the MySQL version"""
    return get_mysql_version()