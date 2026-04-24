# config/routes.rb — Définit toutes les URLs de l'application et leurs contrôleurs associés
# Chaque route mappe une URL HTTP vers une action d'un contrôleur

Rails.application.routes.draw do
  # Routes générées automatiquement par Devise pour l'authentification
  # Inclut : /users/sign_up, /users/sign_in, /users/sign_out, etc.
  devise_for :users

  # Routes imbriquées pour les événements et leurs participations
  # Un événement (event) peut avoir plusieurs participations (attendances)
  resources :events do
    # Routes imbriquées : /events/:event_id/attendances
    # Permet d'associer une participation à un événement spécifique
    resources :attendances, only: [:index, :new, :create, :destroy]
  end

  # Page d'accueil de l'application — affiche la liste des événements
  root to: 'events#index'
end
