# app/services/say_hello.rb — Service d'exemple pour comprendre le pattern Services Rails
# Démontre la convention : un fichier = une classe = une méthode perform
# Appel : SayHello.new.perform dans la console ou n'importe où dans Rails

class SayHello
  # Méthode principale du service — convention Rails pour les services
  # Toujours nommer la méthode "perform" pour uniformiser le code
  # Appel : SayHello.new.perform
  def perform
    # Affiche "bonjour" dans la console (p = print avec retour à la ligne)
    p 'bonjour'
  end
end
