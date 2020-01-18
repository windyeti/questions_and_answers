require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it do
    should allow_values('http://dfg.com', 'https://search.df34CVg.RU').for(:url)
    should_not allow_values('http/dfg.com', 'df34CVg.RU').for(:url)
  end

  describe 'Link' do
    let(:question) { create(:question) }

    context 'to gist' do
      let(:link) { create(:link, linkable: question, url: 'https://gist.github.com/windyeti/6ea00464eb9592b10581097dc2b6c755') }
      it do
        expect(link.gist?).to be_truthy
      end
    end

    context 'to not gist' do
      let(:link) { create(:link, linkable: question, url: 'https://google.ru') }
      it do
        expect(link.gist?).to be_falsey
      end
    end
  end
end
