<<<<<<< HEAD
var IS_DEBUG;

if (!IS_DEBUG){
  var cast = window.cast || {};
  cast.receiver.logger.setLevelValue(cast.receiver.LoggerLevel.DEBUG);
}

=======
var cast = window.cast || {};

cast.receiver.logger.setLevelValue(cast.receiver.LoggerLevel.DEBUG);
>>>>>>> 8434db4ee047d32f06c9bebfcd841d6d9400a500
// Anonymous namespace
(function() {
  'use strict';
  KHC.PROTOCOL = 'urn:x-cast:com.cve-2014-0160.keynote-herher-controller';

  var is_start = false;
  var sender_id = '';
<<<<<<< HEAD
  var SLIDE_CANVAS_ID = 'impress';

  function KHC(board) {
    console.log('******** KeynoteHerherController ********');
    if (!IS_DEBUG){
      this.castReceiverManager_ = cast.receiver.CastReceiverManager.getInstance();
      this.castMessageBus_ = this.castReceiverManager_.getCastMessageBus(KHC.PROTOCOL, cast.receiver.CastMessageBus.MessageType.JSON);
      this.castMessageBus_.onMessage = this.onMessage.bind(this);
      this.castReceiverManager_.onSenderConnected = this.onSenderConnected.bind(this);
      this.castReceiverManager_.onSenderDisconnected = this.onSenderDisconnected.bind(this);
      this.castReceiverManager_.start();
    }
    else {
      unittest();
    }
  }

  function unittest() {
    console.log('in unittest');
    var mock_slide = {};
    mock_slide.title = 'i am test title';
    //mock_slide.url_prefix = 'http://image.slidesharecdn.com/lineintroductionoastickers201405272014-h2-140619112634-phpapp01/95/slide-';
    //mock_slide.url_postfix = '-638.jpg';
    // mock_slide.url_prefix = 'http://image.slidesharecdn.com/slideshare51230trendmicro-111102090557-phpapp02/95/slide-';
    // mock_slide.url_postfix = '-728.jpg';
    mock_slide.url_prefix = 'https://speakerd.s3.amazonaws.com/presentations/03ad1120aa2501313da22a463594f846/slide_';
    mock_slide.url_postfix = '.jpg'
    mock_slide.min_page = '0';
    mock_slide.max_page = '35';

    // if (message.title && message.url_prefix && message.url_postfix && message.max_page && message.min_page){
    KHC.prototype.onInit('123', mock_slide);
=======

  function KHC(board) {
    console.log('******** KeynoteHerherController ********');
    this.castReceiverManager_ = cast.receiver.CastReceiverManager.getInstance();
    this.castMessageBus_ = this.castReceiverManager_.getCastMessageBus(KHC.PROTOCOL, cast.receiver.CastMessageBus.MessageType.JSON);
    this.castMessageBus_.onMessage = this.onMessage.bind(this);
    this.castReceiverManager_.onSenderConnected = this.onSenderConnected.bind(this);
    this.castReceiverManager_.onSenderDisconnected = this.onSenderDisconnected.bind(this);
    this.castReceiverManager_.start();
>>>>>>> 8434db4ee047d32f06c9bebfcd841d6d9400a500
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
<<<<<<< HEAD

      // settings for slide cache
      this.cached_slides = Array();
      this.cache_count = 4;
      this.cached_slides_length = 1 + this.cache_count * 2; // left 2 + right 2

=======
>>>>>>> 8434db4ee047d32f06c9bebfcd841d6d9400a500
      // title, url_prefix, url_postfix, max_page, min_page
      if (message.title && message.url_prefix && message.url_postfix && message.max_page && message.min_page){
        if (this.is_start){
          this.sendError(senderId, 'already init');
        }
        else {
          this.is_start = true;
          this.sender_id = senderId;

          this.title = message.title;
<<<<<<< HEAD

          this.url_prefix = message.url_prefix;
          this.url_postfix = message.url_postfix;

          this.max_page = message.max_page;
          this.min_page = message.min_page;

          this.current_page = 0;

          // show first page
          document.getElementById('SideA').style.backgroundImage = 'url(' + this.url_prefix + message.min_page + this.url_postfix + ')';          
          this._cacheSlides(parseInt(message.min_page));
=======
          this.url_prefix = message.url_prefix;
          this.url_postfix = message.url_postfix;
          this.max_page = message.max_page;
          this.min_page = message.min_page;

          $("#slide_title").html(this.title);
>>>>>>> 8434db4ee047d32f06c9bebfcd841d6d9400a500
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

<<<<<<< HEAD
      this._clearAllNode(SLIDE_CANVAS_ID);
      this._addDivNode(SLIDE_CANVAS_ID, '<q>bye ._.\\~/</q>', '', '', '', '');
=======
      var slide = $("#slide_spotlight")[0];

      $("#slide_title")[0].style.visibility = 'visible';
      slide.style.visibility = 'hidden';
      $("#slide_title").html('._.\\~/');
>>>>>>> 8434db4ee047d32f06c9bebfcd841d6d9400a500

      console.log('</onUninit>');
    },

    onGo: function(senderId, message) {
<<<<<<< HEAD
      var page = parseInt(message.page);

      console.log('<onGo senderId="' + senderId + '">');
      if (!this.is_start){
        this.sendError(senderId, 'slider has not been initialized');
      }
      else if (message.page){
        if (page < parseInt(this.min_page)){
          this.sendError(senderId, 'page number is less than the minimum number: ' + message.page);
        }
        else if (page > parseInt(this.max_page)){
          this.sendError(senderId, 'page number is larger than the maximum number: ' + message.page);
        }
        else {
          var api = impress();
          var next_page = page + 1;
          if (page >= parseInt(this.max_page) - parseInt(this.min_page)){
            next_page = page;
          }

          if (this.current_page == 1){
            this.current_page = 0;
            document.getElementById('SideA').style.backgroundImage = 'url(' + this.url_prefix + page + this.url_postfix + ')';
            document.getElementById('SideB').style.backgroundImage = 'url(' + this.url_prefix + next_page + this.url_postfix + ')';

            api.goto('SideA');
          }
          else {
            this.current_page = 1;
            document.getElementById('SideA').style.backgroundImage = 'url(' + this.url_prefix + next_page + this.url_postfix + ')';
            document.getElementById('SideB').style.backgroundImage = 'url(' + this.url_prefix + page + this.url_postfix + ')';

            api.goto('SideB');
          }
        }
=======
      console.log('<onGo senderId="' + senderId + '">');
      if (message.page){
        var slide = $("#slide_spotlight")[0];

        if (slide.style.visibility == 'hidden'){
          console.log('changing visibility...');
          $("#slide_title")[0].style.visibility = 'hidden';
          slide.style.visibility = 'visible';
        }
        slide.src = this.url_prefix + message.page + this.url_postfix;
>>>>>>> 8434db4ee047d32f06c9bebfcd841d6d9400a500
      }
      else {
        this.sendError(senderId, 'missing parameters for init');
      }
<<<<<<< HEAD

      this._cacheSlides(page);

=======
>>>>>>> 8434db4ee047d32f06c9bebfcd841d6d9400a500
      console.log('</onGo>');
    },

    sendError: function(senderId, errorMessage) {
      this.castMessageBus_.send(senderId, {'event': 'error', 'message': errorMessage });
    },

    broadcast: function(message) {
      this.castMessageBus_.broadcast(message);
<<<<<<< HEAD
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
    },

    _cacheSlides: function(page){
      // caching for slides
      var pre_cache = page - this.cache_count;
      var post_cache = page + this.cache_count;
      var min_page_i = parseInt(this.min_page);
      var max_page_i = parseInt(this.max_page);
      for(var x  = (min_page_i > pre_cache  ? min_page_i : pre_cache), y = 0;
              x <= (post_cache > max_page_i ? max_page_i : post_cache) && y < this.cached_slides_length;
          x++, y++) {
        this.cached_slides[y] = new Image();
        this.cached_slides[y].src = this.url_prefix + x.toString() + this.url_postfix;
      }
=======
>>>>>>> 8434db4ee047d32f06c9bebfcd841d6d9400a500
    }
  };

  // Exposes public functions and APIs
  cast.KHC = KHC;
})();
