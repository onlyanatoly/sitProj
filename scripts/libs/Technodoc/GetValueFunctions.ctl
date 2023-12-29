#uses "TimeFunctionsTD.ctl"

const int PERIOD_RESULT_VALUE = 1;
const int PERIOD_RESULT_STATUS = 2;
const int PERIOD_RESULT_TIME = 3;

// возвращает массив: значение, статус и время
public dyn_string GetByFunctionName(string dp, time startTime, time endTime, string functionName)
{
  dyn_string result;
  string correctAddress = GetCorrectDpAddress(dp);
  
  switch (strtolower(functionName))
  {
    case "getdatapointvalue":
      result = GetDatapointValue(correctAddress);
      break;
            
    case "getdatapointvalueontime":
      result = GetDatapointValueOnTime(correctAddress, startTime);
      break;
      
    case "getlastdatapointvalue":
      result = GetLastDatapointValue(correctAddress, endTime);
      break;
      
    case "getlastdatapointvalueonperiod":
      result = GetLastDatapointValueOnPeriod(correctAddress, startTime, endTime);
      break;
      
    case "getmaxdatapointvalue":
      result = GetMaxDatapointValue(correctAddress, startTime, endTime);
      break;
      
    case "getmindatapointvalue":
      result = GetMinDatapointValue(correctAddress, startTime, endTime);
      break;
      
    case "getaveragedatapointvalue":
      result = GetAverageDatapointValue(correctAddress, startTime, endTime);
      break;
    case "getmaxcontinuousdatapointvalue":
      result = GetMaxContinuousDatapointValue(correctAddress, startTime, endTime);
      break;
      
    case "getmincontinuousdatapointvalue":
      result = GetMinContinuousDatapointValue(correctAddress, startTime, endTime);
      break;
      
    case "getaveragecontinuousdatapointvalue":
      result = GetAverageContinuousDatapointValue(correctAddress, startTime, endTime);
      break;
      
    case "getsumdatapointvalue":
      result = GetSumDatapointValue(correctAddress, startTime, endTime);
      break;
      
    case "getcountdatapointvalue":
      result = GetCountDatapointValue(correctAddress, startTime, endTime);
      break;

    case "getweightaveragedatapointvalue":
      result = GetWeightAverageDatapointValue(correctAddress, startTime, endTime);
      break;
  }
    
  return result;
}

// Возвращает текущее значение тега, статус и время
private dyn_string GetDatapointValue(string dp)
{
  dyn_string result;
  string val = "", tim = "";
  bool badStat = true;
  
  if (dp != "")
  {
    dpGet(dp, val);
    dpGet(dp + ":_offline.._stime", tim);
    dpGet(dp + ":_offline.._bad", badStat);
  }
        
  dynAppend(result, val);
  dynAppend(result, ConvertBoolStatusToString(badStat));
  dynAppend(result, tim);
  return result;
}

// Возвращает значение тега на метку времени, статус и время
private dyn_string GetDatapointValueOnTime(string dp, time timestamp)
{
  return dpGetAsyncEx(dp, timestamp);
}

// Возвращает значение юзербита на метку времени, статус и время
public dyn_string GetUserbitValueOnTime(string dp, time timestamp, int bitNumber)
{
 dp = GetFullDpAddress(dp);
 return dpGetAsyncEx(dp + ":_offline.._userbit" + bitNumber, timestamp);
}

// Возвращает последнее значение тега, статус и время
private dyn_string GetLastDatapointValue(string dp, time endTime)
{
  return dpGetAsyncEx(dp, AddMillisecondsTD(endTime, -1));
}

// Возвращает последнее значение тега, статус и время на период
private dyn_string GetLastDatapointValueOnPeriod(string dp, time startTime, time endTime)
{
  dyn_string result;
  dyn_string value = GetDatapointValueOnTime(dp, endTime);
  if ((time)value[3] < startTime)
  {
    dynAppend(result, "");
    dynAppend(result, "");
    dynAppend(result, "");
    return result;
  }
  return value;
}

// Возвращает максимальное значение тега за промежуток времени, статус и время
private dyn_string GetMaxDpValue(string dp, time startTime, time endTime, bool useInitialValue)
{
  dyn_string result;
  
  dyn_dyn_mixed values = GetPeriodValues(dp, startTime, endTime);  
  int count = dynlen(values);
  
  dyn_string firstValue = GetDatapointValueOnTime(dp, startTime);
  if(useInitialValue && (startTime > (time)firstValue[PERIOD_RESULT_TIME]) && (count == 0 || startTime < (time)values[1][PERIOD_RESULT_TIME]))
  {
    useInitialValue = true;
    dynInsertAt(values, makeDynMixed(firstValue[PERIOD_RESULT_VALUE], firstValue[PERIOD_RESULT_STATUS], firstValue[PERIOD_RESULT_TIME]), 1);
  }
  
  count = dynlen(values);
  if (count == 0)
  {
    dynAppend(result, "");
    dynAppend(result, "");
    dynAppend(result, "");
    return result;
  }

  result = values[1];
  for (int i = 1; i <= count; i++)
  {
    if ((float)values[i][PERIOD_RESULT_VALUE] > (float)result[PERIOD_RESULT_VALUE])
      result = values[i];
  }

  return result;
}

// Возвращает максимальное значение тега за промежуток времени, статус и время
private dyn_string GetMaxDatapointValue(string dp, time startTime, time endTime)
{
  return GetMaxDpValue(dp,startTime,endTime, false);
}

private dyn_string GetMaxContinuousDatapointValue(string dp, time startTime, time endTime)
{
  return GetMaxDpValue(dp, startTime, endTime, true);
}

// Возвращает минимальное значение тега за промежуток времени, статус и время
private dyn_string GetMinDpValue(string dp, time startTime, time endTime, bool useInitialValue)
{
  dyn_string result;
  
  dyn_dyn_mixed values = GetPeriodValues(dp, startTime, endTime);
  int count = dynlen(values);
     
  dyn_string firstValue = GetDatapointValueOnTime(dp, startTime);
  if(useInitialValue && (startTime > (time)firstValue[PERIOD_RESULT_TIME]) && (count == 0 || startTime < (time)values[1][PERIOD_RESULT_TIME]))
  {
    useInitialValue = true;
    dynInsertAt(values, makeDynMixed(firstValue[PERIOD_RESULT_VALUE], firstValue[PERIOD_RESULT_STATUS], firstValue[PERIOD_RESULT_TIME]), 1);
  }
   
  count = dynlen(values);
  if (count == 0)
  {
    dynAppend(result, "");
    dynAppend(result, "");
    dynAppend(result, "");
    return result;
  }
  
  result = values[1];
  for (int i = 1; i <= count; i++)
  {
    if ((float)values[i][PERIOD_RESULT_VALUE] < (float)result[PERIOD_RESULT_VALUE])
      result = values[i];
  }

  return result;
}

private dyn_string GetMinDatapointValue(string dp, time startTime, time endTime)
{
  return GetMinDpValue(dp, startTime, endTime, false);
}

private dyn_string GetMinContinuousDatapointValue(string dp, time startTime, time endTime)
{
  return GetMinDpValue(dp, startTime, endTime, true);
}

// Возвращает среднее значение тега за промежуток времени
private float GetAverageDpValue(string dp, time startTime, time endTime, bool useInitialValue)
{
  float sum = 0;

  dyn_dyn_mixed values = GetPeriodValues(dp, startTime, endTime);
  int count = dynlen(values);
  
  dyn_string firstValue = GetDatapointValueOnTime(dp, startTime);
  if(useInitialValue && (startTime > (time)firstValue[PERIOD_RESULT_TIME]) && (count == 0 || startTime < (time)values[1][PERIOD_RESULT_TIME]))
  {
    useInitialValue = true;
    sum += firstValue[PERIOD_RESULT_VALUE];
  }
  else 
  {
    useInitialValue = false;
  }    
  
  if (count == 0 && !useInitialValue)
    return 0;
    
  for (int i = 1; i <= count; i++)
  {
    sum = sum + values[i][PERIOD_RESULT_VALUE];
  }
    
  return sum / ( useInitialValue ? count+1 : count);
}

private float GetAverageDatapointValue(string dp, time startTime, time endTime)
{
  return GetAverageDpValue(dp, startTime, endTime, false);
}

private float GetAverageContinuousDatapointValue(string dp, time startTime, time endTime)
{
  return GetAverageDpValue(dp, startTime, endTime, true);
}

// Возвращает сумму значений тега за промежуток времени
private float GetSumDatapointValue(string dp, time startTime, time endTime)
{
  dyn_dyn_mixed values = GetPeriodValues(dp, startTime, endTime);
  int count = dynlen(values);
    
  if (count == 0)
    return 0;
    
  float sum = 0;
  for (int i = 1; i <= count; i++)
  {
    sum = sum + values[i][PERIOD_RESULT_VALUE];
  }
  
  //DebugTN("xmlrpc|GetSumDatapointValue|" + dp + ": за период " + (string)startTime + " - " + (string)endTime + ": " + (string)count + " = " + (string)sum);
    
  return sum;
}

// Возвращает количество значений тега за промежуток времени
private int GetCountDatapointValue(string dp, time startTime, time endTime)
{
  dyn_dyn_mixed values = GetPeriodValues(dp, startTime, endTime);
  return dynlen(values);
}

// Возвращает средневзвешенное значение тега за промежуток времени
private float GetWeightAverageDatapointValue(string dp, time startTime, time endTime)
{   
    dyn_dyn_mixed values = GetPeriodValues(dp, startTime, endTime);
    int count = dynlen(values);
    
    float sum = 0;
    float weightsum = 0;
    
    bool useInitialValue = false;
    dyn_string firstValue = GetDatapointValueOnTime(dp, startTime);
    if(startTime > (time)firstValue[PERIOD_RESULT_TIME] && (count == 0 || startTime < (time)values[1][PERIOD_RESULT_TIME]))
    {
      useInitialValue = true;
    } 
    
    
    if (count == 0 && !useInitialValue)
        return 0;
    
    if(useInitialValue)
    {
      time startInterval = startTime;
        
      time endInterval = count > 0? values[1][PERIOD_RESULT_TIME] : endTime ;
      int weight = period(endInterval - startInterval);
      sum = sum + (float)firstValue[PERIOD_RESULT_VALUE] * weight;
      weightsum = weightsum + weight;
          }
    
    for (int i = 1; i <= count; i++)
    {
        time startInterval = values[i][PERIOD_RESULT_TIME];
        if (startInterval < startTime)
            startInterval = startTime;
        
        time endInterval;
        if (i + 1 > count)
            endInterval = endTime;
        else
            endInterval = values[i + 1][PERIOD_RESULT_TIME];
        
        int weight = period(endInterval - startInterval);
        
        sum = sum + values[i][PERIOD_RESULT_VALUE] * weight;
        weightsum = weightsum + weight;
    }
    
    return sum / weightsum;
}

// Возвращает массив массивов строк со значениями тега за промежуток времени
// массивы строк содержат в себе [значение, статус, метка времени]
public dyn_dyn_string GetDatapointValuesOnPeriod(string dp, time startTime, time endTime)
{
  string correctAddress = GetCorrectDpAddress(dp);
  dyn_dyn_mixed values = GetPeriodValues(correctAddress, startTime, endTime);
  
  dyn_dyn_string result;
  for (int i = 1; i <= dynlen(values); i++)
  {
    dynAppend(result,
      makeDynString(values[i][PERIOD_RESULT_VALUE],
        values[i][PERIOD_RESULT_STATUS],
        formatTime("%d.%m.%Y %H:%M:%S", values[i][PERIOD_RESULT_TIME], ".%d")));
  }
    
  return result;
}

// Возвращает значение тега на метку времени, статус и время
// Если у тега не задан архив, вернется текущее значение тега
private dyn_string dpGetAsyncEx(string dp, time timestamp)
{
  dyn_string result;
  string val = "", tim = ""; 
  bool badStatus = false;
  
  string start = TimeToStringForUtcTD(AddMillisecondsTD(timestamp, -1)), end = TimeToStringForUtcTD(timestamp);
  dyn_string istDP = strsplit(dp, ":");

  string configToRead = "_offline.._value";
  //если 3 элемента в массиве, значит мы передали конфиг, который хотим прочитать
  if(dynlen(istDP) == 3)
  {
      configToRead = istDP[3];
      dp = istDP[1] + ":" + istDP[2];
  }
  
  dyn_dyn_anytype resultQuery;  
  string sQuery = "SELECT '" + configToRead + "', '_offline.._stime', '_offline.._bad' FROM \'" + dp +
    "\' REMOTE \'" + istDP[1] + ":\' TIMERANGE(\"" + start + "\",\"" + end + "\",1,1)";
  
  dpQuery(sQuery,	resultQuery);
  
  /// Функция dpQuery с запросом SELECT ... TIMERANGE(startTs, endTs, modus, bonus) со значением bonus = 1
  /// должна возвращать все значения в интервале от startTs до endTs плюс как минимум одно значение до и после интервала.
  /// 
  /// Но, начиная с какого-то времени из прошлого точки, функция перестает возвращать значения.
  /// Т.о., dpQuery не вернет значения в двух случаях: 1) у точки не задан архив, 2) архив есть, но выполняется описанный выше баг винсиси.

  if (dynlen(resultQuery) > 1)
  {    
    for(int i = 2; i <= dynlen(resultQuery); i++) {
    
	  time lastTime = (time)tim;
      if(timestamp >= resultQuery[i][3] && lastTime <= resultQuery[i][3]){
        val = (string)resultQuery[i][2];
        tim = (string)resultQuery[i][3];
        badStatus = (bool)resultQuery[i][4];
      }      
    }       
  }
  else
  {
      // проверяем наличие архива
      string archName;
      dpGet(dp + ":_archive.1._class", archName);
      bool hasArchive = archName != ""; 
      
      if (!hasArchive)
      {
          dpGet(dp, val);
          dpGet(dp + ":_offline.._stime", tim);
      }
  }

  if (val == "") {
    val = "-";
    tim = end;  
  }  
  
  dynAppend(result, val);
  dynAppend(result, ConvertBoolStatusToString(badStatus));
  dynAppend(result, tim);
    
  return result;
}

// Возвращает массив массивов объектов со значениями тега за промежуток времени
// массивы строк содержат в себе [значение, статус, метка времени]
private dyn_dyn_mixed GetPeriodValues(string dp, time startTime, time endTime)
{
  dyn_dyn_mixed result;
    
  dyn_float values;
  dyn_time times;
  dyn_bool badStatuses;
  GetPeriod(startTime, endTime, dp, values, times, badStatuses);
  
  for (int i = 1; i <= dynlen(values); i++)
  {
    if( times[i] < endTime )  
    {
      dynAppend(result, makeDynMixed(values[i], ConvertBoolStatusToString(badStatuses[i]), times[i]));
    }
  }
    
  return result;
}

// Замена dpGetPeriod на dpQuery
public void GetPeriod(time startTime, time endTime, string dp, dyn_string& values, dyn_string& times, dyn_bool& badStatuses)
{
  dp = GetFullDpAddress(dp);
  int secInPart = 86400 / 2;
  float parts = (float)(endTime - startTime) / secInPart;
  int fullParts = (int)parts;
  float residueParts = parts - fullParts;
  dyn_dyn_anytype result;
  string start, end, sQuery;
  dyn_string istDP = strsplit(dp, ":");
  for (int d = 0; d < fullParts; d++)
  {
    start = TimeToStringForUtcTD(startTime + (secInPart*d));
    end = TimeToStringForUtcTD(startTime + (secInPart*d) + secInPart);  
    
    //DebugN(start,end);
    sQuery = "SELECT '_offline.._value', '_offline.._stime', '_offline.._bad' FROM \'" + dp +
      "\' REMOTE \'" + istDP[1] + ":\' TIMERANGE(\"" + start + "\",\"" + end + "\",1,0)";
    //DebugTN(sQuery);
    dpQuery(sQuery,	result);
    for(int i = 2; i <= dynlen(result); i++)
    {     
       if(end == TimeToStringForUtcTD(result[i][3]))continue;
       dynAppend(values, (string)result[i][2]);
       dynAppend(times, (string)result[i][3]);
       dynAppend(badStatuses, (bool)result[i][4]);
    }
  }
  
  if (residueParts > 0) {
    start = TimeToStringForUtcTD(endTime - (residueParts*secInPart));
    end = TimeToStringForUtcTD(endTime);  
    sQuery = "SELECT '_offline.._value', '_offline.._stime', '_offline.._bad' FROM \'" + dp +
      "\' REMOTE \'" + istDP[1] + ":\' TIMERANGE(\"" + start + "\",\"" + end + "\",1,0)";
    //DebugTN(sQuery);
    dpQuery(sQuery,	result);
    for(int i = 2; i <= dynlen(result); i++)
    {
       if(end == TimeToStringForUtcTD(result[i][3]))continue;
       dynAppend(values, (string)result[i][2]);
       dynAppend(times, (string)result[i][3]);
       dynAppend(badStatuses, (bool)result[i][4]); 
    }
  }
}

private string ConvertBoolStatusToString(bool badStatus)
{  
  if (badStatus)
  {
    return "Bad";
  }
  else
  {
  return "Good";  
  }
}


/*
  Получает значения по списку тегов на определённые метки времени
  
  Вход: 
    timedParameters
        1 - айдишник (возвращается назад для идентификации) 
        2 - адрес тега
        3 - временная метка начала периода
        4 - временная метка конца периода
    funcName - имя ф-ии    
        
  Выход: 1 - айдишник
         2 - значение 
*/
public dyn_dyn_string BulkGet(dyn_dyn_string timedParameters, string funcName)
{
    const int ID_FIELD_INDEX = 1;
    const int DATAPOINT_FIELD_INDEX = 2;
    const int TIMESTAMP_FIELD_INDEX = 3;
    const int TIMESTAMP_END_FIELD_INDEX = 4;
  
    dyn_dyn_string result;
  
    for (int i = 1; i <= dynlen(timedParameters); i++)
    {
        if (!dpExists(timedParameters[i][DATAPOINT_FIELD_INDEX]))
        { 
            dynAppend(result, makeDynString(timedParameters[i][ID_FIELD_INDEX], ""));
            continue;
        }

        dyn_string value = GetByFunctionName(timedParameters[i][DATAPOINT_FIELD_INDEX], 
                                         timedParameters[i][TIMESTAMP_FIELD_INDEX], 
                                         timedParameters[i][TIMESTAMP_END_FIELD_INDEX], 
                                         funcName);

        dynAppend(result, makeDynString(timedParameters[i][ID_FIELD_INDEX], value[1]));
    }
    
    return result;
}

// 	Получает сжатое значение точки данных dp в момент времени timestamp
public string GetCompressedDatapointValueOnTime(string dp, time timestamp)
{
    string correctAddress = GetCorrectDpAddress(dp);   
    string res; 
    dyn_string valueParts;
    dyn_time ts;
   
    dpGetPeriod(timestamp, AddMillisecondsTD(timestamp, 999), 0, correctAddress, valueParts, ts);
    
    if(dynlen(valueParts) > 0)
    { 
        // valueParts[1] = значение за 0 мсек = количество частей значения
        for(int i = 1; i <= (int)valueParts[1]; i++)
        {
           res += valueParts[i + 1];
        } 
    }
    
    return res;
}

///
/// Возвращает полный адрес тега address с именем системы.
///
/// Адрес тега address имеет вид - [SystemName:]tagName[:config]
/// Имя точки данных не должно совпадать с именем системы
///
/// Пример: System1:dpName:_address, dpName:_corr.._value, System1:dpName
///
public string GetCorrectDpAddress(string address)
{
   address = GetFullDpAddress(address);
   dyn_string array = strsplit(address, ":");

   dyn_string names;
   dyn_uint ids;
   getSystemNames(names, ids);
   
   // добавляем имя системы в двух случаях:
   // 1) если в address нет символа ":"
   // 2) если в address есть один символ ":" и он используется для разделения имени точки с именем системы, а не для разделения имени точки с именем конфигурации
   //
   // при проверке условия 1) используется функция strpos, а не dynlen(array) == 1, из-за того, что функция strsplit(address, ":") может вернуть массив с одним элементом
   //                         либо если в address нет символа ":", либо в address один символ ":" и он является последним элементом строки address;
   if(address != "" && (strpos(address, ":") == -1 || 
                        (dynlen(array) == 2 && array[1] != "" && !dynContains(names, array[1]))))
   {
       // если имя системы не указано, используем имя собственной системы
       // (сделано по аналогии со стандартными функциями работы с точками данных winccoa - dpGet, dpExists и т.д.)  
       string correctDpAddress = getSystemName() + address;
       if (dpExists(correctDpAddress)) {
           return correctDpAddress;
       }
   }

   return address;   
}

/** Получить полный адрес точки данных
  @param address Адрес тэга
  @return 
*/
public string GetFullDpAddress(string address)
{
  dyn_string nameParts = strsplit(address, ".");

  // Проверяем сколько уровней у точки, уровни разделяются символом '.', если у точки 1 уровень, то добавляем к имени '.'
  // необходимо для корректного чтения данных для проектов с типом NGA (NextGenArchiver)
  if(dynlen(nameParts) == 1 && strlen(address) > 1 && address[strlen(address) - 1] != ".")
  {
    address = address + ".";
  }

  return address;
}
