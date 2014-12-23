window.Loaders = (function(module) {
  module.loadGame = function(gameID) {
    return $.getJSON(Routes.game_path(gameID));
  };

  module.loadGames = function() {
    return $.getJSON(Routes.games_path);
  };
})({});