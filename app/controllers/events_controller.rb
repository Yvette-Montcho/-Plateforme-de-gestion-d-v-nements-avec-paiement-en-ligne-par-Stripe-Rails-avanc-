# app/controllers/events_controller.rb — Contrôleur gérant les événements (CRUD complet)
# Suit la convention REST : index, show, new, create, edit, update, destroy

class EventsController < ApplicationController
  # Exige que l'utilisateur soit connecté pour toutes les actions sauf index et show
  before_action :authenticate_user!, except: [:index, :show]

  # Charge l'événement depuis la BDD avant les actions qui en ont besoin
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # Vérifie que l'utilisateur courant est bien le créateur de l'événement
  # Protège edit, update et destroy contre les accès non autorisés
  before_action :authorize_organizer!, only: [:edit, :update, :destroy]

  # GET /events — Liste tous les événements à venir
  def index
    # Récupère tous les événements à venir, triés par date (scope défini dans le modèle)
    @events = Event.upcoming.includes(:user, :attendances)
  end

  # GET /events/:id — Affiche le détail d'un événement
  def show
    # @event est déjà chargé par set_event
    # On charge les participants pour afficher leur nombre sur la page
    @attendees = @event.attendees.includes(:user)
  end

  # GET /events/new — Affiche le formulaire de création d'événement
  def new
    # Initialise un événement vide pour le formulaire
    @event = Event.new
  end

  # POST /events — Sauvegarde un nouvel événement en BDD
  def create
    # Construit l'événement avec les paramètres filtrés et l'utilisateur courant comme créateur
    @event = Event.new(event_params)
    @event.user = current_user  # Associe le créateur automatiquement

    if @event.save
      # Succès : redirige vers la page de l'événement avec un message de confirmation
      redirect_to @event, notice: "L'événement « #{@event.title} » a été créé avec succès !"
    else
      # Échec de validation : réaffiche le formulaire avec les erreurs
      render :new, status: :unprocessable_entity
    end
  end

  # GET /events/:id/edit — Affiche le formulaire de modification (organisateur uniquement)
  def edit
    # @event est déjà chargé et autorisé par set_event + authorize_organizer!
  end

  # PATCH /PUT /events/:id — Sauvegarde les modifications d'un événement
  def update
    if @event.update(event_params)
      # Succès : redirige vers la page de l'événement
      redirect_to @event, notice: "L'événement a été mis à jour avec succès !"
    else
      # Échec : réaffiche le formulaire d'édition avec les erreurs
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/:id — Supprime un événement (organisateur uniquement)
  def destroy
    # Supprime l'événement (et ses participations grâce à dependent: :destroy)
    @event.destroy
    # Redirige vers la liste des événements avec un message de confirmation
    redirect_to events_path, notice: "L'événement a été supprimé.", status: :see_other
  end

  private

  # Charge l'événement depuis la BDD à partir de l'ID dans l'URL
  # Lève une exception ActiveRecord::RecordNotFound si l'ID n'existe pas (→ 404)
  def set_event
    @event = Event.find(params[:id])
  end

  # Vérifie que l'utilisateur courant est le créateur de l'événement
  # Redirige avec une erreur si ce n'est pas le cas (protection contre l'accès non autorisé)
  def authorize_organizer!
    unless current_user.organizer_of?(@event)
      redirect_to @event, alert: "Vous n'êtes pas autorisé à effectuer cette action."
    end
  end

  # Filtre les paramètres autorisés pour créer/modifier un événement (Strong Parameters)
  # Empêche l'assignation de masse non autorisée (protection sécurité)
  def event_params
    params.require(:event).permit(
      :title,       # Titre de l'événement
      :description, # Description détaillée
      :location,    # Lieu de l'événement
      :starts_at,   # Date et heure de début
      :price        # Prix en centimes (0 = gratuit)
    )
  end
end
