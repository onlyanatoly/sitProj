#uses "CtrlHTTP"
#uses "CtrlXmlRpc"
#uses "xmlrpcHandlerCommon"

#uses "Technodoc/MiscFunctions"
#uses "Technodoc/GetValueFunctions"
#uses "Technodoc/SetValueFunctions"
#uses "Technodoc/GetTagTree"
#uses "Technodoc/ExecuteCommands"
#uses "Technodoc/Technodoc.Server.Settings"
#uses "Technodoc/RequestResponseCommandsFromTechnodocUsingHttp"

//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
// Константы для работы XML RPC сервера для коммуникации Технодока и WinCC OA (используется в скрипте Technodoc.XmlRpcServer.ctl)
// Порт для XMLRPC сервера для работы по протоколу HTTP (в случае указания 0 данный протокол будет отключен)
const int TECHNODOC_XMLRPC_HTTP_PORT = 8242;

// Порт для XMLRPC сервера для работы по протоколу HTTPS (в случае указания 0 данный протокол будет отключен)
const int TECHNODOC_XMLRPC_HTTPS_PORT = 0;

// Использовать XML-RPC для взаимодействия Технодока и WinCC OA
const bool USING_XMLRPC_TO_HANDLE_REQUESTS = true;

// Использовать API Технодока для взаимодействия Технодока и WinCC OA через веб-запросы
const bool USING_TECHNODOC_API_TO_HANDLE_REQUESTS = false;

//--------------------------------------------------------------------------------
/** Запускает Http server для обмена данными с Технодоком по протоколу XML-RPCs
*/
main()
{
    //setQueryRDBDirect(TRUE);
  if(USING_XMLRPC_TO_HANDLE_REQUESTS)
  {
    StartHttpServer();
  }
  
  if(USING_TECHNODOC_API_TO_HANDLE_REQUESTS)
  {
    startThread("startHandlingCommands");
  }
}

public void StartHttpServer()
{
 
    DebugN("Запускаем XMLRPC-сервер...");
    
    
    //Start the HTTP Server
    if (httpServer(false, TECHNODOC_XMLRPC_HTTP_PORT, TECHNODOC_XMLRPC_HTTPS_PORT) < 0)
    {
        DebugN("ERROR: HTTP-server can't start. --- Check license");
        return;
    }

    //Start the XmlRpc Handler
    httpConnect("xmlRpcHandler", "/RPC2");
    httpSetMaxContentLength(9999999);

    string statusMessage = (TECHNODOC_XMLRPC_HTTPS_PORT == 0)
                           ? ("XMLRPC-сервер запущен на порту " + TECHNODOC_XMLRPC_HTTP_PORT)
                           : ("XMLRPC-сервер запущен на портах " + TECHNODOC_XMLRPC_HTTP_PORT + " и " + TECHNODOC_XMLRPC_HTTPS_PORT);

    DebugN(statusMessage);

}

public mixed xmlRpcHandler(const mixed content, string user, string ip, dyn_string ds1, dyn_string ds2, int connIdx)
{
    string sMethod;
    dyn_mixed daArgs;
    string sResponse;
    mixed result;
    bool isError = false;
    
    xmlrpcDecodeRequest(content, sMethod, daArgs);
    //DebugN("REQUEST >> " + sMethod);
    
    
    switch (strtolower(sMethod))
    {
        /* 
            Device tree functions
         */
        case "getdatapoints":
            result = GetDatapoints();
            break;
            
        case "getdatapointtypes":
            result = GetDpTypes();
            break;
           
        case "getselectedparametersalertslist":
            result = GetAlertsList(daArgs[1]);
            break;
            
        case "gettreeparametersvalue":
            result = GetTreeParametersValue(daArgs[1], daArgs[2], daArgs[3]);
            break;
            
            
        /* 
            Get value functions
         */
        case "get":
            result = GetByFunctionName(daArgs[1], daArgs[2], daArgs[3], daArgs[4]);
            break;
            
        case "getdatapointvaluesonperiod":
            result = GetDatapointValuesOnPeriod(daArgs[1], daArgs[2], daArgs[3]);
            break;
            
        case "getuserbitvalueontime":
            result = GetUserbitValueOnTime(daArgs[1], daArgs[2], daArgs[3]);
            break;
            
        case "bulkget":
            //DebugN("daArgs >> " + daArgs[1] + " " + daArgs[2]);
            result = BulkGet(daArgs[1], daArgs[2]);
            break;
            
        case "getcompresseddatapointvalueontime":
            result = GetCompressedDatapointValueOnTime(daArgs[1], daArgs[2]);
            break;
			
        /* 
            Set value functions
         */
        case "setdatapointvalue":
            SetDatapointValue(daArgs[1], daArgs[2]);
            break;
            
        case "setdatapointvalueontime":
            SetDatapointValueOnTime(daArgs[1], daArgs[2], daArgs[3]);
            break;
            
        case "setdatapointvalueontimeasstring":
            SetDatapointValueOnTime(daArgs[1], daArgs[2], daArgs[3]);
            break;

        case "setcompresseddatapointvalue":
            SetCompressedDatapointValue(daArgs[1], daArgs[2]);
            break;
         
        case "setcompresseddatapointvalueontime":
            SetCompressedDatapointValueOnTime(daArgs[1], daArgs[2], daArgs[3]);
            break;                 
            
        /* 
            Misc functions
         */
        case "echo":
            result = Echo(daArgs[1]);
            break;
            
        case "query":
          result = Query(daArgs[1]);
          break;
          
        case "getdescription"  :
          result = GetDescription(daArgs[1]);
          break;
          
        case "getalarms"  :
          result = GetAlarms(daArgs[1], daArgs[2]);
          break;
          
        case "gettimesforvalue":
          result = GetTimesForValue(daArgs[1], daArgs[2], daArgs[3], daArgs[4]);
          break;

        case "gettimesforalert":
          result = GetTimesForAlert(daArgs[1], daArgs[2], daArgs[3]);
          break;
           
        case "evalstring":
          result = EvalString(daArgs[1]);
          break;
		  
        case "evalstringarray":
          result = EvalStringArray(daArgs[1]);
          break;
		  
        case "evalstringdoublearray":
          result = EvalStringDoubleArray(daArgs[1]);
          break;
          
        case "checkdp":
          result = CheckDp(daArgs[1]);
          break;
          
        case "getalarmsonperiod":
          result = GetAlarmsOnPeriod(daArgs[1], daArgs[2], daArgs[3]);
          break; 
          
        /*
          GetTagTree function
        */
        case "gettagtree": 
          result = GetTagTree();
          break;

        /*
          Execute commands functions
        */
        case "executecommands":
          result = ExecuteCommands(daArgs[1]);
          result = jsonEncode(result);
          break;

		/*
          Authorization functions
        */
        case "authenticateuser":
          result = checkPassword(getUserId(daArgs[1]), daArgs[2]);
          break;

        /* 
            Default: method not found
         */
        default:
            sResponse = xmlrpcReturnFault(1, "Method not found: " + sMethod);
            isError = true;
            exit;
    }
            
    if (!isError)
        sResponse = xmlrpcReturnSuccess(result);
    
    //DebugN("RESPONSE >> " + sResponse);
            
    return makeDynString(sResponse, "Content-Type: text/xml");
}
