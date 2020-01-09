shared_examples_for "Returns resource with ..." do
  it "" do
    expect(resource_response.size).to eq resource.size
  end
end
