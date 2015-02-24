// Generated by CoffeeScript 1.9.1
(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  jQuery(function() {
    return window.chatController = new Chat.Controller($('#chat').data('uri'), true);
  });

  window.Chat = {};

  Chat.User = (function() {
    function User(user_name) {
      this.user_name = user_name;
      this.chat_color = ColorPicker.getColor()
      this.serialize = bind(this.serialize, this);
    }

    User.prototype.serialize = function() {
      return {
        user_name: this.user_name,
        chat_color: this.chat_color
      };
    };

    return User;

  })();

  Chat.Controller = (function() {
    Controller.prototype.template = function(message) {
      var html;
      // html = "<div class=\"chat_message\"" + " style=\"background-color:" + this.user.chat_color + "\"" + ">\n  <label class=\"label label-info\">\n    " + message.received.split(' ')[2] + " " + message.user_name + "\n  </label>&nbsp;\n  " + message.msg_body + "\n</div>";
      html = "<div class=\"chat_message\">\n  <label class=\"label label-info\">\n    " + message.received.split(' ')[2] + " " + message.user_name + "\n  </label>&nbsp;\n  " + message.msg_body + "\n</div>";
      return $(html);
    };

    Controller.prototype.userListTemplate = function(userList) {
      var i, len, user, userHtml;
      userHtml = "";
      for (i = 0, len = userList.length; i < len; i++) {
        user = userList[i];
        userHtml = userHtml + ("<li>" + user.user_name + "</li>");
      }
      return $(userHtml);
    };

    function Controller(url, useWebSockets) {
      this.createGuestUser = bind(this.createGuestUser, this);
      this.shiftMessageQueue = bind(this.shiftMessageQueue, this);
      this.updateUserInfo = bind(this.updateUserInfo, this);
      this.updateUserList = bind(this.updateUserList, this);
      this.sendMessage = bind(this.sendMessage, this);
      this.newMessage = bind(this.newMessage, this);
      this.bindEvents = bind(this.bindEvents, this);
      this.messageQueue = [];
      this.saveChatHistory = bind(this.saveChatHistory, this);
      this.dispatcher = new WebSocketRails(url, useWebSockets);
      this.dispatcher.on_open = this.createGuestUser;
      this.bindEvents();
    }

    Controller.prototype.bindEvents = function() {
      this.dispatcher.bind('new_message', this.newMessage);
      this.dispatcher.bind('user_list', this.updateUserList);
      $('input#user_name').on('keyup', this.updateUserInfo);
      $('#send').on('click', this.sendMessage);
      return $('#message').keypress(function(e) {
        if (e.keyCode === 13) {
          return $('#send').click();
        }
      });
    };

    Controller.prototype.newMessage = function(message) {
      this.messageQueue.push(message);
      if (this.messageQueue.length > 15) {
        this.shiftMessageQueue();
      }
      return this.appendMessage(message);
    };

    Controller.prototype.sendMessage = function(event) {
      var message;
      event.preventDefault();
      message = $('#message').val();
      this.dispatcher.trigger('new_message', {
        user_name: this.user.user_name,
        msg_body: message
      });
      return $('#message').val('');
    };

    Controller.prototype.updateUserList = function(userList) {
      return $('#user-list').html(this.userListTemplate(userList));
    };

    Controller.prototype.updateUserInfo = function(event) {
      this.user.user_name = $('input#user_name').val();
      $('#username').html(this.user.user_name);
      return this.dispatcher.trigger('change_username', this.user.serialize());
    };

    Controller.prototype.appendMessage = function(message) {
      var messageTemplate;
      messageTemplate = this.template(message);
      $('#chat').append(messageTemplate);
      this.updateScroll()
      return messageTemplate.slideDown(140);
    };

    Controller.prototype.shiftMessageQueue = function() {
      this.messageQueue.shift();
      return $('#chat div.messages:first').slideDown(100, function() {
        return $(this).remove();
      });
    };

    Controller.prototype.updateScroll = function (){
      var element = document.getElementById("chat");
      element.scrollTop = element.scrollHeight;
    };

    Controller.prototype.createGuestUser = function() {
      var rand_num;
      rand_num = Math.floor(Math.random() * 1000);
      var userName = $("meta[property=currentUserName").attr("content")
      this.user = new Chat.User(userName);
      $('#username').html(this.user.user_name);
      $('input#user_name').val(this.user.user_name);
      return this.dispatcher.trigger('new_user', this.user.serialize());
    };

    Controller.prototype.saveChatHistory = function() {
      chats_to_save = [];

      this.messageQueue.forEach(function(message, index){
        chats_to_save[index] = {
          msg_body: message.msg_body,
          received: message.received,
          user_name: message.user_name
        };
      });
      localStorage.messageQueue = JSON.stringify(chats_to_save);
    };

    Controller.prototype.loadChatHistory = function() {
      var target = this;
      chats = JSON.parse(localStorage.messageQueue || '{}');
      chats.forEach(function(chat){
        console.log(chat);
        target.newMessage(chat);
      });
    };

    return Controller;
  })();

}).call(this);

$(window).unload(function(){
  window.chatController.saveChatHistory();
});
$(window).on('load', function(){
  window.chatController.loadChatHistory.call(window.chatController);
});

