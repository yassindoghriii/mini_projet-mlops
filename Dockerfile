# Utiliser une image Python légère
FROM python:3.9-slim

WORKDIR /app

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    python3-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copier les fichiers de dépendances avant le reste du projet
COPY requirements.txt requirements.txt

# Installation de `psycopg2-binary` en premier pour éviter les conflits
RUN pip install --no-cache-dir psycopg2-binary

# Installer le reste des dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste du projet après installation des dépendances
COPY . .

# Exposer le port Flask
EXPOSE 5000

# Lancer Flask avec Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
