# Migration pour créer la table "attendances" (participations aux événements)
# Une participation relie un utilisateur à un événement

class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    # Crée la table "attendances" — table de jointure enrichie
    create_table :attendances do |t|
      # Clé étrangère vers l'utilisateur participant
      t.references :user, null: false, foreign_key: true

      # Clé étrangère vers l'événement rejoint
      t.references :event, null: false, foreign_key: true

      # Identifiant Stripe de la transaction de paiement
      # Stocké pour référence future (remboursement, historique)
      t.string :stripe_charge_id

      # Montant payé en centimes (snapshot au moment du paiement)
      t.integer :amount_paid, default: 0, null: false

      # Timestamps automatiques
      t.timestamps
    end

    # Index composite pour éviter qu'un utilisateur s'inscrive deux fois au même événement
    add_index :attendances, [:user_id, :event_id], unique: true
  end
end
