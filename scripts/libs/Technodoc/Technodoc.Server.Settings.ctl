//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
// Константы для мониторинга локального экземпляра Технодока через WinCC OA с помощью скрипта Technodoc.Server.ctl
// Адрес по которому доступен локальный экземпляр Технодока
const string TECHNODOC_LOCAL_HTTP_ADDRESS = "http://127.0.0.1:8003";

// Значение пути до корневой папки установленного локально экземпляра Технодока
const string TECHNODOC_ROOT_FOLDER_PATH = getPath(BIN_REL_PATH) + "TechnoDoc";

// Название сервиса
const string TECHNODOC_SERVICE_NAME = _WIN32 ? "TechnoDocServer" : "technodoc-server";

// Максимальное время недоступности сервера, после которого будет выполнен перезапуск
const int MAX_TIME_IN_UNHEALTHY_STATE_LOCAL_SERVER_SEC = 60;

// Интервал опроса состояния сервера
const int MONITORING_INTERVAL_LOCAL_SERVER_SEC = 5;

// Задержка для прогрева сервиса, чтобы убедиться, что с ним все в порядке
const int DELAY_AFTER_START_SEREVICE_SEC = 30;

// Флаг отладки скрипта Technodoc.Server.ctl для вывода дополнительных сообщений.
// Чтобы включить, необходимо в менеджере сценариев добавить -dbg MonitorDebug. Пример: "Technodoc.Server.ctl -dbg MonitorDebug"
const string MONITORING_DEBUG_FLAG = "MonitorDebug";

// Логин пользователя в ТехноДоке
const string TECHNODOC_DEFAULT_USER_LOGIN = "admin";

// Пароль пользователя в ТехноДоке
const string TECHNODOC_DEFAULT_USER_PASSWORD = "admin";

// Массив адресов серверов Технодока
dyn_string TECHNODOC_CLUSTER_URLS = makeDynString(TECHNODOC_LOCAL_HTTP_ADDRESS);

// Максимальное количество раз подряд недоступности сервера
const int MAX_TIME_IN_UNHEALTHY_STATE_CURRENT_SELECTED_SERVER = 30;

// Интервал опроса состояния выбранного сервера
const int MONITOR_INTERVAL_AVAILABILITY_SERVER_SEC = 5;