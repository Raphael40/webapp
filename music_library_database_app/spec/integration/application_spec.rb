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

      expected_response = "<div>Title: Doolittle Released: 1989</div>"
      expected_response_2 = "<div>Title: Surfer Rosa Released: 1988</div>"

      expect(response.status).to eq(200)
      expect(response.body).to include(expected_response)
      expect(response.body).to include(expected_response_2)

    end

    it 'returns a list of albums' do
      response = get('/albums')

      expected_response = "<div>Title: Here Comes the Sun Released: 1971</div>"

      expect(response.status).to eq(200)
      expect(response.body).to include(expected_response)
      
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
      expect(response.body).to eq('')

      response = get('/albums')
      expect(response.body).to include('Voyage')
    end
  end

  context "GET /artists" do
    it 'returns a list of artists' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone')

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


end
