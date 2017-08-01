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
