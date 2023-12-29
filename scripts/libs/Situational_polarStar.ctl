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
string lineColor = "cont_static";
string initLineBorder = "[solid,oneColor,JoinBevel,CapProjecting,1]";
string alarmLineBorder = "[solid,oneColor,JoinBevel,CapProjecting,8]";

//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------


/**
  Обработка отображения идентифкаторов лучей
*/
void setShowTag() {
  dyn_errClass err;
  dyn_string dp_list;
  bool ok = true;
  dp_list = makeDynString();
  if (dynlen(aiNames)>1) {
    for ( int i= 1;i<=dynlen(aiNames);  i++)
  	{
      if( !dpExists( aiNames[i]+".SHOW:_online.._value") )
      {
        ok = false;
        err[1]=makeError(0, PRIO_WARNING, ERR_PARAM, 51, "", myUiNumber(), getUserId(),"У точки данных ["+aiNames[i]+"] отсутсвует SHOW");
        throwError(err);
      }
      dynAppend(dp_list, aiNames[i]+".SHOW:_online.._value");
  	}
  }
  if (ok)
  {
    dpConnect("setShowTagCB", dp_list);
  }
}

/**
  Колбэк функция для обработки отображения идентифкаторов лучей
*/
void setShowTagCB(dyn_string dp_list, dyn_anytype dp_value) {
  for ( int i= 1;i<=dynlen(dp_value);  i++)
  {
    setValue("tag"+i, "visible", dp_value[i]);
    setValue("unit"+i, "visible", dp_value[i]);
    setValue("value"+i, "visible", dp_value[i]);
  }
}


/**
  Обработка флага имитации
*/
void setImitFlag() {
  dyn_errClass err;
  dyn_string dp_list;
  bool ok = true;
  dp_list = makeDynString();
  if (dynlen(aiNames)>1) {
    for ( int i= 1;i<=dynlen(aiNames);  i++)
  	{
      if( !dpExists( aiNames[i]+".SIM:_online.._value") )
      {
        setValue("imitFlag"+i+".imitFig2", "color", "fon_nan");
        ok = false;
        err[1]=makeError(0, PRIO_WARNING, ERR_PARAM, 51, "", myUiNumber(), getUserId(),"У точки данных ["+aiNames[i]+"] отсутсвует SIM");
        throwError(err);
      }
      dynAppend(dp_list, aiNames[i]+".SIM:_online.._value");
  	}
  }
  if (ok)
  {
    dpConnect("setImitFlagCB",dp_list);
  }
}


/**
  Колбэк функция для обработка флага имитации
*/
void setImitFlagCB(dyn_string dp_list, dyn_anytype dp_value) {
  for ( int i= 1;i<=dynlen(dp_value);  i++)
  {
    setValue("imitFlag"+i, "visible", dp_value[i]);
  }
}

/**
  Отрисовка многоугольника при текущих условиях
*/
void drawCurrentPolar()
{
  dyn_string dp_list;
  dyn_string param_list;
  param_list = makeDynString(".OUT:_online.._value", ".OUT:_pv_range.._min", ".OUT:_pv_range.._max");
  if (dynlen(aiNames)>1) {
    for ( int i= 1;i<=dynlen(aiNames);  i++)
  	{
      for ( int j = 1;j<=dynlen(param_list);  j++)
      {
        dynAppend(dp_list, aiNames[i]+param_list[j]);
      }
    }
    dpConnect("drawCurrentPolarCB",dp_list);
  }
}

/**
  Колбэк функция для отрисовки многоугольника при текущих условиях
*/
void drawCurrentPolarCB(dyn_string dp_list, dyn_anytype dp_value)
{
  dyn_dyn_int pts;
  int k;
  pts = makeDynAnytype();
  for ( int i= 1;i<=dynlen(aiNames);  i++)
  {
    k= (i-1)*3;
    insertToDyn(pts, dp_value[1+k], dp_value[2+k], dp_value[3+k], i);
  }
  setValue("POLAR_CURRENT", "points", pts);
}

/**
  Отрисовка положений уставок
*/
void drawUsatvkaLines() {
  dyn_string dp_list;
  dyn_string param_list;
  param_list = makeDynString(".HH", ".H", ".L", ".LL", ".OUT:_pv_range.._min", ".OUT:_pv_range.._max");

  if (dynlen(aiNames)>1)
  {
    for ( int i= 1;i<=dynlen(aiNames);  i++)
  	{
      for ( int j = 1;j<=dynlen(param_list);  j++)
      {
        dynAppend(dp_list, aiNames[i]+param_list[j]);
      }
    }
    dpConnect("drawUsatvkaLinesCB", dp_list);
  }
}

/**
  Колбэк функция для отрисовки положений уставок
*/
void drawUsatvkaLinesCB(dyn_string dp_list, dyn_anytype dp_value)
{
  int delta = 0;
  dyn_dyn_int pts;
  dyn_string alarmSymbolNames;
  int k;
  pts = makeDynAnytype();
  alarmSymbolNames = makeDynString("lineHH", "lineH","lineL", "lineLL");
  for ( int i= 1;i<=dynlen(aiNames);  i++)
  {
    k= (i-1)*6;
    insertToDyn(pts, dp_value[1+k], dp_value[k+5], dp_value[k+6], i);
    insertToDyn(pts, dp_value[2+k], dp_value[k+5], dp_value[k+6], i);
    insertToDyn(pts, dp_value[3+k], dp_value[k+5], dp_value[k+6], i);
    insertToDyn(pts, dp_value[4+k], dp_value[k+5], dp_value[k+6], i);

  }
  for ( int i= 1;i<=dynlen(aiNames);  i++)
  {
    k = (i-1)*4;
    for ( int j = 1;j<=dynlen(alarmSymbolNames);  j++)
    {
        setValue(alarmSymbolNames[j]+i, "position", pts[j+k][1]+delta, pts[j+k][2]-delta);
    }
  }
}

/**
  Обработка алармов лучей
*/
void setLinesAlert() {
  dyn_errClass err;
  dyn_string dp_list;
  dyn_string param_list;
  param_list = makeDynString(".OUT:_alert_hdl.._act_state_color", ".OUT:_online.._invalid", ".REP");
  bool ok = true;
  dp_list = makeDynString();
  if (dynlen(aiNames)>1) {
    for ( int i= 1;i<=dynlen(aiNames);  i++)
  	{
      if( !dpExists( aiNames[i]+".OUT:_alert_hdl.._act_state_color") )
      {
        setValue("LINE"+i, "color", "fon_nan");
        ok = false;
        err[1]=makeError(0, PRIO_WARNING, ERR_PARAM, 51, "", myUiNumber(), getUserId(),"У точки данных ["+aiNames[i]+".OUT"+"] не установлен _alert_hdl.._act_state_color");
        throwError(err);
      }
      for ( int j = 1;j<=dynlen(param_list);  j++)
      {
        dynAppend(dp_list, aiNames[i]+param_list[j]);
      }
  	}
  }

  if (ok)
  {
    dpConnect("setLinesAlertCB",dp_list);
  }
}

/**
  Колбэк функция для обработки алармов лучей
*/
void setLinesAlertCB(dyn_string dp_list, dyn_anytype dp_value)
{
  int k;
  for ( int i= 1;i<=dynlen(aiNames);  i++)
  {
    k= (i-1)*3;
    if (dp_value[2+k])
    {
        if (dp_value[3+k]) {// ремонт
          setValue("LINE"+i, "foreCol","fon_rem");
        } else {
          setValue("LINE"+i, "foreCol", "fon_nan");
        }
        setValue("LINE"+i, "border", alarmLineBorder);
        dpSet(aiNames[i]+".SHOW", true);
    } else {
        if (dp_value[3+k]) {// ремонт
          setValue("LINE"+i, "foreCol","fon_rem");
          setValue("LINE"+i, "border", alarmLineBorder);
          dpSet(aiNames[i]+".SHOW", true);
        } else {
          if (dp_value[1+k]=="") {
            setValue("LINE"+i, "border", initLineBorder);
          } else {
            setValue("LINE"+i, "border", alarmLineBorder);
            dpSet(aiNames[i]+".SHOW", true);
          }
          setValue("LINE"+i, "foreCol", dp_value[1+k]);
        }
    }
  }
}

/**
  Установка идентификаторов лучей
*/
void setTagNames() {
  string value;

  if (dynlen(aiNames)>1) {
    for ( int i= 1;i<=dynlen(aiNames);  i++)
  	{
      //dpGet(aiNames[i]+".OUT:_general.._string_01",value);
      //value = dpGetAlias(aiNames[i]+".");
      //setValue("tag"+i, "text", value);
      setValue("tag"+i, "text", getTagName(aiNames[i]));
      setValue("unit"+i, "text", getTagUnit(aiNames[i]+".OUT"));
  	}
  }
}

/**
  Отрисовка многоугольника при нормальных(ожидаемых) условиях
*/
void drawExpectedPolar()
{
  dyn_dyn_int pts;
  pts = makeDynAnytype();
  if (dynlen(aiNames)>1) {
    for ( int i= 1;i<=dynlen(aiNames);  i++)
  	{
      insertToDynStd(pts, aiNames, i);
  	}
    insertToDynStd(pts, aiNames, 1);
  }
  setValue("POLAR_EXPECTED", "points", pts);
}

/**
  Заполнение массива с позициям (x,y) на оси координат
  @param pts двумерный массив с заполненными позициями
  @param cur текущая точка
  @param min минимальное значение
  @param max максимальное значение
  @param type номер линии
*/
void insertToDyn(dyn_dyn_int &pts, float cur, float min, float max, int type)
{
  int x, y;
  dyn_int positionArr;
  x = getPosX(cur, min, max, type);
  y = getPosY(cur, min, max, type);
  positionArr = makeDynInt(x, y);
  dynAppend(pts, positionArr);
}

/**
  Заполнение массива с позициям (x,y) на оси координат для ожидаемого луча
  @param pts двумерный массив с заполненными позициями
  @param aiNames массив с названиями DP
  @param i номер массива для обработки
*/
void insertToDynStd(dyn_dyn_int &pts, dyn_string aiNames, int i)
{
  float cur, min, max;
  int x, y;
  dyn_int positionArr;
  dpGet(aiNames[i]+".STD_PV:_online.._value", cur, aiNames[i]+".OUT:_pv_range.._min", min, aiNames[i]+".OUT:_pv_range.._max", max);
  x = getPosX(cur, min, max, i);
  y = getPosY(cur, min, max, i);
  positionArr = makeDynInt(x, y);
  dynAppend(pts, positionArr);
}

/**
  Формула для расчета позиции на оси координат
  @param fNewValueXY текущее значение
  @param fXYMin минимальное значение
  @param fXYMax максимальное значение
  @param parBeg точка начало
  @param parEnd точка конца
  @return
*/
float getRezFormula(float fNewValueXY, float fXYMin, float fXYMax, float parBeg, float parEnd)
{
  float rez;
  rez = (parBeg-parEnd) * (fNewValueXY/(fXYMax - fXYMin)) + parEnd;
  return rez;
}


/**
  Определение позиции X на оси координат
  @param fNewValueXY текущее значение
  @param fXYMin минимальное значение
  @param fXYMax максимальное значение
  @param type номер линии
  @return
*/
int getPosX(float fNewValueXY, float fXYMin, float fXYMax, int type)
{
  int rez = 0;
  dyn_errClass err;
  if (type==1) {//line 1
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, x1, x0);
  } else if (type==2) {
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, x2, x0);
  } else if (type==3) {
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, x3, x0);
  } else if (type==4) {
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, x4, x0);
  } else if (type==5) {
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, x5, x0);
  } else if (type==6) {
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, x6, x0);
  } else {
    err[1]=makeError(0, PRIO_WARNING, ERR_INVALID_ARGUMENT, 51, "", myUiNumber(), getUserId(),"Не правильно задан тип");
    throwError(err);
  }
  return rez;
}

/**
  Определение позиции Y на оси координат
  @param fNewValueXY текущее значение
  @param fXYMin минимальное значение
  @param fXYMax максимальное значение
  @param type номер линии
  @return
*/
int getPosY(float fNewValueXY, float fXYMin, float fXYMax, int type)
{
  int rez = 0;
  dyn_errClass err;
  if (type==1) {//line 1
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, y1, y0);
  } else if (type==2) {
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, y2, y0);
  } else if (type==3) {
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, y3, y0);
  } else if (type==4) {
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, y4, y0);
  } else if (type==5) {
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, y5, y0);
  } else if (type==6) {
    rez = getRezFormula(fNewValueXY, fXYMin, fXYMax, y6, y0);
  } else {
    err[1]=makeError(0, PRIO_WARNING, ERR_INVALID_ARGUMENT, 51, "", myUiNumber(), getUserId(),"Не правильно задан тип");
    throwError(err);
  }
  return rez;
}


//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------

