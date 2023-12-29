#uses "TimeFunctionsTD.ctl"

public string Echo(string arg)
{
    return arg;
}

public dyn_dyn_string Query(string query)
{
  time queryTime = getCurrentTime();
  dyn_dyn_anytype res;
  dpQuery(query, res);
  //file f = fopen("d:\\data\\sQuery.log", "r+");
  //string lg = "", st;
  //rewind(f); // Back to the beginning
  //while (feof(f)==0) 
  //{
  //  fgets(st,8000,f); 
  //  lg = lg + st;
  //}
  //rewind(f); // Back to the beginning
  //fputs(lg + (string)(queryTime) + " --- " + (string)(query) + " : " + (string)(dynlen(res)) + "\r\n", f);
  //fclose(f);
  return res;
}
/*dpGetDescriptionMode: 
   0 - если описание не задано, возвращает полное имя элемента точки данных, т.е. DP.DPE1.DPE2.DPE3.[...].DPEN
  -1 - если описание не задано, возвращает только имя элемента точки данных или имя точки данных, т.е. для элемента точки данных DP.DPE1.DPE2 вернет DPE2, а для точки DP. вернет DP,
 ... - см. справку WinCC OA для dpGetDescription*/
public string GetDescription(string address, int dpGetDescriptionMode = 0)
{
  string correctAddress = GetCorrectDpAddress(address);
  return (string)dpGetDescription(correctAddress, dpGetDescriptionMode);
}

public string EvalString(string code)
{
  DebugN("EvalString", code);
  string res;
  evalScript(res, code, "");
  return res;
}

public dyn_string EvalStringArray(string code)
{
  dyn_string res;
  evalScript(res, code, "");
  return res;
}

public dyn_dyn_string EvalStringDoubleArray(string code)
{
  dyn_dyn_string res;
  evalScript(res, code, "");
  return res;
}
    
/*
  Возвращает результат проверки тега address в виде массива строк, где
  [0] - текущее значение тега
  [1] - идентификатор статуса тега
  
  Список статусов тега:
  1 - нет архива
  2 - точка не создана
  3 - адрес не задан
  4 - точка создана, архив задан
*/
public dyn_string CheckDp(string address)
{
    dyn_string res;      
    bool exists = dpExists(address);
    
    int status = 0;
    string value = "";
    
    if (exists)
    {
      // точка создана
      string shortAddress = GetShortAddress(address);
      string archName;
      dpGet(shortAddress + ":_archive.1._class", archName);
      bool hasArchive = archName != ""; 

      dpGet(address, value);
      if (!hasArchive)
      {
        // нет архива
        status = 1;
      }
      else
      {
        // архив задан
        status = 4;
      }      
    }
    else
    {
      // точка не создана
      status = 2;
    }
    dynAppend(res, value);
    dynAppend(res, (string)status);
    
    return res;
}
/*
    Возвращает список аварий по указанному оборудованию на указанный момент времени
    
    Результат:
      0 - Текст алерта
      1 - Время прихода
      2 - Время ухода
*/
public dyn_dyn_string GetAlarms(string dp, time t)
{
    string correctAddress = GetCorrectDpAddress(dp); 
    dyn_dyn_string result;
  
    dyn_string dps = dpNames(correctAddress + ".Alm.*.*");

    for (int i = 1; i <= dynlen(dps); i++)
    {
        // Тег должен архивироваться, иначе нет исторических данных
        bool isArchived;
        dpGet(dps[i] + ":_archive.._archive", isArchived);
        
        if (!isArchived)
            continue;
        
        // В теге на заданный момент времени должен быть признак аварии
        bool isAlarm;
        dpGetAsynch(t, dps[i], isAlarm);
            
        if (!isAlarm)
            continue;
            
        dyn_string alert = GetAlertsForAlarm(dps[i], t);
        dynAppend(result, alert);
    }
    
    return result;
}

private dyn_string GetAlertsForAlarm(string dp, time t)
{
    dyn_bool values;
    dyn_time times;
    
    // count = 3 для предотвращения случаев, когда значение TRUE установилось два раза подряд
    dpGetPeriod(t, AddMillisecondsTD(t, 1), 3, dp, values, times);
    
    time startTime;
    time endTime;
    
    for (int i = 1; i <= dynlen(times); i++)
    {
        if ((times[i] <= t) && (values[i] == true))
            startTime = times[i];
        
        if ((times[i] >= t) && (values[i] == false))
            endTime = times[i];
    }
    
    return makeDynString(dpGetDescription(dp), TimeToStr(startTime), TimeToStr(endTime));
}

public dyn_string GetTimesForAlert(string address, string alertText, time lastTime)
{
  //DebugN(alertText);
  dyn_string res;
  string correctAddress = GetCorrectDpAddress(address); 
  
  string query = "SELECT ALERT '_alert_hdl.._direction', '_alert_hdl.._text' FROM '" + correctAddress + "' TIMERANGE(\""+TimeToStringForUtcTD(lastTime)+"\",\""+TimeToStringForUtcTD(getCurrentTime())+"\",1,0)";
  //DebugN(query);

  dyn_dyn_anytype data;
  dpQuery(query, data);
  //DebugN(data);

  if (dynlen(data) <= 1)
  {
    DebugN("Модуль отчетов. Получение алертов для параметра ", correctAddress, " с текстом ", alertText, " начиная со времени ", lastTime, res);
    return res;
  }

  for(int i =2; i <= dynlen(data); i++)
  {
    // direction == 1 
    if (data[i][3] != 1)
      continue;
    
    if (alertText != "" && strpos(strtolower(data[i][4]), strtolower(alertText)) < 0)
      continue;
    
    dynAppend(res, TimeToStringTD(data[i][2]));
  }
  
  DebugN("Модуль отчетов. Получение алертов для параметра ", correctAddress, " с текстом ", alertText, " начиная со времени ", lastTime, res);
  return res;
}

/*
  Получить временные метки когда параметр address стал больше/меньше указанного значения value начиная с времени lastTime
*/
public dyn_string GetTimesForValue(string address, string compareType, double value, time lastTime)
{
  dyn_string res;
  dyn_float values;
  dyn_time times;
  
  string correctAddress = GetCorrectDpAddress(address); 

  // запрос данных с флагом 1 - означает, что будет выбрано по +1 значению до и после интервала
  // т.к. выбираем до текущего времени, то ожидаю, что первое значение будет до начала запрашиваемого интервала
  dpGetPeriod(lastTime, getCurrentTime(), 1, correctAddress, values, times);

  // если пришло только одно значение, то это означает, что на текущем интервале не было изменений параметра
  if (dynlen(values) <= 1 )
  {
    DebugN("Модуль отчетов. Получение событий, когда значение параметра ", correctAddress, " стало ", compareType, " величины", value, " начиная с времени ", lastTime, " результат >> ",res);    
    return res;
  }
  
  // в начале и на каждом шаге проверяю не произошло ли событие, например, что значение было меньше величены, а стало больше - т.е. значение флага должно измениться с false на true 
  bool flag = CheckValue(compareType, values[1], value);
  for (int i = 2; i <= dynlen(values); i++)
  {
      bool newFlagValue = CheckValue(compareType, values[i], value);
      
      if (flag == false && newFlagValue == true)
        dynAppend(res, TimeToStringTD(times[i]));
      
      flag = newFlagValue;
  }
  
  DebugN("Модуль отчетов. Получение событий, когда значение параметра ", correctAddress, " стало ", compareType, " величины", value, " начиная с времени ", lastTime, " результат >> ",res);    
  return res;
}

public dyn_dyn_string GetAlarmsOnPeriod(string dp, time startTime, time endTime)
{
    string correctAddress = GetCorrectDpAddress(dp);
    
    dyn_dyn_string result;    
    string start = TimeToStringForUtcTD(startTime), 
    end = TimeToStringForUtcTD(endTime);
    dyn_string istDP = strsplit(correctAddress, ":");
    dyn_dyn_anytype resultQuery;    
    string sQuery = "SELECT ALERT '_alert_hdl.._text', '_alert_hdl.._ack_time', '_alert_hdl.._class' " +
	    "FROM \'" + istDP[2] + "\' " +
	    "REMOTE \'" + istDP[1] + ":\' " +
	    "TIMERANGE(\"" + start + "\",\"" + end + "\",1,0) " +
	    "SORT BY 2";
    DebugN(sQuery);
    dpQuery(sQuery,	resultQuery);

    if (dynlen(resultQuery) > 1)
    {
      for(int i = 2; i <= dynlen(resultQuery); i++)
      {
        dynAppend(result,
          makeDynString((string)resultQuery[i][3],
            (string)resultQuery[i][2],
            (string)resultQuery[i][5]));
      }
    }
    return result;
}

private bool CheckValue(string compareType, double value, double valueReference)
{
  if (compareType == "more")
  {
    return value > valueReference;
  }

  if (compareType == "less")
  {
    return value < valueReference;
  }
  
  if (compareType == "equal")
  {
    return value == valueReference;
  }
  
  return false;
}

public string GetShortAddress(string address)
{
    dyn_string array = strsplit(address, ":");
    
    if(dynlen(array) > 2)
    {
          return array[1] + ":" + array[2];
    }
    else
    {
      return address;
    }
}
