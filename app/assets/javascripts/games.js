// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var game_state

$(function (){
  //this happens on page load
  if ($('#game').length) {
    poll(2000);
  } else if (($('#games').length)) {
    refreshGamesList(5000);
  }
});

var refreshGamesList = function(timeout){
  // this works!!
  // $.get("games.js",function(data){
  //   $("#games_list").html(data);
  // });

  $.ajax({
    type : 'GET',
    url : '',
    accepts: 'script',
    dataType: 'html',
    success : function(data){
      $('#games_list').html(data);
    },
    error : function(XMLHttpRequest, textStatus, errorThrown) {
      console.log(textStatus + ": " + errorThrown)
    }
  });

  setTimeout(function() {
    refreshGamesList(timeout);
  }, timeout);
};

var poll = function(timeout){
  var promise = $.getJSON("");
  
  promise.done(function(json) {
    if (game_state) {
      var compare = game_state.game.status.localeCompare(json.game.status);

      if (compare) {
        if ($('#player_answer').length) {
          $('#player_answer').submit();
        } else {
          window.location.reload(true);
        }
      }
    }

    game_state = json;
  });

  promise.always(function() {
    setTimeout(function() {
      poll(timeout);
    }, timeout);
  });
};