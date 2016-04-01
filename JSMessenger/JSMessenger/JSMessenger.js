(function() {

  if (window.JSMessenger) {
    return;
  }

  window.JSMessenger = {
    msgSend: msgSend,
    fetchJavaScriptMessage: fetchJavaScriptMessage,
    fetchNativeMessage: fetchNativeMessage,
  };

  var iframe;
  var messageQueue = [];
  var responseCallbacks = {};

  var cmdMsgSend = 'jsmessenger://msgsend';
  var uniqueId = 0;

  function msgSend(clazz, method, args, callback) {

    if (arguments.length == 3 && typeof args == 'function') {
      callback = args;
      args = null;
    }

    _msgSend({
      class: clazz,
      method: method,
      args: args
    }, callback);
  }

  function _msgSend(message, callback) {
    if (callback) {
      var callbackId = 'callback_' + (uniqueId++) + '_' + new Date().getTime();
      responseCallbacks[callbackId] = callback;
      message['callback'] = callbackId;
    }
    messageQueue.push(message);
    iframe.src = cmdMsgSend;
  }

  function fetchJavaScriptMessage() {
    var messages = JSON.stringify(messageQueue);
    messageQueue = [];
    return messages;
  }

  function fetchNativeMessage(message) {
    var callback = responseCallbacks[message.callback];
    if (callback) {
      callback(message);
      delete responseCallbacks[message.callback];
    }
  }

  iframe = document.createElement('iframe');
  iframe.style.display = 'none';
  document.documentElement.appendChild(iframe);
})();