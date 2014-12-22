// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var state

$(function (){
  //this happens on page load
  if ($('#game').length) {
    console.log("On a game page");
    poll(2000);
  } else if (($('#games').length)) {
    console.log("On the index page")
  } else {
    console.log("Not on a game page")
  }
});

var poll = function(timeout){
  var id = $('#game').attr('data-game-id');

  var promise = $.getJSON(Routes.game_path(id));
  
  promise.done(function(json) {
    if (state) {
      console.log("original: " + state);
      console.log("new: " + JSON.stringify(json.game));
      var compare = state.localeCompare(JSON.stringify(json.game));
      console.log("compared: " + compare);
      if (compare) {
        console.log("CHANGE!!")
        window.location.reload(true);
      }
    }

    state = JSON.stringify(json.game);
  });

  promise.always(function() {
    setTimeout(function() {
      poll(timeout)
    }, timeout);
  });
};