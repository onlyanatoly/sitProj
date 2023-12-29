// Convert normal input into datetimepicker
$('#dp-time').datetimepicker({
   format: "Y-m-d H:00:00"
});

$(".dpGetAsynchButton").click(function() {
  // Make a date format with '-' separator
  myDate = $("#dp-time").val();
  myDate = myDate.replace(/ /g, "-");
  myDate = myDate.replace(/:/g, "-");

  var res = myDate.split("-"); // split the date into numbers

  // Create a Date Object based on the selection from the timepicker
  let uDate  = new Date();
  uDate.setFullYear(res[0]);
  uDate.setMonth(res[1] - 1); // -1 , month format is 0-11, e.g. Jan = 0, Dec = 11
  uDate.setDate(res[2]);
  uDate.setHours(res[3]);
  uDate.setMinutes(res[4]);
  uDate.setSeconds(res[5]);

  // Get the dpeName from the html input element
  let dpName = $("#dp-name").val();

  // Pass the arguments into dpgetAsynch of oaJsApi
  oaJsApi.dpGetAsynch(uDate, dpName, {
    success: function(data) {
      $("#dp-value").val(data);
    }
  });
});