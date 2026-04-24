# app/models/event.rb — Modèle représentant un événement sur la plateforme
# Contient la logique métier liée aux événements

class Event < ApplicationRecord
  # Association : un événement appartient à un utilisateur (son créateur)
  belongs_to :user

  # Association : un événement peut avoir plusieurs participations
  has_many :attendances, dependent: :destroy

  # Association intermédiaire : accès aux participants via les participations
  has_many :attendees, through: :attendances, source: :user

  # Validations pour garantir l'intégrité des données
  # Le titre est obligatoire et ne peut pas être vide
  validates :title, presence: true

  # La date de début est obligatoire
  validates :starts_at, presence: true

  # Le prix doit être un entier positif ou nul (0 = gratuit)
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # Scope pour afficher les événements à venir en premier
  scope :upcoming, -> { where('starts_at >= ?', Time.current).order(:starts_at) }

  # Scope pour afficher les événements passés
  scope :past, -> { where('starts_at < ?', Time.current).order(starts_at: :desc) }

  # Méthode d'instance : vérifie si l'événement est gratuit
  # Notation avec "?" pour indiquer une méthode booléenne (convention Rails)
  # Plus lisible que "event.price == 0" dans les vues et contrôleurs
  def free?
    price.zero?
  end

  # Méthode d'instance : retourne le prix formaté en euros pour l'affichage
  # Le prix est stocké en centimes pour éviter les problèmes d'arrondi
  def price_in_euros
    price / 100.0
  end

  # Méthode d'instance : retourne le prix formaté avec symbole €
  def formatted_price
    free? ? 'Gratuit' : "#{price_in_euros}€"
  end

  # Méthode d'instance : vérifie si un utilisateur peut rejoindre cet événement
  # Un utilisateur peut rejoindre si : il est connecté, pas créateur, pas déjà inscrit
  def joinable_by?(user)
    return false if user.nil?             # Utilisateur non connecté
    return false if user.organizer_of?(self) # Créateur de l'événement
    return false if user.attending?(self)    # Déjà inscrit
    true
  end
end
