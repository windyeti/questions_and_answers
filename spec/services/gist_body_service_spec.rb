require 'rails_helper'

RSpec.describe GistBodyService, type: :service do
  describe 'GET #body' do
    it 'GistBodyService with valid url' do
      expect(GistBodyService.new('https://gist.github.com/windyeti/6ea00464eb9592b10581097dc2b6c755').body).to eq 'gistfile1.txt : Simple text for test'
    end

    it 'GistBodyService with invalid url' do
      expect(GistBodyService.new('https://google.com').body).to be_falsey
    end
  end

end
