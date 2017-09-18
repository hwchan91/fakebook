$(document).on('turbolinks:load', function(){
  $('.expand_comment_button').click(function() {
    $(this).closest(".post_footer").next(".comment_section").toggle();
  });

});

$(document).ready(function(){
  $('.expand_comment_button').click(function() {
    $(this).closest(".post_footer").next(".comment_section").toggle();
  });

});

$(document).ready(function(){
    $("#hide").click(function(){
        $("p").hide();
    });
    $("#show").click(function(){
        $("p").show();
    });
});

$(document).ready(function(){
  $('.expand_comment_button').on('click', btnFunc);

  function btnFunc(e) {
    var post_id = $(e.target).parents('.expand_comment_button').data("id")
    var data = {post_id: post_id};
    $.get("/get_comments", data); 
    $(e.target).parents('.expand_comment_button').off('click', btnFunc);
  }
});