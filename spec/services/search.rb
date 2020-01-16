require 'rails_helper'

RSpec.describe Services::Search, type: :service do
  scopes = %w(User Question Answer Comment ThinkingSphinx)
  query = 'My query'
  scopes.each do |scope|
    search_model = scope.constantize
      it do
        expect(search_model).to receive(:search).with(query)
        Services::Search.call({query: query, scope: scope})
      end
  end
end
