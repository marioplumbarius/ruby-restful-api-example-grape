shared_examples_for :api_endpoint_with_id_requirements do |http_method, body|
  context 'when the :id does not match the requirements' do
    let(:id) { Faker::Name.first_name.downcase }
    let(:uri) { url.dup.concat "/#{id}" }

    it 'returns text/html content-type' do
      response = HttpExecutorHelper.execute_request http_method, uri, body

      expect(response[:last_response].content_type).to eq 'text/html'
    end

    it 'returns 404 status code' do
      response = HttpExecutorHelper.execute_request http_method, uri, body

      expect(response[:last_response].status).to eq 404
    end

    it 'returns Not Found body' do
      response = HttpExecutorHelper.execute_request http_method, uri, body

      expect(response[:last_response].body).to eq 'Not Found'
    end
  end
end

shared_examples_for :api_with_basic_authentication do
  it 'authenticates the user' do
    expect(Developers::API).to receive(:credentials_valid?)
  end
end
