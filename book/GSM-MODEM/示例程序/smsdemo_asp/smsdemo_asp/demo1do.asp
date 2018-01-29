<%
'在ASP中使用本控件注意事项
'1、alasunsmscon.ocx这一文件的权限要设置正确，即设置“IUSR_机器名”这一用户有执行的权限，否则会报错“Server.CreateObject 访问错误”。
'   在设置完权限后，需重启IIS。
'2、如有必要可以在alasunsmscon.ocx所在的目录创建名为“alasunsmslog”的目录，设置“IUSR_机器名”用户对这一目录有可写仅限，用于记录发送日志。
'   此步为可选步骤
'以下程序在实测中验证通过
response.buffer=true
dim objSMS
dim lngRes,strNO,strCON,strMsgCenter
strNO=request.Form("txtNo")
strCON=request.Form("txtContent")
if strNo="" then
	response.Write "<script>alert('请入接收号码');window.history.back();</script>"
	response.End 
end if
set objSMS=Server.CreateObject("alasun.alasunsms")
'设置串口号
objSMS.CommPort=1
'打开设备
lngRes=objSMS.OpenComm
if lngRes=0 then
	response.Write "打开设备成功<br>"
else
	response.Write "打开设备失败<br>"
end if
response.Flush
'设置短信中心，只需在SIM卡第一次使用时设置，以后不用再设，此处仅作示例
strMsgCenter="+8613800757500"  '请改为当地的短信中心号码
lngRes=objSMS.SetMsgCenterNo(strMsgCenter)
if lngRes=0 then
	response.Write "短信中心设置成功<br>"
else
	response.Write "短信中心设置失败<br>"
end if
response.Flush 
'发送短信
lngRes=objSMS.SendMsg(strNO,strCON)
if lngRes=0 then
	response.Write "短信发送成功<br>"
else
	response.Write "短信发送失败<br>"
end if
response.Write "<a href='javascript:window.history.back()'>返回</a>"
response.Flush 
objSMS.CloseComm
set objSMS=nothing
%>