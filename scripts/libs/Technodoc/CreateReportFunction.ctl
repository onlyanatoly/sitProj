#uses "Technodoc/Technodoc.Server.Settings"
#uses "Technodoc/TechnodocAuthorization"

// Создать отчет
void createReport(string guid, time startTimestamp, time endTimestamp) {
  string activeServerUrl = GetActiveServerUrl();
  string url = activeServerUrl + "/api/Report/CreateReport";

  string timeParttern = "%Y.%m.%d.%H.%M.%S";

  // Если дата будет хранится в формате UTC, то заменить на formatTime
  string startTimestampArg = formatTimeUTC(timeParttern, startTimestamp);
  string endTimestampArg = formatTimeUTC(timeParttern, endTimestamp);

  string content = "{"
    + "templateGuid: \"" + guid + "\","
    + "startDate: \"" + startTimestampArg + "\","
    + "endDate: \"" + endTimestampArg + "\","
    + "predefinedValues: []" +
    + "}";

  string token = signIn(activeServerUrl, TECHNODOC_DEFAULT_USER_LOGIN, TECHNODOC_DEFAULT_USER_PASSWORD);

  mapping response;
  mapping headers = makeMapping("Content-Type","application/json; charset=utf-8",
                                "Authorization", "Bearer " + token);

  mapping data = makeMapping("content", content,
                             "headers", headers);

  int result = netPost(url, data, response);

  if (result != 0) {
    DebugN("Не удалось создать отчет в ПО \"ТехноДок\"."
           + " Код состояния: " + response["httpStatusCode"] + ": " + response["httpStatusText"] + "."
           + " Подробности: " + response["errorString"]);
  }
  else {
    DebugN("Отчет с идентификатором \"" + guid + "\" за интервал" + "[" + startTimestampArg + "-" + endTimestampArg + "] успешно создан");
  }
}