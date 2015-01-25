// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  if ($('#nonogram').length) {
    setColor($('#color').data('color'));
    Nonogram.init($('#game').data('game-id'), parseInt($('#nonogram').data('size')));

    UiListeners.hook();
  }

  if ($('#nonogram-display').length) {
    setColor($('#color').data('color'));
  }
});

var setColor = function(color) {
  jss.set('.filled', { 'background-color': color });
};

window.UiListeners = new function() {
  this.hook = function() {
    bindGiveUpButton();

    bindMouseClickTile();
    bindMouseOverTile();

    bindMouseClickColorCircle();
    
    disableContextMenu();
  };

  // PRIVATE

  var bindMouseClickColorCircle = function() {
    $('.color-circle').click(colorClicked);
  };

  var bindGiveUpButton = function() {
    $('#give-up').click(giveUp);
  };

  var bindMouseClickTile = function() {
    $('.game-cell').mousedown(tileClicked);
    $(document).mouseup(function() { Nonogram.clearPaintAndUpdate(); });
  };

  var bindMouseOverTile = function() {
    $('.game-cell').mouseenter(function() { Nonogram.selectTile(this); });
    $('.game-cell').mouseleave(function() { Nonogram.deselectTile(this); });
  };

  var disableContextMenu = function() {
    $('.game-cell').bind('contextmenu', function() { return false; }); 
  };

  var giveUp = function() {
    if (confirm('Are you sure you want to give up?')) {
      $('#type').val('giveup');
      Nonogram.saveForSubmission();
      $('#player-answer').submit();
    }
  };

  var tileClicked = function(event) {
    Nonogram.setPaint(event, this);
    return false;
  };

  var colorClicked = function() {
    var color = $(this).data('color')
    $('#setColor').val(color);
    setColor(color);
  };
};

window.Nonogram = new function() {
  var paint;
  var paintOverFilled;
  var gameId;
  var size;

  this.init = function(id, size_in) {
    gameId = id;
    size = size_in;
    paint = '';

    restoreNonogram();
    this.saveNonogram();
  };

  this.selectTile = function(tile) {
    highlightRow(tile, true);
    highlightColumn(tile, true);
    paintTile(tile);
  };

  this.deselectTile = function(tile) {
    highlightRow(tile, false);
    highlightColumn(tile, false);
  };

  this.setPaint = function(mouseEvent, tile) {
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
    updateClues();
  };

  this.saveNonogram = function() {
    if (gameId != undefined) {
      var savedGames = JSON.parse(localStorage.savedGames || '{}');
      savedGames[gameId] = {
        filled: formatCellData('.filled'),
        crossed: formatCellData('.crossed'),
      };

      localStorage.savedGames = JSON.stringify(savedGames);
    }
  };

  this.removeSavedNonogram = function(id) {
    if (localStorage.savedGames != undefined) {
      var savedGames = JSON.parse(localStorage.savedGames);
      delete savedGames[id];

      localStorage.savedGames = JSON.stringify(savedGames);
    }
  };

  this.saveForSubmission = function() {
    $('#cells').val(formatCellData('.filled'));
  };

  // PRIVATE

  var updateClues = function() {
    $('th').removeClass('completed-clue');

    console.log('going to update clues')

    // solveClues(getRow(0));
    // solveClues(getCol(0));

    for (i = 0; i < size; i++) {
      solveClues(getRow(i));
      solveClues(getCol(i));
    }
  };

  var solveClues = function(line) {
    var index = 0;
    var currentRun = 0;

    console.log('going to solve line. clues: ')
    console.log(line.clues)
    console.log(line.clues.length)

    for (var i = 0; i < line.clues.length; i++) {
      var clueElement = line.clues[i];
      // $(clueElement).removeClass('completed-clue');
      console.log('removed class:')
      console.log($(clueElement))

      var clue = $(line.clues[i]).text();
      console.log('clue: ');
      console.log(clue);

      if (clue.length) {
        console.log('length is true')
      } else {
        console.log('length is false')
        console.log(clue.length)
      }

      if (clue.length) {
        var clueLength = parseInt(clue);
        console.log('clue actual: ');
        console.log(clueLength);
        currentRun = 0;

        console.log('about to attempt a run, index = ' + index + ', size = ' + size);

        for (var a = index; a < size; a++) {
          console.log('beginning run, a= ' + a);
          var cell = $(line.cells[index]);

          if (cell.hasClass('filled')) {
            console.log('found filled')
            //increment current run
            index++;
            currentRun++;
            console.log('index now ' + index + ', currentRun at ' + currentRun);
          } else if (cell.hasClass('crossed')) {
            console.log('found crossed')
            // check if solved a clue
            index++;
            if (currentRun == clueLength) {
              $(clueElement).addClass('completed-clue');
              console.log('finished clue')
              console.log(clueElement)
              console.log($(clueElement))
              currentRun = 0;
              break;
            }
            console.log('did not finish clue')
          } else {
            console.log('clue broke')
            // no clue solved abort
            return;
          }
        }

        // if length matches solve clue (at end of row)
        if (currentRun == clueLength) {
          $(clueElement).addClass('completed-clue');
          console.log('last chance filled clue')
          return;
        }
      }
    }
  };

  var getRow = function(index) {
    var row = $('#' + index + '-0').closest('tr');
    return {
      clues: row.find('th'),
      cells: row.find('td')
    };
  };

  var getCol = function(index) {
    var cell = $('#0-' + index);

    index = $(cell).index();

    var colTh = $(cell).closest('table')
      .find('tr th:nth-child(' + (index + 1) + ')')
    var colTd = $(cell).closest('table')
      .find('tr td:nth-child(' + (index + 1) + ')');

    return {
      clues: colTh,
      cells: colTd
    };
  };

  var setTile = function(tile, paint) {
    $(tile).removeClass('filled');
    $(tile).removeClass('blank');
    $(tile).removeClass('crossed');
    $(tile).addClass(paint);
  };

  var paintTile = function(cell) {
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
      var savedGames = JSON.parse(localStorage.savedGames);

      if (savedGames[gameId] != undefined) {
        setCells('filled', savedGames[gameId]['filled']);
        setCells('crossed', savedGames[gameId]['crossed']);
      }
    }
    updateClues();
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