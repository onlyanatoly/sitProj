#uses "Technodoc/Technodoc.Server.Settings"

// Вернуть активный сервер
string GetActiveServerUrl() {
  for (int i = 1; i < dynlen(TECHNODOC_SERVER_HTTP_ADDRESSES) + 1; i++)
  {
    string url = TECHNODOC_SERVER_HTTP_ADDRESSES[i] + "/api/ClusterServer/GetStatus";
    string token = signIn(TECHNODOC_SERVER_HTTP_ADDRESSES[i], TECHNODOC_DEFAULT_USER_LOGIN, TECHNODOC_DEFAULT_USER_PASSWORD);
  
    mapping response;
    mapping headers = makeMapping("Content-Type","application/json; charset=utf-8",
                                "Authorization", "Bearer " + token);
    mapping data = makeMapping("headers", headers);
  
    int result = netGet(url, response, data);
  
    if (result == 0 && response.content == 2) {
      return TECHNODOC_SERVER_HTTP_ADDRESSES[i];
    }
  }
  return "";
}

// Авторизоваться в ТехноДоке
string signIn(string hostAddress, string login, string password) {
  string url = hostAddress + "/api/Authentication/SignIn";
  string content = "{"
    + "login: \"" + login + "\","
    + "password: \"" + password + "\""
    + "}";

  mapping response;
  mapping headers = makeMapping("Content-Type","application/json; charset=utf-8");
  mapping data = makeMapping("content", content,
                             "headers", headers);

  int result = netPost(url, data, response);

  if (result != 0) {
    DebugN("Не удалось авторизоваться в ПО \"ТехноДок\"."
           + " Код состояния: " + response["httpStatusCode"] + ": " + response["httpStatusText"] + "."
           + " Подробности: " + response["errorString"]);

    return "";
  }

  return parseToken(response["content"]);
}

// Распарсить токен из строки
// Строка представляет собой ответ от сервера в формате JSON
string parseToken(string response) {
  string tokenHeader = strsplit(response, ",")[1];
  string token = strsplit(tokenHeader, ":")[2];

  int tokenLength = strlen(token);
  return substr(token, 1, tokenLength - 2);
}

