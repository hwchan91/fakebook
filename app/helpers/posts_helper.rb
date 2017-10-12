module PostsHelper
    def like_sentence(user, post, friend_ids = nil)
        common_ids = friend_ids & post.liked_user_ids 
        common_ids_index = common_ids.map{|id| post.liked_user_ids.rindex(id)}
        names = post.liked_names
    
        arr = [] 
        arr << "You" if post.liked_user_ids.include?(user.id) 
        arr << names[common_ids_index[0]] if common_ids_index[0] 
        arr << names[common_ids_index[1]] if common_ids_index[1] 
    
        others_count = post.liked_user_ids.count - arr.count 
        arr << others_count.to_s + " " + "other".pluralize(others_count) if others_count > 0
        (arr.count > 1) ? (arr.first(arr.size - 1).join(", ") + " and " + arr[-1]) : arr[0].to_s
    end
end
