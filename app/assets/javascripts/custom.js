$(document).on('turbolinks:load', function(){
  $('.expand_comment_button').click(function() {
    $(this).closest(".post_footer").next(".comment_section").toggle();
  });
  $('input').filestyle({

  // button text
  'buttonText' : 'Choose file',

  // custom icon
  'iconName' : 'glyphicon glyphicon-folder-open',

  // CSS class of button
  'buttonName' : 'btn-default',

  // lg, nr, sm
  'size' : 'nr',

  // enables input
  'input' : true,

  // enables badge
  'badge' : true,

  // enable icon
  'icon' : true,

  // place button at the beginning of the input field
  'buttonBefore' : false,

  // disabled input field
  'disabled' : false,

  // custom placeholder
  'placeholder': ''

})


});



$(document).ready(function(){
    $("#hide").click(function(){
        $("p").hide();
    });
    $("#show").click(function(){
        $("p").show();
    });
});
