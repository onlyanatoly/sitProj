let dpQueryDataTableObj;

//load datatables
$.when(
  $.getScript("/data/html/js/vendor/dataTables/1.10.16/dataTables.min.js"),
  $.getStylesheet("/data/html/js/vendor/dataTables/1.10.16/dataTables.min.css")
).then(function()
{
  //convert html element dpQueryResultTable to a datatable
  dpQueryDataTableObj = $("#dpQueryResultTable").DataTable();

  $(".dpQueryButton").click(function()
  {
    //show the table
    $("#dpQueryResultDiv").show();

    //empty the table
    dpQueryDataTableObj.clear().draw();

    //execute the query
    oaJsApi.dpQuery($("#dp-query").val(), {
      success: function(data)
      {
        $.each(data, function(idx, dataPointName)
        {
          dpQueryDataTableObj.row.add(dataPointName);
        });
        dpQueryDataTableObj.draw();
      }
    });
  });
});