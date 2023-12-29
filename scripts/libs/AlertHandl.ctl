//#uses "Situational_util"

// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author Ruslan.Zalyaev
*/


//--------------------------------------------------------------------------------
// Variables and Constants

int ALERT_PRIOR_HH = 99;
int ALERT_PRIOR_LL = 98;
int ALERT_PRIOR_H = 79;
int ALERT_PRIOR_L = 78;
int ALERT_PRIOR_ISPERR = 51;
int ALERT_PRIOR_NAN = 50;
int ALERT_PRIOR_SIM = 10;

dyn_string alerttext = makeDynString("Низкий критический", "Низкий предупредительный", "Высокий предупредительный", "Высокий критический");
dyn_string alerttextDI = makeDynString("Предупредительная сигнализация", "Критическая сигнализация");
dyn_string alerttextReg = makeDynString("Минимальное задание", "Максимальное задание");
dyn_string alertclass = makeDynString("Sit_LL.", "Sit_L.", "Sit_H.", "Sit_HH.");
dyn_string alertclassDI = makeDynString("Sit_H.", "Sit_HH.");
dyn_bool limitsincl = makeDynBool(TRUE, TRUE);
//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------

/**
  Установка алармов для reg
*/
void setRegAlertHandle()
{
  int numb=0;
  float valL, valH;
  dyn_float limits;
  bool isNeedAck, isActive;
  string dpAlert = $dpe_value+".OUT";
  dpGet($dpe_value+".maxSP", valH,
        $dpe_value+".minSP", valL
        );
  dpGet(dpAlert+":_alert_hdl.._ack_possible", isNeedAck,
        dpAlert+":_alert_hdl.._active", isActive);
  limits = makeDynFloat(valL, valH);
  //чтобы изменить нужно убрать активность, если активность не убиарется - то значит нужно сперва квитировать
  if (isActive)
  {
      if (isNeedAck)
      {
        dpSetWait(dpAlert+":_alert_hdl.._ack", DPATTR_ACKTYPE_MULTIPLE);
      }
      dpSetWait(dpAlert+":_alert_hdl.._active", false);
  }
  setRegAlertHandleSub(limits, dpAlert);
}

/**
  Установка алармов для di
*/
void setDiAlertHandle()
{
  int numb=0;
  float valHH, valH;
  bool valisHH, valisH;
  dyn_float limits;
  bool isNeedAck, isActive;
  string dpAlert = $dpe_value+".OUT";
  dpGet($dpe_value+".HH", valHH,
        $dpe_value+".H", valH,
        $dpe_value+".isHH", valisHH,
        $dpe_value+".isH", valisH
        );
  dpGet(dpAlert+":_alert_hdl.._ack_possible", isNeedAck,
        dpAlert+":_alert_hdl.._active", isActive);
  valisH?numb = numb + 1:"";
  valisHH?numb = numb + 2:"";
  limits = makeDynFloat(valH, valHH);
  //чтобы изменить нужно убрать активность, если активность не убиарется - то значит нужно сперва квитировать
  if (isActive)
  {
      if (isNeedAck)
      {
        dpSetWait(dpAlert+":_alert_hdl.._ack", DPATTR_ACKTYPE_MULTIPLE);
      }
      dpSetWait(dpAlert+":_alert_hdl.._active", false);
  }
  switch (numb)
  {
    case 1: setDiAlertHandleSub(1, limits, dpAlert, 1, 2); break;
    case 2: setDiAlertHandleSub(1, limits, dpAlert, 2, 2); break;
    case 3: setDiAlertHandleSub(2, limits, dpAlert, -1, -1); break;
    default: break;
  }

}


/**
  Установка алармов для ai
*/
void setAiAlertHandle()
{
  int numb=0;
  float valHH, valH, valL, valLL;
  bool valisHH, valisH, valisL, valisLL;
  dyn_float limits;
  bool isNeedAck, isActive;
  string dpAlert = $dpe_value+".OUT";
  dpGet($dpe_value+".HH", valHH,
        $dpe_value+".H", valH,
        $dpe_value+".L", valL,
        $dpe_value+".LL", valLL,
        $dpe_value+".isHH", valisHH,
        $dpe_value+".isH", valisH,
        $dpe_value+".isL", valisL,
        $dpe_value+".isLL", valisLL
        );
  dpGet(dpAlert+":_alert_hdl.._ack_possible", isNeedAck,
        dpAlert+":_alert_hdl.._active", isActive);
  valisLL?numb = numb + 1:"";
  valisL?numb = numb + 2:"";
  valisH?numb = numb + 4:"";
  valisHH?numb = numb + 8:"";
  limits = makeDynFloat(valLL, valL, valH, valHH);
  //чтобы изменить нужно убрать активность, если активность не убиарется - то значит нужно сперва квитировать
  if (isActive)
  {
      if (isNeedAck)
      {
        dpSetWait(dpAlert+":_alert_hdl.._ack", DPATTR_ACKTYPE_MULTIPLE);
      }
      dpSetWait(dpAlert+":_alert_hdl.._active", false);
  }
  switch (numb)
  {
    case 1: setAiAlertHandleSub(1, limits, dpAlert, 1, 1, -1, -1, -1, -1); break;
    case 2: setAiAlertHandleSub(1, limits, dpAlert, 2, 1, -1, -1, -1, -1); break;
    case 3: setAiAlertHandleSub(2, limits, dpAlert, 1, 1, 2, 2, -1, -1); break;
    case 4: setAiAlertHandleSub(1, limits, dpAlert, 3, 2, -1, -1, -1, -1); break;
    case 5: setAiAlertHandleSub(2, limits, dpAlert, 1, 1, 3, 3, -1, -1); break;
    case 6: setAiAlertHandleSub(2, limits, dpAlert, 2, 1, 3, 3, -1, -1); break;
    case 7: setAiAlertHandleSub(3, limits, dpAlert, 1, 1, 2, 2, 3, 4); break;
    case 8: setAiAlertHandleSub(1, limits, dpAlert, 4, 2, -1, -1, -1, -1); break;
    case 9: setAiAlertHandleSub(2, limits, dpAlert, 1, 1, 4, 3, -1, -1); break;
    case 10: setAiAlertHandleSub(2, limits, dpAlert, 2, 1, 4, 3, -1, -1); break;
    case 11: setAiAlertHandleSub(3, limits, dpAlert, 1, 1, 2, 2, 4, 4); break;
    case 12: setAiAlertHandleSub(2, limits, dpAlert, 3, 2, 4, 3, -1, -1); break;
    case 13: setAiAlertHandleSub(3, limits, dpAlert, 1, 1, 3, 3, 4, 4); break;
    case 14: setAiAlertHandleSub(3, limits, dpAlert, 2, 1, 3, 3, 4, 4); break;
    case 15: setAiAlertHandleSub(4, limits, dpAlert, -1, -1, -1, -1, -1, -1); break;
    default: break;
  }
}

void alertClassFunctAck(string dpAlert, bool ackPossible, int prior)
{
  DebugN( dpAlert,  ackPossible,  prior);
  dyn_string tags;
  dyn_int apriors,wpriors,ipriors;
  int i, temppr;
  string dp;
  dp = getDpFromFullName(dpAlert);
  dpGet("ALERT.TAG",tags,"ALERT.APRIOR",apriors,"ALERT.WPRIOR",wpriors,"ALERT.IPRIOR",ipriors);
  i = dynContains(tags, dp);
  if (ackPossible)//необходимо квитирование
  {
    if (i==0)
    {
      dynAppend(tags,dp);
      if (prior == ALERT_PRIOR_HH || prior == ALERT_PRIOR_LL)
      {
        dynAppend(apriors,prior);
        dynAppend(wpriors,0);
        dynAppend(ipriors,0);
      }
      else if (prior == ALERT_PRIOR_H || prior == ALERT_PRIOR_L)
      {
        dynAppend(apriors,0);
        dynAppend(wpriors,prior);
        dynAppend(ipriors,0);
      }
      else if (prior == ALERT_PRIOR_ISPERR || prior == ALERT_PRIOR_NAN)
      {
        dynAppend(apriors,0);
        dynAppend(wpriors,0);
        dynAppend(ipriors,prior);
      }

      dpSetWait("ALERT.TAG",tags,"ALERT.APRIOR",apriors,"ALERT.WPRIOR",wpriors,"ALERT.IPRIOR",ipriors);
    }
    else
    {
      if (prior == ALERT_PRIOR_HH || prior == ALERT_PRIOR_LL)
      {
        apriors[i] = prior;
      }
      else if (prior == ALERT_PRIOR_H || prior == ALERT_PRIOR_L)
      {
        wpriors[i] = prior;
      }
      else if (prior == ALERT_PRIOR_ISPERR || prior == ALERT_PRIOR_NAN)
      {
        ipriors[i] = prior;
      }
      dpSetWait("ALERT.TAG",tags,"ALERT.APRIOR",apriors,"ALERT.WPRIOR",wpriors,"ALERT.IPRIOR",ipriors);
    }
  }
  else//квитировали или нет необходимости
  {
    if (i!=0)
    {
      if (prior == ALERT_PRIOR_HH || prior == ALERT_PRIOR_LL)
      {
        apriors[i] = 0;
      }
      else if (prior == ALERT_PRIOR_H || prior == ALERT_PRIOR_L)
      {
        wpriors[i] = 0;
      }
      else if (prior == ALERT_PRIOR_ISPERR || prior == ALERT_PRIOR_NAN)
      {
        ipriors[i] = 0;
      }

      if (apriors[i]==0 && wpriors[i]==0 && ipriors[i]==0)
      {
        dynRemove(tags, i);
        dynRemove(apriors, i);
        dynRemove(wpriors, i);
        dynRemove(ipriors, i);
      }
      dpSetWait("ALERT.TAG",tags,"ALERT.APRIOR",apriors,"ALERT.WPRIOR",wpriors,"ALERT.IPRIOR",ipriors);
    }
  }
}

//--------------------------------------------------------------------------------
//@private members

/**
Установка алармов в конфигурации
  @param limits
  @param dpAlert
  @return
*/
private bool setRegAlertHandleSub(dyn_float limits, string dpAlert) {
  int rc;
  dyn_errClass err;

    rc = dpSetWait(dpAlert + ":_alert_hdl.._type", DPCONFIG_ALERT_NONBINARYSIGNAL,
      dpAlert + ":_alert_hdl.1._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.2._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.3._type", DPDETAIL_RANGETYPE_MINMAX,

      dpAlert + ":_alert_hdl.1._u_limit", limits[1],
      dpAlert + ":_alert_hdl.2._l_limit", limits[1],
      dpAlert + ":_alert_hdl.2._u_limit", limits[2],
      dpAlert + ":_alert_hdl.3._l_limit", limits[2],

      dpAlert + ":_alert_hdl.1._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.1._l_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.2._u_incl", limitsincl[2],
      dpAlert + ":_alert_hdl.2._l_incl", !limitsincl[1],
      dpAlert + ":_alert_hdl.3._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.3._l_incl", !limitsincl[2],

      dpAlert + ":_alert_hdl." + 1 + "._text", alerttextReg[1],
      dpAlert + ":_alert_hdl." + 1 + "._class", alertclass[1],
      dpAlert + ":_alert_hdl." + 3 + "._text", alerttextReg[2],
      dpAlert + ":_alert_hdl." + 3 + "._class", alertclass[4],

      dpAlert + ":_alert_hdl.._orig_hdl", TRUE,
      dpAlert + ":_alert_hdl.._active", TRUE);

  err = getLastError();
  if (dynlen(err) > 0) {
    throwError(err);
    return false;
  } else {
    return true;
  }
}

/**
  Установка алармов в конфигурации
  @param type тип аларма (1 - отдельные алармы, 2 - для двух алармов, 3 - для трех, 4 - для всех)
  @param limits значения уставок
  @param dpAlert точка данных
  @param idx индекс массива текста и класса алармов
  @param i номер диапазона аларма
  @param jdx индекс массива текста и класса алармов
  @param j номер диапазона аларма
  @param kdx индекс массива текста и класса алармов
  @param k номер диапазона аларма
  @return успешно или нет
*/
private bool setAiAlertHandleSub(int type, dyn_float limits, string dpAlert, int idx, int i, int jdx, int j, int kdx, int k) {
  int rc;
  dyn_errClass err;
  switch (type) {
  case 1:
    rc = dpSetWait(dpAlert + ":_alert_hdl.._type", DPCONFIG_ALERT_NONBINARYSIGNAL,
      dpAlert + ":_alert_hdl.1._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.2._type", DPDETAIL_RANGETYPE_MINMAX,

      dpAlert + ":_alert_hdl.1._u_limit", limits[idx],
      dpAlert + ":_alert_hdl.2._l_limit", limits[idx],

      dpAlert + ":_alert_hdl.1._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.1._l_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.2._u_incl", limitsincl[2],
      dpAlert + ":_alert_hdl.2._l_incl", !limitsincl[1],

      dpAlert + ":_alert_hdl." + i + "._text", alerttext[idx],
      dpAlert + ":_alert_hdl." + i + "._class", alertclass[idx],

      dpAlert + ":_alert_hdl.._orig_hdl", TRUE,
      dpAlert + ":_alert_hdl.._active", TRUE);
    break;
  case 2:
    rc = dpSetWait(dpAlert + ":_alert_hdl.._type", DPCONFIG_ALERT_NONBINARYSIGNAL,
      dpAlert + ":_alert_hdl.1._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.2._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.3._type", DPDETAIL_RANGETYPE_MINMAX,

      dpAlert + ":_alert_hdl.1._u_limit", limits[idx],
      dpAlert + ":_alert_hdl.2._l_limit", limits[idx],
      dpAlert + ":_alert_hdl.2._u_limit", limits[jdx],
      dpAlert + ":_alert_hdl.3._l_limit", limits[jdx],

      dpAlert + ":_alert_hdl.1._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.1._l_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.2._u_incl", limitsincl[2],
      dpAlert + ":_alert_hdl.2._l_incl", !limitsincl[1],
      dpAlert + ":_alert_hdl.3._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.3._l_incl", !limitsincl[2],

      dpAlert + ":_alert_hdl." + i + "._text", alerttext[idx],
      dpAlert + ":_alert_hdl." + i + "._class", alertclass[idx],
      dpAlert + ":_alert_hdl." + j + "._text", alerttext[jdx],
      dpAlert + ":_alert_hdl." + j + "._class", alertclass[jdx],

      dpAlert + ":_alert_hdl.._orig_hdl", TRUE,
      dpAlert + ":_alert_hdl.._active", TRUE);
    break;
  case 3:
    rc = dpSetWait(dpAlert + ":_alert_hdl.._type", DPCONFIG_ALERT_NONBINARYSIGNAL,
      dpAlert + ":_alert_hdl.1._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.2._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.3._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.4._type", DPDETAIL_RANGETYPE_MINMAX,

      dpAlert + ":_alert_hdl.1._u_limit", limits[idx],
      dpAlert + ":_alert_hdl.2._l_limit", limits[idx],
      dpAlert + ":_alert_hdl.2._u_limit", limits[jdx],
      dpAlert + ":_alert_hdl.3._l_limit", limits[jdx],
      dpAlert + ":_alert_hdl.3._u_limit", limits[kdx],
      dpAlert + ":_alert_hdl.4._l_limit", limits[kdx],

      dpAlert + ":_alert_hdl.1._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.1._l_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.2._u_incl", limitsincl[2],
      dpAlert + ":_alert_hdl.2._l_incl", !limitsincl[1],
      dpAlert + ":_alert_hdl.3._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.3._l_incl", !limitsincl[2],
      dpAlert + ":_alert_hdl.4._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.4._l_incl", !limitsincl[2],

      dpAlert + ":_alert_hdl." + i + "._text", alerttext[idx],
      dpAlert + ":_alert_hdl." + i + "._class", alertclass[idx],
      dpAlert + ":_alert_hdl." + j + "._text", alerttext[jdx],
      dpAlert + ":_alert_hdl." + j + "._class", alertclass[jdx],
      dpAlert + ":_alert_hdl." + k + "._text", alerttext[kdx],
      dpAlert + ":_alert_hdl." + k + "._class", alertclass[kdx],

      dpAlert + ":_alert_hdl.._orig_hdl", TRUE,
      dpAlert + ":_alert_hdl.._active", TRUE);
    break;
  case 4:
    rc = dpSetWait(dpAlert + ":_alert_hdl.._type", DPCONFIG_ALERT_NONBINARYSIGNAL,
      dpAlert + ":_alert_hdl.1._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.2._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.3._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.4._type", DPDETAIL_RANGETYPE_MINMAX,
      dpAlert + ":_alert_hdl.5._type", DPDETAIL_RANGETYPE_MINMAX,

      dpAlert + ":_alert_hdl.1._u_limit", limits[1],
      dpAlert + ":_alert_hdl.2._l_limit", limits[1],
      dpAlert + ":_alert_hdl.2._u_limit", limits[2],
      dpAlert + ":_alert_hdl.3._l_limit", limits[2],
      dpAlert + ":_alert_hdl.3._u_limit", limits[3],
      dpAlert + ":_alert_hdl.4._l_limit", limits[3],
      dpAlert + ":_alert_hdl.4._u_limit", limits[4],
      dpAlert + ":_alert_hdl.5._l_limit", limits[4],

      dpAlert + ":_alert_hdl.1._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.1._l_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.2._u_incl", limitsincl[2],
      dpAlert + ":_alert_hdl.2._l_incl", !limitsincl[1],
      dpAlert + ":_alert_hdl.3._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.3._l_incl", !limitsincl[2],
      dpAlert + ":_alert_hdl.4._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.4._l_incl", !limitsincl[2],
      dpAlert + ":_alert_hdl.5._u_incl", limitsincl[1],
      dpAlert + ":_alert_hdl.5._l_incl", !limitsincl[2],

      dpAlert + ":_alert_hdl.1._text", alerttext[1],
      dpAlert + ":_alert_hdl.2._text", alerttext[2],
      dpAlert + ":_alert_hdl.4._text", alerttext[3],
      dpAlert + ":_alert_hdl.5._text", alerttext[4],

      dpAlert + ":_alert_hdl.1._class", alertclass[1],
      dpAlert + ":_alert_hdl.2._class", alertclass[2],
      dpAlert + ":_alert_hdl.4._class", alertclass[3],
      dpAlert + ":_alert_hdl.5._class", alertclass[4],

      dpAlert + ":_alert_hdl.._orig_hdl", TRUE,
      dpAlert + ":_alert_hdl.._active", TRUE);
    break;
  default:
    break;
  }

  err = getLastError();
  if (dynlen(err) > 0) {
    throwError(err);
    return false;
  } else {
    return true;
  }
}

/**
  Установка алармов в конфигурации
  @param type тип аларма (1 - отдельные алармы, 2 - для всех)
  @param limits значения уставок
  @param dpAlert точка данных
  @param idx индекс массива текста и класса алармов
  @param i номер диапазона аларма
  @return
*/
private bool setDiAlertHandleSub(int type, dyn_float limits, string dpAlert, int idx, int i) {
  int rc;
  dyn_errClass err;
  switch (type) {
  case 1:
    rc = dpSetWait(dpAlert + ":_alert_hdl.._type", DPCONFIG_ALERT_NONBINARYSIGNAL,
      dpAlert + ":_alert_hdl.1._type", DPDETAIL_RANGETYPE_MATCH,
      dpAlert + ":_alert_hdl.2._type", DPDETAIL_RANGETYPE_MATCH,

      dpAlert + ":_alert_hdl.1._match", "*",
      dpAlert + ":_alert_hdl.2._match", limits[idx],

      dpAlert + ":_alert_hdl." + i + "._text", alerttextDI[idx],
      dpAlert + ":_alert_hdl." + i + "._class", alertclassDI[idx],

      dpAlert + ":_alert_hdl.._orig_hdl", TRUE,
      dpAlert + ":_alert_hdl.._active", TRUE);
    break;
  case 2:
    rc = dpSetWait(dpAlert + ":_alert_hdl.._type", DPCONFIG_ALERT_NONBINARYSIGNAL,
      dpAlert + ":_alert_hdl.1._type", DPDETAIL_RANGETYPE_MATCH,
      dpAlert + ":_alert_hdl.2._type", DPDETAIL_RANGETYPE_MATCH,
      dpAlert + ":_alert_hdl.3._type", DPDETAIL_RANGETYPE_MATCH,

      dpAlert + ":_alert_hdl.1._match", "*",
      dpAlert + ":_alert_hdl.2._match", limits[1],
      dpAlert + ":_alert_hdl.3._match", limits[2],

      dpAlert+":_alert_hdl.2._text", alerttextDI[1],
      dpAlert+":_alert_hdl.2._class", alertclassDI[1],
      dpAlert+":_alert_hdl.3._text", alerttextDI[2],
      dpAlert+":_alert_hdl.3._class", alertclassDI[2],

      dpAlert + ":_alert_hdl.._orig_hdl", TRUE,
      dpAlert + ":_alert_hdl.._active", TRUE);
    break;
  default:
    break;
  }

  err = getLastError();
  if (dynlen(err) > 0) {
    throwError(err);
    return false;
  } else {
    return true;
  }
}


//--------------------------------------------------------------------------------

