class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
private
  def api
    @API ||= Radiator::Api.new
  end
  
  def account_name
    ENV.fetch("ACCOUNT_NAME")
  end
  
  def broadcast_options
    {
      url: 'https://steemd.steemit.com',
      wif: ENV.fetch("POSTING_WIF")
    }.dup
  end
  
  def comment_metadata
    {
      tags: ['steembin'],
      app: 'steembin/0.0.1'
    }
  end
end
