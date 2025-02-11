pipeline {
    agent any

    environment {
        DATA_PATH = ""  // Les fichiers sont à la racine, donc pas de sous-dossier
        MODEL_PATH = "models/"
    }

    stages {
        stage('Cloner le code') {
            steps {
                git branch: 'main', url: 'https://github.com/yassindoghriii/mini_projet-mlops.git'
            }
        }

        stage('Vérifier les fichiers de données') {
            steps {
                script {
                    if (fileExists('train.csv') && fileExists('test.csv')) {
                        echo "✔️ Les fichiers de données existent, traitement lancé."
                    } else {
                        error "❌ Les fichiers de données train.csv et test.csv sont manquants."
                    }
                }
            }
        }

        stage('Installer les dépendances') {
            steps {
                sh 'python3 -m pip install --no-cache-dir -r requirements.txt || exit 1'
            }
        }

        stage('Prétraitement des données') {
            steps {
                sh 'python3 preprocessing.py'
            }
        }

        stage('Entraînement du modèle') {
            steps {
                sh 'python3 train.py'
            }
        }

        stage('Évaluation du modèle') {
            steps {
                sh 'python3 evaluate.py'
            }
        }

        stage('Stockage des artefacts') {
            steps {
                archiveArtifacts artifacts: 'rf_model.pkl, dt_model.pkl, ann_model.pkl', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline terminé avec succès ! ✅"
        }
        failure {
            echo "🚨 Le pipeline a échoué ! Vérifie les logs Jenkins."
        }
    }
}
