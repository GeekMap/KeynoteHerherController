var cast = window.cast || {};

cast.receiver.logger.setLevelValue(cast.receiver.LoggerLevel.DEBUG);
// Anonymous namespace
(function() {
  'use strict';
  KHC.PROTOCOL = 'urn:x-cast:com.cve-2014-0160.keynote-herher-controller';

  var is_start = false;
  var sender_id = '';
  var SLIDE_CANVAS_ID = 'impress';

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
          this.max_page = message.max_page;
          this.min_page = message.min_page;

          this._clearAllNode(SLIDE_CANVAS_ID);

          for (var i = message.min_page; i <= message.max_page; i++) {
            var datax = 1000 * i;

            this._addDivNode(
              SLIDE_CANVAS_ID, 
              '', 
              datax.toString(), 
              '0', 
              'background-image:url(' + message.url_prefix + i + message.url_postfix + ');',
              'step slide'
            );
          }

          impress().init();

          // show first page
          message.page = message.min_page;
          this.onGo(senderId, message);
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

      this._clearAllNode(SLIDE_CANVAS_ID);
      this._addDivNode(SLIDE_CANVAS_ID, '<q>bye ._.\\~/</q>', '', '', '', '');

      console.log('</onUninit>');
    },

    onGo: function(senderId, message) {
      var page = parseInt(message.page) - 1;

      console.log('<onGo senderId="' + senderId + '">');
      if (!this.is_start){
        this.sendError(senderId, 'slider has not been initialized');
      }
      else if (message.page){
        if (page < parseInt(this.min_page)-1){
          this.sendError(senderId, 'page number is less than the minimum number: ' + message.page);
        }
        else if (page >= parseInt(this.max_page)){
          this.sendError(senderId, 'page number is larger than the maximum number: ' + message.page);
        }
        else {
          var api = impress();
          api.goto(page);
        }
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
    },

    _addDivNode: function(domId, html, x, y, style, className){
      var div = document.createElement('div');
      div.className = className;
      div.setAttribute('data-x', x);
      div.setAttribute('data-y', y);
      div.setAttribute('style', style);
      document.getElementById(domId).appendChild(div);
    },

    _clearAllNode: function(domId){
      var canvas = document.getElementById(domId);
      while (canvas.firstChild) {
          canvas.removeChild(canvas.firstChild);
      }
    }
  };

  // Exposes public functions and APIs
  cast.KHC = KHC;
})();
