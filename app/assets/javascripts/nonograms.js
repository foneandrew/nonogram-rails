// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  if ($('#nonogram').length) {
    console.debug('N: in nonogram');
    Nonogram.init($('#game').data('game-id'));

    UiListeners.hook();
  }
});

window.UiListeners = new function() {
  this.hook = function() {
    console.debug('N: binding mouse');

    bindMouseClick();
    bindMouseOver();
    
    disableContextMenu();
  };

  // PRIVATE

  var bindMouseClick = function() {
    $('.game-cell').mousedown(tileClicked);
    $(document).mouseup(function() { Nonogram.clearPaintAndUpdate(); });
  };

  var bindMouseOver = function() {
    $('.game-cell').mouseenter(function() { Nonogram.selectTile(this); });
    $('.game-cell').mouseleave(function() { Nonogram.deselectTile(this); });
  };

  var disableContextMenu = function() {
    $('.game-cell').bind('contextmenu', function() { return false; }); 
  };

  var tileClicked = function() {
    Nonogram.setPaint(event, this);
    return false;
  };
};

window.Nonogram = new function() {
  var paint;
  var paintOverFilled;
  var gameId;

  this.init = function(id) {
    console.debug('N: initialising Nonogram');
    gameId = id;
    paint = '';
    
    restoreNonogram();
    this.saveNonogram();
  };

  this.selectTile = function(tile) {
    console.debug('N: selecting tile');
    highlightRow(tile, true);
    highlightColumn(tile, true);
    paintTile(tile);
  };

  this.deselectTile = function(tile) {
    console.debug('N: deselecting tile');
    highlightRow(tile, false);
    highlightColumn(tile, false);
  };

  this.setPaint = function(mouseEvent, tile) {
    console.debug('N: setting paint');
    if ($(tile).hasClass('filled')) {
      paintOverFilled = true;
    } 
    if (mouseEvent.which == 1) {
      // left mouse button
      if ($(tile).hasClass('filled')) {
        paint = 'blank';
      } else {
        paint = 'filled';
      }
      setTile(tile, paint);
    } else if (mouseEvent.which == 3) {
      // right mouse button
      if ($(tile).hasClass('crossed')) {
        paint = 'blank';
      } else {
        paint = 'crossed';
      }
      setTile(tile, paint);
    }
    return false;
  };

  this.clearPaintAndUpdate = function() {
    paint = '';
    paintOverFilled = false;
    this.saveForSubmission();
    this.saveNonogram();
  };

  this.saveNonogram = function() {
    if (gameId != undefined) {
      console.debug('N: savig nonogram');
      var savedGames = JSON.parse(localStorage.savedGames || '{}');
      savedGames[gameId] = {
        filled: formatCellData('.filled'),
        crossed: formatCellData('.crossed'),
      };

      localStorage.savedGames = JSON.stringify(savedGames);
    }
  };

  this.removeSavedNonogram = function(id) {
    console.debug('N: deleting nonogram');
    if (localStorage.savedGames != undefined) {
      var savedGames = JSON.parse(localStorage.savedGames);
      delete savedGames[id];

      localStorage.savedGames = JSON.stringify(savedGames);
    }
  };

  this.saveForSubmission = function() {
    console.debug('N: preparing data for submission');
    $('#cells').val(formatCellData('.filled'));
  };

  // PRIVATE

  var setTile = function(tile, paint) {
    $(tile).removeClass('filled');
    $(tile).removeClass('blank');
    $(tile).removeClass('crossed');
    $(tile).addClass(paint);
  };


  var paintTile = function(cell) {
    console.debug('N: painting tile');
    if ($(cell).hasClass('filled') && !paintOverFilled) {
      return;
    }
    if (paint.length) {
      setTile(cell, paint)
    }
  };

  var highlightRow = function(cell, highlight) {
    var row = $(cell).closest('tr');

    if (highlight) {
      row.addClass('highlight-clue');
    } else {
      row.removeClass('highlight-clue');
    }
  };

  var highlightColumn = function(cell, highlight) {
    var index = $(cell).index();

    var column = $(cell).closest('table')
        .find('tr th:nth-child(' + (index + 1) + ')');

    if (highlight) {
      column.addClass('highlight-clue');
    } else {
      column.removeClass('highlight-clue');
    }
  };

  var restoreNonogram = function() {
    if (localStorage.savedGames != undefined && gameId != undefined) {
      console.debug('N: restoring a nonogram from storage');
      var savedGames = JSON.parse(localStorage.savedGames);

      if (savedGames[gameId] != undefined) {
        setCells('filled', savedGames[gameId]['filled']);
        setCells('crossed', savedGames[gameId]['crossed']);
      }
    }
  };

  var setCells = function(cssClass, cellIds) {
    var cells = JSON.parse(cellIds);

    for(var i = 0; i < cells.length; i++) {
      var cellId = '#' + cells[i];
      setTile(cellId, cssClass);
    }
  };

  var formatCellData = function(id) {
    return JSON.stringify(cell_ids(id));
  };

  var cell_ids = function(id) {
    return $(id).toArray().map(function(cell) { return cell.id });
  };
};