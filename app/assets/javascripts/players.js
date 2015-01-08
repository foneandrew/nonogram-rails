// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  if ($('#game-over').length) {
    console.debug('P: in game over');
    Nonogram.removeSavedNonogram($('#game').data('game-id'));
    refreshPlayersAnswers(2000);
  }
});

var refreshPlayersAnswers = function(timeout) {
  console.debug('P: about to refresh players answers');
  $.ajax({
    type : 'GET',
    url : window.location.pathname + '/players',
    accepts: 'html',
    dataType: 'html',
    success : function(data){
      $('#other-players-attempts').html(data);
      console.debug('P: refreshed PlayersAnswers');
    },
    error : function(XMLHttpRequest, textStatus, errorThrown) {
      console.debug('P: aw damn it fucked up');
      console.log(textStatus + ": " + errorThrown)
    }
  });
  
  if (! $('#all-answers-in').length) {
    console.debug('P: allowed to set up for another refresh');
    setTimeout(function() {
      refreshPlayersAnswers(timeout);
    }, timeout);
  }
};