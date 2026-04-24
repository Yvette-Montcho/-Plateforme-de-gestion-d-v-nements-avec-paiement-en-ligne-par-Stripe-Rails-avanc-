# db/seeds.rb — Peuplement initial de la base de données avec des données de test
# Exécuter avec : rails db:seed
# Ces données permettent de tester l'application sans créer manuellement chaque enregistrement

puts "🌱 Nettoyage des données existantes..."
# Supprime dans l'ordre inverse des dépendances pour respecter les contraintes FK
Attendance.destroy_all  # Supprime d'abord les participations
Event.destroy_all       # Puis les événements
User.destroy_all        # Enfin les utilisateurs

puts "👤 Création des utilisateurs..."

# Crée l'organisateur principal — celui qui créera des événements
organizer = User.create!(
  email: 'organisateur@eventfreeka.com',  # Email de connexion
  password: 'password123'                  # Mot de passe de test
)

# Crée plusieurs utilisateurs participants
participants = 3.times.map do |i|
  User.create!(
    email: "participant#{i + 1}@eventfreeka.com",
    password: 'password123'
  )
end

puts "🎉 Création des événements..."

# Événement payant dans le futur
event_payant = Event.create!(
  title: 'Soirée Networking Startups Paris',              # Titre accrocheur
  description: "Un événement pour connecter les entrepreneurs, investisseurs et développeurs de la scène tech parisienne. Venez pitcher votre projet et rencontrer des talents !",
  location: '42 rue du Louvre, Paris 75001',              # Adresse précise
  starts_at: 2.weeks.from_now,                            # Dans 2 semaines
  price: 2500,                                             # 25€ en centimes
  user: organizer                                          # Créé par l'organisateur
)

# Événement gratuit dans le futur
event_gratuit = Event.create!(
  title: 'Atelier Ruby on Rails pour débutants',
  description: "Un atelier gratuit pour apprendre les bases de Ruby on Rails. Apportez votre laptop et votre curiosité !",
  location: 'École 42, Paris',
  starts_at: 1.week.from_now,                             # Dans 1 semaine
  price: 0,                                               # Gratuit !
  user: organizer
)

# Événement passé (pour tester les scopes)
Event.create!(
  title: 'Meetup Ruby - Édition Janvier',
  description: 'Retour sur les nouveautés de Rails 7 et présentation de Hotwire.',
  location: 'Le Wagon Paris',
  starts_at: 1.month.ago,                                 # Il y a 1 mois (passé)
  price: 500,                                             # 5€
  user: organizer
)

puts "🎟️ Création de participations..."

# Inscrit 2 participants à l'événement gratuit
participants.first(2).each do |participant|
  Attendance.create!(
    user:             participant,     # Participant
    event:            event_gratuit,   # Événement gratuit
    stripe_charge_id: nil,             # Pas de paiement Stripe pour un événement gratuit
    amount_paid:      0                # Montant = 0
  )
end

# Inscrit 1 participant à l'événement payant (simule un paiement réussi)
Attendance.create!(
  user:             participants.first,          # Premier participant
  event:            event_payant,                # Événement payant
  stripe_charge_id: 'ch_test_seed_1234567890',  # ID Stripe simulé pour les seeds
  amount_paid:      2500                          # 25€ payés
)

puts "✅ Seeds terminés !"
puts "   • #{User.count} utilisateurs créés"
puts "   • #{Event.count} événements créés"
puts "   • #{Attendance.count} participations créées"
puts ""
puts "📧 Connexion organisateur : organisateur@eventfreeka.com / password123"
puts "📧 Connexion participant : participant1@eventfreeka.com / password123"
