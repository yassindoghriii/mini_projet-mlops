FROM python:3.9-slim

WORKDIR /app

# Installer PostgreSQL et les outils nécessaires
RUN apt-get update && apt-get install -y libpq-dev gcc python3-dev postgresql-client

# Copier et installer les dépendances Python
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste du projet
COPY . .

EXPOSE 5000

# Lancer Flask avec Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
