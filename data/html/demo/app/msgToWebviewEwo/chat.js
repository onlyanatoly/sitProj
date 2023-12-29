function insertChat(params)
{
  var who = params.who;
  var text = params.message;

  var control = "";

  if (who === chatName)
  {

    control = '<li style="width:100%">' +
      '<div class="msj macro">' +
      '<div class="avatar">' + text + '</div>' +
      '<div class="text text-l">' +
      '</div>' +
      '</div>' +
      '</li>';
    oaJsApi.msgToWebViewEwo(targetChatEwo, "insertChat", {
      who: chatName,
      message: text
    });
  }
  else
  {
    control = '<li style="width:100%;">' +
      '<div class="msj-rta macro">' +
      '<div class="text text-r">' +
      '<p>' + chatName + ":" + '</p>' +
      '</div>' +
      '<div class="avatar" style="padding:0px 0px 0px 10px !important">' + text + '</div>' +
      '</li>';
  }
  $("ul.msgtoWebviewEwoChat").append(control);

}

$(".mytext").on("keyup", function(e)
{
  if (e.which == 13)
  {
    var text = $(this).val();
    if (text !== "")
    {
      insertChat({
        who: chatName,
        message: text
      });
      $(this).val('');
    }
  }
});

