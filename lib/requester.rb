require 'httparty'
class Requester
  BASE_URL = 'http://node.locomote.com/code-task/'
  def initialize(api_method:, params: {})
    @api_method = api_method
    @params = params
    request
  end

  def body
    @response.body
  end

  def parsed_body
    JSON.parse body
  end

  private

  def request
    @response ||= HTTParty.get(request_url, @params)
  end

  def request_url
    %(#{BASE_URL}#{@api_method})
  end

end
