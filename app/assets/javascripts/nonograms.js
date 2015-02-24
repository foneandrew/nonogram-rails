// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  if ($('#nonogram').length) {
    setColor($('#color').data('color'));

    Clues.init(parseInt($('#nonogram').data('size')));
    Nonogram.init($('#game').data('game-id'));

    UiListeners.hook();

    ImageImporter.init();
  }

  if ($('#nonogram-display').length) {
    setColor($('#color').data('color'));
  }
});

window.ImageImporter = new function() {
  var image = new Image();


  this.init = function() {
    document.getElementById('file').addEventListener('change', handleFileSelect, false);
    canvas.width = 20;
    canvas.height = 20;

    var thresholdElem = document.getElementById('threshold-range');

    thresholdElem.onchange = function() {
      ImageImporter.thresholdImageAndUpdate(false);
    }

    image.onload = function() {
      ImageImporter.thresholdImageAndUpdate(true);
    }
  };

  this.thresholdImageAndUpdate = function(autoThreshold) {
    var thresholdElem = document.getElementById("threshold-range");
    var context = canvas.getContext("2d");
    var imageWidth, imageHeight;
    var imageRatio = image.width / image.height;

    if (imageRatio < 1) {
      imageWidth  = 20 * imageRatio;
      imageHeight = 20;
    }
    else if (imageRatio > 1) {
      imageWidth  = 20;
      imageHeight = 20 / imageRatio;
    }
    else {
      imageWidth  = 20;
      imageHeight = 20;
    }

    imageWidth = Math.round(imageWidth);
    imageHeight = Math.round(imageHeight);

    // canvas.width  = imageWidth * 10;
    // canvas.height = imageHeight * 10;
    canvas.style.width  = (imageWidth  * 5) + "px";
    canvas.style.height = (imageHeight * 5) + "px";

    var xCenterFactor = Math.floor((20 - imageWidth)  / 2);
    var yCenterFactor = Math.floor((20 - imageHeight) / 2);

    console.log("xCenterFactor:", xCenterFactor);
    console.log("yCenterFactor:", yCenterFactor);

     // TODO: Draw size should respect aspect ratio.
    context.drawImage(image, 0, 0, imageWidth, imageHeight);

    var imageData = context.getImageData(0, 0, 20, 20);

    var cells = [];

    if (autoThreshold) {
      var lums = [];
      for(var x = 0; x < 20; x++) {
        for(var y = 0; y < 20; y++) {
          var pixel = ((x * 20) + y) * 4;

          var r = imageData.data[pixel  ] / 255;
          var g = imageData.data[pixel+1] / 255;
          var b = imageData.data[pixel+2] / 255;

          var lum = (0.21 * r) + (0.72 * g) + (0.07 * b);
          lums.push(lum);
        }
      }

      lums.sort(function(a, b) {
        return a - b;
      });

      thresholdElem.value = lums[lums.length / 2];
    }

    for (var x = 0; x < 20; x++) {
      for (var y = 0; y < 20; y++) {
        var pixel = ((x * 20) + y) * 4

        var r = imageData.data[pixel  ] / 255;
        var g = imageData.data[pixel+1] / 255;
        var b = imageData.data[pixel+2] / 255;
        var a = imageData.data[pixel+3] / 255;

        var lum = (0.21 * r) + (0.72 * g) + (0.07 * b);

        if(x >= imageHeight || y >= imageWidth)
          lum = 1;

        if (lum <= thresholdElem.value) {
          var cell = (x + Math.floor(yCenterFactor)) + "-" + (y + Math.floor(xCenterFactor));
          cells.push(cell)
        }


      }
    }

    Nonogram.refreshFilledCells(cells)
  };

  // PRIVATE

  var handleFileSelect = function(evt) {
    console.log(evt)
    console.log(evt.target)
    console.log(evt.target.files[0])

    var reader = new FileReader();
    reader.onload = function(event){
      image.src = event.target.result;
    }
    reader.readAsDataURL(evt.target.files[0]);
  };
};

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

window.Clues = new function() {
  var onRun = 1;
  var success = 2;
  var fail = 3;

  var blank = 0;
  var crossed = 1;
  var filled = 2;

  var size;

  this.init = function(size_in) {
    size = size_in;
  };

  this.updateClues = function() {
    $('th').removeClass('completed-clue');
    $('th').removeClass('broken-clue');

    for (i = 0; i < size; i++) {
      solveClues(getRow(i));
      solveClues(getCol(i));
    }
  };

  var solveClues = function(line) {
    var cells = [].slice.call(line.cells, 0);
    var clues = [].slice.call(line.clues, 0);
    var currentRun = 0;
    var firstClueDone = false;
    var unmatchedCells = cells;
    var checkRemains = true;

    // check that there arent too many tiles
    var sumCells = cells.reduce(function(pv, cell) { if (cell == filled) { return pv + 1; } else { return pv; }}, 0);
    var sumClues = clues.reduce(function(pv, clue) { return pv + parseInt($(clue).text()); }, 0);


    if (sumCells > sumClues) {
      $(line.clues).addClass('broken-clue');
      return;
    }

    // SPECIAL CASE NO CLUE
    if (clues.length == 0) {
      return;
    }

    // NORMAL START FROM LEFT SIDE (IGNORE FINAL CLUE)
    solveLeft:
    while (clues.length >= 1) {
      var clue = clues.shift();
      var clueLength = parseInt($(clue).text());
      currentRun = 0;

      while (cells.length > 0) {
        var cell = cells.shift();

        result = solveClue(cell, currentRun, clueLength);

        if (result == onRun) {
          currentRun++;
          if (cells.length == 0 && currentRun == clueLength){
            $(clue).addClass('completed-clue');
            return;
          }
        } else if (result == success) {
          $(clue).addClass('completed-clue');
          //save for the right hand solver
          unmatchedCells = cells.slice();
          unmatchedCells.unshift(cell);
          break;
        } else if (result == fail) {
          if (cell == blank) {
            //dont want to restore the first clue as it should always be attatched to the left side
            clues.unshift(clue);
          }

          cells.unshift(cell);
          cells = unmatchedCells;
          break solveLeft;
        }
      }
      firstClueDone = true;
    }

    // FINSH OFF WITH RIGHT SIDE
    while (clues.length > 0) {
      var clue = clues.pop();
      var clueLength = parseInt($(clue).text());
      currentRun = 0;

      while (cells.length > 0) {
        var cell = cells.pop();

        result = solveClue(cell, currentRun, clueLength);

        if (result == onRun) {
          currentRun++;
          // check if end of cells
          if (cells.length == 0 && currentRun == clueLength){
            $(clue).addClass('completed-clue');
            return;
          }
        } else if (result == success) {
          $(clue).addClass('completed-clue');
          break;
        } else if (result == fail) {
          return;
        }
      }
    }
  };

  var solveClue = function(cell, currentRun, clueLength) {
    if (cell == filled) {
      currentRun++;
      if (currentRun > clueLength) {
        // run is too long, break and move on to right side
        return fail;
      }
      // start/continue run
      return onRun;
    } else if (cell == crossed) {
      if (currentRun == clueLength){
        return success;
        // move onto next clue and set highlight
      } else if (0 < currentRun && currentRun < clueLength) {
        // run is broken abort and move to right side
        return fail;
      }
      // contine run unless run is broken
    } else {
      return fail;
      //break, move on to looking from right
    }
  }

  var solveSingleClue = function(cells, clue) {
    var currentRun = 0;
    cells = [].slice.call(cells, 0);

    while (cells.length) {
      var clueLength = parseInt($(clue).text());
      var cell = cells.shift();

      if (cell == filled) {
        if (currentRun >= clueLength) {
          return;
        }
        currentRun++;
        // start/continue run
      } else if (cell == crossed) {
        if (0 < currentRun && currentRun < clueLength) {
          return;
        }
        // contine run unless run is broken
      } else {
        // break! clue failed
        return;
      }
    }
    $(clue).addClass('completed-clue');
    return;
  };

  var getRow = function(index) {
    var row = $('#' + index + '-0').closest('tr');
    return {
      clues: row.find('th').filter(mapClues),
      cells: row.find('td').map(mapCells)
    };
  };

  var getCol = function(index) {
    var cell = $('#0-' + index);

    index = $(cell).index();

    var colTh = $(cell).closest('table')
      .find('tr th:nth-child(' + (index + 1) + ')').filter(mapClues);
    var colTd = $(cell).closest('table')
      .find('tr td:nth-child(' + (index + 1) + ')').map(mapCells);

    return {
      clues: colTh,
      cells: colTd
    };
  };

  var mapClues = function(index, clue, array) {
    if ($(clue).text().length) {
      return true;
    } else {
      return false;
    }
  };

  var mapCells = function(index, cell) {
    if ($(cell).hasClass('filled')) {
      return filled;
    } else if ($(cell).hasClass('crossed')) {
      return crossed;
    } else {
      return blank;
    }
  };
};

window.Nonogram = new function() {
  var paint;
  var paintOverFilled;
  var gameId;

  this.init = function(id) {
    gameId = id;
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
    Clues.updateClues();
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

  this.refreshFilledCells = function(cellIds) {
    $('.cell').removeClass('filled');
    $('.cell').removeClass('blank');
    $('.cell').removeClass('crossed');
    setCells('filled', cellIds)
  };

  // PRIVATE

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
        setCells('filled', JSON.parse(savedGames[gameId]['filled']));
        setCells('crossed', JSON.parse(savedGames[gameId]['crossed']));
      }
    }
    Clues.updateClues();
  };

  var setCells = function(cssClass, cells) {
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
