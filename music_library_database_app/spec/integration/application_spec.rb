require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do 
    reset_albums_table
  end

  before(:each) do 
    reset_artists_table
  end

  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /albums" do
    it 'returns a list of albums' do
      response = get('/albums')

      expected_response_0 = '<a href="/albums/1">Title: Doolittle Released: 1989</a>'
      expected_response_1 = '<a href="/albums/2">Title: Surfer Rosa Released: 1988</a>'
      expected_response_10 = '<a href="/albums/10">Title: Here Comes the Sun Released: 1971</a>'

      expect(response.status).to eq(200)
      expect(response.body).to include(expected_response_0)
      expect(response.body).to include(expected_response_1)
      expect(response.body).to include(expected_response_10)

    end
  end

  context "POST /albums" do
    it 'returns 200 OK' do
      response = post(
        '/albums',
        title:'Voyage',
        release_year:"2022",
        artist_id:"2"
      )
      
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Voyage has been added</h1>')

      get_albums = get('/albums')

      expect(get_albums.body).to include('Voyage')
    end
  end

  context 'GET /albums/:id' do
    it 'returns the data of a single album formatted in html' do
      response = get('/albums/1')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>Doolittle</h1>')
      expect(response.body).to include ('Release year: 1989')
      expect(response.body).to include ('Artist: Pixies')      
    end
  end

  context "GET /artists" do
    it 'returns a list of artists' do
      response = get('/artists')

      expected_response_0 = '<a href="/artists/1">Artist: Pixies Genre: Rock</a>'
      expected_response_1 = '<a href="/artists/2">Artist: ABBA Genre: Pop</a>'
      expected_response_2 = '<a href="/artists/3">Artist: Taylor Swift Genre: Pop</a>'

      expect(response.status).to eq(200)
      expect(response.body).to include(expected_response_0)
      expect(response.body).to include(expected_response_1)
      expect(response.body).to include(expected_response_2)
    end
  end

  context "POST /artists" do
    it 'returns 200 OK' do
      response = post(
        '/artists',
        name:'Wild Nothing',
        genre:'Indie'
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to include('Wild Nothing')
    end
  end

  context 'GET /artists/:id' do
    it 'returns the data of a single album formatted in html' do
      response = get('/artists/1')
      expect(response.status).to eq (200)
      expect(response.body).to include ('Pixies')
      expect(response.body).to include ('Genre: Rock')
    end
  end

    context 'GET /albums/new' do
      it 'returns a form page' do
        response = get("/albums/new")

        expect(response.status).to eq(200)
        expect(response.body).to include('<form method="POST" action="/albums">')
        expect(response.body).to include('<input type="text" name="title" />')
        expect(response.body).to include('<input type="text" name="release_year" />')
        expect(response.body).to include('<input type="text" name="artist_id" />')
      end
    end
end
