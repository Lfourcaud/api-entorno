# API de Monitoreo de Sistema (Dockerizada)

Este proyecto es una aplicación web desarrollada en **Python (Flask)** que permite visualizar en tiempo real el estado del hardware (CPU, RAM, Disco) tanto a través de una interfaz gráfica (UI) como de un endpoint JSON.

## 🚀 Requisitos previos

- Tener instalado [Docker](https://www.docker.com/get-started).
- Tener instalado [Docker Compose](https://docs.docker.com/compose/install/) (opcional, pero recomendado).

## 🛠️ Cómo ejecutar el proyecto

### Opción 1: Usando Docker Compose (Recomendada)

Desde la carpeta `api-entorno/`, ejecuta:

```bash
docker compose up -d
```

Luego, abre en tu navegador: [http://localhost:8080/](http://localhost:8080/)

### Opción 2: Usando Docker CLI

1. **Construir la imagen:**
   ```bash
   docker build -t mi-api-monitoreo .
   ```

2. **Ejecutar el contenedor:**
   ```bash
   docker run -d --rm -p 8080:5000 --name mi-api-viva mi-api-monitoreo
   ```

## 📊 Endpoints disponibles

- **Interfaz Gráfica:** `http://localhost:8080/`
- **Datos JSON:** `http://localhost:8080/status`

## 📝 Notas importantes sobre las métricas

Por defecto, Docker ejecuta el contenedor en un entorno aislado. Esto significa que las métricas (CPU, RAM) reflejarán el estado **desde la perspectiva del contenedor**.

Si deseas que la aplicación muestre las métricas **reales del sistema host**, debes ejecutar el contenedor compartiendo el espacio de nombres de procesos del host:

```bash
docker run -d --rm --pid=host -p 8080:5000 --name mi-api-viva mi-api-monitoreo
```

**Nota sobre macOS:** Docker Desktop en macOS ejecuta contenedores dentro de una máquina virtual. Por ello, `--pid=host` no comparte el espacio de nombres de procesos del sistema macOS y **no** permitirá obtener las métricas reales del host macOS. Para ver métricas reales tienes dos opciones:

- Ejecutar la aplicación directamente en tu macOS (sin Docker):

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

- O ejecutar el contenedor en una máquina Linux (o servidor) donde `--pid=host` sí es compatible.

## 📂 Estructura del Proyecto

- `app.py`: Servidor Flask y lógica de obtención de métricas con `psutil`.
- `Dockerfile`: Configuración para empaquetar la app.
- `docker-compose.yml`: Orquestación sencilla del servicio.
- `static/`: Archivos CSS y JavaScript para la UI.
- `templates/`: Plantillas HTML (index.html).
- `api_auditoria.log`: Archivo donde se registran las consultas recibidas (mapeado como volumen en Docker).

---
*Desarrollado para el Trabajo Práctico de Ingenieria de Software.*
