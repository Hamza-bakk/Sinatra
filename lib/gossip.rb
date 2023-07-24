# Importation de la bibliothèque CSV
require 'csv'

# Définition de la classe Gossip
class Gossip
  # Déclaration des attributs accessibles en lecture et écriture
  attr_accessor :id, :author, :content

  # Méthode d'initialisation de la classe
  def initialize(id, author, content)
    @id = id
    @author = author
    @content = content
  end
  
  # Méthode pour sauvegarder le potin dans le fichier CSV
  def save
    # Récupérer tous les potins depuis le fichier CSV
    all_gossips = Gossip.all

    # Rechercher si le potin existe déjà dans la liste par son ID
    index = all_gossips.index { |gossip| gossip.id == @id }

    if index
      # Mettre à jour le potin existant s'il existe déjà dans le CSV
      all_gossips[index] = self
    else
      # Sinon, ajouter le nouveau potin à la liste
      all_gossips << self
    end

    # Écrire tous les potins dans le fichier CSV
    CSV.open("./db/gossip.csv", "wb") do |csv| # Utilisez le mode "wb" pour écrire à partir de zéro
      all_gossips.each do |gossip|
        csv << [gossip.id, gossip.author, gossip.content]
      end
    end
  end

  # Méthode de classe pour récupérer tous les potins depuis le fichier CSV
  def self.all
    all_gossips = []
    CSV.read("./db/gossip.csv").each do |csv_line|
      all_gossips << Gossip.new(csv_line[0], csv_line[1], csv_line[2])
    end
    return all_gossips
  end

  # Méthode de classe pour trouver un potin par son ID
  def self.find(id)
    all_gossips = all
    return all_gossips.find { |gossip| gossip.id == id }
  end
end
