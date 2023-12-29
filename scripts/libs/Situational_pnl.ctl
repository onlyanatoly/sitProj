// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author Ruslan.Zalyaev
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)

//--------------------------------------------------------------------------------
// Variables and Constants
int INITIAL_NAV_SCREEN=1;
string NAVIGATION_DIR = getPath(PANELS_REL_PATH)+"navigation/";
string NAVIGATION_PNL_NAME = "navigation";
string DETAIL_PNL_NAME = "detail";
string FRONT_PNL_NAME = "front";
string TOP_PNL_NAME = "topPanel";
string NAVIGATION_PNL = "";
string DETAIL_PNL = "";
string FRONT_PNL = "";
string TOP_PNL = "";

/*string NAVIGATION_PNL = "navigation/navigation.pnl";
string DETAIL_PNL = "navigation/detail.pnl";
string FRONT_PNL = "navigation/front.pnl";
string TOP_PNL = "navigation/topPanel.pnl";*/
string NAVIGATION_MODULE = "navigateModule";
string DETAIL_MODULE = "detailModule";
string FRONT_MODULE = "frontModule";
string NAVIGATION_DP_NUMBER = "NAVIGATION.monitorNumber";
string MAIN_MODULE = "mainModule";
string TOP_MODULE = "topModule";
int MONITORS = 2;
dyn_string DYN_SIT_AI = makeDynString("SIT_AI");
dyn_string DYN_SIT_DI = makeDynString("SIT_DI");
dyn_string DYN_SIT_REG = makeDynString("SIT_REG");
dyn_string DYN_SIT_ISP = makeDynString("SIT_PUMP", "SIT_VALVE");


/**
  Первоначальные настройки панели
*/
void initialConfigs()
{
  ptms_UserDefinedInitFunctions();
  setValue(MAIN_MODULE, "ModuleName", ptms_BuildModuleName(MAIN_MODULE,$Screen));
  setValue(TOP_MODULE, "ModuleName", ptms_BuildModuleName(TOP_MODULE,$Screen));
  setValue(NAVIGATION_MODULE, "ModuleName", ptms_BuildModuleName(NAVIGATION_MODULE,$Screen));
  setValue(DETAIL_MODULE, "ModuleName", ptms_BuildModuleName(DETAIL_MODULE,$Screen));
  setValue(FRONT_MODULE, "ModuleName", ptms_BuildModuleName(FRONT_MODULE,$Screen));
  ptms_LoadInitPanel($Number,$Screen, isDollarDefined("$Node") ? $Node : 0);
  setModulePanels();
  openTop();
  openNavigation();
  openDetail();
  openFront();
}

void setModulePanels()
{
  int x, y;
  getScreenSize(x, y);
  string suffix = +"_"+x+"_"+y+".pnl";
  DebugN("start", suffix);

  NAVIGATION_PNL = getPanelNameForModule(NAVIGATION_PNL_NAME, suffix);
  DebugN("NAVIGATION_PNL", NAVIGATION_PNL);
  DETAIL_PNL = getPanelNameForModule(DETAIL_PNL_NAME, suffix);
  DebugN("DETAIL_PNL", DETAIL_PNL);
  FRONT_PNL = getPanelNameForModule(FRONT_PNL_NAME, suffix);
  DebugN("FRONT_PNL", FRONT_PNL);
  TOP_PNL = getPanelNameForModule(TOP_PNL_NAME, suffix);
  DebugN("TOP_PNL", TOP_PNL);
}

string getPanelNameForModule(string name, string suffix)
{
  int i;
  string navName = NAVIGATION_DIR+name+suffix;
  DebugN(navName);
  i=access(navName, F_OK);
  if (i!=0) {
    return NAVIGATION_DIR+name+".pnl";
  } else {
    return navName;
  }
}


/**
  Открытие верхней панели
*/
void openTop()
{
  int i;
  for(i=1; i<=MONITORS; i++)
  {
    RootPanelOnModule( TOP_PNL, "", ptms_BuildModuleName(TOP_MODULE,ptnavi_GetScreenName()), "");
  }
}

/**
  Открытие лицевой панели
*/
void openFront()
{
  int i;
  dyn_string dps;

  for(i=1; i<=MONITORS; i++)
  {
    dpSetWait("NAV_FRONT_"+i+".monitorNumber", 0);
    if (i==INITIAL_NAV_SCREEN)//TODO тестово открою в первом окне, потом удалить надо?
    {
      dpSetWait("NAV_FRONT_"+i+".monitorNumber", INITIAL_NAV_SCREEN);
    }
    RootPanelOnModule( FRONT_PNL, "", ptms_BuildModuleName(FRONT_MODULE,ptnavi_GetScreenName()), makeDynString("$dpNav:NAV_FRONT_"+ptnavi_GetScreenName(), "$dpNavNoScreen:NAV_FRONT_", "$Screen:NAV_FRONT_"));
    setScaleFit(ptms_BuildModuleName(FRONT_MODULE,ptnavi_GetScreenName()));
    if (ptnavi_GetScreenName()!=INITIAL_NAV_SCREEN)
    {
      //DebugN("not equal screen = "+ptnavi_GetScreenName());
      shape navMod = getShape(FRONT_MODULE);
      setValue(navMod, "visible", false);
    }
    dps[i] = "NAV_FRONT_"+i+".monitorNumber";
  }
  dpConnect("checkMonitorNumberFronts", false, dps);
}


/**
  Открытие детальной панели
*/
void openDetail()
{
  int i;
  dyn_string dps;

  for(i=1; i<=MONITORS; i++)
  {
    dpSetWait("NAV_DETAIL_"+i+".monitorNumber", 0);
    if (i==INITIAL_NAV_SCREEN)//TODO тестово открою в первом окне, потом удалить надо?
    {
      dpSetWait("NAV_DETAIL_"+i+".monitorNumber", INITIAL_NAV_SCREEN);
    }
    RootPanelOnModule( DETAIL_PNL, "", ptms_BuildModuleName(DETAIL_MODULE,ptnavi_GetScreenName()), makeDynString("$dpNav:NAV_DETAIL_"+ptnavi_GetScreenName(), "$dpNavNoScreen:NAV_DETAIL_", "$Screen:NAV_DETAIL_"));
    setScaleFit(ptms_BuildModuleName(DETAIL_MODULE,ptnavi_GetScreenName()));
    if (ptnavi_GetScreenName()!=INITIAL_NAV_SCREEN)
    {
      //DebugN("not equal screen = "+ptnavi_GetScreenName());
      shape navMod = getShape(DETAIL_MODULE);
      setValue(navMod, "visible", false);
    }
    dps[i] = "NAV_DETAIL_"+i+".monitorNumber";
  }
  dpConnect("checkMonitorNumberDetails", false, dps);
}

/**
  Перемещение лицевой панели по мониторам
  @param dpe
  @param navMonitorNumber
*/
void checkMonitorNumberFronts(dyn_string dpe, dyn_int navMonitorNumber)
{
  int i;
  int tempNavMonitorNumber;
  shape navMod = getShape(FRONT_MODULE);
  tempNavMonitorNumber = navMonitorNumber[ptnavi_GetScreenName()];
  if (ptnavi_GetScreenName()!=tempNavMonitorNumber)
  {
     setValue(navMod, "visible", false);
  }
  else
  {
    setValue(navMod, "visible", true);
  }
}

/**
  Перемещение детальной панели по мониторам
  @param dpe
  @param navMonitorNumber
*/
void checkMonitorNumberDetails(dyn_string dpe, dyn_int navMonitorNumber)
{
  int i;
  int tempNavMonitorNumber;
  shape navMod = getShape(DETAIL_MODULE);
  tempNavMonitorNumber = navMonitorNumber[ptnavi_GetScreenName()];
  if (ptnavi_GetScreenName()!=tempNavMonitorNumber)
  {
     setValue(navMod, "visible", false);
  }
  else
  {
    setValue(navMod, "visible", true);
  }
}

/**
  Установка масштабирования внутри модуля
*/
void setScaleFit(string moduleName)
{
    setScaleStyle(SCALE_FIT_TO_MODULE, moduleName);
}

/**
  Открытие панели навигации при первоначальном запуске
*/
void openNavigation()
{
  dpSetWait(NAVIGATION_DP_NUMBER, INITIAL_NAV_SCREEN);
  if (ptnavi_GetScreenName()==INITIAL_NAV_SCREEN)
  {
    RootPanelOnModule( NAVIGATION_PNL, "",ptms_BuildModuleName(NAVIGATION_MODULE,ptnavi_GetScreenName()), "");
    setScaleFit(ptms_BuildModuleName(NAVIGATION_MODULE,ptnavi_GetScreenName()));
  }
  else
  {
    //на остальных окнах закрываем
    shape navMod = getShape(NAVIGATION_MODULE);
    setValue(navMod, "visible", false);
  }
  dpConnect("checkMonitorNumberNavigation", false, NAVIGATION_DP_NUMBER);
}

/**
  Перемещение панели навигации по мониторам
  @param dpe
  @param navMonitorNumber
*/
void checkMonitorNumberNavigation(string dpe, int navMonitorNumber)
{
  int pnlNumber;
  shape navMod = getShape(NAVIGATION_MODULE);
  if (ptnavi_GetScreenName()!=navMonitorNumber)
  {
    PanelOffPanel(NAVIGATION_PNL);
    setValue(navMod, "visible", false);
  }
  else
  {
    DebugN("ptnavi_GetScreenName()", ptnavi_GetScreenName());
    DebugN("navMonitorNumber",navMonitorNumber);
    dpGet("NAVIGATION_"+ptnavi_GetScreenName()+".panelNumber",pnlNumber);
    dpSet("NAVIGATION.panelNumber",pnlNumber);
    setValue(navMod, "visible", true);
    RootPanelOnModule( NAVIGATION_PNL, "",ptms_BuildModuleName(NAVIGATION_MODULE,navMonitorNumber), "");
    setScaleFit(ptms_BuildModuleName(NAVIGATION_MODULE,ptnavi_GetScreenName()));
  }
}

/**
  Открытие лицевой и детальной панели у элемента
  @param dpe
*/
void openFrontAndDetailPanel(string dpe)
{
  openFrontPanel(dpe);
  openDetailPanel(dpe);
}

/**
  Открытие лицевой панели у элемента
  @param dpe
*/
void openFrontPanel(string dpe)
{
  dpSet("NAV_FRONT_"+ptnavi_GetScreenName()+".element", dpe);
  dpSet("NAV_FRONT_"+ptnavi_GetScreenName()+".monitorNumber",ptnavi_GetScreenName());
}

/**
  Открытие детальной панели у элемента
  @param dpe
*/
void openDetailPanel(string dpe)
{
  string dpType;
  dpType=dpTypeName(dpe);
  if (dynContains(DYN_SIT_ISP, dpType))
  {
    //нет детального окна
  }
  else
  {
    dpSet("NAV_DETAIL_"+ptnavi_GetScreenName()+".element", dpe);
    dpSet("NAV_DETAIL_"+ptnavi_GetScreenName()+".monitorNumber",ptnavi_GetScreenName());
  }
}

/**
  Установка элементов в DP из панели
*/
void setElementForVF()
{
  file f;
  int i;
  string dpName, filename, filestr, pnlPath;
  dyn_string dynNames, dynTemp, dynElements;
  DebugN("setElementForVF begin");
  pnlPath = getPath(PANELS_REL_PATH);
  dynNames = dpNames("*","SIT_VF");
  for(i=1; i<=dynlen(dynNames);i++)
  {
    dpName = dynNames[i];
    dpGet(dpName+".fileName", filename);
    filename = pnlPath+filename;
    f=fopen(filename,"r");//чтение и запись
    dynClear(dynElements);
    while (feof(f)==0) // При условии, что это не в конце
    {
      fgets(filestr,50,f); // Дополнительное чтение из файла
      if (strpos(filestr,"dpe_value")>0)
      {
        dynTemp = strsplit(filestr, "\"");
        if (dynlen(dynTemp)>=4)
        {
          dynAppend(dynElements, dynTemp[4]);
        }
      }
    }
    fclose(f);
    if (dynlen(dynElements)>0)
    {
      DebugN(dpName, dynElements);
      dpSet(dpName+".elements", dynElements);
    }
  }
  DebugN("setElementForVF finish");
}

/**
  Поиск панели для элемента
  @param inElement название элемента
  @return название панели
*/
string findPanel(string inElement)
{
  int i, j;
  string dpName, rezult = "";
  dyn_string dynNames, dynElements;
  bool isFind;
  dynNames = dpNames("*","SIT_VF");
  for(i=1; i<=dynlen(dynNames);i++)
  {
    isFind = false;
    dpName = dynNames[i];
    dpGet(dpName+".elements", dynElements);
    if (dynlen(dynElements)>0)
    {
      for(j=1; j<=dynlen(dynElements);j++)
      {
        if (dynElements[j]==inElement)
        {
          isFind = true;
          break;
        }
      }
    }
    if (isFind)
    {
      rezult=dpName;
      break;
    }
  }
  return rezult;
}

/**
  Открытие панели где находится элемент
  @param element
*/
void openPnlForElement(string element)
{
  int pnlNumb;
  string dpVf, pnlPath;
  dpVf = findPanel(element);
  if (dpVf!="")
  {
    //dpGet(dpVf+".fileName", pnlPath);
    //RootPanelOnModule( pnlPath, "",ptms_BuildModuleName(MAIN_MODULE,ptnavi_GetScreenName()), "");
    dpGet(dpVf+".panelNumber", pnlNumb);
    dpSet("NAVIGATION.panelNumber", pnlNumb);
    dpSet("NAVIGATION_"+ptnavi_GetScreenName()+".panelNumber", pnlNumb);
    dpSet(NAVIGATION_DP_NUMBER, ptnavi_GetScreenName());
  }
}


/**
  Открытие панеди первого уровня
*/
void openMainPanel()
{
    dpSet("NAVIGATION_"+ptnavi_GetScreenName()+".panelNumber", 1);
    //dpSet("NAVIGATION.panelNumber", 1);
    openNavigationCurrentScreen();
}

void openNavigationCurrentScreen()
{
    dpSet(NAVIGATION_DP_NUMBER, ptnavi_GetScreenName());
}

/**
  Название модуля
  @param type
*/
string getModuleName(int type)
{
  string result = "";
  string screenName = ptnavi_GetScreenName();

  if (type == 1)
  {
    result = ptms_BuildModuleName(MAIN_MODULE, screenName);
  }
  else if (type == 2)
  {
    result = ptms_BuildModuleName(DETAIL_MODULE, screenName);
  }
  else if (type == 3)
  {
    result = ptms_BuildModuleName(FRONT_MODULE, screenName);
  }
  else if (type == 4)
  {
    result = ptms_BuildModuleName(NAVIGATION_MODULE, screenName);
  }
  return result;
}


/**
  Название текущей выбранной панели
  @param type
*/
string getCurrentPanelFullName(int type)
{//TODO сделать
  //в зависимости на какой окне находимся вернуть название соответсвующей панели для соответсвующего модуля
  string result = "pnlTest\\POA_GOU_Main.pnl";

  if (type == 1)
  {
  }
  else if (type == 2)
  {
  }
  else if (type == 3)
  {
  }
  else if (type == 4)
  {
  }
  return result;
}
