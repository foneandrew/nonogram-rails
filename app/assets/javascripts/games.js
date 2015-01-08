// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var gameState;

$(function() {
  if ($('#game-lobby').length || $('#game-play').length) {
    pollGameChanges(2000);
    console.debug('G: will poll lobby changes');
  }

  if (($('#games-list').length)) {
    console.debug('G: will refresh the games list');
    refreshGamesList(5000);
  }
});

var refreshGamesList = function(timeout) {
  console.debug('G: about to refresh games list');

  $.ajax({
    type : 'GET',
    url : '',
    accepts: 'script',
    dataType: 'html',
    success : function(data){
      $('#games-list').html(data);
      console.debug('G: refreshed games-list');
    },
    error : function(XMLHttpRequest, textStatus, errorThrown) {
      console.log(textStatus + ": " + errorThrown)
    }
  });
  
  setTimeout(function() {
    refreshGamesList(timeout);
  }, timeout);
};

var pollGameChanges = function(timeout){
  console.debug('G: about to poll game changes');
  var promise = $.getJSON('');
  
  promise.done(function(json) {
    if (gameState) {
      if ($('#game-play').length) {
        console.debug('G: in game play');
        if (json['game']['completed']) {
          console.debug('G: submitting game');
          Nonogram.saveForSubmission();
          $('#player-answer').submit();
        }
      } else if ($('#game-lobby').length) {
        console.debug('G: in game lobby');
        // this is somewhat redundant, but will fix those cases where the game is started between the page reloading and the first JSON pull
        var compare = gameState.game.status.localeCompare(json.game.status);

        if (compare || json['game']['started']) {
          window.location.reload(true);
        }
      }
    }

    gameState = json;
  });

  promise.always(function() {
    setTimeout(function() {
      pollGameChanges(timeout);
    }, timeout);
  });
};