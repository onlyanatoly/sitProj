var chatName = "User2";
var targetChatEwo = "WebView_ewo2";
$.getScript("/data/html/demo/app/msgToWebviewEwo/chat.js", function()
{
  insertChat({
    who: name,
    message: name + " entered the chat"
  });
});

