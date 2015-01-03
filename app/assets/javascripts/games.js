// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var game_state
var paint
var paint_over_filled

$(function (){
  //this happens on page load
  if ($('#game').length) {
    poll(2000);

    if ($('#nonogram').length) {
      $('.game-cell').bind('contextmenu', function() { return false; }); 

      paint = '';
      update_cells();

      $('.game-cell').mousedown(set_paint);
      $('.game-cell').mouseenter(select_tile);
      $('.game-cell').mouseleave(deselect_tile);
      $(document).mouseup(clear_paint_and_update);
    } else if ($('#waiting-for-results').length) {
      refreshGameOver(2000);
    }
  } else if (($('#games').length)) {
    refreshGamesList(5000);
  }
});

var select_tile = function() {
  highlight_row(this, true);
  highlight_column(this, true);
  paint_tile(this);
};

var deselect_tile = function() {
  highlight_row(this, false);
  highlight_column(this, false);
};

var highlight_row = function(cell, highlight) {
  var row = $(cell).closest('tr');

  if (highlight) {
    row.addClass('highlight-clue');
  } else {
    row.removeClass('highlight-clue');
  }
}

var highlight_column = function(cell, highlight) {
  var index = $(cell).index();

  var column = $(cell).closest('table')
      .find('tr th:nth-child(' + (index + 1) + ')');

  if (highlight) {
    column.addClass('highlight-clue');
  } else {
    column.removeClass('highlight-clue');
  }
}

var set_paint = function() {
  if ($(this).hasClass('filled')) {
    paint_over_filled = true;
  } 
  if (event.which == 1) {
    // left mouse button
    if ($(this).hasClass('filled')) {
      paint = 'blank';
    } else {
      paint = 'filled';
    }
    set_tile(this, paint);
  } else if (event.which == 3) {
    // right mouse button
    if ($(this).hasClass('crossed')) {
      paint = 'blank';
    } else {
      paint = 'crossed';
    }
    set_tile(this, paint);
  }
  return false;
};

var paint_tile = function(cell) {
  if ($(cell).hasClass('filled') && !paint_over_filled) {
    return;
  }
  if (paint.length) {
    set_tile(cell, paint)
  }
};

var set_tile = function(tile, paint) {
  $(tile).removeClass('filled');
  $(tile).removeClass('blank');
  $(tile).removeClass('crossed');
  $(tile).addClass(paint);
}

var clear_paint_and_update = function() {
  paint = '';
  paint_over_filled = false;
  update_cells();
};

var update_cells = function() {
  $('#cells').val(format_cell_data());
};

var format_cell_data = function() {
  var map = Array.prototype.map;
  var formatted_data = map.call($('.filled'), function(cell) { return cell.id });
  return JSON.stringify(formatted_data);
}

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

var refreshGamesList = function(timeout){
  // $.get("games.js",function(data){
  //   $("#games_list").html(data);
  // });

  $.ajax({
    type : 'GET',
    url : '',
    accepts: 'script',
    dataType: 'html',
    success : function(data){
      $('#games_list').html(data);
    },
    error : function(XMLHttpRequest, textStatus, errorThrown) {
      console.log(textStatus + ": " + errorThrown)
    }
  });

  setTimeout(function() {
    refreshGamesList(timeout);
  }, timeout);
};

var poll = function(timeout){
  var promise = $.getJSON("");
  
  promise.done(function(json) {
    if (game_state) {
      var compare = game_state.game.status.localeCompare(json.game.status);

      if (compare) {
        if ($('#player_answer').length) {
          update_cells();
          $('#player_answer').submit();
        } else {
          window.location.reload(true);
        }
      }
    }

    game_state = json;
  });

  promise.always(function() {
    setTimeout(function() {
      poll(timeout);
    }, timeout);
  });
};