#uses "CtrlHTTP"
#uses "http.ctl"
main()
{
  httpServer(FALSE, 12000,0); //

  httpConnect("getRestful", "/restful/*");
}
string getRestful(dyn_string names, dyn_string values, string user, string ip, dyn_string headerNames, dyn_string headerValues, int idx)
{
string result;
string tag;
int rc;
dyn_string numbers;
string sURI = httpGetURI(idx);
DebugN("sURL string ="+ sURI);

strreplace(sURI,"/restful/","");
tag ="System1:"+sURI+".";
numbers = dpNames(tag+"*");

for(int i =1;i<=numbers.count();i++)
{
anytype temp;

    dpGet(numbers[i],temp);
result += numbers[i]+" = "+temp+"<br/>";//<br/> 为html的换行符
  }
return result;
}
