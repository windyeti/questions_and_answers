class UrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors.add attribute, "#{value} is invalid URL" unless url_valid?(value)
  end

  def url_valid?(value)
    begin
      url = URI::parse(value)
      url.kind_of?(URl::HTTP) || url.kind_of?(URl::HTTPS)
    rescue
      false
    end
  end
end
