# app/models/user.rb — Modèle représentant un utilisateur de l'application
# Géré par Devise pour l'authentification (email + mot de passe)

class User < ApplicationRecord
  # Modules Devise activés pour ce modèle :
  # :database_authenticatable — stocke et valide le mot de passe en BDD
  # :registerable — permet l'inscription via un formulaire
  # :recoverable — réinitialisation du mot de passe par email
  # :rememberable — option "se souvenir de moi" (cookie)
  # :validatable — valide l'email et le mot de passe automatiquement
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Association : un utilisateur peut créer plusieurs événements
  # dependent: :destroy supprime les événements si l'utilisateur est supprimé
  has_many :created_events, class_name: 'Event', foreign_key: 'user_id', dependent: :destroy

  # Association : un utilisateur peut avoir plusieurs participations (événements rejoints)
  has_many :attendances, dependent: :destroy

  # Association intermédiaire : accès aux événements rejoints via les participations
  has_many :attended_events, through: :attendances, source: :event

  # Vérifie si l'utilisateur est le créateur d'un événement donné
  # Utilisé dans les vues pour afficher/masquer les boutons d'administration
  def organizer_of?(event)
    created_events.include?(event)
  end

  # Vérifie si l'utilisateur est déjà inscrit à un événement
  # Utilisé pour conditionner l'affichage du bouton "Rejoindre"
  def attending?(event)
    attended_events.include?(event)
  end
end
