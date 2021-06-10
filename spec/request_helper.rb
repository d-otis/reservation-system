module RequestHelper
  def response_body
    JSON.parse(response.body)
  end

  def admin_header
    {
      "Authorization" => "Bearer #{admin_valid_token}"
    }
  end

  def non_admin_header
    {
      "Authorization" => "Bearer #{non_admin_valid_token}"
    }
  end
end