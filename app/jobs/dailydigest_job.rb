class DailydigestJob < ApplicationJob
  queue_as :default

  def perform
    Services::DailyDigest.new.send_digest
  end
end
