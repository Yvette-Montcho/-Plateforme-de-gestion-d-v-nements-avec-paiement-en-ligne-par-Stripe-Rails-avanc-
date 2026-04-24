# app/services/attendance_creator_service.rb — Service de création d'une participation
# Orchestre le paiement Stripe puis la création en BDD en cas de succès
# Appel : AttendanceCreatorService.new(user: user, event: event, token: token).perform

class AttendanceCreatorService
  # Constructeur : reçoit l'utilisateur, l'événement et le jeton Stripe
  # user  — instance ActiveRecord de l'utilisateur qui rejoint l'événement
  # event — instance ActiveRecord de l'événement à rejoindre
  # token — jeton de carte bancaire fourni par Stripe.js (nil si gratuit)
  def initialize(user:, event:, token: nil)
    @user  = user   # Utilisateur qui s'inscrit
    @event = event  # Événement rejoint
    @token = token  # Jeton Stripe (nil pour les événements gratuits)
  end

  # Méthode principale : gère le flux complet inscription (paiement + création BDD)
  # Retourne un hash { success: Boolean, attendance: Attendance, error: String }
  def perform
    # Branche selon le type d'événement (payant ou gratuit)
    if @event.free?
      # Événement gratuit : on crée directement la participation sans paiement
      create_attendance(stripe_charge_id: nil, amount_paid: 0)
    else
      # Événement payant : on passe d'abord par Stripe
      process_paid_attendance
    end
  end

  private

  # Traite l'inscription à un événement payant
  # Appelle StripeChargeService puis crée la participation si le paiement réussit
  def process_paid_attendance
    # Délègue le paiement au service Stripe dédié
    result = StripeChargeService.new(
      token:  @token,         # Jeton de carte bancaire
      amount: @event.price,   # Prix en centimes
      email:  @user.email     # Email pour le reçu Stripe
    ).perform

    # Si le paiement a échoué, on retourne l'erreur sans toucher à la BDD
    return { success: false, error: result[:error] } unless result[:success]

    # Le paiement a réussi : on crée la participation avec les données Stripe
    create_attendance(
      stripe_charge_id: result[:charge_id], # ID Stripe pour référence future
      amount_paid:      @event.price         # Montant payé (snapshot)
    )
  end

  # Crée l'enregistrement de participation en base de données
  # Retourne un hash succès/échec selon la validation ActiveRecord
  def create_attendance(stripe_charge_id:, amount_paid:)
    # Construit et sauvegarde la participation
    attendance = Attendance.new(
      user:             @user,             # Utilisateur participant
      event:            @event,            # Événement rejoint
      stripe_charge_id: stripe_charge_id,  # ID Stripe (nil si gratuit)
      amount_paid:      amount_paid         # Montant payé en centimes
    )

    if attendance.save
      # Succès : retourne la participation créée
      { success: true, attendance: attendance }
    else
      # Échec des validations ActiveRecord (doublon, etc.)
      { success: false, error: attendance.errors.full_messages.join(', ') }
    end
  end
end
