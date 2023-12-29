// $License: NOLICENSE
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Libraries used (#uses)
#uses "Technodoc/TechnodocUtils"
#uses "Technodoc/Technodoc.Server.Settings"

//--------------------------------------------------------------------------------
/** Мониторинг и управление локальным экземпляром Технодока
*/
main()
{
  if(!isTechnodocServiceRunning(TECHNODOC_SERVICE_NAME))
  {
    DebugFN(MONITORING_DEBUG_FLAG, "Сервис Технодока не запущен, попытка запуска сервиса.");
    if(!isTechnodocServiceExists(TECHNODOC_SERVICE_NAME) && !createTechnodocService(TECHNODOC_ROOT_FOLDER_PATH))
    {
      throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось создать службу Технодока. Обратитесь к администратору. Скрипт мониторинга завершит свою работу."));
      return;
    }

    if(!startTechnodocService(TECHNODOC_ROOT_FOLDER_PATH) || !isTechnodocServiceRunning(TECHNODOC_SERVICE_NAME))
    {
      throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось запустить службу Технодока. Обратитесь к администратору. Скрипт мониторинга завершит свою работу."));
      return;
    }

    delay(DELAY_AFTER_START_SEREVICE_SEC);

    if(!isTechnodocServiceRunning(TECHNODOC_SERVICE_NAME))
    {
      throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось запустить службу Технодока. Обратитесь к администратору. Скрипт мониторинга завершит свою работу."));
      return;
    }
  }

  time lastHealthyServerStateTime = getCurrentTime();
  while(true)
  {
      delay(MONITORING_INTERVAL_LOCAL_SERVER_SEC);

      // Если сервер доступен, то ничего не делаем
      if(isTechnodocServerAlive(TECHNODOC_LOCAL_HTTP_ADDRESS))
      {
        DebugFN(MONITORING_DEBUG_FLAG, "Текущий сервер с адресом \"" + TECHNODOC_LOCAL_HTTP_ADDRESS + "\" доступен");
        lastHealthyServerStateTime = getCurrentTime();
        continue;
      }

      // Если неработоспособность сервера не превысила максимальный таймаут, то ничего не делаем
      int secondsInUnhealthyState = (int)(getCurrentTime() - lastHealthyServerStateTime);
      if(secondsInUnhealthyState < MAX_TIME_IN_UNHEALTHY_STATE_LOCAL_SERVER_SEC)
      {
        DebugFN(MONITORING_DEBUG_FLAG, "Текущий сервер с адресом \"" + TECHNODOC_LOCAL_HTTP_ADDRESS + "\" недоступен \"" + secondsInUnhealthyState + "\" секунд. Максимальное время недоступности, после которого будет выполнен перезапуск сервера \"" + MAX_TIME_IN_UNHEALTHY_STATE_LOCAL_SERVER_SEC + "\" секунд.");
        continue;
      }

      throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Время недоступности сервера Технодока превысило максимальное время. Будет произведена попытка перезапуска."));

      if(isTechnodocServiceRunning(TECHNODOC_SERVICE_NAME))
      {
        DebugFN(MONITORING_DEBUG_FLAG, "Сервис Технодока запущен, но не отвечает. Попытка выполнить перезапуск сервиса.");
        stopTechnodocService(TECHNODOC_ROOT_FOLDER_PATH);
        startTechnodocService(TECHNODOC_ROOT_FOLDER_PATH);
      }
      else
      {
        DebugFN(MONITORING_DEBUG_FLAG, "Сервис Технодока не запущен. Попытка выполнить запуск сервиса.");
        startTechnodocService(TECHNODOC_ROOT_FOLDER_PATH);
      }
  }
}

/** Запущен ли сервис Технодока
  @param serviceName Имя сервиса Технодока
  @return Возвращает true если сервис Технодока запущен, иначе false
*/
private bool isTechnodocServiceRunning(string serviceName)
{
  DebugFN(MONITORING_DEBUG_FLAG, "Начата проверка состояния запуска сервиса Технодока");

  int returnCode = -1;
  string out, err;
  string command = "";
  if(_WIN32)
  {
    command = "sc query \"" + serviceName + "\" | find \"RUNNING\"";
    returnCode = system(command, out, err);
  }
  else if(_UNIX)
  {
    command = "systemctl is-active --quiet \"" + serviceName + "\"";
    returnCode = system(command, out, err);
  }
  else
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось проверить состояние сервиса Технодока. Неподдерживаемая операционная система."));
    return false;
  }

  DebugFN(MONITORING_DEBUG_FLAG, "Выполнена команда проверки существования сервиса Технодока: \"" + command + "\"");
  
  if(returnCode != 0)
  {
    throwError(makeError("", PRIO_WARNING, ERR_CONTROL, 0, __FUNCTION__ , "Сервис Технодока не запущен: " + out + " " + err));
    return false;
  }

  DebugFN(MONITORING_DEBUG_FLAG, "Сервис Технодока запущен. Результат выполнения запуска: " + out + " " + err);

  return true;
}

/** Запустить сервис Технодока
  @param technodocRootFolderPath Корневая папка Технодока
  @return Возвращает true если удалось запустить сервис Технодока, иначе false
*/
private bool startTechnodocService(string technodocRootFolderPath)
{
  DebugFN(MONITORING_DEBUG_FLAG, "Начата попытка запуска сервиса Технодока");

  string scriptName = "";

  if(_WIN32)
  {
    scriptName = "startTechnoDocServerSrv.bat";
  }
  else if(_UNIX)
  {
    scriptName = "startTechnoDocServerDaemon.sh";
  }
  else
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось выполнить запуск сервиса Технодока. Неподдерживаемая операционная система."));
    return false;
  }

  string scriptPath = technodocRootFolderPath + "/scripts/" + scriptName;

  if(!isfile(scriptPath))
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось найти скрипт запуска службы Технодока: \"" + scriptPath + "\". Обратитесь к администратору."));
    return false;
  }

  string out, err;
  int returnCode = system(scriptPath, out, err);

  if(returnCode != 0)
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Скрипт запуска службы Технодока завершился с ошибками: " + out + " " + err + ". Обратитесь к администратору."));
    return false;
  }

  DebugFN(MONITORING_DEBUG_FLAG, "Запуск сервиса Технодока выполнен успешно");

  return true;
}

/** Остановить сервис Технодока
  @param technodocRootFolderPath Корневая папка Технодока
  @return Возвращает true если удалось остановить сервис Технодока, иначе false
*/
private bool stopTechnodocService(string technodocRootFolderPath)
{
  DebugFN(MONITORING_DEBUG_FLAG, "Начата попытка остановки сервиса Технодока");

  string scriptName = "";

  if(_WIN32)
  {
    scriptName = "stopTechnoDocServerSrv.bat";
  }
  else if(_UNIX)
  {
    scriptName = "stopTechnoDocServerDaemon.sh";
  }
  else
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось выполнить остановку сервиса Технодока. Неподдерживаемая операционная система."));
    return false;
  }

  string scriptPath = technodocRootFolderPath + "/scripts/" + scriptName;

  if(!isfile(scriptPath))
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось найти скрипт остановки службы Технодока: \"" + scriptPath + "\". Обратитесь к администратору."));
    return false;
  }

  string out, err;
  int returnCode = system(scriptPath, out, err);

  if(returnCode != 0)
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Скрипт остановки службы Технодока завершился с ошибками: " + out + " " + err + ". Обратитесь к администратору."));
    return false;
  }

  DebugFN(MONITORING_DEBUG_FLAG, "Остановка сервиса Технодока выполнена успешно");

  return true;
}

/** Существет ли сервис Технодока
  @param serviceName Имя сервиса Технодока
  @return Возвращает true если сервис Технодока существует, иначе false
*/
private bool isTechnodocServiceExists(string serviceName)
{
  DebugFN(MONITORING_DEBUG_FLAG, "Начата проверка существования сервиса Технодока");

  int returnCode = -1;
  string out, err;
  if(_WIN32)
  {
    returnCode = system("sc query \"" + serviceName + "\"", out, err);
  }
  else if(_UNIX)
  {
    returnCode = system("systemctl cat \"" + serviceName + "\"", out, err);
  }
  else
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось выполнить проверку существования сервиса Технодока. Неподдерживаемая операционная система."));
    return false;
  }

  if(returnCode != 0)
  {
    throwError(makeError("", PRIO_WARNING, ERR_CONTROL, 0, __FUNCTION__ , "Выполнение проверки существования сервиса Технодока завершилось с ошибками: " + out + " " + err + "."));
    return false;
  }

  DebugFN(MONITORING_DEBUG_FLAG, "Сервис Технодока существует");

  return true;
}

/** Создать сервис Технодока
  @param technodocRootFolderPath Корневая папка Технодока
  @return Возвращает true если удалось создать сервис Технодока, иначе false
*/
private bool createTechnodocService(string technodocRootFolderPath)
{
  DebugFN(MONITORING_DEBUG_FLAG, "Начата попытка создания сервиса Технодока");

  string scriptName = "";

  if(_WIN32)
  {
    scriptName = "createTechnoDocServerSrv.bat";
  }
  else if(_UNIX)
  {
    scriptName = "createTechnoDocServerDaemon.sh";
  }
  else
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось выполнить создание сервиса Технодока. Неподдерживаемая операционная система."));
    return false;
  }

  string scriptPath = technodocRootFolderPath + "/scripts/" + scriptName;

  if(!isfile(scriptPath))
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Не удалось найти скрипт создания службы Технодока: \"" + scriptPath + "\". Обратитесь к администратору."));
    return false;
  }

  string out, err;
  int returnCode = system(scriptPath, out, err);

  if(returnCode != 0)
  {
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , "Скрипт создания службы Технодока авершился с ошибками: " + out + " " + err + ". Обратитесь к администратору."));
    return false;
  }

  DebugFN(MONITORING_DEBUG_FLAG, "Создание сервиса Технодока выполнено успешно");

  return true;
}

