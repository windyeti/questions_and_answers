class Services::Search
  def self.call(params_search)
    klass = params_search[:scope].constantize rescue return
    klass.search(ThinkingSphinx::Query.escape(params_search[:query]))
  end
end
