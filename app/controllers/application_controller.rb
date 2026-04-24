# app/controllers/application_controller.rb — Contrôleur parent de toute l'application
# Toutes les méthodes ici sont disponibles dans tous les autres contrôleurs

class ApplicationController < ActionController::Base
  # Protège toutes les requêtes contre les attaques CSRF (Cross-Site Request Forgery)
  protect_from_forgery with: :exception

  # Autorise les paramètres supplémentaires lors de l'inscription/modification Devise
  # Devise ne permet par défaut que email + password, on ajoute les champs custom
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Définit les paramètres autorisés pour Devise
  def configure_permitted_parameters
    # Paramètres autorisés à l'inscription (sign_up)
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])

    # Paramètres autorisés lors de la modification du profil (account_update)
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
