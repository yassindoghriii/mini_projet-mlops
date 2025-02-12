FROM python:3.9-slim

WORKDIR /app

# Installer PostgreSQL et ses dépendances système nécessaires pour psycopg2
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    python3-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copier les fichiers de dépendances AVANT le reste du projet (meilleure gestion du cache)
COPY requirements.txt requirements.txt

# Installer `psycopg2-binary` séparément AVANT les autres dépendances
RUN pip install --no-cache-dir psycopg2-binary

# Installer le reste des dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste du projet après installation des dépendances
COPY . .

EXPOSE 5000

# Lancer Flask avec Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
