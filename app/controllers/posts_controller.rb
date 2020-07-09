class PostsController < ApplicationController

    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:index, :show]
    before_action :require_same_user, only: [:edit, :update, :destroy]

    def index
        @posts = Post.paginate(page: params[:page], per_page: 3)
    end

    def show    
    end

    def new 
    	@post = Post.new
    end

    def create
         # render plain: params[:post].inspect
         @post = Post.new(post_params)
         @post.user = current_user  

         if(@post.save)
           flash[:notice] = "Post was created successfully"
           redirect_to @post
         else
           render 'new'
         end
    end

    def edit 
    end

    def update
    	if(@post.update(post_params))  
            flash[:notice] = "Post was updated successfully."
    		redirect_to @post
    	else
    		render 'edit'
    	end
    end

    def destroy
    	@post.destroy
 
    	redirect_to posts_path
    end

    private 

    def set_post
       @post = Post.find(params[:id])
    end

    def post_params
    	params.require(:post).permit(:title,:body)
    end

    def require_same_user
        if current_user != @post.user
        flash[:notice] = "You can edit or delete you own article"
        redirect_to @post
    end

   end

end