class GistBodyService
  def initialize(gist_url, client: default_client)
    @gist_url = gist_url
    @client = default_client
  end

  def default_client
    Octokit::Client.new
  end

  def call
    @client.gist(id_gist)
  end

  def id_gist
    @gist_url.split('/').last
  end

  def body
    response = call
    body = response[:files].map do |key, value|
      "#{key} : #{value[:content]}"
    end
    pp body.join('\n')
  end
end
