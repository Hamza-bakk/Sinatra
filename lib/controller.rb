# Importation des bibliothèques et fichiers nécessaires
require 'bundler'
Bundler.require
require './lib/gossip'

# Définition de la classe ApplicationController qui hérite de Sinatra::Base
class ApplicationController < Sinatra::Base
  # Activation de la méthode de substitution pour permettre l'utilisation de PUT et DELETE
  enable :method_override

  # Route pour la page d'accueil, affiche tous les potins
  get '/' do
    # Récupérer tous les potins depuis la base de données
    @gossips = Gossip.all

    # Afficher la vue index.erb avec la liste des potins (@gossips)
    erb :index, locals: { gossips: @gossips }
  end

  # Route pour la création d'un nouveau potin, affiche le formulaire de création
  get '/gossips/new' do
    # Afficher la vue new_gossip.erb avec le formulaire de création de potin
    erb :new_gossip
  end

  # Route pour afficher un potin spécifique
  get '/gossips/:id' do
    # Récupérer le potin depuis la base de données en utilisant l'ID fourni
    @gossip = Gossip.find(params[:id])

    # Afficher la vue show.erb avec les détails du potin (@gossip)
    erb :show, locals: { gossip: @gossip }
  end

  # Route pour créer un nouveau potin suite à la soumission du formulaire
  post '/gossips/new' do
    # Récupérer l'ID du nouveau potin (nombre total de potins + 1)
    id = Gossip.all.length + 1

    # Créer un nouveau potin avec les informations fournies dans le formulaire
    Gossip.new(id, params["gossip_author"], params["gossip_content"]).save

    # Rediriger l'utilisateur vers la page d'accueil
    redirect '/'
  end

  # Route pour afficher le formulaire d'édition d'un potin spécifique
  get '/gossips/:id/edit' do
    # Récupérer le potin depuis la base de données en utilisant l'ID fourni
    @gossip = Gossip.find(params[:id])

    # Afficher la vue edit.erb avec le formulaire d'édition de potin et la variable @gossip
    erb :edit, locals: { gossip: @gossip }
  end

  # Route pour mettre à jour un potin suite à la soumission du formulaire d'édition
  put '/gossips/:id' do
    # Récupérer le potin depuis la base de données en utilisant l'ID fourni
    @gossip = Gossip.find(params[:id])

    # Mettre à jour les données du potin avec les nouvelles valeurs du formulaire
    @gossip.author = params[:author]
    @gossip.content = params[:content]
    @gossip.save

    # Rediriger l'utilisateur vers la page de détails du potin mis à jour
    redirect "/gossips/#{@gossip.id}"
  end
end
