/**
 * Register the click handler for the "New Simulator" Button
 */
$("#simulatorAddButton").click(function()
{
  insertRow(null, "", null, null, null);
});

/**
 * Register a new Simulator
 * @param btn
 */
var setSimulatorData = function(btn)
{
  var button = $(btn),
    simId = button.attr("simulator-id"),
    row = $("tr[simulator-id=" + simId + "]"),
    dpName = row.find(".simulatorRowName").val(),
    from = parseInt(row.find(".simulatorRowFrom").val()),
    to = parseInt(row.find(".simulatorRowTo").val()),
    interval = parseInt(row.find(".simulatorRowInterval").val());

  if (typeof(simulatorData.items[simId]) != "undefined" && simulatorData.items[simId].callback !== "undefined")
  {
    clearInterval(simulatorData.items[simId].callback);
  }

  simulatorData.items[simId] = {
    dpName: dpName,
    from: from,
    to: to,
    interval: interval,

    callback: setInterval(function()
    {
      oaJsApi.dpSet(dpName, getRandomInt(from, to));
    }, interval)
  };
};

/**
 * Delete a Simulator
 * @param btn
 */
var deleteSimulator = function(btn)
{
  var button = $(btn),
    simId = button.attr("simulator-id"),
    row = $("tr[simulator-id=" + simId + "]");
  if (typeof(simulatorData.items[simId]) != "undefined" && simulatorData.items[simId].callback !== "undefined")
  {
    clearInterval(simulatorData.items[simId].callback);
    delete simulatorData.items[simId];
  }
  row.remove();
};

/**
 * Insert a new Row into the Simulator Table
 * @param simId
 * @param dpName
 * @param from
 * @param to
 * @param interval
 * @returns {*}
 */
var insertRow = function(simId, dpName, from, to, interval)
{

  if (!simId)
  {
    simId = randomString();
  }

  $("#simulatorTable > tbody").append(
    "<tr simulator-id='" + simId + "'>" +
    "<td><input type='text' class='simulatorRowName form-control' placeholder='Data Point' value='" + dpName + "' /></td>" +
    "<td><input type='number' class='simulatorRowFrom form-control' placeholder='From'value='" + from + "' /></td>" +
    "<td><input type='number' class='simulatorRowTo form-control' placeholder='To'value='" + to + "' /></td>" +
    "<td><input type='number' class='simulatorRowInterval form-control' min='10' max='10000' placeholder='Interval in ms'value='" + interval + "'  /></td>" +
    "<td>" +
    "<button onclick='setSimulatorData(this)' class='simulatorRowSet btn btn-primary m-1' simulator-id='" + simId + "'>Set</button><button onclick='deleteSimulator(this)' class='simulatorRowDelete btn btn-danger' simulator-id='" + simId + "'>Delete</button></td>" +
    "</tr>"
  );
  return simId;
};

var initialize = function()
{
  $.each(simulatorData.items, function(idx, row)
  {
    insertRow(idx, row.dpName, row.from, row.to, row.interval);
  });
};

//on click on simulator call initalize to visualize existing simulators...
initialize();

