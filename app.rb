# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/' do
    return erb(:index)
  end

  get '/about' do
    return erb(:about)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all

    return erb(:albums)
  end

  post '/albums' do
    repo = AlbumRepository.new
    album = Album.new
    
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    repo.create(album)
    
    @new_album = params[:title]

    return erb(:album_created)
  end

  get '/albums/new' do
    return erb(:new_album)
  end

  get '/albums/:id' do
    album_repo = AlbumRepository.new
    album = album_repo.find(params[:id])

    @album_title = album.title
    @release_year = album.release_year
    
    artist_repo = ArtistRepository.new
    artist = artist_repo.find(album.artist_id)
    @artist_name = artist.name

    return erb(:album)

  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all

    return erb(:artists)
  end

  post '/artists' do
    repo = ArtistRepository.new
    artist = Artist.new

    artist.name = params[:name]
    artist.genre = params[:genre]
    repo.create(artist)

    @new_artist = params[:name]

    return erb(:artist_created)
  end

  get "/artists/new" do
    return erb(:new_artist)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    artist = repo.find(params[:id])

    @artist_name = artist.name
    @artist_genre = artist.genre

    return erb(:artist)
  end
end