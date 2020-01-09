shared_examples_for 'Returns successful' do
  it 'returns status 2..' do
    expect(response).to be_successful
  end
end

shared_examples_for 'Returns forbidden' do
  it do
    expect(response).to have_http_status(:forbidden)
  end
end

shared_examples_for 'Returns array' do
  it 'returns array' do
    expect(resource_response.size).to eq size_array
  end
end

shared_examples_for 'Returns fields' do
  it 'returns fields' do
    fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples_for 'Create resource' do
  it do
    expect do
      do_method(method, api_path, params: params, headers: headers)
    end.to change(model_resource, :count).by(1)
  end
end

shared_examples_for 'Deletes resource' do
  it do
    expect do
      do_method(method, api_path, params: params, headers: headers)
    end.to change(model_resource, :count).by(-1)
  end
end

shared_examples_for 'Does not create resource' do
  it do
    expect do
      do_method(method, api_path, params: params, headers: headers)
    end.to_not change(model_resource, :count)
  end
end

shared_examples_for 'Update resource' do
  it do
    expect(response).to have_http_status(:forbidden)
  end
end

shared_examples_for 'Updates resource' do
  it do
    do_method(method, api_path, params: params, headers: headers)
    resource.reload
    expect(resource.send(attr)).to eq new_value
  end
end

shared_examples_for 'Does not updates resource' do
  it do
    do_method(method, api_path, params: params, headers: headers)
    resource.reload
    expect(resource.send(attr)).to eq old_value
  end
end

shared_examples_for 'Returns status unauthorized' do
  it do
    expect(response).to have_http_status(:unauthorized)
  end
end

shared_examples_for 'Does not deletes resource' do
  it do
    expect do
      do_method(method, api_path, params: params, headers: headers)
    end.to_not change(model_resource, :count)
  end
end

