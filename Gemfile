# Gemfile — Déclaration de toutes les dépendances Ruby de l'application
# Chaque gem est une bibliothèque externe qui étend les fonctionnalités de Rails

# Source officielle pour télécharger les gems
source 'https://rubygems.org'

# Version de Ruby utilisée pour ce projet
ruby '3.1.2'

# Framework principal : Ruby on Rails (version 7)
gem 'rails', '~> 7.0.4'

# Adaptateur PostgreSQL — base de données relationnelle principale
gem 'pg', '~> 1.1'

# Serveur web Puma — utilisé en développement et en production
gem 'puma', '~> 5.0'

# Pipeline d'assets (CSS, JS, images) avec Sprockets
gem 'sprockets-rails'

# Gestion de l'authentification utilisateur (inscription, connexion, déconnexion)
gem 'devise', '~> 4.9'

# Intégration de Stripe pour les paiements par carte bancaire
gem 'stripe', '~> 8.0'

# Gestion des variables d'environnement en développement (.env)
gem 'dotenv-rails', groups: [:development, :test]

# Bootstrap 5 — framework CSS pour un design responsive rapide
gem 'bootstrap', '~> 5.2'

# Permet d'utiliser JavaScript moderne (importmaps)
gem 'importmap-rails'

# Turbo Rails — navigation rapide sans rechargement complet de page
gem 'turbo-rails'

# Stimulus — framework JavaScript léger pour enrichir les vues Rails
gem 'stimulus-rails'

# Simplification des formulaires HTML dans les vues Rails
gem 'simple_form', '~> 5.1'

# Pagination des listes (événements, participants)
gem 'kaminari', '~> 1.2'

# Compression des assets JavaScript en production
gem 'uglifier', '>= 1.3.0'

# Gestion du fuseau horaire et du formatage des dates
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  # Débogueur interactif — permet d'inspecter le code en cours d'exécution
  gem 'debug', platforms: [:mri, :mingw, :x64_mingw]

  # Génère des données fictives pour les tests (noms, emails, etc.)
  gem 'faker', '~> 3.0'

  # Framework de tests unitaires et fonctionnels
  gem 'rspec-rails', '~> 6.0'
end

group :development do
  # Affiche les erreurs détaillées dans le navigateur en développement
  gem 'web-console'

  # Annoter les modèles avec le schéma de la base de données
  gem 'annotate'

  # Détecte les requêtes SQL inutiles (N+1 queries)
  gem 'bullet'
end

group :test do
  # Simule un navigateur pour les tests d'intégration
  gem 'capybara'

  # Pilote de navigateur headless pour les tests système
  gem 'selenium-webdriver'
end
