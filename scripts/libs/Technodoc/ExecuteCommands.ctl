// $License: NOLICENSE
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Libraries used (#uses)

#uses "Technodoc/GetTagTree"
//--------------------------------------------------------------------------------
// Variables and Constants

// Ключи для получения данных для выполнения команд
// Ключ для адреса
private const string TAG_ADDRESS_IDX = "TagAddress";

// Ключ для значения
private const string VALUE_IDX = "Value";

// Ключ типа команды
private const string COMMAND_TYPE_IDX = "Type";

// Ключ вида команды
private const string COMMAND_KIND_IDX = "Kind";

// Задержка до выполнения команды
private const string COMMAND_DELAY_BEFORE_EXECUTION_MSEC_IDX = "DelayBeforeExecutionMsec";

// Задержка после выполнения команды
private const string COMMAND_DELAY_AFTER_EXECUTION_MSEC_IDX = "DelayAfterExecutionMsec";

// Номере бита
private const string COMMAND_BIT_NUMBER_IDX = "BitNumber";

// Значении бита
private const string COMMAND_BIT_VALUE_IDX = "BitValue";

// Типы команд
// Проверка
private const int VERIFY_COMMAND = 0;

// Запись
private const int WRITE_COMMAND = 1;

// Проверка бита
private const int VERIFY_BIT_COMMAND = 2;

// Запись бита
private const int WRITE_BIT_COMMAND = 3;

// Виды команд
// Стандартная
private const int STANDARD_COMMAND_KIND = 0;

// Проверка положения ключа
private const int CONTROL_KEY_POSITION_COMMAND_KIND = 1;

// Проверка сигнализации
private const int ALARM_COMMAND_KIND = 2;

// Проверка существования тэга
private const int CHECK_DP_COMMAND_KIND = 3;

// Получение дерева тэгов
private const int TAG_TREE_COMMAND_KIND = 4;

// Тексты ошибок
private const string ERROR_COMPARISON_TEXT = "Ошибка сравнения.\nОжидаемое значение тега \"%s\" = \"%s\".\nПолученное значение = \"%s\".";
private const string ERROR_COMPARISON_BIT_TEXT = "Ошибка сравнения.\nОжидаемое значение бита с номером \"%s\" для тега = \"%s\".\nПолученное значение = \"%s\".";
private const string GET_TAG_ERROR = "Не удалось найти точку данных с адресом: \"%s\"";
private const string GET_TYPE_ERROR = "Не удалось распознать тип точки данных с адресом: \"%s\"";
private const string CONVERT_TO_FLOAT_FORMAT_ERROR = "Не удалось преобразовать к формату типа float значение: \"%s\"";
private const string COMPARISON_DETAILS = "Полученное значение = \"%s\".";
private const string COMPARISON_BIT_DETAILS = "Полученное значение бита с номером \"%s\" = \"%s\".";
private const string UNSUPPORTED_TYPE_FOR_BIT_OPERATION_ERROR = "Неподдерживаемый тип для выполнения битовых операций. Допустипы только целочисленные типы";

// Статусы выполнения команд
// Успешно
private const int Success = 0;

// Внутренняя ошибка WinCC OA
private const int WinccOaError = 1;

// Ошибка сравнения
private const int ComparisonError = 2;

// Сработала сигнализация 
private const int AlarmCame = 3;

// Неподдерживаемый тип данных
private const int UnsupportedTypeError = 4;

/// Положения ключа ДУ
/// Положение ключа в положении Освобождено
private const int RemoteKeyPositionReleased = 0;

/// Положение ключа в положении ГЭС
private const int RemoteKeyPositionHpp = 1;

/// Положение ключа в положении ОДУ
private const int RemoteKeyPositionJsc = 2;

/// Положение ключа не определено
private const int RemoteKeyPositionNone = 3;

// Логирование
// Ключ для включения логов скрипта 
private const string LogCommandsFlag = "LogCommands";
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

/** Выполнить команды
  @param commands Список команд
  @return Возвращает структуру в формате json {Status, FailedCommandIndex},
          в случае успеха Status и FailedCommandIndex равны 0,
          в случае ошибки Status равен коду ошибки, а FailedCommandIndex равен номеру команды, на которой произошла ошибка (нумерация идет с 1)
*/
public mapping ExecuteCommands(dyn_mapping commands)
{
  int failedCommandIdx = 0;
  string errorMessage = "";
  int status = Success;
  bool isNeedWrite = true;
  int remoteKeyPosition = RemoteKeyPositionNone;
  string responseDetails;

  DebugFN(LogCommandsFlag , "Начата обработка команд: ", commands);

  if(!determineRemoteKeyPosition(commands, remoteKeyPosition, status, failedCommandIdx, errorMessage, responseDetails))
  {
    return makeResult(failedCommandIdx, status, remoteKeyPosition, responseDetails);
  }
  else if(remoteKeyPosition == RemoteKeyPositionJsc)
  {
    isNeedWrite = false;
  }

  for(int i = 1; i <= dynlen(commands); i++)
  {
    if(commands[i][COMMAND_KIND_IDX] == CONTROL_KEY_POSITION_COMMAND_KIND)
    {
      continue;
    }

    if(commands[i][COMMAND_KIND_IDX] == STANDARD_COMMAND_KIND && commands[i][COMMAND_DELAY_BEFORE_EXECUTION_MSEC_IDX] > 0)
    {
        DebugFN(LogCommandsFlag, "Выполняется ожидание перед выполнением команды: " + commands[i][COMMAND_DELAY_BEFORE_EXECUTION_MSEC_IDX] + " мсек.");
        delay(0, commands[i][COMMAND_DELAY_BEFORE_EXECUTION_MSEC_IDX]);
    }

    switch(commands[i][COMMAND_TYPE_IDX])
    {
      case VERIFY_COMMAND:
      {
        switch(commands[i][COMMAND_KIND_IDX])
        {
          case STANDARD_COMMAND_KIND:
          {
            DebugFN(LogCommandsFlag, "Выполняется команда чтения.");      
            status = executeVerifyCommand(commands[i][TAG_ADDRESS_IDX], commands[i][VALUE_IDX], errorMessage, responseDetails);
            DebugFN(LogCommandsFlag, "Команда чтения завершена.");
            break;
          }
          case ALARM_COMMAND_KIND:
          {
            status = executeAlarmCommand(commands[i][TAG_ADDRESS_IDX], commands[i][VALUE_IDX], errorMessage, responseDetails);
            break;
          }
          case CHECK_DP_COMMAND_KIND:
          {
            status = dpExists(commands[i][TAG_ADDRESS_IDX]) ? Success : WinccOaError;
            break;
          }
          case TAG_TREE_COMMAND_KIND:
          {
            dyn_dyn_mixed tree = GetTagTree();
            responseDetails = jsonEncode(tree);
            break;
          }
          default:
          {
            errorMessage = "Не удалось распознать вид команды: " + commands[i][COMMAND_KIND_IDX];
            responseDetails = errorMessage;
            throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
            status = WinccOaError;
            break;
          }
        }
        break;
      }
      case WRITE_COMMAND:
      {
        if(isNeedWrite)
        {
          status = executeWriteCommand(commands[i][TAG_ADDRESS_IDX], commands[i][VALUE_IDX], errorMessage, responseDetails);
        }
        else
        {
          DebugFN(LogCommandsFlag, "Команда на запись пропускается, так как ключ ДУ в положении ОДУ.");
        }

        break;
      }
      case VERIFY_BIT_COMMAND:
      {
        DebugFN(LogCommandsFlag, "Выполняется команда чтения бита.");
        status = executeVerifyBitCommand(commands[i][TAG_ADDRESS_IDX], commands[i][COMMAND_BIT_NUMBER_IDX], commands[i][COMMAND_BIT_VALUE_IDX], errorMessage, responseDetails);
        DebugFN(LogCommandsFlag, "Команда чтения бита завершена.");
        break;
      }
      case WRITE_BIT_COMMAND:
      {
        if(isNeedWrite)
        {
          status = executeWriteBitCommand(commands[i][TAG_ADDRESS_IDX], commands[i][COMMAND_BIT_NUMBER_IDX], commands[i][COMMAND_BIT_VALUE_IDX], errorMessage, responseDetails);
        }
        else
        {
          DebugFN(LogCommandsFlag, "Команда на запись бита пропускается, так как ключ ДУ в положении ОДУ.");
        }

        break;
      }
      default:
      {
        errorMessage = "Не удалось распознать тип команды: " + commands[i][COMMAND_TYPE_IDX];
        responseDetails = errorMessage;
        throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
        status = WinccOaError;
        break;
      }
    }

    if(status != Success)
    {
      DebugFN(LogCommandsFlag , "Выполнение команд будет прервано. Статус последней выполненной команды: \"" + status + "\"");
      failedCommandIdx = i;
      break;
    }

    if(commands[i][COMMAND_KIND_IDX] == STANDARD_COMMAND_KIND && commands[i][COMMAND_DELAY_AFTER_EXECUTION_MSEC_IDX] > 0)
    {
      DebugFN(LogCommandsFlag, "Выполняется ожидание после выполнения команды: " + commands[i][COMMAND_DELAY_AFTER_EXECUTION_MSEC_IDX] + " мсек.");
      delay(0, commands[i][COMMAND_DELAY_AFTER_EXECUTION_MSEC_IDX]);
    }
  }

  return makeResult(failedCommandIdx, status, remoteKeyPosition, responseDetails);
}

//--------------------------------------------------------------------------------
//@private members

/** Определить положение ключа ДУ
  @param commands Команды
  @param remoteKeyPosition Положение ключа
  @param status Статус выполнения
  @param failedCommandIdx Индекс команды с ошибкой
  @param errorMessage Сообщение об ошибки
  @param responseDetails Детали для ответа
  @return Возвращает true в случае успешного определения или если не найдена команда для определения положения, иначе false
*/
private bool determineRemoteKeyPosition(dyn_mapping& commands, int& remoteKeyPosition, int& status, int& failedCommandIdx, string& errorMessage, string& responseDetails)
{
  for(int i = 1; i <= dynlen(commands); i++)
  {
    if(commands[i][COMMAND_TYPE_IDX] == VERIFY_COMMAND && commands[i][COMMAND_KIND_IDX] == CONTROL_KEY_POSITION_COMMAND_KIND)
    {
      DebugFN(LogCommandsFlag, "Выполняется команда определения положения ключа ДУ.", commands[i]);

      string tagAddress = GetFullDpAddress(commands[i][TAG_ADDRESS_IDX]);

      if(!dpExists(tagAddress))
      {
        sprintf(errorMessage, GET_TAG_ERROR, tagAddress);
        responseDetails = errorMessage;
        throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage, getLastError()));
        DebugFN(LogCommandsFlag, errorMessage);
        status = WinccOaError;
        failedCommandIdx = i;
        return false;
      }

      anytype remoteKeyPostionValue;
      int returnCode = dpGet(tagAddress, remoteKeyPostionValue);
       
      if(returnCode != 0)
      {
        errorMessage = "Не удалось получить значение точки данных с адресом: " + tagAddress;
        responseDetails = errorMessage;
        throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
        DebugFN(LogCommandsFlag, errorMessage);
        status = WinccOaError;
        failedCommandIdx = i;
        return false;
      }
       
      switch(remoteKeyPostionValue)
      {
        case RemoteKeyPositionReleased:
        {
          DebugFN(LogCommandsFlag, "Ключ ДУ в положении Освобождено. Запись разрешена.");
          remoteKeyPosition = RemoteKeyPositionReleased;
          return true;
        }
        case RemoteKeyPositionHpp:
        {
          DebugFN(LogCommandsFlag, "Ключ ДУ в положении ГЭС. Запись разрешена.");
          remoteKeyPosition = RemoteKeyPositionHpp;
          return true;
        }
        case RemoteKeyPositionJsc:
        {
          DebugFN(LogCommandsFlag, "Ключ ДУ в положении ОДУ. Запись запрещена.");
          remoteKeyPosition = RemoteKeyPositionJsc;
          status = Success;
          return true;
        }
        default:
        {
          responseDetails = "Не удалось определить положение ключа ДУ. \n Значение ключа равно: \""  + remoteKeyPostionValue + "\"";
          DebugFN(LogCommandsFlag, responseDetails);
          status = WinccOaError;
          failedCommandIdx = i;
          return false;
        }
      }
    }
  }

  return true;
}

/** Сформировать результат выполнения команд
  @param failedCommandIdx Индекс команды с ошибкой
  @param status Статус выполнения команд
  @param remoteKeyPosition Позиция ключа ДУ
  @param details Содержит дополнительную информацию
  @return
*/
private mapping makeResult(int failedCommandIdx, int status, int remoteKeyPosition, string details)
{
  mapping result = makeMapping("FailedCommandIndex", failedCommandIdx,
                               "Status", status,
                               "RemoteControlKeyPosition", remoteKeyPosition,
                               "Details", details);

  DebugFN(LogCommandsFlag, "Результат: ", result);

  return result;
}

/** Прочитать значение и сравнить с эталонным
  @param tagAddress Адрес тэга точки данных
  @param referenceValue Эталонное значение
  @param errorMessage Сообщение об ошибки
  @param responseDetails Детали для ответа
  @return Возвращает статус выполнения команды
*/
private int executeVerifyCommand(string tagAddress, string referenceValue, string& errorMessage, string& responseDetails)
{
  tagAddress = GetFullDpAddress(tagAddress);

  DebugFN(LogCommandsFlag, "Выполняется проверка значения тэга с адресом \"" + tagAddress + "\". Ожидаемое значение: \"" + referenceValue + "\".");
  if(!dpExists(tagAddress))
  {
    sprintf(errorMessage, GET_TAG_ERROR, tagAddress);
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage, getLastError()));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  int type = dpElementType(tagAddress);

  if(type == -1)
  {
    sprintf(errorMessage, GET_TYPE_ERROR, tagAddress);
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  anytype value;
  int result = dpGet(tagAddress, value);

  if(result != 0)
  {
    errorMessage = "Не удалось получить значение точки данных с адресом: " + tagAddress;
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  switch(type)
  {
    case DPEL_FLOAT:
    {
      result = strreplace(referenceValue, ",", ".");

      if(result != 0)
      {
          sprintf(errorMessage, CONVERT_TO_FLOAT_FORMAT_ERROR, referenceValue);
          responseDetails = errorMessage;
          throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
          DebugFN(LogCommandsFlag, errorMessage);
          return WinccOaError;
      }

      if((float)value != (float)referenceValue)
      {
          sprintf(errorMessage, ERROR_COMPARISON_TEXT, tagAddress, (string)referenceValue, (string)value);
          sprintf(responseDetails, COMPARISON_DETAILS, (string)value);
          DebugFN(LogCommandsFlag, errorMessage);
          return ComparisonError;
      }

      break;
    }
    case DPEL_BOOL:
    {
      if((bool)value != (bool)referenceValue)
      {
        sprintf(errorMessage, ERROR_COMPARISON_TEXT, tagAddress, (string)referenceValue, (string)value);
        sprintf(responseDetails, COMPARISON_DETAILS, (string)value);
        DebugFN(LogCommandsFlag, errorMessage);
        return ComparisonError;
      }

      break;
    }
    default:
    {
      if((string)value != referenceValue)
      {
        sprintf(errorMessage, ERROR_COMPARISON_TEXT, tagAddress, (string)referenceValue, (string)value);
        sprintf(responseDetails, COMPARISON_DETAILS, (string)value);
        DebugFN(LogCommandsFlag, errorMessage);
        return ComparisonError;
      }

      break;
    }
  }

  DebugFN(LogCommandsFlag, "Полученное значение равно ожидаемому.");
  return Success;
}

/** Записать значение точки данных
  @param tagAddress Адрес тэга
  @param value Значение для записи
  @param errorMessage Сообщение об ошибки
  @param responseDetails Детали для ответа
  @return Возвращает статус выполнения команды
*/
private int executeWriteCommand(string tagAddress, string value, string& errorMessage, string& responseDetails)
{
  DebugFN(LogCommandsFlag, "Выполняется запись значения \"" + value + "\" по адресу \"" + tagAddress, "\".");
  tagAddress = GetFullDpAddress(tagAddress);

  if(!dpExists(tagAddress))
  {
    sprintf(errorMessage, GET_TAG_ERROR, tagAddress);
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage, getLastError()));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  int type = dpElementType(tagAddress);

  if(type == -1)
  {
    sprintf(errorMessage, GET_TYPE_ERROR, tagAddress);
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  int result;
  if(type == DPEL_FLOAT)
  {
    // Для типа float заменяем "," на ".", чтобы выполнить корректную установку значения,
    // если указали в качестве десятичного разделителя ",", WinCC OA в качестве десятичного разделителя использует "."
    result = strreplace(value, ",", ".");
    if(result == -1)
    {
      sprintf(errorMessage, CONVERT_TO_FLOAT_FORMAT_ERROR, value);
      responseDetails = errorMessage;
      throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
      DebugFN(LogCommandsFlag, errorMessage);
      return WinccOaError;
    }
  }

  result = dpSetWait(tagAddress, value);

  if(result != 0)
  {
    errorMessage = "Не удалось записать значение \"" + value + "\" по адресу \"" + tagAddress + "\".";
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  DebugFN(LogCommandsFlag, "Запись успешно выполнена.");
  return Success;
}

/** Выполнить команду проверки сигнализации
  @param tagAddress Адрес тэга
  @param value Значение для проверки (значение, в котором считается, что сигнализация включена)
  @param errorMessage Сообщение об ошибки
  @param responseDetails Детали для ответа
  @return Возвращает статус выполнения команды
*/
private int executeAlarmCommand(string tagAddress, string referenceValue, string& errorMessage, string& responseDetails)
{
  DebugFN(LogCommandsFlag, "Выполняется проверка существования аварийной сигнализации.");
  int status = executeVerifyCommand(tagAddress, referenceValue, errorMessage, responseDetails);
  
  switch(status)
  {
    case Success:
    {
      DebugFN(LogCommandsFlag, "Включена аварийная сигнализация.");
      status = AlarmCame;
      break;
    }
    case ComparisonError:
    {
      DebugFN(LogCommandsFlag, "Аварийная сигнализация не включена.");
      status = Success;
      break;
    }
    case WinccOaError:
    {
      responseDetails = "Ошибка определения статуса проверки сигнализации.\n" + responseDetails;
      break;
    }
    default:
    {
      responseDetails = "Не удалось распознать существования аварийной сигнализации.\n" + responseDetails;
      DebugFN(LogCommandsFlag, responseDetails);
      status = WinccOaError;
      break;
    }
  }
  
  DebugFN(LogCommandsFlag, "Проверка аварийной сигнализации выполнена.");
  return status;
}

/** Выполнить команду проверки бита
  @param tagAddress Адрес тэга
  @param value Значение с информацией о бите (НомерБита;ЗначениеБита)
  @param errorMessage Сообщение об ошибки
  @param responseDetails Детали для ответа
  @return Возвращает статус выполнения команды
*/
private int executeVerifyBitCommand(string tagAddress, int bitNumber, int referenceBitValue, string& errorMessage, string& responseDetails)
{
  DebugFN(LogCommandsFlag, "Выполняется проверка значения бита тэга с адресом \"" + tagAddress + "\". Ожидаемое значение: \"" + referenceBitValue + "\".");

  tagAddress = GetFullDpAddress(tagAddress);
  if(!dpExists(tagAddress))
  {
    sprintf(errorMessage, GET_TAG_ERROR, tagAddress);
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage, getLastError()));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  int type = dpElementType(tagAddress);
  if(type == -1)
  {
    sprintf(errorMessage, GET_TYPE_ERROR, tagAddress);
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  if(!isAvailableTypeForBitOperation(type, errorMessage, responseDetails))
  {
    return UnsupportedTypeError;
  }

  bit64 value;
  int result = dpGet(tagAddress, value);
  if(result != 0)
  {
    errorMessage = "Не удалось получить значение точки данных с адресом: " + tagAddress;
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  int bitValue = getBit(value, bitNumber);
  if(bitValue != referenceBitValue)
  {
    sprintf(errorMessage, ERROR_COMPARISON_BIT_TEXT, (string)bitNumber, tagAddress, referenceBitValue, bitValue);
    sprintf(responseDetails, COMPARISON_BIT_DETAILS, (string)bitNumber, (string)bitValue);
    DebugFN(LogCommandsFlag, errorMessage);

    return ComparisonError;
  }

  DebugFN(LogCommandsFlag, "Полученное значение равно ожидаемому.");
  return Success;
}

/** Выполнить команду записи бита
  @param tagAddress Адрес тэга
  @param value Значение с информацией о бите (НомерБита;ЗначениеБита)
  @param errorMessage Сообщение об ошибки
  @param responseDetails Детали для ответа
  @return Возвращает статус выполнения команды
*/
private int executeWriteBitCommand(string tagAddress, int bitNumber, int referenceBitValue, string& errorMessage, string& responseDetails)
{
  DebugFN(LogCommandsFlag, "Выполняется запись бита \"" + referenceBitValue + "\" с номером \"" + bitNumber + "\" по адресу \"" + tagAddress, "\".");

  tagAddress = GetFullDpAddress(tagAddress);

  if(!dpExists(tagAddress))
  {
    sprintf(errorMessage, GET_TAG_ERROR, tagAddress);
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage, getLastError()));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  int type = dpElementType(tagAddress);
  if(type == -1)
  {
    sprintf(errorMessage, GET_TYPE_ERROR, tagAddress);
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  if(!isAvailableTypeForBitOperation(type, errorMessage, responseDetails))
  {
    return UnsupportedTypeError;
  }

  bit64 value;
  int result = dpGet(tagAddress, value);

  if(result != 0)
  {
    errorMessage = "Не удалось получить значение точки данных с адресом: " + tagAddress;
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  result = setBit(value, bitNumber, (referenceBitValue == 1) ? true : false);

  if(result != 0)
  {
    errorMessage = "Не удалось установить значение бита \"" + referenceBitValue + "\" c номером \"" + bitNumber + "\".";
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  result = dpSetWait(tagAddress, value);

  if(result != 0)
  {
    errorMessage = "Не удалось записать значение \"" + value + "\" по адресу \"" + tagAddress + "\".";
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);
    return WinccOaError;
  }

  DebugFN(LogCommandsFlag, "Запись бита успешно выполнена.");
  return Success;
}

/** Является ли тип точки данных допустимым для битовых операций 
  @param type Тип точки данных
  @param errorMessage Сообщение об ошибки
  @param responseDetails Детали для ответа
  @return Возвращает true, если тип данных разрешен, иначе false
*/
private bool isAvailableTypeForBitOperation(int type, string& errorMessage, string& responseDetails)
{
  if(type != DPEL_INT && type != DPEL_UINT && type != DPEL_BIT32 
    || (VERSION_NUMERIC > 313000 && type != DPEL_LONG && type != DPEL_ULONG && type != DPEL_ULONG && type != DPEL_BIT64))
  {
    errorMessage = UNSUPPORTED_TYPE_FOR_BIT_OPERATION_ERROR;
    responseDetails = errorMessage;
    throwError(makeError("", PRIO_SEVERE, ERR_CONTROL, 0, __FUNCTION__ , errorMessage));
    DebugFN(LogCommandsFlag, errorMessage);

    return false;
  }

  return true;
}