#uses "Technodoc/TechnodocUtils"
#uses "Technodoc/ExecuteCommands.ctl"

// Таймаут между попытками опроса Технодока
private const int DELAY_BETWEEN_SEND_COMMANDS_REQUEST_SEC = 3; 

// Веб-метод получения команд на выполнение 
private const string GET_ALL_BATCHES_OF_COMMANDS_WEB_METHOD = "/api/WinCCOA/GetAllRequests";

// Веб-метод для ответа результата выполнения
private const string SEND_EXECUTION_RESULT_WEB_METHOD = "/api/WinCCOA/AddResponse";

// Имя заголовка содержащего статус выполнения
private const string STATUS_CODE_RESPONSE_HEADER_NAME = "httpStatusCode";

// Имя заголовка содержащего данные
private const string CONTENT_RESPONSE_HEADER_NAME = "content";

// Количество попыток отправить ответ выполнения
private const int ATTEMTPS_COUNT_RESPONSE = 3;

// Таймаут между попытками отправить ответ
private const int DELAY_BETWEEN_SEND_RESPONSE_SEC = 3; 

// Ключ для включения логов скрипта 
private const string LogTechnodocCommandsRequestsFlag = "LogCommands";

// Успешный код выполнениязапроса  
private const int SUCCESS_REQUEST_STATUS_CODE = 200;

// Имя поля содержащее идентификатор запроса выполнения команд
private const string REQUEST_ID_NAME = "Id"; 

// Имя поля содержащее данные запроса для выполнения команд
private const string REQUEST_DATA_NAME = "Data"; 

// Имя поля содержащее идентификатор ответа о выполнении команд
private const string RESPONSE_ID_NAME = "Id"; 

// Имя поля содержащее данные ответа о выполнении команд
private const string RESPONSE_DATA_NAME = "Data"; 

/** Запустить обработчик команд
*/   
void startHandlingCommands()
{
  string requestJson = "";
  string primaryTechnodocServerAddress = "";
  
  while(true)
  {
    try
    {
      delay(DELAY_BETWEEN_SEND_COMMANDS_REQUEST_SEC);

      requestJson = "";
      
      if(getPrimaryTechnodocAddress(primaryTechnodocServerAddress)) 
      {   
        // Если данных нет, то ничего не делаем
        if(!getNextCommands(primaryTechnodocServerAddress + GET_ALL_BATCHES_OF_COMMANDS_WEB_METHOD, requestJson))
        {
          DebugFTN(LogTechnodocCommandsRequestsFlag, "Нет команд для обработки, ожидаем...");
          continue;
        }
      
        dyn_mapping decodedRequest = jsonDecode(requestJson);
      
        // Если данных нет, то ничего не делаем
        if(dynlen(decodedRequest) == 0)
        {
          DebugFTN(LogTechnodocCommandsRequestsFlag, "Нет команд для обработки, ожидаем...");
          continue;
        }
      
        dyn_mapping results;
        dyn_string lastProcessedIds;
        for(int i = 1; i <= dynlen(decodedRequest); i++)
        {
          mapping request = decodedRequest[i];
          if(!mappingHasKey(request, REQUEST_ID_NAME) || !mappingHasKey(request, RESPONSE_DATA_NAME))
          {
            DebugFTN(LogTechnodocCommandsRequestsFlag, "Запрос не содержит данных для выполнения команд");
            continue;
          }
        
          if(dynContains(lastProcessedIds, request[REQUEST_ID_NAME]) > 0)
          {
            DebugFTN(LogTechnodocCommandsRequestsFlag, "Данные команды уже выполнялись, пропускаем...");
            DebugFTN(LogTechnodocCommandsRequestsFlag, request[RESPONSE_DATA_NAME]);
            continue;
          }
        
          mapping executionCommandsResult = ExecuteCommands(request[RESPONSE_DATA_NAME]);
          mapping response = makeMapping(RESPONSE_ID_NAME, request[REQUEST_ID_NAME], RESPONSE_DATA_NAME, executionCommandsResult);
        
          sendExecutionCommandsResult(primaryTechnodocServerAddress + SEND_EXECUTION_RESULT_WEB_METHOD, response);
          dynAppend(lastProcessedIds, request[REQUEST_ID_NAME]);
        }
      
        updateProcessedIds(lastProcessedIds, decodedRequest);
      }
      else 
      {
        DebugN("Не удалось определить основной сервер Технодока.");
      }
    }
    catch
    {
      DebugTN("Произошла ошибка во время обработки запроса от Технодока: " + getLastException());
    }
  } 
}

/** Получить список команд для обработки
  @param url Адрес отправки
  @param commands Список команд для обработки
*/
bool getNextCommands(string url, string& commands)
{
  mapping response;
  if(netGet(url, response) == -1)
  {
    DebugFTN(LogTechnodocCommandsRequestsFlag, "Запрос списка команд на выполнение завершился ошибкой.", "Полученный ответ: ", response);
    return false;
  }
    
  if(mappingHasKey(response, STATUS_CODE_RESPONSE_HEADER_NAME) && response[STATUS_CODE_RESPONSE_HEADER_NAME] != SUCCESS_REQUEST_STATUS_CODE)
  {
    DebugFTN(LogTechnodocCommandsRequestsFlag, "Запрос списка команд на выполнение вернул не успешный код.", "Полученный ответ: ", response);
    return false;
  }
    
  if(!mappingHasKey(response, CONTENT_RESPONSE_HEADER_NAME) || response[CONTENT_RESPONSE_HEADER_NAME] == "")
  {
    DebugFTN(LogTechnodocCommandsRequestsFlag, "Запрос списка команд не содержит данных для выполнения.", "Полученный ответ: ", response);
    return false;
  }
    
  DebugFTN(LogTechnodocCommandsRequestsFlag, "Получен успешный ответ: ", response);
  commands = response[CONTENT_RESPONSE_HEADER_NAME];
  return true;
}

/** Отправить результат выполнения команд
  @param url Адрес отправки
  @param executionResult Результат выполнения команд
*/
bool sendExecutionCommandsResult(string url, mapping executionResult)
{
  string executionResultJson = jsonEncode(makeMapping("response", executionResult));
  mapping headerOptions = makeMapping("Content-Type", "application/json");
  mapping data = makeMapping("headers", headerOptions, "content", executionResultJson);        
  mapping requestResult;    
  
  DebugFTN(LogTechnodocCommandsRequestsFlag, "Будет отправлен ответ в следующем виде: ", data);      
    
  int attemptCount = 0;
  bool resultSend = false;
  while(attemptCount < ATTEMTPS_COUNT_RESPONSE)
  {
    int returnCode = netPost(url, data, requestResult);
              
    if(returnCode == -1 || (mappingHasKey(requestResult, STATUS_CODE_RESPONSE_HEADER_NAME) && requestResult[STATUS_CODE_RESPONSE_HEADER_NAME] != SUCCESS_REQUEST_STATUS_CODE))
    {
      attemptCount++;
      DebugFTN(LogTechnodocCommandsRequestsFlag, "Неудачный статус отправки ответа:" + requestResult + ". Попытка " + attemptCount + " из " + ATTEMTPS_COUNT_RESPONSE);
      delay(DELAY_BETWEEN_SEND_RESPONSE_SEC);      
      continue;
    }

    resultSend = true;
    DebugFTN(LogTechnodocCommandsRequestsFlag, "Отправлен ответ: ", requestResult);
    break;   
  }
  
  return resultSend;
}

/** Обновить список последних обработанных команд
  @param lastProcessedIds Список идентификаторов последних обработанных запросов
  @param commandsBatches Текущий список запросов
*/
void updateProcessedIds(dyn_string& lastProcessedIds, dyn_mapping& commandsBatches)
{
  dyn_string idsToRemove;
  for(int i = 1; i <= dynlen(lastProcessedIds); i++)
  {
    bool hasInLastRequest = false;
    for(int j = 1; j <= dynlen(commandsBatches); j++)
    {
      mapping commandsBatch = commandsBatches[j];
      if(!mappingHasKey(commandsBatch, REQUEST_ID_NAME))
      {
        continue;
      }
              
      if(lastProcessedIds[i] == commandsBatch[REQUEST_ID_NAME])
      {
        hasInLastRequest = true;
        break;
      }
    }
      
    if(!hasInLastRequest)
    {
      dynAppend(idsToRemove, lastProcessedIds[i]);
    }
  }
    
  for(int i = 1; i <= dynlen(idsToRemove); i++)
  {
    int idx = dynContains(lastProcessedIds, idsToRemove[i]);
    if(idx > 0)
    {
      dynRemove(lastProcessedIds, idx);
    }
  }
}
