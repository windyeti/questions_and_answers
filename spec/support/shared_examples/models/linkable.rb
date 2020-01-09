shared_examples_for 'Linkable' do
    it { should have_many(:links).dependent(:destroy) }
end
