// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  if ($('#game-over').length) {
    Nonogram.removeSavedNonogram($('#game').data('game-id'));
    refreshPlayersAnswers(2000);
  }
});

var refreshPlayersAnswers = function(timeout) {
  $.ajax({
    type : 'GET',
    url : window.location.pathname + '/players',
    accepts: 'html',
    dataType: 'html',
    success : function(data){
      $('#other-players-attempts').html(data);
    },
    error : function(XMLHttpRequest, textStatus, errorThrown) {
      console.log(textStatus + ": " + errorThrown)
    }
  });
  
  if (! $('#all-answers-in').length) {
    setTimeout(function() {
      refreshPlayersAnswers(timeout);
    }, timeout);
  }
};