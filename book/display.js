function $(obj){return document.getElementById(obj);}
//����XML����
function createXMLHttps(){
var ret = null;
try {ret = new ActiveXObject('Msxml2.XMLHTTP')}
catch (e) {
	try {ret = new ActiveXObject('Microsoft.XMLHTTP')}
        catch (ee) {ret = null}
	}
if (!ret&&typeof XMLHttpRequest !='undefined') ret = new XMLHttpRequest();
return ret;
}

function AjaxGet(URL) {
URL="book/"+URL
$("BookList").innerHTML="<div class='Loading'>������������,���Ժ�...</div>";
var xmlhttp = createXMLHttps();
xmlhttp.open("GET",URL,true);
xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
xmlhttp.onreadystatechange = function() {
	//alert(xmlhttp.responseText)
	if (xmlhttp.readyState == 4 && xmlhttp.status==404) {$("BookList").innerHTML="��������æ,��ˢ������...";return}
	if (xmlhttp.readyState == 4 && xmlhttp.status==500) {$("BookList").innerHTML="��������æ,��ˢ������...";return}
	if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
		var ajaxHtml=xmlhttp.responseText;
		$("BookList").innerHTML=ajaxHtml
		}
	}
xmlhttp.send(null);
}


function SendNow(){
//if($("JXK_Myname").value.length<2||$("JXK_Myname").value.length>5){alert('����Ӧ��2-5���ַ�����!');return false}
if($("JXK_Myname").value=="��ʵ����"){alert('��������ʵ�������');return false}
if($("JXK_Myname").value.length<2||$("JXK_Myname").value.length>4){alert('��ʲô��������Ҳ���');return false}
if($("JXK_Peo").value.length<2||$("JXK_Peo").value.length>4){alert('��ʲô��������Ҳ���');return false}
if($("JXK_Peo").value=="����"){alert('û����ϵ����������˭��');return false}
if($("JXK_Tel").value.length<11||$("JXK_Myname").value.length>11){alert('�ף����氡���ֻ��������');return false}
if($("JXK_Loc").value=="9������"){alert('�����ˣ�������Ϸ����������ܸø����Ұɣ�');return false}
if($("JXK_Content").value=="9������"){alert('�㵽����������ʲô��');return false}
if($("JXK_Content").value.length<5||$("JXK_Content").value.length>42){alert('������������Ӧ��5-42���ַ�����!');return false}
$("Send1").style.display='none';
$("Send2").innerHTML="�����ύ���ϱ���...";
}

function SendOk(){
AjaxGet("list.asp")
$("JXK_Content").value="";
$("Send1").style.display="";
$("Send2").innerHTML="";
}

function SendErr(){
$("Send1").style.display="";
$("Send2").innerHTML="";
$('CodeImg').src='GetCode.asp'
}

function Login(){
$("AdminLogin").style.display="none";
AjaxGet("list.asp?Pass="+$("Pass").value);
}

window.onload=function(){
AjaxGet('list.asp');
}
//����ֻ�������ֻ�����
function   _CheckSinglePhone(Phone)   
  {   
  var   reg=/^((13[0-9]{9})|(159[0-9]{8}))$/;   
  return   reg.test(Phone);   
  }   
function   _Check()   
{   
  var   Phone   =   document.getElementById("JXK_Tel").value;   
        if(!_CheckSinglePhone(Phone))   
  {   
            alert("������ֻ��������");   
            return   ;   
   }   
}   