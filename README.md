# EventFreeka 🎉

> Plateforme de gestion d'événements avec paiement en ligne par Stripe — projet Rails avancé (Services & API).

---

## Nom du repository GitHub recommandé

```
eventfreeka-rails
```

> Simple, descriptif, en kebab-case (convention GitHub), et reflète à la fois le projet (EventFreeka) et le framework (Rails).

---

## Description du projet

EventFreeka est une application Ruby on Rails inspirée d'Eventbrite. Elle permet à des utilisateurs de :

- **Créer et gérer des événements** (titre, description, lieu, date, prix)
- **S'inscrire à des événements payants** via un paiement sécurisé par carte bancaire (Stripe)
- **S'inscrire gratuitement** si le prix de l'événement est 0
- **Consulter la liste des participants** (réservé à l'organisateur)
- **Modifier ou supprimer un événement** depuis un espace dédié

### Concepts clés abordés

| Concept | Description |
|---------|-------------|
| **Services Rails (PORO)** | Isolation de la logique métier dans `app/services/` |
| **Stripe API** | Paiement sécurisé par carte bancaire |
| **Dotenv** | Gestion des clés d'API en développement |
| **Variables Heroku** | Gestion des clés d'API en production |
| **Devise** | Authentification utilisateur (inscription, connexion) |
| **Before Actions** | Protection des routes selon le rôle de l'utilisateur |

---

## Architecture du projet

```
eventfreeka-rails/
│
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb   # Contrôleur parent (filtres globaux, Devise)
│   │   ├── events_controller.rb        # CRUD des événements + autorisation organisateur
│   │   └── attendances_controller.rb   # Inscription, liste participants, désinscription
│   │
│   ├── models/
│   │   ├── user.rb                     # Modèle utilisateur (Devise + associations)
│   │   ├── event.rb                    # Modèle événement (validations + méthodes métier)
│   │   └── attendance.rb              # Modèle participation (lien user/event + Stripe)
│   │
│   ├── services/
│   │   ├── say_hello.rb               # Service d'exemple (démo du pattern)
│   │   ├── stripe_charge_service.rb   # Traitement du paiement Stripe
│   │   └── attendance_creator_service.rb # Orchestration paiement + création participation
│   │
│   └── views/
│       ├── layouts/application.html.erb   # Template global (navbar, flash, footer)
│       ├── events/                         # Vues CRUD événements
│       └── attendances/                   # Formulaire Stripe + liste participants
│
├── config/
│   ├── routes.rb                      # Routes imbriquées events > attendances
│   ├── database.yml                   # Configuration PostgreSQL (dev/test/prod)
│   └── initializers/stripe.rb        # Initialisation Stripe avec clé secrète
│
├── db/
│   ├── migrate/                       # Migrations PostgreSQL
│   └── seeds.rb                      # Données de test
│
├── .env.example                       # Modèle de fichier .env (sans les vraies clés)
├── .gitignore                         # Fichiers exclus de Git (dont .env !)
└── Gemfile                           # Dépendances Ruby
```

---

## Prérequis

Avant d'installer le projet, assurez-vous d'avoir installé :

| Outil | Version recommandée | Vérification |
|-------|---------------------|--------------|
| Ruby | 3.1.2+ | `ruby -v` |
| Rails | 7.0+ | `rails -v` |
| PostgreSQL | 14+ | `psql --version` |
| Node.js | 18+ | `node -v` |
| Bundler | 2.3+ | `bundler -v` |

---

## Installation et exécution avec VS Code

### Extensions VS Code à installer

Installez ces extensions avant de commencer (**Extensions recommandées**) :

| Extension | ID | Utilité |
|-----------|-----|---------|
| **Ruby LSP** | `Shopify.ruby-lsp` | Autocomplétion, go-to-definition, erreurs en temps réel |
| **ERB Formatter/Viewer** | `aliariff.vscode-erb-beautify` | Formatage des fichiers `.html.erb` |
| **Rails** | `bung.vscode-rails-rspec` | Snippets et navigation Rails |
| **PostgreSQL** | `ckolkman.vscode-postgres` | Visualiser la base de données directement dans VS Code |
| **GitLens** | `eamodio.gitlens` | Historique Git enrichi |
| **DotENV** | `mikestead.dotenv` | Coloration syntaxique des fichiers `.env` |
| **Prettier** | `esbenp.prettier-vscode` | Formatage automatique du code |
| **Auto Rename Tag** | `formulahendry.auto-rename-tag` | Fermeture automatique des balises HTML/ERB |

> **Astuce** : Ouvrez le panneau Extensions avec `Ctrl+Shift+X`, puis recherchez l'ID de chaque extension.

---

### Étapes d'installation

#### 1. Cloner le repository

```bash
git clone https://github.com/VOTRE_USERNAME/eventfreeka-rails.git
cd eventfreeka-rails
```

#### 2. Ouvrir dans VS Code

```bash
code .
```

#### 3. Installer les dépendances Ruby

Dans le terminal intégré VS Code (`Ctrl+`` ` ```) :

```bash
bundle install
```

#### 4. Configurer les variables d'environnement

```bash
# Copier le fichier modèle
cp .env.example .env

# Ouvrir .env et remplir vos vraies clés
```

Éditez `.env` avec vos clés Stripe (disponibles sur [dashboard.stripe.com](https://dashboard.stripe.com/apikeys)) :

```env
STRIPE_PUBLISHABLE_KEY=pk_test_votre_vraie_cle
STRIPE_SECRET_KEY=sk_test_votre_vraie_cle
```

#### 5. Créer et migrer la base de données

```bash
rails db:create
rails db:migrate
rails db:seed   # Optionnel : peuple la BDD avec des données de test
```

#### 6. Lancer le serveur de développement

```bash
rails server
```

> L'application est accessible sur **http://localhost:3000**

---

### Comptes de test (après `rails db:seed`)

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| Organisateur | `organisateur@eventfreeka.com` | `password123` |
| Participant 1 | `participant1@eventfreeka.com` | `password123` |
| Participant 2 | `participant2@eventfreeka.com` | `password123` |

### Carte bancaire de test Stripe

Pour tester le paiement **sans débiter une vraie carte** :

| Champ | Valeur |
|-------|--------|
| Numéro de carte | `4242 4242 4242 4242` |
| Date d'expiration | N'importe quelle date future |
| CVC | N'importe quels 3 chiffres |

---

## Commandes utiles

```bash
# Lancer la console Rails interactive
rails console

# Tester le service SayHello en console
SayHello.new.perform

# Voir toutes les routes disponibles
rails routes

# Réinitialiser la base de données
rails db:reset

# Lancer les tests
bundle exec rspec
```

---

## Déploiement sur Heroku

```bash
# Créer l'application Heroku
heroku create eventfreeka

# Configurer les variables d'environnement (remplace le fichier .env)
heroku config:set STRIPE_PUBLISHABLE_KEY=pk_live_votre_cle
heroku config:set STRIPE_SECRET_KEY=sk_live_votre_cle

# Déployer
git push heroku main

# Migrer la base de données en production
heroku run rails db:migrate
```

> ⚠️ **Important** : N'oubliez jamais de mettre `.env` dans `.gitignore`. Des milliers de développeurs se font pirater leurs clés chaque année !

---

## Technologies utilisées

- **Ruby on Rails 7** — Framework MVC
- **PostgreSQL** — Base de données relationnelle
- **Devise** — Authentification utilisateur
- **Stripe** — Paiement en ligne sécurisé
- **Dotenv** — Gestion des variables d'environnement
- **Bootstrap 5** — Interface utilisateur responsive
- **Heroku** — Hébergement cloud

---

## Licence

Ce projet est réalisé dans un cadre éducatif — formation **Entreprendre dans la Tech** (ETP4A), Semaine 7, Jour 3.
