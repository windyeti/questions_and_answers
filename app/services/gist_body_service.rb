class GistBodyService
  def initialize(gist_url, client: default_client)
    @gist_url = gist_url
    @client = default_client
  end

  def body
    response = call
    return false unless response

    body = response[:files].map do |key, value|
      "#{key} : #{value[:content]}"
    end
    pp body.join('\n')
  end

  private

  def default_client
    Octokit::Client.new
  end

  def call
    @client.gist(id_gist) rescue false
  end

  def id_gist
    @gist_url.split('/').last
  end
end
