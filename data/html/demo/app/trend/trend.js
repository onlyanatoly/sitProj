//let url = "https://cdn.plot.ly/plotly-latest.min.js";
//let url = "https://cdn.plot.ly/plotly-2.25.2.min.js";
//let url ="C:\WinCC_OA_Proj\SitProj\data\html\plotly-2.25.2.min.js";
//let url = "/data/html/plotly.js-1.34.0/dist/plotly.min.js";
//<script type="text/javascript" src="/data/html/plotly-2.25.2.min.js"></script>
/* If no internet connection is available the Plotly libraries can be downloaded seperately 
and placed on your local machine or network (e.g. your projects /data/html folder)*/


$.when(
$.getScript("plotly-2.25.2.min.js")
).done( function () {
  //Adds a new plot area to the "trend" container
  Plotly.newPlot('trend',
    [{
      type: 'scatter'
    }],
    {
      //Trend Caption
      title: 'Memory Information',
      //X-axis label and formatting
      xaxis:
      {
        title: 'Time',
        type: 'date',
      },
      //Y-axis label
      yaxis:
      {
        title: 'RAM [kb]'
      }
    });
  //Adds a new trace/trend line to the plot area
  Plotly.addTraces('trend', {
    x: [new Date()],
    y: [0],
    name: 'AvailKB'
  }, 0);
  //Adds a second new trace/trend line to the plot area
  Plotly.addTraces('trend', {
    x: [new Date()],
    y: [0],
    name: 'UsedKB'
  }, 1);
  //dpConnect to the data points _MemoryCheck.AvailKB and System1:_MemoryCheck.UsedKB
  oaJsApi.dpConnect(['System1:_MemoryCheck.AvailKB:_original.._value',
    'System1:_MemoryCheck.UsedKB:_original.._value'], false, {
      success: function (data) {  //success callback of the dpConnect function
        //time variable used to display the time inside of axis caption
        var time = new Date();
        //Adds the data point value (data.value[0]) of the first stated data point (_MemoryCheck.AvailKB)
        //at the current time to the first trace (ID:0)
        Plotly.extendTraces('trend', {
          x: [[time]],
          y: [[data.value[0]]]
        }, [0]);
        //Adds the data point value (data.value[1]) of the second stated data point (_MemoryCheck.UsedKB)
        //at the current time to the second trace (ID:1)
        Plotly.extendTraces('trend', {
          x: [[time]],
          y: [[data.value[1]]]
        }, [1]);
      }
    });
});