class SearchesController < ApplicationController
  skip_authorization_check
  def index
    @results = Services::Search.call(params_search)
    redirect_to root_path unless @results
  end

  private

  def params_search
    params.permit(:scope, :query)
  end
end
