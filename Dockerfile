# 1. Decimos qué sistema operativo y qué Python queremos usar
FROM python:3.9-slim

# 2. Creamos una carpeta dentro de esa caja llamada "app"
WORKDIR /app

# 3. Copiamos nuestro archivo de requisitos
COPY requirements.txt .

# 4. Instalamos las librerías necesarias dentro de la caja
# psutil necesita compilar en algunas plataformas -> instalar herramientas de compilación
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
	&& apt-get install -y --no-install-recommends build-essential gcc python3-dev \
	&& pip install --no-cache-dir -r requirements.txt \
	&& apt-get purge -y --auto-remove build-essential gcc python3-dev \
	&& rm -rf /var/lib/apt/lists/*

# 5. Copiamos todo el resto de nuestro código a la caja
COPY . .

# 6. Decimos que esta caja va a usar el puerto 5000
EXPOSE 5000

# 7. El comando que enciende la app apenas arranca la caja
CMD ["python", "app.py"]
