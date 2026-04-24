# app/services/stripe_charge_service.rb — Service de traitement des paiements Stripe
# Isole toute la logique de paiement hors du contrôleur (Single Responsibility Principle)
# Appel : StripeChargeService.new(token: token, amount: amount, email: email).perform

class StripeChargeService
  # Constructeur : reçoit les paramètres nécessaires au paiement
  # token  — jeton sécurisé généré par Stripe.js côté client (représente la carte)
  # amount — montant en centimes (ex: 1000 = 10€)
  # email  — email du client pour la facturation Stripe
  def initialize(token:, amount:, email:)
    @token  = token   # Jeton de carte bancaire fourni par Stripe.js
    @amount = amount  # Montant en centimes
    @email  = email   # Email pour associer la charge à un client Stripe
  end

  # Méthode principale : crée le paiement chez Stripe et retourne le résultat
  # Retourne un objet avec :success (booléen), :charge_id (String) ou :error (String)
  def perform
    # Tente de créer une charge (débit) chez Stripe via leur API
    charge = Stripe::Charge.create(
      amount:      @amount,      # Montant en centimes
      currency:    'eur',        # Devise : euros
      source:      @token,       # Jeton de carte bancaire (usage unique)
      description: 'EventFreeka — Inscription événement', # Description visible sur le reçu
      receipt_email: @email      # Envoie automatiquement un reçu par email
    )

    # Retourne un hash de succès avec l'identifiant de la charge Stripe
    # stripe_id sera stocké en BDD dans la table attendances
    { success: true, charge_id: charge.id }

  rescue Stripe::CardError => e
    # Erreur de carte (numéro invalide, fonds insuffisants, carte expirée, etc.)
    # On renvoie le message d'erreur Stripe pour l'afficher à l'utilisateur
    { success: false, error: e.message }

  rescue Stripe::StripeError => e
    # Erreur générique Stripe (problème réseau, API indisponible, etc.)
    { success: false, error: "Erreur de paiement : #{e.message}" }
  end
end
