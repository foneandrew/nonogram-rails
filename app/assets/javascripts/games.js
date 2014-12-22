// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function (){
  //this happens on page load
  if ($('#game').length > 0) {
    console.log("On a game page");
    setTimeout(thang, 2000);
  } else if (($('#games').length > 0)) {
    console.log("On the index page")
  } else {
    console.log("Not on a game page")
  }
});

function thang() {
  // window.alert("ummm...");
  var id = $('#game').attr('data-game-id');

  $.getJSON(Routes.game_path(id), function(json) {
    console.log(json);
  });
}