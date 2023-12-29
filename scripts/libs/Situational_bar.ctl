// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author Ruslan.Zalyaev
*/

//--------------------------------------------------------------------------------
// used libraries (#uses)
//#uses "STD_Symbols"

//--------------------------------------------------------------------------------
// variables and constants

//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------
STD_bar_AI() {
  dyn_errClass err;
  int i;
  int iAType, iPvType;

  dpGet(msDPE + ".OUT" + ":_alert_hdl.._active", iAType,
    msDPE + ".OUT" + ":_pv_range.._type", iPvType);

  if (bShowAlarm) {
    if (iAType) // существует обработка аларма
    {
      if (iPvType != DPCONFIG_NONE) // установлен pv_range
      {
        if (msDPE + ".OUT" == "")
          STD_showConnectError("DPE");
        else
        if (dpConnect("work_bar_1", msDPE + ".OUT" + ":_online.._value",
            msDPE + ".OUT" + ":_original.._invalid",
            msDPE + ".OUT" + ":_alert_hdl.._active",
            msDPE + ".OUT" + ":_alert_hdl.._act_state_color",
            msDPE + ".REP:_online.._value",
            msDPE + ".OUT" + ":_pv_range.._min",
            msDPE + ".OUT" + ":_pv_range.._max") == -1)
          setValue("s" + miNum, "color", "fon_nan");
        setValue("s" + miNum, "visible", 1);
        if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
          setValue("s" + miNum2, "color", "fon_nan");
          setValue("s" + miNum2, "visible", 1);
        }
      } else {
        if (msDPE + ".OUT" == "")
          STD_showConnectError("DPE");
        else
          STD_showConnectError("У точки данных [" + msDPE + ".OUT" + "] не установлена конфигурация _pv_range");
      }

    } else //не существует обработка аларма
    {
      if ((iPvType != DPCONFIG_NONE)) // установлен pv_range
      {
        if (msDPE + ".OUT" == "")
          STD_showConnectError("DPE");
        else
        if (dpConnect("work_bar_2", msDPE + ".OUT" + ":_online.._value",
            msDPE + ".OUT" + ":_original.._invalid",
            msDPE + ".REP:_online.._value",
            msDPE + ".OUT" + ":_pv_range.._min",
            msDPE + ".OUT" + ":_pv_range.._max") == -1)
          setValue("s" + miNum, "color", "fon_nan");
        setValue("s" + miNum, "visible", 1);
        if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
          setValue("s" + miNum2, "color", "fon_nan");
          setValue("s" + miNum2, "visible", 1);
        }

      } else {
        if (msDPE + ".OUT" == "")
          STD_showConnectError("DPE");
        else
          STD_showConnectError("У точки данных [" + msDPE + ".OUT" + "] не установлена конфигурация _pv_range");
      }
      err[1] = makeError(0, PRIO_INFO, ERR_PARAM, 51, "", myUiNumber(), getUserId(), "У точки данных [" + msDPE + ".OUT" + "] не установлен _alert_hdl");
      throwError(err);
    }
  } else {
    if ((iPvType != DPCONFIG_NONE)) // установлен pv_range
    {
      if (msDPE + ".OUT" == "")
        STD_showConnectError("DPE");
      else
      if (dpConnect("work_bar_4", msDPE + ".OUT" + ":_online.._value",
          msDPE + ".OUT" + ":_pv_range.._min",
          msDPE + ".OUT" + ":_pv_range.._max") == -1)
        setValue("s" + miNum, "color", "fon_nan");
      setValue("s" + miNum, "visible", 1);
      if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
        setValue("s" + miNum2, "color", "fon_nan");
        setValue("s" + miNum2, "visible", 1);
      }
    } else {
      if (msDPE + ".OUT" == "")
        STD_showConnectError("DPE");
      else
        STD_showConnectError("У точки данных [" + msDPE + ".OUT" + "] не установлена конфигурация _pv_range");
    }
  }
}

work_bar_1(string dp1, float fValue,
  string dp2, bool bInvalid,
  string dp3, bool bActiv,
  string dp4, string sColor,
  string dp7, bool bIsRep,
  string dp5, float fMin,
  string dp6, float fMax) {
  int i;
  if (bInvalid && mbIBit) {
    setValue("s" + miNum, "color", "fon_nan");
    if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
      setValue("s" + miNum2, "color", "fon_nan");
    }
  } else {
    if (bActiv) {
      setValue("s" + miNum, "color", sColor);
      if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
        setValue("s" + miNum2, "color", sColor);
      }
    } else {
      setValue("s" + miNum, "color", msCol);
      if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
        setValue("s" + miNum2, "color", msCol);
      }
    }
  }
  if (bIsRep) {
    fValue = 0;
  } else if (bInvalid) {
    fValue = 10000000;
  }
  STD_scaleBar_AI(fValue, fMin, fMax, miNum, miNum2);
}

work_bar_2(string dp1, float fValue,
  string dp2, bool bInvalid,
  string dp7, bool bIsRep,
  string dp3, float fMin,
  string dp4, float fMax) {
  int i;
  if (bInvalid && mbIBit) {
    setValue("s" + miNum, "color", "fon_nan");
    if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
      setValue("s" + miNum2, "color", "fon_nan");
    }
  } else {
    setValue("s" + miNum, "color", msCol);
    if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
      setValue("s" + miNum2, "color", msCol);
    }
  }
  if (bIsRep) {
    fValue = 0;
  } else if (bInvalid) {
    fValue = 10000000;
  }
  STD_scaleBar_AI(fValue, fMin, fMax, miNum, miNum2);
}

work_bar_3(string dp1, float fValue,
  string dp2, bool bInvalid,
  string dp7, bool bIsRep,
  string dp3, float fMin,
  string dp4, float fMax) {
  int i;
  if (bInvalid && mbIBit) {
    setValue("s" + miNum2, "color", "fon_nan");
    if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
      setValue("s" + miNum2, "color", "fon_nan");
    }
  } else {
    setValue("s" + miNum2, "color", msCol);
    if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
      setValue("s" + miNum2, "color", msCol);
    }
  }
  if (bIsRep) {
    fValue = 0;
  } else if (bInvalid) {
    fValue = 10000000;
  }
  STD_scaleBar_AI(fValue, fMin, fMax, miNum2, miNum2);
}

work_bar_4(string dp1, float fValue,
  string dp3, float fMin,
  string dp4, float fMax) {
  int i;
  setValue("s" + miNum, "color", msCol);
  if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
    setValue("s" + miNum2, "color", msCol);
  }
  STD_scaleBar_AI(fValue, fMin, fMax, miNum, miNum2);
}

work_bar_SP(string dp1, float fValue,
  string dp2, bool bInvalid,
  string dp7, bool bIsRep,
  string dp3, float fMin,
  string dp4, float fMax) {
  STD_scaleBar_AI(fValue, fMin, fMax, miNum, miNum2);
}

STD_scaleBar_AI(float fValue, float fMin, float fMax, int miNumIn, int miNumIn2) {
  float x = 1;
  float y = 1;
  float fNewScale;

  if (fValue >= fMax) fValue = fMax;
  if (fValue <= fMin) fValue = fMin;

  if ((fMax - fMin) == 0)
    fNewScale = 0;
  else
    fNewScale = (fValue - fMin) / (fMax - fMin);

  if (miDirection == 1)
    y = y * fNewScale;
  else
    x = x * fNewScale;
  if (aiType != 1) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
    setValue("s" + miNumIn, "scale", x, y);
  }

  if (isSlider) {
    if (miDirection == 1) {
      setValue("slider1", "position", sliderX,sliderY - s1BackSizeX * fNewScale);
      setValue("sp1", "position", sliderX,sliderY - s1BackSizeX * fNewScale);
    } else {
      setValue("slider1", "position", sliderX + s1BackSizeX * fNewScale, sliderY);
      setValue("sp1", "position", sliderX + s1BackSizeX * fNewScale, sliderY);
    }

  }
  if (aiType == 1 || aiType == 2) {
    if (miDirection == 1) {
      setValue("s" + miNumIn2, "position", pointX, pointY - s1BackSizeY * fNewScale);

    } else {
      setValue("s" + miNumIn2, "position", pointX + s1BackSizeX * fNewScale, pointY);

    }
  }
}

STD_bar_Regulator() {
  dyn_errClass err;
  int i;
  int iAType, iPvType;

  dpGet(msDPE + ".OUT" + ":_pv_range.._type", iPvType);

  if ((iPvType != DPCONFIG_NONE)) // установлен pv_range
  {
    if (msDPE + ".OUT" == "")
      STD_showConnectError("DPE");
    else
    if (dpConnect("work_bar_2", msDPE + ".OUT" + ":_online.._value",
        msDPE + ".OUT" + ":_original.._invalid",
        msDPE + ".REP:_online.._value",
        msDPE + ".OUT" + ":_pv_range.._min",
        msDPE + ".OUT" + ":_pv_range.._max") == -1)
      setValue("s" + miNum, "color", "fon_nan");
    setValue("s" + miNum, "visible", 1);
    if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
      setValue("s" + miNum2, "color", "fon_nan");
      setValue("s" + miNum2, "visible", 1);
    }
  } else {
    if (msDPE + ".OUT" == "")
      STD_showConnectError("DPE");
    else
      STD_showConnectError("У точки данных [" + msDPE + ".OUT" + "] не установлена конфигурация _pv_range");
  }

  if (isOutAi) {
    dpGet(msDPE + ".aiOUT" + ":_pv_range.._type", iPvType);

    if ((iPvType != DPCONFIG_NONE)) // установлен pv_range
    {
      if (msDPE + ".aiOUT" == "")
        STD_showConnectError("DPE");
      else
      if (dpConnect("work_bar_3", msDPE + ".aiOUT" + ":_online.._value",
          msDPE + ".aiOUT" + ":_original.._invalid",
          msDPE + ".REP:_online.._value",
          msDPE + ".aiOUT" + ":_pv_range.._min",
          msDPE + ".aiOUT" + ":_pv_range.._max") == -1)
        setValue("s" + miNum2, "color", "fon_nan");
      setValue("s" + miNum2, "visible", 1);
      if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
        setValue("s" + miNum2, "color", "fon_nan");
        setValue("s" + miNum2, "visible", 1);
      }
    } else {
      if (msDPE + ".aiOUT" == "")
        STD_showConnectError("DPE");
      else
        STD_showConnectError("У точки данных [" + msDPE + ".aiOUT" + "] не установлена конфигурация _pv_range");
    }
  }

}
STD_bar_Regulator_SP() {
  dyn_errClass err;
  int i;
  int iPvType;
  bool isSP=true;

  if (isSP) {
    dpGet(msDPE + ".OUT" + ":_pv_range.._type", iPvType);

    if ((iPvType != DPCONFIG_NONE)) // установлен pv_range
    {
      if (msDPE + ".SP" == "")
        STD_showConnectError("DPE");
      else
      if (dpConnect("work_bar_SP", msDPE + ".SP" + ":_online.._value",
          msDPE + ".SP" + ":_original.._invalid",
          msDPE + ".REP:_online.._value",
          msDPE + ".OUT" + ":_pv_range.._min",
          msDPE + ".OUT" + ":_pv_range.._max") == -1)
        setValue("sp1", "color", "fon_nan");
        setValue("sp1", "visible", 1);
      if (aiType == 2) { //0 - индикатор, 1 - точка, 2 - индикатор и точка
        setValue("sp1", "color", "fon_nan");
        setValue("sp1", "visible", 1);
      }
    } else {
      if (msDPE + ".SP" == "")
        STD_showConnectError("DPE");
      else
        STD_showConnectError("У точки данных [" + msDPE + ".SP" + "] не установлена конфигурация _pv_range");
    }
  }

}

//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------
