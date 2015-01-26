// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var gameState;

$(function() {
  if ($('#game-lobby').length || $('#game-play').length || $('#gave-up').length) {
    pollGameChanges(2000);
  }

  if (($('#games-list').length)) {
    
    refreshGamesList(5000);
  }

  DropDown.initEvents();

});

var refreshGamesList = function(timeout) {

  $.ajax({
    type : 'GET',
    url : '',
    accepts: 'script',
    dataType: 'html',
    success : function(data){
      $('#games-list').html(data);
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
  var promise = $.getJSON('');

  promise.done(function(json) {
    var gameString = JSON.stringify(JSON.stringify(json.game));

    if (gameState) {
      if ($('#game-lobby').length) {
        var compare = gameState.localeCompare(gameString);

        if (compare || json['game']['started']) {
          window.location.reload(true);
        }
      } else {
        if (json['game']['completed']) {
          if ($('#game-play').length) {
            Nonogram.saveForSubmission();
            $('#player-answer').submit();
          } else {
            window.location.reload(true);
          }
        }
      }
    }

    gameState = gameString;
  });

  promise.always(function() {
    setTimeout(function() {
      pollGameChanges(timeout);
    }, timeout);
  });
};
