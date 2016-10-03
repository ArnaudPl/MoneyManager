$(document).ready(function() {
  window.materializeForm.init();
  $(".button-collapse").sideNav();
  //$('.alert').delay(6000).hide(400);
  $('.alert').click(function(event) {
    $(this).hide(500);
  });
});
