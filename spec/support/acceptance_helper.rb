module AcceptanceHelper
  def wait_ajax
    Capybara.default_max_wait_time = 5
  end
end
