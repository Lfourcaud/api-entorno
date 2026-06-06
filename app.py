from flask import Flask, jsonify
from datetime import datetime, timezone
import os

app = Flask(__name__)

@app.route('/')
def system_info():
    info = {
        "estado": "Operativo",
        "entorno": os.getenv("FLASK_ENV", "Desarrollo"),
        "fecha_utc": datetime.now(timezone.utc).isoformat(),
        "servicio": "API de Informacion del Entorno"
    }
    return jsonify(info)

if __name__ == '__main__':
    # Expone la aplicación en el puerto 5000 para toda la red (necesario para Docker luego)
    app.run(host='0.0.0.0', port=5000)