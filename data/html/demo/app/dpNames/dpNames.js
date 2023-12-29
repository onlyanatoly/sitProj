let dpQueryDataTableObj;

//load external library dataTable (js+css)
$.when(
  $.getScript("/data/html/js/vendor/dataTables/1.10.16/dataTables.min.js"),
  $.getStylesheet("/data/html/js/vendor/dataTables/1.10.16/dataTables.min.css")
).then(function() {
  //ok, datatables are ready

  //convert each table which contains the class 'dataTable' to a datatable
  dpQueryDataTableObj = $("#dpNamesDataTable").DataTable();

  let dpNamesQuery;

  //bind a listener on the keyup to html element dpNamesDpName
  $('#dpNamesDpName').on("keyup", function() {
    clearTimeout(dpNamesQuery);
    let value = $(this).val();

    // Set a timeout of 1 second. if the timeout has not been cleard (by continuing typing) ... call function executeQuery
    dpNamesQuery = setTimeout(function() {
      //empty the table
      dpQueryDataTableObj.clear().draw();

      //execute the query if user entered a value

      if (value.length)
      {
        executeQuery(value);
      }

    }, 1000);
  });
});

let executeQuery = function(value) {
  //show the nice "Querying..." in order to inform the user about an active query...
  $(".inputHint").show();

  oaJsApi.dpNames(value, "", {
    success: function(data) {
      //we arrived in the success callback, therefore we received an answer from server and query has been finished.
      //lets hide the "Querying..."
      $(".inputHint").hide();

      if (data && data.length)
      {
        //for each entry in the result list add a row in our datatable
        $.each(data, function(idx, dataPointName) {
          dpQueryDataTableObj.row.add([dataPointName]);
        });
        //after finishing lets draw the datatable
        dpQueryDataTableObj.draw();
      }
    }
  });
};

//when document is ready fire firest query with initial value
$(document).ready(function() {
  executeQuery($('#dpNamesDpName').val());
});
