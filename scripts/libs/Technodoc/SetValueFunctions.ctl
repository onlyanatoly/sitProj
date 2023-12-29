#uses "TimeFunctionsTD.ctl"

public void SetDatapointValue(string dp, string value)
{  
    string decodeValue;
    base64Decode(value, decodeValue);
    string correctAddress = GetCorrectDpAddress(dp);
    dpSet(correctAddress, decodeValue);
	//DebugN("SetDatapointValue", correctAddress, "Value Length = " + strlen(decodeValue));
}

public void SetDatapointValueOnTime(string dp, time timestamp, string value)
{
    string decodeValue;
    base64Decode(value, decodeValue);
    string correctAddress = GetCorrectDpAddress(dp);
    int res = dpSetTimedWait(timestamp, correctAddress, decodeValue);
    //DebugN("SetDatapointValueOnTime", dp, timestamp, "Value Length = " + strlen(decodeValue));
}

public void SetCompressedDatapointValue(string dp, string value)
{    
    string correctAddress = GetCorrectDpAddress(dp);
    dpSet(correctAddress, value);
    //DebugN("SetCompressedDatapointValue (Template)", dp, value, "Value Length = " + strlen(value));
}

/* 	Устанавливает сжатое значение value на момент времени timestamp точке данных dp.
	
	Значение записывается в бд частями по 4000 символов на миллисекунды.
	
	Пример: Запись отчета за 04.06.2016 05:00:00 размером 18 000 символов.
			Отчет будет разбит на 5 строк, которые будут хранится в 1,2,3, 4 и 5 миллисекундах временной метки 04.06.2016 05:00:00.
			В нулевой миллисекунде будет записано количество частей отчета (5).	
*/
public void SetCompressedDatapointValueOnTime(string dp, time timestamp, string value)
{
    const int MAX_LENGTH = 4000;
    string correctAddress = GetCorrectDpAddress(dp);
    
    //в 0-ую миллисекунду пишем количество занятых миллисекунд
    int partsCount = ceil((float)strlen(value)/MAX_LENGTH);
    dpSetTimedWait(timestamp, correctAddress, partsCount);
    
	   for(int i = 0; i < partsCount; i++)
    {
        int res =  dpSetTimedWait(AddMillisecondsTD(timestamp, i + 1), correctAddress, substr(value, i*MAX_LENGTH, MAX_LENGTH)); 
    } 

    //DebugN("SetCompressedDatapointValueOnTime", correctAddress, "Value Length = " + strlen(value));     
}
