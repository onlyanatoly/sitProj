// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author Ruslan.Zalyaev
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)

//--------------------------------------------------------------------------------
// Variables and Constants


//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------


public string getDpFromFullName(string inDp)
{
  string rez;
  rez = strsplit(inDp,":")[2];
  return rez;
}

public string getTagName(string inDp)
{
  int i;
  if (inDp!="") {
    dyn_string replace = makeDynString("OO1_FTA1_", "GOU_", "OO1_TTA_", "OO1_GTO_FIRE1_", "OO1_GTO_FIRE2_", "OO1_GTO_FIRE3_", "OO1_GTO_FIRE4_", "SPUMP_", "SBA_", "SGA_", "SLOT_","PZA_","PK_","230","231","232");
    for(i=1; i<=dynlen(replace); i++) {
      strreplace(inDp, replace[i], "");
    }
  } else {
    inDp = "xXx";
  }
  return inDp;
}

public string getTagUnit(string inDp)
{
  return dpGetUnit(inDp);
}

public string getFormatTagValue(string inDp, float value)
{
  return strltrim(dpValToString(inDp, value, FALSE), " ");
}

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------




