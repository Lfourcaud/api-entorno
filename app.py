import sys
try:
    from flask import Flask, jsonify, request, render_template
    import psutil
    import platform
    import logging
    from datetime import datetime, timezone
except ImportError as e:
    missing = str(e).replace("No module named ", "").strip().strip("'\"")
    msg = (f"Missing dependency: {missing}.\n"
           "Activate the virtualenv and install requirements, for example:\n"
           "  source venv/bin/activate\n"
           "  pip install -r requirements.txt\n"
           "Or run the app with the project's venv Python:\n"
           "  ./venv/bin/python app.py\n")
    print(msg, file=sys.stderr)
    sys.exit(1)

app = Flask(__name__)

# Configuración del Sistema de Auditoría (Logs)
# Esto creará un archivo llamado 'api_auditoria.log' y guardará los eventos ahí
logging.basicConfig(
    filename='api_auditoria.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

@app.route('/status')
def status():
    # 1. ACCIÓN OCULTA: Registrar quién hace la consulta
    ip_cliente = request.remote_addr
    logging.info(f"Consulta de estado recibida desde la IP: {ip_cliente}")

    # 2. ACCIÓN VISIBLE: Recopilar las métricas del hardware
    info = {
        "sistema": platform.system(),
        "cpu_uso_porcentaje": psutil.cpu_percent(interval=1),
        "ram_disponible_gb": round(psutil.virtual_memory().available / (1024**3), 2),
        "disco_usado_porcentaje": psutil.disk_usage('/').percent,
        "estado_salud": "Operativo" if psutil.cpu_percent() < 90 else "Alerta: Sobrecarga",
        "fecha_utc": datetime.now(timezone.utc).isoformat()
    }
    
    # 3. Devolver el JSON al usuario
    return jsonify(info)


@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)