class SearchController < ApplicationController
  skip_authorization_check
  def index
    @results = ThinkingSphinx.search(params_search)
    p '::::::::::::::::::::::::::::'
    p Question.all
    p '::::::::::::::::::::::::::::'
    p '>>>>>>>>>>>>>>>>>>>>>>>'
    p @results
    p '>>>>>>>>>>>>>>>>>>>>>>>'
    render :index
    # if params_search.present?
    # end
  end

  private

  def params_search
    params.require('query')
  end
end
