shared_examples_for 'Search' do
  describe 'Valid scope' do
    let(:params_search) { {scope: scope, query: query} }

    before do
      expect(Services::Search).to receive(:call).and_return(what_search)
      get :index, params: params_search
    end

    it 'assigns results' do
      expect(assigns(:results)).to eq what_search
    end

    it 'be successful' do
      expect(response).to be_successful
    end

    it 'render template index' do
      expect(response).to render_template :index
    end

    it 'data not from query' do
      other_data.each do |other_resource|
        expect(response).to_not have_content other_resource
      end
    end
  end
end
