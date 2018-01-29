<%
Response.Charset = "GB2312"
'Response.Addheader "Content-Type","text/html; charset=GB2312"
Response.Buffer = True
Response.ExpiresAbsolute = Now() - 1
Response.Expires = 0
Response.CacheControl = "no-cache"
'============================
Web_MdbUrl="#sshy_book2013.mdb"	'数据库地址
Web_SendType=1			'为1时故障报告不需要审核,为0则需要审核
Web_WebPass="admin888"		'管理员密码
Web_PageNum=7			'每页显示几条故障报告
'============================
Pass=request("Pass")
out=request("out")
if Pass<>"" then
	if Pass<>Web_WebPass then
	Response.Write "密码错误!"
	else
	Response.Write "登陆成功!"
	Response.Cookies("Main_LoginPass")=Pass
	end if
Response.Write"<br><br><a href='#' onclick=""AjaxGet('List.asp');return false"">>> 返回查看列表</a>"
Response.End
end if
Main_LoginPass=Request.Cookies("Main_LoginPass")
if (Main_LoginPass<>"" and Main_LoginPass<>Web_WebPass) or out="ok" then
Response.Cookies("Main_LoginPass")=""
Main_LoginPass=""
end if

connstr="DBQ="+server.mappath(Web_MdbUrl)+";DefaultDir=;DRIVER={Microsoft Access Driver (*.mdb)};"
set conn=server.createobject("ADODB.CONNECTION")
conn.open connstr
IF Err.Number <> 0 Then
Response.Write "数据库连接错误，请检查数据库连接文件！"
Response.End
End IF

sub CloseConn()
set rs=nothing
conn.close
set conn=nothing
end sub
'删除修改操作开始
if Main_LoginPass<>"" then
del=request("del")
sh=request("sh")
id=request("id")
re=request("re")
if del<>"" then
conn.Execute("delete from book where id="&del&"")
end if
if sh<>"" and id<>"" then
id=int(id)
sh=int(sh)
conn.Execute("update book set JXK_Types="&sh&" where id="&id&"")
elseif id<>"" then
conn.Execute("update book set JXK_CeoRe='"&re&"',JXK_ReTime='"&now()&"' where id="&id&"")
end if

end if
'删除修改操作结束
set rs=server.createobject("adodb.recordset")
action=request("action")
if action="save" then
JXK_Myname=trim(request.form("JXK_Myname"))
JXK_Cat=trim(request.form("JXK_Cat"))
JXK_Content=trim(request.form("JXK_Content"))
'增加3个字段
JXK_Peo=trim(request.form("JXK_Peo"))
JXK_Tel=trim(request.form("JXK_Tel"))
JXK_Loc=trim(request.form("JXK_Loc"))
'增加3个字段
if len(JXK_Myname)<2 or len(JXK_Myname)>5 then
Response.Write "<script>alert('姓名须在2-5个字符以内!');parent.SendErr()</script>"
Call CloseConn()
Response.End
end if

if len(JXK_Content)<5 or len(JXK_Content)>500 then
Response.Write "<script>alert('内容须在5-500个字符以内!');parent.SendErr()</script>"
Call CloseConn()
Response.End
end if

JXK_Content=Server.Htmlencode(JXK_Content)
JXK_Content=Replace(JXK_Content,CHR(13),"<br>")

if JXK_Cat="" then JXK_Cat=1
if JXK_Cat=0 then JXK_Cat=1
JXK_Cat=int(JXK_Cat)
JXK_MyIp = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
If JXK_MyIp="" Then JXK_MyIp=Request.ServerVariables("REMOTE_ADDR")
if JXK_MyIp="" then
Response.Write "<script>alert('无法获取您的IP信息,系统禁止报告故障!')</script>"
Call CloseConn()
Response.End
end if

rs.open "select * from Book",conn,1,3
rs.addnew
rs("Jxk_Content")=Jxk_Content
rs("JXK_Myname")=JXK_Myname
rs("JXK_MyIp")=JXK_MyIp
rs("JXK_Cat")=0
rs("JXK_Types")=Web_SendType
'增加3个记录
rs("JXK_Peo")=JXK_Peo
rs("JXK_Loc")=JXK_Loc
rs("JXK_Tel")=JXK_Tel
rs.update
rs.close
Call CloseConn()
Response.Write "<script>parent.SendOk()</script>"
Response.End
end if

page=request("page")
C=request("C")
if C="" then C=0
C=int(C)
'分页函数
function Pageinc(pagenum,listnum)
onpage=request("page")
if onpage="" then onpage=1
pagenum=int(pagenum)
onpage=int(onpage)
pagelink=replace(request.querystring(),"page="&request("page")&"&","")
pagelink=replace(pagelink,"page="&request("page"),"")
if pagelink<>"" then pagelink="&"&pagelink
if onpage-2 < 1 then
fistpage=1
else
fistpage=onpage-2
end if
if pagenum-fistpage<9 and pagenum>9 then fistpage=pagenum-9
if pagenum>fistpage+9 then
lastpage=fistpage+9
else
lastpage=pagenum
end if
if pagenum>8 and lastpage-fistpage<9 then
fistpage=lastpage-8
elseif pagenum<9 and lastpage-fistpage<9 then
fistpage=1
end if
pageinc=pageinc&"<div style='margin-left:0px'>共<b>"&pagenum&"</b>页<b>"&listnum&"</b>条故障报告"
if Main_LoginPass<>"" then pageinc=pageinc&" <a href='#' onclick=""AjaxGet('List.asp?out=ok');return false"" style=""color:#0000ff"">[退出]</a>"
pageinc=pageinc&"</div>"
if onpage>1 then
pageinc=pageinc&"<div><a href=""javascript:AjaxGet('List.asp?C="&C&"')"">|<<</a></div>"
pageinc=pageinc&"<div><a href=""javascript:AjaxGet('List.asp?C="&C&"&page="&onpage-1&"')""><<</a></div> "
else
pageinc=pageinc&"<div class=WinPageDis>|<<</div>"
pageinc=pageinc&"<div class=WinPageDis><<</div> "
end if
for i=fistpage to lastpage
if i<10 then ii="0"&i else ii=i
if onpage=i then
pageinc=pageinc&"<div class=WinPageCur>"&ii&"</div> "
else
pageinc=pageinc&"<div><a href=""javascript:AjaxGet('List.asp?C="&C&"&page="&i&"')"">"&ii&"</a></div> "
end if
next
if onpage<pagenum and pagenum<>1 then
pageinc=pageinc&"<div><a href=""javascript:AjaxGet('List.asp?C="&C&"&page="&onpage+1&"')"">>></a></div> "
pageinc=pageinc&"<div><a href=""javascript:AjaxGet('List.asp?C="&C&"&page="&pagenum&"')"">>>|</a></div>"
else
pageinc=pageinc&"<div class=WinPageDis>>></div> "
pageinc=pageinc&"<div class=WinPageDis>>>|</div>"
end if
pageinc=pageinc&"</ul>"
end function

'各种日期格式转换
Function DateFormat(DateStr)
Hours=Hour(DateStr)
if Hours<10 then Hours="0"&Hours
Minutes=int(Minute(DateStr))
if Minutes<10 then Minutes="0"&Minutes
Months=month(DateStr)
if Months<10 then Months="0"&Months
days=day(DateStr)
if days<10 then days="0"&days
DateString = right(year(DateStr),2)&"-"&Months&"-"&days&" "&Hours&":"&Minutes
DateFormat = DateString
End Function

'过滤
Function HtmlEnCode(fString)
'普通替换
'fString=UCase(fString)
fString = Replace(fString, "我靠", "＊＊")
fString = Replace(fString, "我草", "＊＊")
fString = Replace(fString, "去死", "＊＊")
fString = Replace(fString, "你妈", "＊＊")
fString = Replace(fString, "他妈", "＊＊")
fString = Replace(fString, "垃圾", "＊＊")
fString = Replace(fString, "干你", "＊＊")
fString = Replace(fString, "色情", "＊＊")
fString = Replace(fString, "黄片", "＊＊")
fString = Replace(fString, "我日", "＊＊")
fString = Replace(fString, "我操", "＊＊")
fString = Replace(fString, "傻B", "＊＊")

Set re=new regExp
re.IgnoreCase=true
re.Global=true
re.Pattern="(http://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?)" 
fString=re.replace(fString,"<a href='$1' target='_blank' onclick=""return(confirm('该链接为网友发布,系统不保证该链接的安全性!\n\n确定要打开'+this.href+'吗？'))"">$1</a>") 
re.Pattern="([^(http:\/\/)])(www\.([\w-]+\.)+[\w]+(\/[\w-]+)*[\/]?([\w-]+\.[\w]+)?(\?[\w]+=[\w]+(&[\w]+=[\w]+)*)?)" 
fString=re.replace(fString,"$1<a href='http://$2' target='_blank' onclick=""return(confirm('该链接为网友发布,系统不保证该链接的安全性!\n\n确定要打开'+this.href+'吗？'))"">$2</a>")
re.Pattern="(mailto:)?([\w]+@([\w-]+\.)+[\w]+)" 
fString=re.replace(fString,"<a href='mailto:$2' onclick=""return(confirm('该链接为网友发布,系统不保证该链接的安全性!\n\n确定要打开'+this.href+'吗？'))"">$1$2</a>") 
Set re=nothing
HtmlEnCode=fString
End Function

dim PageList
sql="select * from book"
if C<>0 then sql=sql&" where JXK_Cat="&C&""
sql=sql&" order by id desc"
rs.open sql,conn,1,1
if rs.eof then
PageList="<p style='text-align:center;padding:10px'>暂时未有单位报告故障!</a>"
else
rs.PageSize=Web_PageNum
pre = true 
last = true 
if len(page) = 0 then 
intpage = 1 
pre = false 
else 
if cint(page) =< 1 then 
intpage = 1 
pre = false 
else
if cint(page) >= rs.PageCount then 
intpage = rs.PageCount 
last = false 
else 
intpage = cint(page) 
end if 
end if 
end if 
if not rs.eof then
rs.AbsolutePage = intpage 
end if 
for i=1 to rs.PageSize
if rs.EOF or rs.BOF then exit for
JXK_MyIp=rs("JXK_MyIp")
if Main_LoginPass="" then JXK_MyIp=left(JXK_MyIp,len(JXK_MyIp)-len(split(JXK_MyIp,".")(3)))&"*"

jxk_content=HtmlEnCode(rs("jxk_content"))
if rs("JXK_Types")=0 and Main_LoginPass="" then jxk_content="<p align=center style='color:#999999;padding-bottom:10px'>〓 该条故障尚未经过管理员审核! 〓</font>"
PageList=PageList&"<div class='JXK_List'>"
PageList=PageList&"<div class='List1'><table><tr><td rowspan='2' id='aaa'>"&rs("id")&"</td><td class='bbb'>报障人</td><td class='ttt'>"&rs("JXK_MyName")&"</td><td class='bbb'>联系人</td><td class='ttt'>"&rs("JXK_Peo")&"</td><td class='bbb'>联系电话</td><td class='ttt'>"&rs("JXK_Tel")&"</td><td class='bbb'>报障时间</td><td class='ttt'>"&rs("jxk_time")&"</td><td class='bbb'>IP地址</td><td class='ttt'>"&JXK_MyIp&"</td></tr><tr><td class='bbb'>具体位置</td><td colspan='10' class='ttt' style='text-align:left'>"&rs("JXK_Loc")&"</td></tr></table></div>"
PageList=PageList&"<div class='List2'><b>故障描述：</b><font style='color:#666666;'>"&jxk_content&"</font></div>"
if Main_LoginPass<>"" then
PageList=PageList&"<div class='List3'><hr><font style='color:blue'>运维人员回复：</font>"
PageList=PageList&"<input type='text' id='re_"&rs("id")&"' size=64 class='JXK_inp' value='"&rs("JXK_CeoRe")&"'> <input type='button' value='保存' class='JXK_button' onclick=""AjaxGet('list.asp?page="&page&"&id="&rs("id")&"&re='+$('re_"&rs("id")&"').value)""> <input type='button' value='删除' class='JXK_button' onclick=""if(confirm('确认删除?')){AjaxGet('list.asp?page="&page&"&del="&rs("id")&"')}""> "
if rs("JXK_Types")=0 then
PageList=PageList&"<input onclick=""AjaxGet('list.asp?page="&page&"&sh=1&id="&rs("id")&"')"" type='button' value='审核' class='JXK_button' style='color:#0000ff'>"
else
PageList=PageList&"<input onclick=""AjaxGet('list.asp?page="&page&"&sh=0&id="&rs("id")&"')"" type='button' value='取消审核' class='JXK_button'>"
end if
PageList=PageList&"</div>"
else
	if rs("JXK_CeoRe")<>"无" and len(rs("JXK_CeoRe"))>0 then
	PageList=PageList&"<div class='List3'><font style='color:blue'>运维人员回复："&rs("JXK_CeoRe")&"</font><span id='retime'>"&rs("JXK_ReTime")&"</span></div>"
	end if
end if
PageList=PageList&"</div>"
rs.movenext
next
end if
PageList=PageList&"<div class='WinPage'>"&Pageinc(rs.PageCount,rs.RecordCount)&"</div>"
rs.close
Call CloseConn()
Response.Write PageList
%>