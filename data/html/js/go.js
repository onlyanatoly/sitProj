'use strict';

oaJsApi.setLogLevel = {d:true};
let successHandler = function()
{
  let snippedFileName = getParameterByName('javascriptFile');
  if (snippedFileName)
  {
    $.ajax({
      url: snippedFileName,

    }).done(function(data)
    {
      $(document.body).append(data);

    });
  }

};
if (getParameterByName('context') === "ulc")
{
  oaJsApi.setUlcContext(true);
  window.parent.ETM.webViewInstances[getParameterByName('windowId')] = oaJsApi;

  oaJsApi.customSender(function(payload)
  {
    //extract winid
    let winId = getParameterByName('windowId');

    let payloadJson = JSON.stringify(payload);
    verifyPayloadSize(payloadJson.length);

    let arr, i;
    arr = [6];     // msg-type
    arr.push16(winId);
    arr.push32(payloadJson.length);

    for(i = 0; i < payloadJson.length; i++)
    {
      arr.push(payloadJson.charCodeAt(i));
    }

    return window.parent.ETM.ws.send(arr);
  });
  successHandler();
}
else
{
  oaJsApi.connect("ws://127.0.0.1:" + getParameterByName('webSocketServerPort'), {
    baseParams: {
      webViewId: getParameterByName('webViewId')
    },
    listeners: {
      success: successHandler,
      error: function(error)
      {
        console.error(error);

      }
    }
  });
}

(function($)
{
  $.fn.oaJsApi = function()
  {

    return oaJsApi;
  };
}(jQuery));
