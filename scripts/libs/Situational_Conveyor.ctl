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

string nanColor = "fon_nan";
string borderElementName = "border";
string dir1ElementName = "Elem1";
string dir2ElementName = "Elem2";

//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------
void elementsFunctConveyor()
{
  EP_fillElements();
}

/**
  Окраска элементов по dp
*/
void EP_fillElements()
{
  dyn_errClass err;

  if (!dpExists(mse + ".ERROR:_online.._value") || !dpExists(mse + ".invalid:_online.._value")
      || !dpExists(mse + ".LOCAL:_online.._value") || !dpExists(mse + ".DIST:_online.._value")
      || !dpExists(mse + ".DIR1:_online.._value") || !dpExists(mse + ".DIR2:_online.._value")|| !dpExists(mse + ".SIM:_online.._value"))
  {
    STD_showConnectError("У точки данных [" + mse + "] отсутсвует один из необходимых узлов (ERROR, invalid, LOCAL, DIST, DIR1, DIR2, SIM)");
    setNanElements();
    return;
  }

  dpConnect("fillElementsConveyor_CB",
            mse + ".DIR1:_online.._value",
            mse + ".DIR2:_online.._value",
            mse + ".ERROR:_online.._value",
            mse + ".LOCAL:_online.._value",
            mse + ".DIST:_online.._value",
            mse + ".invalid:_online.._value",
            mse + ".SIM:_online.._value");
  err = getLastError();

  if (dynlen(err) > 0) {
    STD_showConnectError("Ошибка при dpConnect у [" + mse + "]");
    setNanElements();
  }
}


/**
  Видимость границы
  @param b_visible видимость
  @param s_color цвет
*/
void borderVisible(bool b_visible, string s_color)
{
  setValue(borderElementName, "visible", b_visible);
  setValue(borderElementName, "color", s_color);
}

/**
  Цвет элемента
  @param s_element название элемента
  @param s_color цвет
*/
void setElementColor(string s_element, string s_color)
{
  setValue(s_element, "backCol", s_color);
}

/**
 Установка недоступности
*/
void setNanElements()
{
  borderVisible(true, nanColor);
  setElementColor(dir1ElementName, nanColor);
  setElementColor(dir2ElementName, nanColor);
}

/**
  Окраска элементов по dp callback
*/
void fillElementsConveyor_CB(string dp1, bool isRunDir1,
                             string dp2, bool isRunDir2,
                             string dp3, bool isError,
                             string dp4, bool isLocal,
                             string dp5, bool isDist,
                             string dp6, bool isInvalid,
                             string dp7, bool isSim)
{
  //bool isRunDir1, isRunDir2, isError, isLocal, isDist, isInvalid;
  //dpGet(mse+".Dir1", isRunDir1, mse+".Dir2", isRunDir2, mse+".invalid",isInvalid, mse+".ERROR", isError, mse+".LOCAL", isLocal, mse+".DIST", isDist);
  if (isInvalid)  //не доступен
  {
    setNanElements();
    setVisibeSim(false);
  }
  else    //нормальный режим работы
  {
    setVisibeSim(isSim);
    if (isError) {//ошибка
      borderVisible(true, "fon_alarm");
      dpSet(mse + ".SHOW", 1);
    } else {
      borderVisible(false, "");
      dpSet(mse + ".SHOW", 0);
    }

    if (isRunDir1)
    {
      setElementColor(dir1ElementName, "fon_open");
    }
    else
    {
      setElementColor(dir1ElementName, "fon_close");
    }

    if (isRunDir2)
    {
      setElementColor(dir2ElementName, "fon_open");
    }
    else
    {
      setElementColor(dir2ElementName, "fon_close");
    }

    if (isLocal)
    {
      borderVisible(true, "_Transparent");
    }

    if (isDist)
    {
      borderVisible(true, "fon_warn");
    }
  }
}

void setVisibeSim(bool boNewValue)
{
  setValue("imitFigRef", "visible", boNewValue);
}

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------

