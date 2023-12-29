//load some (gaugeObj)settings and the gaugeObj library
let dpName = $("#dp-name").val();
//ok, gaugeObj library has been loaded, convert the 'gaugeObj' html to a nice gaugeObj visualisation
let target = document.getElementById('gauge');
let gaugeObj = new Gauge(target).setOptions(opts); // apply the options from settings.js
gaugeObj.maxValue = 100; // set max gaugeObj value
gaugeObj.setMinValue(0);  // Prefer setter over gaugeObj.minValue = 0
gaugeObj.animationSpeed = 32; // set animation speed (32 is default value)

//connect the gaugeObj to the datapoint element
oaJsApi.dpConnect("ExampleDP_Rpt1.:_original.._value", true, {
  success: function(data) {
    if ( (typeof(data) === "object") && data.value )
    {
      let value = data.value[0];
      gaugeObj.set(value);

      //write back value to field (maybe it has been changed externally)
      $("#dp-value").val(value);

    }
  }
});

//add event handler for dpSet button
$(".dpSetButton").click(function() {
  let value = $("#dp-value").val();
  oaJsApi.dpSet(dpName, value);
});