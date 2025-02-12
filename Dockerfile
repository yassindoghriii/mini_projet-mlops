# Utiliser une image Python légère
FROM python:3.9-slim

WORKDIR /app

# Copier le fichier requirements.txt et installer les dépendances
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copier tous les fichiers du projet
COPY . .

# Exécuter l'entraînement du modèle avant de lancer l'API Flask
RUN python train.py

# Exposer le port Flask
EXPOSE 5000

# Lancer l'API Flask avec Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
