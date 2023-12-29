public time AddMillisecondsTD(time t, int milliseconds)
{
  time difference = makeTime(1970, 1, 1, 0, 0, 0 + timeFromGMT(), abs(milliseconds));
  return milliseconds >= 0 ? t + difference : t - difference;
}

public string TimeToStringTD(time arg)
{
  string s = day(arg) + "." + month(arg) + "." + year(arg) + " " + hour(arg) + ":" + minute(arg) + ":" + second(arg);
  return s;
}

public string TimeToStringForUtcTD(time arg)
{
  string s = year(arg) + "." + month(arg) + "." + day(arg) + " " + hour(arg) + ":" + minute(arg) + ":" + second(arg);
  return s;
}
