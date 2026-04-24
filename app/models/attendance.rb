# app/models/attendance.rb — Modèle représentant la participation d'un utilisateur à un événement
# Fait le lien entre un User et un Event, et stocke les données de paiement Stripe

class Attendance < ApplicationRecord
  # Association : une participation appartient à un utilisateur
  belongs_to :user

  # Association : une participation appartient à un événement
  belongs_to :event

  # Validation : un utilisateur ne peut pas s'inscrire deux fois au même événement
  # L'index unique en BDD est le filet de sécurité, cette validation donne un message clair
  validates :user_id, uniqueness: {
    scope: :event_id,
    message: 'est déjà inscrit à cet événement'
  }

  # Validation : le montant payé doit être positif ou nul
  validates :amount_paid, numericality: { greater_than_or_equal_to: 0 }

  # Méthode d'instance : vérifie si cette participation a été payée via Stripe
  def paid?
    stripe_charge_id.present?
  end
end
