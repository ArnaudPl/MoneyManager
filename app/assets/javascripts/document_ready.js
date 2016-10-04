$(document).ready(function() {
  window.materializeForm.init();
  $(".button-collapse").sideNav();
  //Hide alerts on click
  $('.alert').click(function(event) {
    $(this).hide(500);
  });
});
