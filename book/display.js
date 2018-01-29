function $(obj){return document.getElementById(obj);}
//创建XML对象
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
$("BookList").innerHTML="<div class='Loading'>数据正在载入,请稍后...</div>";
var xmlhttp = createXMLHttps();
xmlhttp.open("GET",URL,true);
xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
xmlhttp.onreadystatechange = function() {
	//alert(xmlhttp.responseText)
	if (xmlhttp.readyState == 4 && xmlhttp.status==404) {$("BookList").innerHTML="服务器繁忙,请刷新重试...";return}
	if (xmlhttp.readyState == 4 && xmlhttp.status==500) {$("BookList").innerHTML="服务器繁忙,请刷新重试...";return}
	if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
		var ajaxHtml=xmlhttp.responseText;
		$("BookList").innerHTML=ajaxHtml
		}
	}
xmlhttp.send(null);
}


function SendNow(){
//if($("JXK_Myname").value.length<2||$("JXK_Myname").value.length>5){alert('姓名应在2-5个字符以内!');return false}
if($("JXK_Myname").value=="真实姓名"){alert('报障人真实姓名必填！');return false}
if($("JXK_Myname").value.length<2||$("JXK_Myname").value.length>4){alert('搞什么啊，名字也输错！');return false}
if($("JXK_Peo").value.length<2||$("JXK_Peo").value.length>4){alert('搞什么啊，名字也输错！');return false}
if($("JXK_Peo").value=="必填"){alert('没有联系人你让我找谁？');return false}
if($("JXK_Tel").value.length<11||$("JXK_Myname").value.length>11){alert('亲，还玩啊，手机号码输错！');return false}
if($("JXK_Loc").value=="9个汉字"){alert('别闹了，具体故障发生在哪里总该告诉我吧？');return false}
if($("JXK_Content").value=="9个汉字"){alert('你到底想让我修什么？');return false}
if($("JXK_Content").value.length<5||$("JXK_Content").value.length>42){alert('故障内容描述应在5-42个字符以内!');return false}
$("Send1").style.display='none';
$("Send2").innerHTML="正在提交故障报告...";
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
//限制只能输入手机号码
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
            alert("输入的手机号码错误");   
            return   ;   
   }   
}   