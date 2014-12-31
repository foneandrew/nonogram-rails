// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var game_state

$(function (){
  //this happens on page load
  if ($('#game').length) {
    poll(2000);

    if ($('#nonogram').length) {
      $('.cell').bind('contextmenu', right_click_tile); 

      $('.cell').click(click_tile);
    }
  } else if (($('#games').length)) {
    refreshGamesList(5000);
  }
});

var click_tile = function() {
  // alert(this.id);
  // $(this).css( "border", "3px solid red" );

  if ($(this).hasClass('filled')) {
    $(this).removeClass('filled');
    $(this).addClass('blank');
  } else {
    $(this).removeClass('blank');
    $(this).removeClass('crossed');
    $(this).addClass('filled');
  }
};

var right_click_tile = function() {
  if ($(this).hasClass('crossed')) {
    $(this).removeClass('crossed');
    $(this).addClass('blank');
  } else {
    $(this).removeClass('blank');
    $(this).removeClass('filled');
    $(this).addClass('crossed');
  }
  return false;
};

var refreshGamesList = function(timeout){
  // this works!?
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