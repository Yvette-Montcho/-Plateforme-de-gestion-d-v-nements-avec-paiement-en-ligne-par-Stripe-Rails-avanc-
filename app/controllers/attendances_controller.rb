# app/controllers/attendances_controller.rb — Contrôleur gérant les participations aux événements
# Gère l'inscription (avec paiement Stripe) et la liste des participants

class AttendancesController < ApplicationController
  # L'utilisateur doit être connecté pour toutes les actions
  before_action :authenticate_user!

  # Charge l'événement parent à partir de l'URL (/events/:event_id/attendances)
  before_action :set_event

  # Vérifie que seul l'organisateur peut voir la liste des participants
  before_action :authorize_organizer!, only: [:index]

  # GET /events/:event_id/attendances — Liste des participants (organisateur uniquement)
  def index
    # Récupère toutes les participations avec les utilisateurs associés (évite les N+1)
    @attendances = @event.attendances.includes(:user).order(created_at: :desc)
  end

  # GET /events/:event_id/attendances/new — Formulaire d'inscription avec Stripe
  def new
    # Vérifie que l'utilisateur peut rejoindre cet événement (pas déjà inscrit, pas organisateur)
    unless @event.joinable_by?(current_user)
      redirect_to @event, alert: 'Vous ne pouvez pas rejoindre cet événement.'
      return
    end

    # Initialise une participation vide pour le formulaire
    @attendance = Attendance.new

    # Passe la clé publique Stripe à la vue pour initialiser Stripe.js
    # La clé publique peut être exposée côté client (elle ne donne aucun accès à votre compte)
    @stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  end

  # POST /events/:event_id/attendances — Traite le paiement et crée la participation
  def create
    # Vérifie une dernière fois que l'utilisateur peut rejoindre (protection double)
    unless @event.joinable_by?(current_user)
      redirect_to @event, alert: 'Vous ne pouvez pas rejoindre cet événement.'
      return
    end

    # Délègue toute la logique au service dédié (paiement + création en BDD)
    # Le token Stripe est fourni par Stripe.js depuis le formulaire côté client
    result = AttendanceCreatorService.new(
      user:  current_user,                  # Utilisateur qui s'inscrit
      event: @event,                        # Événement à rejoindre
      token: params[:stripeToken]           # Jeton de carte (nil si événement gratuit)
    ).perform

    if result[:success]
      # Succès : redirige vers la page de l'événement avec un message de confirmation
      redirect_to @event, notice: "Vous êtes maintenant inscrit à « #{@event.title} » !"
    else
      # Échec (paiement refusé ou erreur de validation) : réaffiche le formulaire
      @attendance = Attendance.new
      @stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
      flash.now[:alert] = result[:error]     # Affiche l'erreur Stripe dans le formulaire
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /events/:event_id/attendances/:id — Supprime une participation (désinscription)
  def destroy
    # Trouve la participation de l'utilisateur courant pour cet événement
    @attendance = @event.attendances.find_by(user: current_user)

    if @attendance
      # Supprime la participation en BDD
      @attendance.destroy
      redirect_to @event, notice: 'Vous avez été désinscrit de cet événement.'
    else
      # Protection : l'utilisateur n'était pas inscrit
      redirect_to @event, alert: 'Participation introuvable.'
    end
  end

  private

  # Charge l'événement parent depuis l'URL (/events/:event_id/attendances)
  # Toutes les actions de ce contrôleur opèrent dans le contexte d'un événement
  def set_event
    @event = Event.find(params[:event_id])
  end

  # Vérifie que l'utilisateur courant est l'organisateur de l'événement
  # Protège la liste des participants contre les accès non autorisés
  def authorize_organizer!
    unless current_user.organizer_of?(@event)
      redirect_to @event, alert: "Accès réservé à l'organisateur de l'événement."
    end
  end
end
