require 'digest/bubblebabble'

class Post
  include ActiveModel::Model
  DIGEST_SALT = 'df5f858ad0f022fc5f17c53dcc01ea1c'.freeze
  
  attr_accessor :permlink, :title, :body
  
  def self.find(permlink)
    response = Radiator::Api.new.get_content(APP_CONFIG[:account_name], permlink )
    
    Post.new(response.result)
  end
  
  def initialize(options = nil)
    return if options.nil?
    
    @permlink = options[:permlink]
    @title = options[:title]
    @body = options[:body]
  end
  
  def permlink
    @permlink ||= Digest.bubblebabble(Digest::SHA1::hexdigest(Time.now.to_f.to_s + DIGEST_SALT)).split('-').first
  end
  
  def to_param
    permlink
  end
end
