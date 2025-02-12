FROM python:3.9-slim

WORKDIR /app

# Installer PostgreSQL et ses dépendances système pour psycopg2
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    python3-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Définir le chemin de `pg_config` pour éviter les erreurs
ENV PATH="/usr/lib/postgresql/15/bin:$PATH"

# Copier les fichiers requirements.txt
COPY requirements.txt requirements.txt

# Installer `psycopg2-binary` en premier pour éviter les conflits
RUN pip install --no-cache-dir psycopg2-binary

# Installer les autres dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste du projet
COPY . .

EXPOSE 5000

# Lancer Flask avec Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
