$(document).on('turbolinks:load', function(){
//$(document).ready(function(){
  if ($('.bootstrap-filestyle').length == 0) {
    init_filestyle();
  }
  
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
    $(this).closest(".post_footer").next(".comment_section").toggle();
  });


  $('.expand_comment_button').click(btnFunc);

  function btnFunc(e) {
    var post_id = $(e.target).parents('.expand_comment_button').data("id")
    var data = {post_id: post_id};
    $.get("/get_comments", data); 
    $(e.target).parents('.expand_comment_button').off('click', btnFunc);
  }



   if ($('.pagination').length) {
    $(window).scroll(function() {
      //var url = $('.pagination .next_page').attr('href')
      var last_id = $('.post').last().attr('id').match(/[0-9]+/)
      var url = $('.pagination a[rel=next]').attr('href')
      //console.log("last id", url)
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 1500) {
        $('.pagination').text("Loading...")
        $.getScript(url  + '&last_id=' + last_id)
      };
    });
    $(window).scroll()
  }



});