class CustomRelation
    def initialize(user, page, last_id)  #default values cannot be set here because the argument is not nothing but 'nil'
      @user = user
      page = page || 1
      @page = page.to_i
      @limit = 20
      @last_id = last_id || 99999
    end
  
    def current_page
      @page
    end
  
    def total_pages
      #total = Post.where("user_id IN (?) OR user_id = ?", @user.friend_ids, @user.id ).count
      total = @posts.length #reduces 1 call to db by having @posts stored
      (total.to_f / @limit).ceil
    end
  
    def limit_value
      @limit
    end

    def next_page
        @page < total_pages
    end
  
    def per_page
        #offset = (@page - 1) * @limit
        @posts ||= Post.includes(:user, :liked_users, :post_attachments)
        .where("user_id IN (?) OR user_id = ?", @user.friend_ids, @user.id)
        .where("posts.id < ?", @last_id).order(created_at: :desc).limit(@limit)
       
    end
  
  
  end
