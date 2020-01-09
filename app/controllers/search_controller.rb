class SearchController < ApplicationController
  skip_authorization_check
  def index
    @results = ThinkingSphinx.search(params_search)
  end

  private

  def params_search
    params.require('query')
  end
end
