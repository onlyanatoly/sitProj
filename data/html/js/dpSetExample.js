//@author Markus Uebeleis
// created 2018-07-06

// Load some (gauge) settings and the gauge library
let dpName = $("#dp-name").val();
let gaugeObj = null;

$.when(
  $.getScript("/data/html/demo/app/dpSet/settings.js"),
  $.getScript("/data/html/js/vendor/gaugejs.1.3.6.min.js")
).then(function() {
  // Gauge library has been loaded, convert the 'gauge' html to a nice gauge visualisation
  let target = document.getElementById('gauge');
  opts.percentColors = [[0.0, "#0000ff"], [10.0, "#0000ff"]];
  gaugeObj = new Gauge(target).setOptions(opts); // apply the options from settings.js
  gaugeObj.maxValue = 350; // set max gauge value
  gaugeObj.setMinValue(0);  // Prefer setter over gauge.minValue = 0
  gaugeObj.animationSpeed = 32; // set animation speed (32 is default value)

  // Connect the gauge to the datapoint element
  oaJsApi.dpConnect("ExampleDP_Rpt1.:_original.._value", true, {
    success: function(data) {
      if ( (typeof(data) === "object") && data.value && data.value[0] )
      {
        let value = data.value[0];
        $("#dp-value").val(value);
        gaugeObj.set(value);

      }
    }
  });
});

/**
 * Click handler for the button.
 */
$("#colorDiv1").click(function() {

  // Get the current background color of js-button
  let currentBackgroundColor = hexc($(this).css("background-color"));

  // Calculate new color
  let newColor = (currentBackgroundColor === "#ff0000" ? "#0000ff" : "#ff0000");

  // Colorize js-button
  $(this).css("background-color", newColor);

  // Colorize gauge
  gaugeObj.setOptions({percentColors: [[0.0, newColor], [10.0, newColor]]});

  // Colorize qt-button
  oaJsApi.setValue("PUSH_BUTTON1", "backCol", (currentBackgroundColor === "#ff0000" ? "blue" : "red"));
});

/**
 * Toggle color between red and blue on gauge and button.
 * This method will be fired from control over oaJsApi.
 */
function toggleColor()
{
  // Fetch the color from the arguments
  let newColor = (arguments[0] === "blue" ? "#ff0000" : "#0000ff");
  
  // Colorize gauge
  gaugeObj.setOptions({percentColors: [[0.0, newColor], [10.0, newColor]]});

  // Colorize button
  $("#colorDiv1").css("background-color", newColor);
}

/**
 * Helper function to convert from rgb(r,g,b) to hex.
 * @param colorval The color in the RGB format
 * @return color The color in the hex format
 */
function hexc(colorval)
{
  // Spot and remove 'rgb' from the color name
  var parts = colorval.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
  delete(parts[0]);
  
  // Convert numbers to hex strings
  for(var i = 1; i <= 3; ++i)
  {
    parts[i] = parseInt(parts[i]).toString(16);
    if ( parts[i].length == 1 )
    {
      parts[i] = '0' + parts[i];
    }
  }
  
  // Add hashtag and return the color
  color = '#' + parts.join('');
  return color;
}