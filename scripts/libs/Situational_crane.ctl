// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author admin
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)

//--------------------------------------------------------------------------------
// Variables and Constants


//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

void elementsCraneFunct()
{

  EP_setForeColorElements();
  EP_setVisibleText();
}

void EP_setVisibleText()
{
  dyn_errClass err;

  if( !dpExists( mse+".SHOW:_online.._value"))
  {
    return;
  }

  dpConnect("setVisibleText",
            mse+".SHOW:_online.._value");
  err = getLastError();
  if (dynlen(err) > 0) {
    setVisibleText("fon_nan");
  }
}

void setVisibleText(string dpSource, float fNewValue) {
  if (fNewValue == 0) {//отклонено
    setValue(elementText, "visible", true);
  }
  else {
    setValue(elementText, "visible", false);
  }
}

void EP_setForeColorElements()
{
  dyn_errClass err;

  if( !dpExists( mse+".STATE:_online.._value"))
  {
    fillElementsCraneColor("fon_nan");
    return;
  }

  dpConnect("EP_setForeColorCB",
            mse+".STATE:_online.._value");
  err = getLastError();
  if (dynlen(err) > 0) {
    fillElementsCraneColor("fon_nan");
  }
}


void EP_setForeColorCB(string dpSource, float fNewValue)
{
  if (fNewValue == 0) {//отклонено
    fillElementsCraneForecolor("fon_alarm");
  }
  else if (fNewValue == 1){//разрешено
    fillElementsCraneForecolor("fon_open");
  }
  else {
    fillElementsCraneForecolor("fon_nan");
  }
}


void fillElementsCraneForecolor(string s_newcolor)
{
  for ( int i= 1;i<=dynlen(elementNames);  i++)
  {
    setValue(elementNames[i], "foreCol", s_newcolor);
  }
}

void fillElementsCraneColor(string s_newcolor)
{
  for ( int i= 1;i<=dynlen(elementNames);  i++)
  {
    setValue(elementNames[i], "backCol", s_newcolor);
  }
}



//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------

