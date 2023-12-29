$("#getValueButton").click(function() {
  oaJsApi.getValue("RECTANGLE1", "backCol", {
    success: function(data) {
      //set the value to the input field
      $("#getValueInputField").val(data);
    }
  });
});
$("#setValueButton").click(function() {
  //get the value from the input field
  let backgroundColor = $("#getValueInputField").val();

  oaJsApi.setValue("RECTANGLE1", "backCol", backgroundColor, {
    success: function(data) {

    }
  });
});