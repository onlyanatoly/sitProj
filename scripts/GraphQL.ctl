// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author Anatolii.Gurin
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)

//--------------------------------------------------------------------------------
// Variables and Constants

//--------------------------------------------------------------------------------
/**
*/
#uses "CtrlHTTP"
#uses "http.ctl"
string main()
{
  string url = "https://server.rocworks.at/graphql";

  string query = "query($tag: String!){getTag(name: $tag){tag{current{value}}}}";

  mapping variables = makeMapping("tag", "Input");

  mapping content = makeMapping("query", query, "variables", variables);

  mapping data = makeMapping(
      "headers", makeMapping("Content-Type", "application/json"),
      "content", jsonEncode(content)
  );

  mapping result;

  netPost(url, data, result);

  if (result["httpStatusText"]=="OK") {
    DebugTN(result["content"]);
  }
  else {
    return "Error";
  }
}
