var cast = window.cast || {};

cast.receiver.logger.setLevelValue(cast.receiver.LoggerLevel.DEBUG);
// Anonymous namespace
(function() {
  'use strict';
  KHC.PROTOCOL = 'urn:x-cast:com.cve-2014-0160.keynote-herher-controller';

  var is_start = false;
  var sender_id = '';

  function KHC(board) {
    console.log('******** KeynoteHerherController ********');
    this.castReceiverManager_ = cast.receiver.CastReceiverManager.getInstance();
    this.castMessageBus_ = this.castReceiverManager_.getCastMessageBus(KHC.PROTOCOL, cast.receiver.CastMessageBus.MessageType.JSON);
    this.castMessageBus_.onMessage = this.onMessage.bind(this);
    this.castReceiverManager_.onSenderConnected = this.onSenderConnected.bind(this);
    this.castReceiverManager_.onSenderDisconnected = this.onSenderDisconnected.bind(this);
    this.castReceiverManager_.start();
  }

  KHC.prototype = {
    onSenderConnected: function(event) {
      console.log('onSenderConnected. Total number of senders: ' + this.castReceiverManager_.getSenders().length);

      // disconnect user if session already exists and user id different
      if (!is_start || sender_id == event.senderId){
        console.log('you are safe');
      }
      else{
        console.log('get out of here, bitch');
      }
    },

    onSenderDisconnected: function(event) {
      console.log('onSenderDisconnected. Total number of senders: ' + this.castReceiverManager_.getSenders().length);
      if (this.castReceiverManager_.getSenders().length == 0) {
        window.close();
      }
    },

    onMessage: function(event) {
      var message = event.data;
      console.log('******** onMessage ********' + JSON.stringify(event.data));

      switch (message.cmd){
        case 'init':
          this.onInit(event.senderId, message.meta);
          break;
        case 'uninit':
          this.onUninit();
          break;
        case 'go':
          this.onGo(event.senderId, message.meta);
          break;
        default:
          console.log('Invalid command received: ' + message.cmd);
      }
    },

    onInit: function(senderId, message) {
      console.log('<onInit senderId="' + senderId + '">');
      // title, url_prefix, url_postfix, max_page, min_page
      if (message.title && message.url_prefix && message.url_postfix && message.max_page && message.min_page){
        if (this.is_start){
          this.sendError(senderId, 'already init');
        }
        else {
          this.is_start = true;
          this.sender_id = senderId;

          this.title = message.title;
          this.url_prefix = message.url_prefix;
          this.url_postfix = message.url_postfix;
          this.max_page = message.max_page;
          this.min_page = message.min_page;

          $("#slide_title").html(this.title);
        }
      }
      else {
        this.sendError(senderId, 'missing parameters for init');
      }

      console.log('</onInit>');
    },

    onUninit: function(senderId, message) {
      console.log('<onUninit senderId="' + senderId + '">');
      
      this.is_start = false;
      this.sender_id = '';

      var slide = $("#slide_spotlight")[0];

      $("#slide_title")[0].style.visibility = 'visible';
      slide.style.visibility = 'hidden';
      $("#slide_title").html('._.\\~/');

      console.log('</onUninit>');
    },

    onGo: function(senderId, message) {
      console.log('<onGo senderId="' + senderId + '">');
      if (message.page){
        var slide = $("#slide_spotlight")[0];

        if (slide.style.visibility == 'hidden'){
          console.log('changing visibility...');
          $("#slide_title")[0].style.visibility = 'hidden';
          slide.style.visibility = 'visible';
        }
        slide.src = this.url_prefix + message.page + this.url_postfix;
      }
      else {
        this.sendError(senderId, 'missing parameters for init');
      }
      console.log('</onGo>');
    },

    sendError: function(senderId, errorMessage) {
      this.castMessageBus_.send(senderId, {'event': 'error', 'message': errorMessage });
    },

    broadcast: function(message) {
      this.castMessageBus_.broadcast(message);
    }
  };

  // Exposes public functions and APIs
  cast.KHC = KHC;
})();
