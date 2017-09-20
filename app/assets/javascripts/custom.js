$(document).on('turbolinks:load', function(){
//$(document).ready(function(){
  init_filestyle();
  
  function init_filestyle() {
    $(":file.filestyle").filestyle({
      input: false,
      buttonText: "Add Photos",
      buttonName: "btn btn-primary",
      buttonBefore: true,
      iconName: 'glyphicon glyphicon-folder-open'
    });
  };

  $('.expand_comment_button').click(function(e) {
    btnFunc(e);
    $(this).closest(".post_footer").next(".comment_section").toggle();
  });

  function btnFunc(e) {
    var post_id = $(e.target).parents('.expand_comment_button').data("id")
    var data = {post_id: post_id};
    $.get("/get_comments", data); 
    $(e.target).parents('.expand_comment_button').off('click', btnFunc);
  }

  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href')
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 100) {
        $('.pagination').text("Loading...")
        $.getScript(url)
      };
    });
    $(window).scroll()
  }
  

});