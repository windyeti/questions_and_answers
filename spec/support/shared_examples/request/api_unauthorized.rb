shared_examples_for 'API Unauthorizable' do
  it 'returns 401 if there is no token' do
    do_method(method, api_path, headers: headers )
    expect(response.status).to eq 401
  end

  it 'returns 401 if there is token invalid' do
    do_method(method, api_path, params: { access_token: '1234' }, headers: headers )
    expect(response.status).to eq 401
  end
end
