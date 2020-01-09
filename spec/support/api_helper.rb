module ApiHelper
  def json
    JSON.parse(response.body)
  end

  def do_method(method, api_path, options = {})
    send method, api_path, options
  end
end
