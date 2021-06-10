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

  def invalid_header
    {
      "Authorization" => "Bearer #{invalid_token}"
    }
  end

  def random_user_header
    # random => could be admin or not
    {
      "Authorization" => "Bearer #{random_user_token}"
    }
  end
end