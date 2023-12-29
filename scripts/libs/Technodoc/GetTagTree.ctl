public dyn_dyn_mixed GetTagTree()
{
  string internalPointPrefix = "_";
  
  dyn_dyn_mixed structure;  
  
  //Получить все системы
  dyn_string sysNames;
  dyn_uint sysIds;
  
  getSystemNames(sysNames, sysIds);
  
  int sysCount = dynlen(sysNames);
  
  // Для каждой системы
  for (int i = 1; i <= sysCount; i++)
  {     
    
    string sysName = sysNames[i];
    uint sysId = sysIds[i];
    
    dyn_dyn_mixed sysArr;
        
    // получить типы тегов для системы    
    dyn_string dpTypeNames=dpTypes("*", sysId);
    
    int dpTypeCount = dynlen(dpTypeNames);
    
    for (int k = 1; k <= dpTypeCount; k++)
    {
       string typeName = dpTypeNames[k];
       
       // Отфильтровать Internal datapoints  
       if(strpos(typeName, internalPointPrefix) == 0) continue;          
       
       // Получить точки первого уровня
       dyn_dyn_mixed points = ProcessTag(sysName + ":", typeName, 0);
       
       //DebugTN(typeName, dynlen(points)); 
       
       dynAppend(sysArr, dynlen(points) > 0
                 ? makeDynMixed(typeName, points)
                 : makeDynMixed(typeName));
    }
    
    dynAppend(structure, makeDynMixed(sysName, sysArr));
    
  }
  return structure;
  
}


public dyn_dyn_mixed ProcessTag(string dpPattern, string typeName, int level)
{
  string masterPointPrefix = dpPattern+"_mp_";
  level++;
  
  dyn_dyn_mixed pointsData;
  
  // Получить точки текущего уровня  
  dyn_string points = dpNames(dpPattern +"*", typeName);
  int pointCount = dynlen(points);
  
  // Для каждой точки 
  for (int j = 1; j <= pointCount; j++)
  {
     string point = points[j];

     // Отфильтровать  masterpoints если на уровне тега
     if(level == 1 && strpos(point, masterPointPrefix) == 0) continue;
     
     // Получить тип данных точки
     int typeValue = (level == 1) ? dpElementType(point + ".") : dpElementType(point);
     
     // Получить вложенные точки для типа
     dyn_mixed internalProperties = ProcessTag(point + ".", typeName,level);
     
     // Получить Description    
     string description = (level == 1)? GetNodeDescription(point + ".") : GetDescription(point, -1);

     // Получить имя точки     
     dyn_string pointNames = (level == 1) ? strsplit(point, ":") : strsplit(point, ".");
     string pointName = pointNames[dynlen(pointNames)];

     dyn_dyn_mixed pointData;
     dynAppend(pointData, dynlen(internalProperties) > 0
                           ? makeDynMixed(pointName, description, typeValue, internalProperties)
                           : makeDynMixed(pointName, description, typeValue)); 
     
     dynAppend(pointsData, pointData);
  }
  return pointsData;
}

private string GetNodeDescription(string address)
{
  return (string)dpGetDescription(address, -1);
}



