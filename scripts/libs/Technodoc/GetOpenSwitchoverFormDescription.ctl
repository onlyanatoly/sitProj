#uses "Technodoc/Technodoc.Server.Settings"
#uses "Technodoc/TechnodocAuthorization"

dyn_string GetOpenSwitchoverFormWriteForbiddenTagAddresses() 
{
  string response = GetOpenSwitchoverFormDescription();
  dyn_string responseArray = strsplit(response, "\n");
  dyn_string tagStrings;
  
  for (int i = 1; i < dynlen(responseArray) + 1; i++)
  {
    string el = responseArray[i];
    if (el[0] !=  35) 
    {
      dynAppend(tagStrings, el);
    }    
  }

  dyn_string result;
  for (int j = 1; j < dynlen(tagStrings) + 1; j++)
  {
    dyn_string ar = strsplit(tagStrings[j], ";");
    dynAppend(result, ar);
  }
  return result;
}

string GetOpenSwitchoverFormDescription()
{
  string activeServerUrl = GetActiveServerUrl();
  string url = activeServerUrl + "/api/SwitchoverForm/GetOpenFormDescription";
  string token = signIn(activeServerUrl, TECHNODOC_DEFAULT_USER_LOGIN, TECHNODOC_DEFAULT_USER_PASSWORD);
  
  mapping response;
  mapping headers = makeMapping("Content-Type","application/json; charset=utf-8",
                                "Authorization", "Bearer " + token);
  mapping data = makeMapping("headers", headers);
  
  int result = netGet(url, response, data);
  
  if (result != 0) {
    DebugN("Не удалось получить описание открытого отчета в ПО \"ТехноДок\"."
           + " Код состояния: " + response["httpStatusCode"] + ": " + response["httpStatusText"] + "."
           + " Подробности: " + response["errorString"]);
    return "";
  }
  else {
    return response.content;
  }
}
