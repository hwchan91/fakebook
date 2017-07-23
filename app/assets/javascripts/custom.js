$(idocument).ready(function() {
    $('.comment_textarea').keydown(function(event) {
        if (event.keyCode == 13) {
            this.form.submit();
            return false;
         }
    });
});

$(document).ready(function() {
    $('.comment_textarea').keydown(function(event) {
        if (event.keyCode == 13) {
            this.siblings('.post_button').submit();
            return false;
         }
    });
});
