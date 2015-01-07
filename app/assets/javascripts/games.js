// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var gameId;
var gameState;
var paint;
var paintOverFilled;

$(function() {
  //this happens on page load
  if ($('#log-in').length) {
    localStorage.removeItem('savedGames');
  }

  if ($('#game').length) {
    gameId = $('#game').data('game-id');

    if ($('#game-play').length) {
      restoreFromSavedGames();
      pollGameChanges(2000);
    } else if ($('#game-lobby').length) {
      pollGameChanges(2000);
    } else {
      if (localStorage.savedGames != undefined) {
        var savedGames = JSON.parse(localStorage.savedGames);
        delete savedGames[gameId];

        localStorage.savedGames = JSON.stringify(savedGames);
      }

      refreshElement('#other-players-attempts', 2000, '#waiting-for-results');
    }
  }

  if (($('#games-list').length)) {
    refreshElement('#games-list', 5000, '#games-list');
  }

  if ($('#nonogram').length) {
    $('.game-cell').bind('contextmenu', function() { return false; }); 

    paint = '';
    updateSavedGames();

    $('.game-cell').mousedown(setPaint);
    $('.game-cell').mouseenter(selectTile);
    $('.game-cell').mouseleave(deselectTile);
    $(document).mouseup(clearPaintAndUpdate);
  }
});

var selectTile = function() {
  highlightRow(this, true);
  highlightColumn(this, true);
  paintTile(this);
};

var deselectTile = function() {
  highlightRow(this, false);
  highlightColumn(this, false);
};

var highlightRow = function(cell, highlight) {
  var row = $(cell).closest('tr');

  if (highlight) {
    row.addClass('highlight-clue');
  } else {
    row.removeClass('highlight-clue');
  }
}

var highlightColumn = function(cell, highlight) {
  var index = $(cell).index();

  var column = $(cell).closest('table')
      .find('tr th:nth-child(' + (index + 1) + ')');

  if (highlight) {
    column.addClass('highlight-clue');
  } else {
    column.removeClass('highlight-clue');
  }
}

var setPaint = function() {
  if ($(this).hasClass('filled')) {
    paintOverFilled = true;
  } 
  if (event.which == 1) {
    // left mouse button
    if ($(this).hasClass('filled')) {
      paint = 'blank';
    } else {
      paint = 'filled';
    }
    setTile(this, paint);
  } else if (event.which == 3) {
    // right mouse button
    if ($(this).hasClass('crossed')) {
      paint = 'blank';
    } else {
      paint = 'crossed';
    }
    setTile(this, paint);
  }
  return false;
};

var paintTile = function(cell) {
  if ($(cell).hasClass('filled') && !paintOverFilled) {
    return;
  }
  if (paint.length) {
    setTile(cell, paint)
  }
};

var setTile = function(tile, paint) {
  $(tile).removeClass('filled');
  $(tile).removeClass('blank');
  $(tile).removeClass('crossed');
  $(tile).addClass(paint);
}

var clearPaintAndUpdate = function() {
  paint = '';
  paintOverFilled = false;
  updateSavedGames();
};

var restoreFromSavedGames = function() {
  if (localStorage.savedGames != undefined) {
    var savedGames = JSON.parse(localStorage.savedGames);

    if (savedGames[gameId] != undefined) {
      setCells('filled', savedGames[gameId]['filled']);
      setCells('crossed', savedGames[gameId]['crossed']);
    }
  }
}

var setCells = function(cssClass, cellIds) {
  var cells = JSON.parse(cellIds);
  for(var i = 0; i < cells.length; i++) {
    var cellId = '#' + cells[i];
    setTile(cellId, cssClass);
  }
};

var updateSavedGames = function() {
  $('#cells').val(formatCellData('.filled'));

  var savedGames = JSON.parse(localStorage.savedGames || '{}');
  savedGames[gameId] = {
    filled: formatCellData('.filled'),
    crossed: formatCellData('.crossed'),
  };

  localStorage.savedGames = JSON.stringify(savedGames);
};

var formatCellData = function(id) {
  return JSON.stringify(cell_ids(id));
};

var cell_ids = function(id) {
  return $(id).toArray().map(function(cell) { return cell.id });
};

var click_tile = function() {
  if ($(this).hasClass('filled')) {
    $(this).removeClass('filled');
    $(this).addClass('blank');
  } else {
    $(this).removeClass('blank');
    $(this).removeClass('crossed');
    $(this).addClass('filled');
  }
};

var refreshGameOver = function(timeout){
  setTimeout(function() {
    location.reload();
  }, timeout);
};

var refreshElement = function(elementId, timeout, doWhileElementId) {
  if (! $(doWhileElementId).length) {
    return;
  }

  $.ajax({
    type : 'GET',
    url : '',
    accepts: 'script',
    dataType: 'html',
    success : function(data){
      $(elementId).html(data);
    },
    error : function(XMLHttpRequest, textStatus, errorThrown) {
      console.log(textStatus + ": " + errorThrown)
    }
  });

  setTimeout(function() {
    refreshElement(elementId, timeout, doWhileElementId);
  }, timeout);
};

var pollGameChanges = function(timeout){
  var promise = $.getJSON("");
  
  promise.done(function(json) {
    if (gameState) {
      if ($('#game-play').length) {
        if (json['game']['completed']) {
          updateSavedGames();
          $('#player-answer').submit();
        }
      } else if ($('#game-lobby').length) {
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