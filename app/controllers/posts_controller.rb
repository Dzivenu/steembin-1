class PostsController < ApplicationController
  def index
    @page = params[:page].presence || 1
    @posts = Sbds::Comment.where(author: account_name).order(timestamp: :asc)
    @posts = @posts.paginate(page: @page, per_page: 25)
  end
  
  def show
    @post = Post.find(params[:permlink])
    
    if @post.nil? || @post.body.empty?
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
      return
    end
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    
    tx = Radiator::Transaction.new(broadcast_options)
    tx.operations << {
      type: :comment,
      parent_author: '',
      parent_permlink: 'steembin',
      author: account_name,
      permlink: @post.permlink,
      title: @post.title || 'Untitled',
      body: @post.body,
      json_metadata: comment_metadata.to_json
    }
    
    response = tx.process(true)
    
    if !!response.error
      data = response.error.data
      flash[:error] = "#{data.message}: #{data.stack.first.format}"
      render :new
    else
      redirect_to @post
    end
  end
private
  def post_params
    attributes = [:title, :body]

    params.require(:post).permit *attributes
  end
end