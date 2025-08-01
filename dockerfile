FROM python:3.11-slim

# 🟢 Crear usuario y grupo no root
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# 🟢 Directorio de trabajo
WORKDIR /app

# 🟢 Copiar e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 🟢 Copiar código fuente
COPY . .

#🟢 Instalar dependencias del sistema
RUN apt-get update && apt-get install -y curl && apt-get clean

# 🟢 Permisos y seguridad
RUN chown -R appuser:appgroup /app
USER appuser

# 🟢 Exponer puerto 
EXPOSE 8765

# 🟡 Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=20s --retries=3 \
  CMD curl -f http://localhost:${DJANGO_PORT}/api/ || exit 1


CMD sh -c "python manage.py migrate && python manage.py runserver 0.0.0.0:${DJANGO_PORT:-8765}"
