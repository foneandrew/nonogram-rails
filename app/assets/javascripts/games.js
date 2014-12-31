// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var game_state
var paint

$(function (){
  //this happens on page load
  if ($('#game').length) {
    poll(2000);

    if ($('#nonogram').length) {
      $('.cell').bind('contextmenu', function() { return false; }); 

      paint = '';
      update_cells();

      $('.cell').mousedown(set_paint);
      $('.cell').mouseover(paint_tile);
      $(document).mouseup(clear_paint_and_update);
    }
  } else if (($('#games').length)) {
    refreshGamesList(5000);
  }
});

var set_paint = function() {
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

var paint_tile = function() {
  if (paint.length) {
    set_tile(this, paint)
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