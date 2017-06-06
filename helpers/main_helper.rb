module MainHelper
  def search_params_present?
    !params["from"].empty? && !params["to"].empty? && !params["date"].empty?
  end

  def missing_params_error_messages
    %w(from to date).each_with_object([]) do |param_key, array|
      array << "'#{param_key.upcase}' parameter is missing" if params[param_key].empty?
    end
  end
end
