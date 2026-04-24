# Migration pour créer la table "events" dans la base de données PostgreSQL
# Chaque migration décrit une modification précise du schéma de la BDD

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    # Crée la table "events" avec ses colonnes
    create_table :events do |t|
      # Titre de l'événement (obligatoire, chaîne de caractères)
      t.string :title, null: false

      # Description détaillée de l'événement (texte long)
      t.text :description

      # Lieu où se déroule l'événement
      t.string :location

      # Date et heure de l'événement
      t.datetime :starts_at, null: false

      # Prix de l'événement en centimes (0 = gratuit, ex: 1000 = 10€)
      # Utiliser les centimes évite les problèmes d'arrondi avec les flottants
      t.integer :price, default: 0, null: false

      # Clé étrangère vers l'utilisateur créateur de l'événement
      # null: false garantit qu'un événement a toujours un propriétaire
      t.references :user, null: false, foreign_key: true

      # Timestamps automatiques : created_at et updated_at
      t.timestamps
    end

    # Index sur starts_at pour accélérer les tris chronologiques
    add_index :events, :starts_at
  end
end
