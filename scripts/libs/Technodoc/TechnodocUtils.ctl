//--------------------------------------------------------------------------------
// Libraries used (#uses)

#uses "Technodoc/Technodoc.Server.Settings"

//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
// Константы для проверки доступности технодока (используется для проверки доступности Технодока в скрипте мониторинга Technodoc.Server.ctl и панели technodoc.pnl)
// Веб-метод для проверки состояния сервера
const string TECHNODOC_CHECK_HEALTH_WEB_METHOD_NAME = "/health";

// Результат веб-метода healthWebMethodName, при котором считается, что сервер в порядке
const string TECHNODOC_HEALTHY_SERVER_STATUS_NAME = "Healthy";

// Флаг отладки выполнения
const string TECHNODOC_ALIVE_STATUS_DEBUG_FLAG = "TechnodocAliveStatus";

// Веб-метод для проверки состояния сервера
const string TECHNODOC_SERVER_STATUS_WEB_METHOD_NAME = "/api/ClusterServer/GetStatus";

const string PRIMARY_SERVER_STATUS = "2";

//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

/** Доступен ли сервер Технодока
  @param baseTechnodocUrl Базовый адрес Технодока
  @return Возвращает true если сервер доступен, иначе false
*/
public bool isTechnodocServerAlive(string baseTechnodocUrl)
{
  string result;
  string healthCheckUrl = baseTechnodocUrl + TECHNODOC_CHECK_HEALTH_WEB_METHOD_NAME;
  netGet(healthCheckUrl, result);
  DebugFN(TECHNODOC_ALIVE_STATUS_DEBUG_FLAG, "Результат выполнения проверки доступности по адресу \"" + healthCheckUrl + "\": " + result);
  return result == TECHNODOC_HEALTHY_SERVER_STATUS_NAME;
}

/** Является ли указанный сервер Технодока основным
  @param baseTechnodocUrl Адрес основного сервера Технодока
  @return Возвращает true если сервер основной, иначе false
*/
public bool isTechnodocServerPrimary(string baseTechnodocUrl)
{
  string result;
  string getServerStatusUrl = baseTechnodocUrl + TECHNODOC_SERVER_STATUS_WEB_METHOD_NAME;
  
  netGet(getServerStatusUrl, result);
  DebugFN(TECHNODOC_ALIVE_STATUS_DEBUG_FLAG, "Результат выполнения проверки статуса по адресу \"" + getServerStatusUrl + "\": " + result);
  return result == PRIMARY_SERVER_STATUS;
}

/** Вернуть текущий основной сервер Технодока
  @param primaryServerAddress Адрес основного сервера Технодока
  @return Возвращает true если сервер найден, иначе false
*/
public bool getPrimaryTechnodocAddress(string& primaryServerAddress)
{
  dyn_string primaryServerAddresses;
  int primaryServerAddressIndex;

  for(int i = 1; i <= dynlen(TECHNODOC_CLUSTER_URLS); i++)
  {
    string result;
    string getServerStatusUrl = TECHNODOC_CLUSTER_URLS[i] + TECHNODOC_SERVER_STATUS_WEB_METHOD_NAME;
    
    netGet(getServerStatusUrl, result);

    if(result == PRIMARY_SERVER_STATUS)
    {
      primaryServerAddressIndex = i;
      dynAppend(primaryServerAddresses, TECHNODOC_CLUSTER_URLS[i]);
      break;
    }
  }

  int countPrimaryServerAddresses = dynlen(primaryServerAddresses);
  if(countPrimaryServerAddresses != 1)
  {
    string message = countPrimaryServerAddresses == 0
      ? "Не найдено ни одного основного сервера."
      : "Найдено более одного основного сервера.";
    DebugN(message);
    return false;
  }

  if (primaryServerAddresses[1] != TECHNODOC_CLUSTER_URLS[1]) {
    dynRemove(TECHNODOC_CLUSTER_URLS, primaryServerAddressIndex);
    dynInsertAt(TECHNODOC_CLUSTER_URLS, primaryServerAddresses[1], 1);
  }  
  
  primaryServerAddress = primaryServerAddresses[1];
  return true;
} 

/** Вернуть базовый адрес текущего сервера на основе текущего url в webview
  @param currentUrl Адрес текущей страницы
  @param urls Список адресов кластера
  @return Базовый url текущего работающего сервера
*/
public string getCurrentTechnodocBaseUrl(string currentUrl)
{
  string currentBaseUrl = "";
  for(int i = 1; i <= dynlen(TECHNODOC_CLUSTER_URLS); i++)
  {
    if(strpos(currentUrl, TECHNODOC_CLUSTER_URLS[i]) >= 0)
    {
      currentBaseUrl = TECHNODOC_CLUSTER_URLS[i];
      break;
    }
  }

  return currentBaseUrl;
}

/** Вернуть относительный путь относительно полного пути
  @param currentUrl Полный url
  @param currentBaseUrl Базовый url, относительно которого ищется относительный путь
  @return Относительный url
*/
public string getRelativePathRelativeFullPath(string currentUrl, string currentBaseUrl)
{
  return substr(currentUrl, strlen(currentBaseUrl));
}
