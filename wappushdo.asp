<%
'��ASP��ʹ�ñ��ؼ�ע������
'1��alasunsmscon.ocx��һ�ļ���Ȩ��Ҫ������ȷ�������á�IUSR_����������һ�û���ִ�е�Ȩ�ޣ�����ᱨ����Server.CreateObject ���ʴ��󡱡�
'   ��������Ȩ�޺�������IIS��
'2�����б�Ҫ������alasunsmscon.ocx���ڵ�Ŀ¼������Ϊ��alasunsmslog����Ŀ¼�����á�IUSR_���������û�����һĿ¼�п�д���ޣ����ڼ�¼������־��
'   �˲�Ϊ��ѡ����
'���³�����ʵ������֤ͨ��
response.buffer=true
dim objSMS
dim lngRes,strNO,strCON,strUrl
strNO=request.Form("txtNo")
strUrl=request.Form("txtUrl")
strCON=request.Form("txtContent")
if strNo="" then
	response.Write "<script>alert('������պ���');window.history.back();</script>"
	response.End 
end if
if strUrl="" then
	response.Write "<script>alert('����������ַ');window.history.back();</script>"
	response.End 
end if
set objSMS=Server.CreateObject("alasun.alasunsms")
'���ô��ں�
objSMS.CommPort=1
'���豸
lngRes=objSMS.OpenComm
if lngRes=0 then
	response.Write "���豸�ɹ�<br>"
else
	response.Write "���豸ʧ��<br>"
end if
response.Flush
'���Ͷ���
lngRes=objSMS.SendWapPushMsg(strNO,strUrl,strCON)
if lngRes=0 then
	response.Write "WAP PUSH���ŷ��ͳɹ�<br>"
else
	response.Write "WAP PUSH���ŷ���ʧ��<br>"
end if
response.Write "<a href='javascript:window.history.back()'>����</a>"
response.Flush 
objSMS.CloseComm
set objSMS=nothing
%>