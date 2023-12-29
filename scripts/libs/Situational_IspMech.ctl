// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author admin
*/

//--------------------------------------------------------------------------------
// used libraries (#uses)

//--------------------------------------------------------------------------------
// variables and constants

//string m1 = "[pattern,[tile,any,mest1.png]]";
//string m2 = "[pattern,[tile,any,mest2.png]]";

//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------


void elementsFunct()
{
  EP_setVisibleSim();
  EP_setFillElements();
  //EP_setTagName();
  EP_setVisibleTag();
}

/**
  При инициализации должны имена брать
void EP_setTagName()
{
  if( !dpExists(mse))
  {
    setValue("tag", "text", "XXX");
    return;
  } else {
    //setValue("tag", "text", mse);
    //setValue("tag", "text", dpGetAlias(mse+"."));
    setValue("tag", "text", mse);
  }
}
**/

void EP_setFillElements()
{

  dpConnect("EP_setFillElementCB",
            mse+".STATE",
            mse+".invalid",
            mse+".REG",
            mse+".MODE",
            mse+".REP",
            mse+".ERR");

}


void EP_setFillElementCB(string dp1, int iNewValue1, string dp2, bool boNewValue2, string dp3, int iNewValue3, string dp4, int iNewValue4, string dp5, bool boNewValue5, string dp6, int iNewValue6)
{
    fillElements();
}

void EP_setVisibleSim()
{
  dyn_errClass err;

  if( !dpExists( mse+".SIM:_online.._value"))
  {
    setValue("imitFigRef.imitFig2", "color", "fon_nan");
    return;
  }

  dpConnect("EP_setVisibleCB",
            mse+".SIM:_online.._value");
  err = getLastError();
  if (dynlen(err) > 0)
    setValue("imitFigRef", "imitFigRef.imitFig2", "fon_nan");

}


void EP_setVisibleCB(string dp, bool boNewValue)
{
    setValue("imitFigRef", "visible", boNewValue);
    fillElements();
}

void EP_setVisibleTag()
{
  dyn_errClass err;

  if( !dpExists( mse+".SHOW:_online.._value"))
  {
    return;
  }


  dpConnect("EP_setVisibleTagCB",
            mse+".SHOW:_online.._value");
  err = getLastError();

}


void EP_setVisibleTagCB(string dp, bool boNewValue)
{
    setValue("tag", "visible", boNewValue);
}


void fillElementsForecolor(string s_newcolor)
{
  for ( int i= 1;i<=dynlen(elementNames);  i++)
  {
    setValue(elementNames[i], "foreCol", s_newcolor);
  }
}

void fillElementsColor(string s_newcolor)
{
  for ( int i= 1;i<=dynlen(elementNames);  i++)
  {
    setValue(elementNames[i], "backCol", s_newcolor);
  }
}
/*
void fillElementsColorMest(bool isMest, bool isStop)
{
  string value;
  string color;
  if (isMest)
  {
    if (isStop)
    {
      value = m2;
    }
    else
    {
      value = m1;
    }
    for ( int i= 1;i<=dynlen(elementNames);  i++)
    {
      setValue(elementNames[i], "fill", value);
    }
    fillElementsForecolor("cont_static");
  }
  else
  {
    for ( int i= 1;i<=dynlen(elementNames);  i++)
    {
      setValue(elementNames[i], "fill", "[solid]");
    }
  }
}
*/
void tagvalVisible(bool b_visible)
{
  bool val;
  if (b_visible)
  {
    dpGet(mse+".SHOW", val);
    if (val)
    {
      setValue("tag", "visible", b_visible);
    }
  }
  else
  {
    setValue("tag", "visible", b_visible);
  }
}

void alarmBorderVisible(bool b_visible, string s_color)
{
  setValue("alarmBorder", "visible", b_visible);
  setValue("alarmBorder", "color", s_color);
}

void fillElements()
{
  bool isInvalid, isRep;
  int regim, state, mode, err;
  dpGet(mse+".STATE", state, mse+".invalid",isInvalid, mse+".REP", isRep, mse+".REG", regim, mse+".MODE", mode, mse+".ERR", err);

  if (isInvalid) {//неисправность
    fillElementsColor("fon_nan");
    fillElementsForecolor("cont_static");
    alarmBorderVisible(true, "fon_nan");
    tagvalVisible(false);
  }
  else if (isRep)
  {
    fillElementsColor("fon_rem");
    fillElementsForecolor("cont_rem");
    alarmBorderVisible(false, "fon_nan");
    tagvalVisible(false);
  }
  else if (err!=0)
  {
    if (err==1) {//предупреждение
      alarmBorderVisible(true, "fon_warn");
    } else if (err==2) {//авария
      alarmBorderVisible(true, "fon_alarm");
    } else if (err==3) {//ошибка запуска
      alarmBorderVisible(true, "fon_nan");
    }
    tagvalVisible(true);
    /*if (err==1)
    {//авария
      fillElementsColor("fon_alarm");
    }
    else if (err==2)
    {//ошибка запуска
      fillElementsColor("fon_nan");
    }
    fillElementsForecolor("cont_rem");
    alarmBorderVisible(false);
    tagvalVisible(false);*/
  }
  else
  {
    alarmBorderVisible(false, "fon_nan");
    tagvalVisible(true);
    if (state==1)
    {//включен/запущено/открыто
      fillElementsColor("fon_open");
    }
    else if (state==0)
    {//выключен/остановлено/закрыто
      fillElementsColor("fon_close");
    }

    if (regim == 0)
    {//автоматический
      fillElementsForecolor("cont_static");
    }
    else if (regim == 1)
    {//ручной
      if (mode == 0)
      {//дистанционнаый
        fillElementsForecolor("cont_dist");
      }
      else if (mode == 1)
      {//местный
        fillElementsForecolor("cont_mest");
      }
    }
  }
}

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------

