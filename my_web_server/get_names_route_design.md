Get /names Route Design Recipe

1. Design the Route Signature
You'll need to include:

the HTTP method 
the path
any query parameters (passed in the URL)
or body parameters (passed in the request body)

Returning names

Method: get
Path: /names

Query parameters: String

2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return 200 OK if the post exists, but 404 Not Found if the post is not found in the database.

Your response might return plain text, JSON, or HTML code.

Replace the below with your own design. Think of all the different possible responses your route will return.


Expect response: "Julia, Mary, Karim"

3. Write Examples
Replace these with your own design.

# Request:

GET /names

# Expected response:

Response for 200 OK
"Julia, Mary, Karim"

4. Encode as Tests Examples
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /names" do
    it 'returns 200 OK' do
      response = get('/names')

      expect(response.status).to eq(200)
      expect(response.body).to eq("Julia, Mary, Karim")
    end
  end
end
5. Implement the Route
Write the route and web server code to implement the route behaviour.