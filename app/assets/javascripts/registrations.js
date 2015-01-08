// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  if ($('#log-in').length) {
    console.debug('R: removing all saved games');
    localStorage.removeItem('savedGames');
  }
});