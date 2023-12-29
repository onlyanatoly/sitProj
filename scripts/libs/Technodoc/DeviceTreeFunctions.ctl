// Возвращает набор массивов данных о точке
// 1 - Название точки
// 2 - Тип
public dyn_dyn_string GetDatapoints()
{
    dyn_dyn_string result;
    
    dyn_string types = dpTypes("*", 1);
    for (int i = 1; i <= dynlen(types); i++)
    {
        if (types[i][0] == "_")
            continue;
        
        dyn_string dps = dpNames("*", types[i]);
        
        for (int j = 1; j <= dynlen(dps); j++)
        {
            dynAppend(result, makeDynString(dps[j], types[i]));
        }
    }

    return result;
}

//Возвращает набор массивов данных о параметрах дерева
// 1 - Параметр
// 2 - Время возникновения сообщения
// 3 - Текст сообщения
// 4 - Время квитирования
// 5 - Цвет сообщения (шестнадцатеричный код цвета)
public dyn_dyn_string GetAlertsList(dyn_string asuDp)
{
   dyn_dyn_string result;
  
    for(int i = 1; i <= dynlen(asuDp); i++)
    {
       dynAppend(result, GetSelectedDpAlertsList(asuDp[i]));  
    } 
    return result;
}

// Возвращает набор массивов данных о типе
// 1 - Id (не привязан к реальным данным, используется только для построения дерева)
// 2 - Parent Id
// 3 - NodeName
// 4 - NodeType
public dyn_dyn_string GetDpTypes()
{
    dyn_dyn_string result;
    int index = 0;
    
    dyn_string types = dpTypes("*");
    for (int i = 1; i <= dynlen(types); i++)
    {
        AppendTypeDescription(types[i], result, index);
    }

    return result;
}

//Возвращает набор массивов данных о параметрах дерева
// 1 - Параметр дерева 
// 2 - Значение параметра (value)
// 3 - Время, в момент которого параметр дерева имел значение value
public dyn_dyn_string GetTreeParametersValue(time startTime, time endTime, dyn_string asuDp)
{
    dyn_dyn_string result;
        
    for(int i = 1; i <= dynlen(asuDp); i++)
    {
        dynAppend(result, GetDpValuesArchives(startTime, endTime, asuDp[i]));      
    }    
    return result;
}
