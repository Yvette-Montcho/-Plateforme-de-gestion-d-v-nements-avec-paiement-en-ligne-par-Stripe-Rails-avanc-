# config/initializers/stripe.rb — Configuration de la gem Stripe au démarrage de Rails
# Ce fichier est chargé automatiquement par Rails au lancement de l'application

# Configure la clé secrète Stripe à partir de la variable d'environnement
# La clé est lue depuis .env en développement, et depuis les Config Vars Heroku en production
# Ne jamais écrire la clé directement ici — utiliser toujours une variable d'environnement
Stripe.api_key = ENV['STRIPE_SECRET_KEY']
