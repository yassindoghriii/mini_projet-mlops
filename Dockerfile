# Utiliser une image Python minimale
FROM python:3.9-slim

WORKDIR /app

# Installer les dépendances système pour PostgreSQL et psycopg2
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    python3-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Vérifier si `pg_config` est bien installé
RUN which pg_config || echo "pg_config not found"

# Copier uniquement `requirements.txt` pour optimiser le cache Docker
COPY requirements.txt requirements.txt

# Installer `psycopg2-binary` AVANT le reste des dépendances
RUN pip install --no-cache-dir psycopg2-binary

# Installer toutes les autres dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste du projet après installation des dépendances
COPY . .

EXPOSE 5000

# Lancer Flask avec Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
