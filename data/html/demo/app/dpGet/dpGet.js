//bind the click event of the html dpGetButton
$(".dpGetButton").click(function() {
  //button has been clicked, lets do a dpGet on oaJsApi
  oaJsApi.dpGet($("#dp-name").val(), {
    success: function(data) {
      //we arrived in the success callback
      //lets update the html input element of the form "dp-value"
      $("#dp-value").val(data);
    }
  })
});