class Services::Search
  def self.call(params_search)
    return if params_search[:query].empty?

    klass = params_search[:scope].constantize rescue return
    result = klass.search(ThinkingSphinx::Query.escape(params_search[:query]))
    return if result.is_a? ThinkingSphinx::NoIndicesError
    result
  end
end
