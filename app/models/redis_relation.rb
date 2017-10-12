class RedisRelation
    def initialize(page, last_id)
      page = page || 1
      @page = page.to_i
      @limit = 20
      @last_id = last_id
    end
  
    def current_page
      @page
    end
  
    def total_pages
      total = $redis.zcard("newest_posts")
      (total.to_f / @limit).ceil
    end
  
    def limit_value
      @limit
    end

    def next_page
        @page < total_pages
    end
  
    def per_page
      offset = (@page - 1) * @limit
      if @last_id
        undisplayed =  $redis.zrevrangebyscore("newest_posts", "(#{@last_id}", "0")
        undisplayed[0..@limit-1]
      else
        $redis.zrevrange("newest_posts", "#{offset}", "#{@limit * @page -1}")
      end
    end
  
  
end