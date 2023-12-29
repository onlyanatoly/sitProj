'use strict';
/**
 *
 * @class
 */
let oaJsApi = (function()
{

  /**
   *
   *  This Callback will be fired in case of an exception. If no errorCallback is registered, oaJsApi will console.error to console.
   *  Arguments can be different, depends who calls the error handler. Could be catch block of javascript or WinCCOA.
   * @callback errorCallback

   * @example
   *
   * oaJsApi.registerListeners({
   *  error: function()
   *  {
   *    console.error(arguments);
   *  }
   * });
   */

  let logLevel = {
    timeprofile: false,
    i: false,
    w: true,
    e: true,
    d: false
  };
  let connection = null;
  let execCallbacks = {};
  let listeners = {};
  let timeProfiles = {};
  let cs = null;
  let requestId = 0;
  let ulcContext = false;

  let baseParams = null;
  let _log = {
    t: function(message, uuid, time)
    {
      if (logLevel.timeprofile)
      {
        if (typeof (time) === "undefined")
        {
          time = Date.now();
        }

        if (typeof (timeProfiles[uuid]) === "undefined")
        {
          timeProfiles[uuid] = {};
        }

        timeProfiles[uuid][message] = {
          time: time
        };
      }
    },
    d: function(message)
    {
      if (logLevel.d)
      {
        console.debug(message);
      }
    },
    i: function(message)
    {
      if (logLevel.i || logLevel.d)
      {
        console.log(message);
      }
    },
    w: function(message)
    {
      if (logLevel.w || logLevel.i || logLevel.d)
      {
        console.warn(message);
      }
    },
    e: function(message)
    {
      if (logLevel.e || logLevel.w || logLevel.i || logLevel.d)
      {
        console.error(message);
      }
    }
  };
  let _setBaseParams = function(params)
  {
    if (baseParams === null)
    {
      baseParams = params;
    }
    else
    {
      baseParams = Object.extend(baseParams, params);
    }

  };

  let _setLogLevel = function(newLogLevel)
  {

    Object.extend(logLevel, newLogLevel);
  };

  /**
   * Opens a WebSock Object to the given baseUrl.
   * @function oaJsApi.connect

   * @param {String} baseUrl
   * @param {Object=} options Configuration Options
   * @param {Object=} options.webViewId WebView ID
   * @param {Object=} options.listeners register global listeners
   * @param {requestCallback=} options.listeners.success success Callback of connect
   * @private
   * @example
   *
   *  oaJsApi.connect("wss://localhost:12345", {
   *    baseParams: {
   *       webViewId: 1
   *    },
   *    listeners: {
   *       success: function() {
   *          console.log("Connected to WinCC OA");
   *       }
   *    }
   *  });

   */
  let _connect = function(baseUrl, options)
  {

    if (options && options.listeners)
    {
      _registerListeners(options.listeners);
    }
    try
    {
      if (typeof (_cpp_connection) != "undefined")
      {
        _cpp_connection.addEventListener = function(name, func)
        {
          _log.d("_cpp_connection.addEventListener; name=" + name);
          _cpp_connection[name].connect(func);
        };
        connection = _cpp_connection;
        _log.d("connection = _cpp_connection;");
      }
      else
      {
        connection = new WebSocket(baseUrl);
        connection.binaryType = "arraybuffer";
      }

      connection.addEventListener('message', function(event)
      {
        _onIncomingMessage(JSON.parse(event.data));
      });
      if (typeof (options.baseParams) === "object")
      {
        _setBaseParams(options.baseParams);
      }

      if (typeof (options.log) === "object")
      {
        _setLogLevel(options.log);
      }

      let openCallBack = function()
      {
        _log.d("reached open state");
        _sendMessage('init', {}, {
          success: function()
          {
            if (options && options.listeners && options.listeners.success && typeof (options.listeners.success) === "function")
            {
              options.listeners.success(connection);

            }
          }
        }, false); // init call

      };

      if (typeof (_cpp_connection) != "undefined")
      {
        openCallBack();
      }
      else
      {
        connection.addEventListener('open', openCallBack);
      }

    } catch(error)
    {

      if (listeners.error)
      {
        listeners.error(error);
      }
      else
      {
        console.error(error);
        return false;
      }

    }
  };
  /**

   * Closes the active instance
   * @private
   */
  let _close = function()
  {
    if (instance !== null)
    {
      instance.close();
    }
  };

  let _onIncomingMessage = function(data)
  {
    let callback = null;
    _log.i("incoming message:" + JSON.stringify(data));
    _log.t("end", data.uuid);

    let isSuccess = (data.success === true || data.success === "true");
    let errorToReport = !isSuccess;
    if (execCallbacks[data.uuid] && typeof (execCallbacks[data.uuid]) === "object")
    {

      if (isSuccess)
      {

        /*
         let answer = {};
         if (logLevel.timeprofile === true)
         {
         _log.t("serverStart", data.uuid, data.procStartTime1);
         _log.t("serverEnd", data.uuid, data.procEndTime1);

         //generate a readable answer

         answer.total = timeProfiles[data.uuid].end.time - timeProfiles[data.uuid].start.time;
         answer.server = timeProfiles[data.uuid].serverEnd.time - timeProfiles[data.uuid].serverStart.time;
         answer.websocket = answer.total - answer.server;

         }*/
        if (!(data.suppressSuccessCallback === true || data.suppressSuccessCallback === "true") &&
          typeof (execCallbacks[data.uuid].success) === "function")
        {

          execCallbacks[data.uuid].success(data.data);
        }

      }
      else
      {
        if (typeof (execCallbacks[data.uuid].error) === "function")
        {
          execCallbacks[data.uuid].error(data);
          errorToReport = false;  // error is reported
        }
      }

      //if this callback has flag lastInRequest true... server will not send any callbacks based on this id again
      //therefore we can delete the callback
      if (typeof (data.lastInRequest) === "boolean" && data.lastInRequest === true)
      {
        delete execCallbacks[data.uuid];
      }

    }
    else
    {
      if (typeof (window) !== "undefined" && typeof (window[data.functionName]) === "function")
      {
        if (!(typeof (data.data) === "object" && Array.isArray(data.data) === true))
        {
          data.data = [data.data];
        }
        //noinspection JSUnresolvedVariable
        window[data.functionName].apply(this, data.data);
      }
    }
    if (errorToReport)
    {
      // there's an error, but we didn't report it yet
      if (listeners.error && typeof (listeners.error) === "function")
      {
        listeners.error(data);
      }
      else
      {
        console.error(data);
      }
    }
  };

  /**
   * Triggers the messageReceived Event on the WebView Ewo
   * @function oaJsApi.toCtrl

   * @param {Object} params Object which will be forwarded to the messageReceived event of the WebView EWO
   * @param {Object=} options
   * @param {requestCallback=} options.success Success Callback; Only triggered if msgToJs() is called within the messageReceived Event. If a success callback is given but msgToJs() is not called, some memory allocated for handling the callback will not be freed.
   * @param {errorCallback} options.error Error Callback
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   * @example
   * let params={
   *   exampleKey : "exampleValue"
   * };
   * oaJsApi.toCtrl(params,{
   *   success: function(data) {
   *      console.log(data);
   *   },
   *   error: function() {
   *      console.error(arguments);
   *   }
   * });
   *
   */
  let _toCtrl = function(params, options)
  {
    return _sendMessage('msgToCtrl', params, options, false);
  };

  /**
   * Triggers an existing Control-Function
   * @function oaJsApi.toCtrlFn

   * @param {String} functionName The Name of the Function which should be triggered
   * @param {Object} params A Array which represents the Arguments of the Function
   * @param {Object=} options
   * @param {requestCallback=} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @private
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   * @example
   * oaJsApi.toCtrlFn("setValue",  [ "\"PUSH_BUTTON1\"", "\"foreCol\"", "\"blue\""], {
   *   success: function(data) {
   *      console.log(data);
   *   },
   *   error: function() {
   *      console.error(arguments);
   *   }
   * });
   */
  let _toCtrlFn = function(functionName, params, options)
  {
    params = {
      functionName: functionName,
      params: params
    };
    return _sendMessage("toCtrlFn", params, options, false);
  };

  /**
   * Forwards the given params on another Webview Ewo
   * @function oaJsApi.msgToWebViewEwo

   * @param {String} shapeName Name of the WebViewEwo
   * @param {String} functionName Name of the Function which should be executed on the shapeName
   * @param {Array} params An Array of arguments which will be forwarded
   * @param {Object=} options
   * @param {callback=} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @example
   *
   * oaJsApi.msgToWebViewEwo("WebView_Ewo2", "myFunction", [{key: "value"},"string", 3]);
   *
   * //in document of WebView_Ewo2
   * function myFunction(aObjectArgument, aStringArgument, aNumberArgument) {
   *   console.log(aObjectArgument);
   *   console.log(aStringArgument);
   *   console.log(aNumberArgument);
   * }
   */
  let _msgToWebViewEwo = function(shapeName, functionName, params, options)
  {

    let iframeList = window.parent.$("iframe[webviewewo-name='" + shapeName + "']");

    if (iframeList.length)
    {
      for(let i = 0; i < iframeList.length; i++)
      {
        iframeList[i].contentWindow[functionName].apply(this, params);
      }
    }
    else
    {
      params = {
        shapeName: shapeName,
        functionName: functionName,
        params: params
      };
      _sendMessage("callExecJsOnEwo", params, options);
    }
  };

  /**
   * @callback oaJsApi~dpConnectCallback
   * @param {Array} data returned Data by Server for dpConnect
   * @example
   * {
   *  "dp": ["System1:_MemoryCheck.AvailKB:_original.._value"],
   * "value": [22408656]
   * }
   * //in case of multiple values:
   * {
   *  "dp": ["System1:_MemoryCheck.AvailKB:_original.._value", "System1:_MemoryCheck.FreeKB:_original.._value"],
   * "value": [1, 2]
   * }
   */

  /**
   * Calls a callback function whenever the passed data point values/attributes change.
   * @function oaJsApi.dpConnect
   * @param {String|Array} dpName Name of the Data Point Element
   * @param {bool} answer Specifies if the callback function should be executed the first time already when the dpConnect() is called or first every time a value changes
   * @param {Object} options
   * @param {oaJsApi~dpConnectCallback} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   * @example
   *
   * oaJsApi.dpConnect('System1:_MemoryCheck.AvailKB:_original.._value', true, {
   *   success: function(data) {
   *      console.log(data);
   *   },
   *   error: function() {
   *      console.error(arguments);
   *   }
   * });
   */
  let _dpConnect = function(dpName, answer, options)
  {
    if (!(_requireSuccessCallback(options)))
    {
      return false;
    }

    let params = {
      dpName: dpName,
      answer: answer
    };

    // clone options and inject the dpName in order to find the combination in the dpDisconnect
    let connectOptions = Object.extend({}, options);
    connectOptions.dpName = dpName;

    return _sendMessage("dpConnect", params, connectOptions, true);
  };

  /**
   * Disconnects the hotlink
   * The list of the first argument of multiple datapoints (dpName) has to be the in the same order as in dpConnect.
   * @function oaJsApi.dpDisconnect
   * @param {String|Array} dpName Name of the Data Point Element
   * @param {Function} callback The callback which should be disconnected
   * @param {Object=} options
   * @param {callback=} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   */
  let _dpDisconnect = function (dpName, callback, options)
  {
    let originalCallback = null;
    let params = null;
    let disconnectOptions = {};

    //find the original uuid
    for (var idx in execCallbacks)
    {
      let item = execCallbacks[idx];
      idx = parseInt(idx);
      if (item.success && item.success === callback && item.dpName && isEqual(item.dpName, dpName))
      {
        // extract what we need from options
        if (options)
        {
          Object.extend(disconnectOptions, options);
          if (typeof (options.success) === "function")
          {
            originalCallback = options.success;
          }
        }

        // create a new success callback
        disconnectOptions.success = function (data)
        {
          if (typeof (execCallbacks[idx]) !== "undefined")
          {
            delete execCallbacks[idx];
          }
          if (typeof (originalCallback) === "function")
          {
            originalCallback(data);
          }
        };

        params = {
          dpName: dpName,
          connectUuid: idx
        };
        break;

      }
    }

    if (disconnectOptions.success)
    {
      return _sendMessage("dpDisconnect", params, disconnectOptions, true);
    }
    else
    {
      // callback not found in execCallbacks
      return false;
    }
  };
  /**
   * Assigns values to data point attributes
   * @function oaJsApi.dpSet

   * @param {String|Array} dpName Name of the Data Point Element
   * @param {String|Array} value New Value for the Data Point
   * @param {Object=} options
   * @param {callback=} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   * @example
   * oaJsApi.dpSet('System1:_MemoryCheck.AvailKB:_original.._value', '1234', {
   *   success: function() {
   *      console.log("dpSet succeeded");
   *   },
   *   error: function() {
   *      console.error(arguments);
   *   }
   * });
   */
  let _dpSet = function(dpName, value, options)
  {
    let params = {
      dpName: dpName,
      value: value
    };
    return _sendMessage("dpSet", params, options, true);
  };

  /**
   * @callback oaJsApi~dpGetPeriodCallback
   * @param {Object} data returned Data by Server for dpGetPeriod
   * @example
   * {
   *   "data": [
   *     54321
   *   ],
   *   "dataTime": [
   *     "2018-01-09T11:32:14"
   *   ]
   * }
   *
   * //in case of multiple dpes
   * {"data":[
   *      [0,23642068,23566520,23543584],
   *      [33343448]
   *    ],
   *    "dataTime":[
   *       [1551780370405,1551949331446,1551949336690,1551949341993],
   *       [1551948923632]
   *    ]
   * }
   */

  /**
   * Querying DP attributes over a particular time period
   * @function oaJsApi.dpGetPeriod
   * @param {Date} startTime
   * @param {Date} endTime
   * @param {Number} count
   * @param {String|Array} dpName
   * @param {Object} options
   * @param {oaJsApi~dpGetPeriodCallback} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @example
   * oaJsApi.dpGetPeriod(new Date(2017,5,5), new Date(2017,5,6), 5, 'System1:_MemoryCheck.AvailKB:_original.._value', {
   *   success: function(data) {
   *      console.log(data);
   *   },
   *   error: function() {
   *      console.error(arguments);
   *   }
   * });
   *
   * //query multiple dpe
   *
   * oaJsApi.dpGetPeriod(new Date(2019,2,5), new Date(2019,2,8), 5, ['System1:_MemoryCheck.AvailKB:_original.._value','System1:_MemoryCheck.UsedKB:_original.._value'], {
   *  success: function(data) {
   *     console.log(data);
   *  },
   *  error: function() {
   *     console.error(arguments);
   *  }
   *});
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   */
  let _dpGetPeriod = function(startTime, endTime, count, dpName, options)
  {
    if (!(_requireSuccessCallback(options)))
    {
      return false;
    }
    let params = {
      startTime: _formatDate(startTime),
      endTime: _formatDate(endTime),
      count: count,
      dpName: dpName
    };
    return _sendMessage("dpGetPeriod", params, options, true);
  };

  /**
   * @callback oaJsApi~alertGetPeriodCallback
   * @param {Object} data returned Data by Server for alertGetPeriod
   * @example
   *
   *   {
   *   data: ["Value to 1"],
   *   dataCount: [0],
   *   dataDpa: ["System1:ExampleDP_AlertHdl1.:_alert_hdl.._text"],
   *   dataTime: [1551951458868]
   *   }
   *
   * //result for multiple attributes
   *   {
   *   data: [
   *        ["Value to 1"], [60]
   *     ],
   *     dataCount: [0],
   *     dataDpa: [
   *       ["System1:ExampleDP_AlertHdl1.:_alert_hdl.._text"],
   *       ["System1:ExampleDP_AlertHdl1.:_alert_hdl.._prior"]
   *   ],
   *     dataTime: [1551951458868]
   * }
   */

  /**
   * Gets alarms inside a time interval

   * @function oaJsApi.alertGetPeriod
   * @param {Date} startTime Start time of the interval from which alarms are returned
   * @param {Date} endTime End time of the interval from which alarms are returned
   * @param {String|Array} dpName Name(s) of the alert config(s) to return
   * @param {Object} options
   * @param {oaJsApi~alertGetPeriodCallback} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @example
   * oaJsApi.alertGetPeriod(
   *   new Date(2019,2,5),
   *   new Date(2019,2,8),
   *   'System1:ExampleDP_AlertHdl1.:_alert_hdl.._text',
   *   {
   *     success: function(data) {
   *       console.log(data);
   *     },
   *     error: function() {
   *       console.error(arguments);
   *     }
   *   }
   * );
   *
   * //query multiple dpe
   * oaJsApi.alertGetPeriod(
   *   new Date(2019,2,5),
   *   new Date(2019,2,8),
   *   ['System1:ExampleDP_AlertHdl1.:_alert_hdl.._text', 'System1:ExampleDP_AlertHdl1.:_alert_hdl.._prior'],
   *   {
   *     success: function(data) {
   *       console.log(data);
   *     },
   *     error: function() {
   *       console.error(arguments);
   *     }
   *   }
   * );
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   */
  let _alertGetPeriod = function(startTime, endTime, dpName, options)
  {
    if (!(_requireSuccessCallback(options)))
    {
      return false;
    }
    let params = {
      startTime: _formatDate(startTime),
      endTime: _formatDate(endTime),
      dpName: dpName
    };
    return _sendMessage("alertGetPeriod", params, options, true);
  };

  /**
   *
   * @callback oaJsApi~dpGetCallback
   * @param {String|Number|Array} data returned Data by Server for dpGet
   * @example
   * // in case of Number
   * 4
   * // in case of multple Arguments: oaJsApi.dpGet(['System1:_MemoryCheck.AvailKB:_original.._value','System1:_MemoryCheck.UsedKB:_original.._value','System1:_MemoryCheck.AvailKB:_original.._value',...]
   * [
   * 22783640,
   * 10559852,
   * 22783640
   ]
   */

  /**
   * Reads values of data point attributes
   * @function oaJsApi.dpGet
   * @param {String|Array} dpName Name of the Data Point Element
   * @param {Object} options
   * @param {oaJsApi~dpGetCallback} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @example
   *
   * oaJsApi.dpGet('System1:_MemoryCheck.AvailKB:_original.._value', {
   *   success: function(data) {
   *      console.log(data);
   *   },
   *   error: function() {
   *      console.error(arguments);
   *   }
   * });
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   */
  let _dpGet = function(dpName, options)
  {
    if (!(_requireSuccessCallback(options)))
    {
      return false;
    }
    let params = {
      dpName: dpName
    };
    return _sendMessage("dpGet", params, options, true);
  };

  /**
   * The function setValue() sets any number of graphics attributes of a graphics object
   * @function oaJsApi.setValue
   * @param {string} shapeName Name of the graphics object as it can be specified in the attribute editor. " " (empty string) addresses its own object
   * @param {string} property Name of the basic attribute
   * @param value Parameters that describe the graphics attribute. The number of parameters depends on the graphics attribute
   * @param {Object=} options
   * @param {callback=} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   * @example
   * oaJsApi.setValue("Vision_1.yourpanelname.pnl:PUSH_BUTTON1", "foreCol", "red", {
   * success: function() {
   *    console.log("Setvalue succeeded");
   * },
   * //optional
   * error: function() {
   *    console.log(data);
   * }
   * });
   *
   * //query multiple properties
   * oaJsApi.setValue("PUSH_BUTTON1", ["foreCol", "text"], ["green", "red"], {
   * success: function() {
   *    console.log("Setvalue succeeded");
   * },
   * //optional
   * error: function() {
   *    console.log(arguments);
   * }
   * });
   */
  let _setValue = function(shapeName, property, value, options)
  {
    let params = {
      shapeName: shapeName,
      propertyName: property,
      newValue: value
    };
    return _sendMessage("setValue", params, options, true);
  };

  /**
   *
   * @callback oaJsApi~getValueCallback
   * @param {*} data returned Data by Server for getValue
   * @example
   * { "0" : "_ButtonText"}
   *
   * //in case of multiple attributes of same shape
   * [ "_ButtonText" , "PUSH_BUTTON1" ]
   *
   */

  /**
   * Reads graphics attribute values for a graphics object in variables
   * @function oaJsApi.getValue
   * @param {string} shapeName Name of the graphics object
   * @param {string} property Names of the attributes
   * @param {Object} options
   * @param {oaJsApi~getValueCallback} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   * @example
   *    oaJsApi.getValue("PUSH_BUTTON1", "foreCol", {
   * success: function() {
   *    console.log(arguments);
   * },
   * //optional
   * error: function() {
   *    console.log(arguments);
   * }
   * });
   *
   *
   * //query multiple properties
   *   oaJsApi.getValue("PUSH_BUTTON1", ["foreCol", "text"], {
   *    success: function(data) {
   *      console.log(data);
   *   },
   * //optional
   *    error: function() {
   *      console.log(arguments);
   *    }
   * });
   *   */
  let _getValue = function(shapeName, property, options)
  {
    if (!(_requireSuccessCallback(options)))
    {
      return false;
    }
    let params = {
      shapeName: shapeName,
      propertyName: property,
    };
    return _sendMessage("getValue", params, options, true);
  };

  /**
   * @callback oaJsApi~dpGetAsynchCallback
   * @param {String|Number|Array} data returned Data by Server for dpGet
   * @example
   * // in case of Number
   * 4
   * // in case of multple Arguments: oaJsApi.dpGet(['System1:_MemoryCheck.AvailKB:_original.._value','System1:_MemoryCheck.UsedKB:_original.._value','System1:_MemoryCheck.AvailKB:_original.._value', ...]
   * [
   * 22783640,
   * 10559852,
   * 22783640
   * ]
   */

  /**
   * Returns the historic values that were valid at that time
   * @function oaJsApi.dpGetAsynch
   * @param {Date} time
   * @param {String|Array} dpName
   * @param {Object} options
   * @param {oaJsApi~dpGetAsynchCallback} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @example
   * oaJsApi.dpGetAsynch(new Date(), 'System1:ExampleDP_Trend1.:_original.._value', {
   *   success: function(data) {
   *      console.log(data);
   *   },
   *   error: function() {
   *      console.error(arguments);
   *   }
   * });
   *
   * //query multiple dpe
   * oaJsApi.dpGetAsynch(new Date(), ['System1:ExampleDP_Trend1.:_original.._value','System1:ExampleDP_Rpt2.:_original.._value'], {
   *    success: function(data) {
   *     console.log(data);
   *  },
   *  error: function() {
   *     console.error(arguments);
   *  }
   * });
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   */
  let _dpGetAsynch = function(time, dpName, options)
  {
    if (!(_requireSuccessCallback(options)))
    {
      return false;
    }
    let params = {
      time: _formatDate(time),
      dpName: dpName
    };
    return _sendMessage("dpGetAsynch", params, options, true);
  };

  /**
   * @private

   * @param {String} command Command, which will be forwarded to cpp
   * @param {Object} params This Object will pe passed to cpp
   * @param {requestCallback=} callback  Default callback
   * @param {Boolean} toEvent
   * @returns {Number} Connection ID
   */
  let _sendMessage = function(command, params, callback, toEvent)
  {
    let returnValue = false;
    //increase requestId
    requestId++;

    let payload = {
      toEvent: toEvent,
      command: command,
      params: params,
      uuid: requestId
    };

    //injecting the baseParams into the payload
    //$.extend(payload, payload, baseParams);
    payload = Object.extend(payload, baseParams);

    if (callback && callback.success && (typeof callback.success) === "function")
    {
      execCallbacks[requestId] = callback;
    }
    try
    {

      _log.i("sending " + JSON.stringify(payload));
      _log.t("start", requestId);

      if (cs !== null)
      {
        cs(payload);
      }
      else
      {
        let payloadJson = JSON.stringify(payload);
        verifyPayloadSize(payloadJson.length);
        connection.send(payloadJson);
      }

      returnValue = true;
    } catch(error)
    {
      if (listeners.error)
      {
        listeners.error(error);
      }
      else
      {
        console.error(error);
      }

    }

    return returnValue;

  };

  /**
   * Inject a custom sender method. This method will be called with a payload object instead
   * @function oaJsApi.customSender
   * @param customSender Function
   */
  let _customSender = function(customSender)
  {
    cs = customSender;
  };

  /**
   * @callback oaJsApi~dpNamesCallback
   * @param {Array} data returned Data by Server for dpNames
   * @example
   * //for "System1:_MemoryCheck.*"
   * [
   * "System1:_MemoryCheck.AvailKB",
   * "System1:_MemoryCheck.AvailPerc",
   * "System1:_MemoryCheck.EmergencyKBLimit",
   * "System1:_MemoryCheck.FreeKB",
   * "System1:_MemoryCheck.FreePerc",
   * "System1:_MemoryCheck.Status",
   * "System1:_MemoryCheck.TotalKB",
   * "System1:_MemoryCheck.UsedKB"
   * ]

   * Returns all the data point names or data point element names that match a pattern. The data point structures are written to the array in alphabetical order
   * @function oaJsApi.dpNames

   * @param {String} dpPattern Pattern
   * @param {String=} dpType Data point type. Allows to restrict the returned data points to a specific data point type. When using the parameter only data points that are matching the pattern and the selected data point type will be returned.
   * @param {Object} options
   * @param {oaJsApi~dpNamesCallback} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @example
   * oaJsApi.dpNames('System1:ExampleDP_Trend1.:_original.._value', null, {
   *   success: function(data) {
   *      console.log(data);
   *   },
   *   error: function() {
   *      console.error(arguments);
   *   }
   * });
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   */
  let _dpNames = function(dpPattern, dpType, options)
  {
    if (!(_requireSuccessCallback(options)))
    {
      return false;
    }
    let params = {
      dpPattern: dpPattern,
      dpType: dpType
    };
    return _sendMessage("dpNames", params, options, true, true);
  };

  /**
   *
   * @callback oaJsApi~dpQueryCallback
   * @param {Array} data returned Data by Server for dpQuery
   * @example
   * [
   * [
   *   "",
   *   ":_original.._value"
   * ],
   * [
   *   "System1:ExampleDP_Arg1.",
   *   1234
   * ],
   * [
   *   "System1:ExampleDP_Arg2.",
   *   50
   * ]
   *]

   * Retrieves attribute values with the help of SQL statements
   * @function oaJsApi.dpQuery
   * @param {String} query
   * @param {Object} options
   * @param {oaJsApi~dpQueryCallback} options.success Success Callback
   * @param {errorCallback=} options.error Error Callback
   * @example
   * let params={
   *   query: "SELECT '_original.._value' FROM 'ExampleDP_Arg*' WHERE _DPT= \"ExampleDP_Float\"",
   * };
   *
   * oaJsApi.dpQuery("SELECT '_original.._value' FROM 'ExampleDP_Arg*' WHERE _DPT= \"ExampleDP_Float\"", {
   *   success: function(data) {
   *      console.log(data);
   *   },
   *   error: function() {
   *      console.error(arguments);
   *   }
   * });
   * @returns {boolean} Defines whether the server has accepted the message or not. In order to know if the command was successful or to retrieve the datas use the success/error callback.
   */
  let _dpQuery = function(query, options)
  {
    if (!(_requireSuccessCallback(options)))
    {
      return false;
    }
    let params = {
      query: query
    };
    return _sendMessage("dpQuery", params, options, true, true);
  };

  /**
   * Register a listener
   * @function oaJsApi.registerListeners
   * @param {Object} listenerObject The key is the name of the listener, the Value is the callback Function
   * @example
   * oaJsApi.registerListeners({
   * error: function() {
   *    console.error(arguments)
   *  });
   */
  let _registerListeners = function(listenerObject)
  {
    for(var name in listenerObject)
    {
      listeners[name] = listenerObject[name];
    }
  };

  let _unregisterListeners = function(name)
  {
    if (listeners[name])
    {
      delete (listeners[name]);
    }

  };
  let _requireSuccessCallback = function(options)
  {
    if (!(typeof (options) === "object" && typeof (options.success) === "function"))
    {
      let error = {
        responseMessage: "Success Callback is mandatory"
      };
      if (listeners.error)
      {
        listeners.error(error);
        return false;
      }
      else
      {
        console.error(error);
        return false;
      }
    }
    return true;
  };

  /**
   * Returns a special dateformat for WinCC OA in the format <secondsSinceEpoch>.<ms>
   * @param {Date} date a Javascript Date Object
   * @private
   * @returns {String}
   */
  let _formatDate = function(date)
  {
    return (date.getTime() / 1000);
  };

  let _setUlcContext = function(value)
  {
    ulcContext = value;
  };

  return {
    setLogLevel: _setLogLevel,
    //toCtrlFn: _toCtrlFn,
    toCtrl: _toCtrl,
    msgToWebViewEwo: _msgToWebViewEwo,
    setBaseParams: _setBaseParams,
    customSender: _customSender,
    connect: _connect,
    dpConnect: _dpConnect,
    dpDisconnect: _dpDisconnect,
    dpSet: _dpSet,
    dpGetAsynch: _dpGetAsynch,
    dpQuery: _dpQuery,
    dpGetPeriod: _dpGetPeriod,
    dpNames: _dpNames,
    dpGet: _dpGet,
    setValue: _setValue,
    getValue: _getValue,
    alertGetPeriod: _alertGetPeriod,
    close: _close,
    registerListeners: _registerListeners,
    onIncomingMessage: _onIncomingMessage,
    unregisterListeners: _unregisterListeners,
    setUlcContext: _setUlcContext
  };
})();
