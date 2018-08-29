<%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><meta http-equiv="X-UA-Compatible" content="IE=7" /><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/feedBackFrame.js"<%=defer%>></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/modalController.js"<%=defer%>></script><title><%=LabelManager.getName(labelSet,"titSys")%></title><script>

	var WORK_AREA_MAX = 4;
	var WORK_AREA_MIN = 158;
	//////////////////////////
	//pasar a  framesLayout.js SIN DEFER!!
	////////////////////////////

	
	</script><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/frames.css" rel="styleSheet" type="text/css" media="screen"><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/frames/frames.js" language="Javascript"<%=defer%>></script><%@include file="../../../programs/chat/include/framesJs.jsp" %><script>
		function sizeMe(){
			var width=(document.body.offsetWidth+2);
			var height=(window.innerHeight);
			if(navigator.userAgent.indexOf("MSIE")>0){
				width=document.body.clientWidth;
				if(navigator.userAgent.indexOf("MSIE 6.0")>0){width-=2;}
				window.event.cancelBubble = true;
				height=document.documentElement.clientHeight;
			}
			height-=(document.getElementById("topFrame").clientHeight+10);
			document.getElementById("workArea").style.height=height+"px";
			document.getElementById("workArea").style.width=(width-152)+"px";
			document.getElementById("topFrame").style.width=(width)+"px";
			if(navigator.userAgent.indexOf("MSIE")>0){
				document.getElementById("topFrame").style.width=(width+2)+"px";
			}
			document.getElementById("tocArea").style.height=height+"px";
			window.frames["tocArea"].sizeToc();
			minimizeToc();
		}
		function init(){
			
			document.getElementById("workArea").onmouseover = function() { minimizeToc(); }			
			sizeMe();
			window.onresize=function(){
				sizeMe();
			}
		}
		function minimizeToc(){
			document.getElementById("tocArea").style.width="151px";
			document.getElementById("tocArea").setAttribute("already_sized", "false");
			window.frames["tocArea"].adjustBack(151);
		}
				
		function toggleExplorer(){
			width=0;
			if(navigator.userAgent.indexOf("MSIE")>=0){
				width=document.body.parentElement.clientWidth-10;
			}else{
				width=(document.body.offsetWidth);
			}
			if(document.getElementById("tocArea").style.display=="none"){
				document.getElementById("tocArea").style.display="block";
				document.getElementById("workArea").style.width=(width-150)+"px";
				document.getElementById("workArea").style.left="154px";				
			}else{
				document.getElementById("tocArea").style.display="none";
				document.getElementById("workArea").style.width=(width)+"px";
				document.getElementById("workArea").style.left="4px";
			}
		}

	</script><script language="javascript"<%=defer%>>
		if(navigator.userAgent.indexOf("MSIE")>0){
			document.getElementById("workArea").onmouseover="";
			document.getElementById("tocArea").onblur=minimizeToc;
		}
	</script><%@include file="../../../programs/chat/include/framesScripts.jsp" %></head><body onLoad="init()" scroll="no"><iframe name="topFrame" id="topFrame" src="FramesAction.do?action=top&style=Clean" scrolling="NO" TABINDEX=-1 FRAMEBORDER=0></iframe><iframe name="workArea" id="workArea" src="FramesAction.do?action=splash" scrolling="NO"  TABINDEX=1 FRAMEBORDER=0></iframe><iframe name="tocArea" id="tocArea" src="FramesAction.do?action=menu" scrolling="NO" TABINDEX=-1 FRAMEBORDER=0></iframe><iframe style="z-index:9999990;" name="iframeResult" id="iframeResult" class="feedBackFrame" frameborder="no" style="display:none;" ></iframe><iframe style="z-index:99999999;" name="iframeMessages" id="iframeMessages" class="feedBackFrame" frameborder="no" style="" src="<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory %>/frames/feedBackWin.jsp"></iframe><iframe style="z-index:99999999;" name="iframeLogout" id="iframeLogout" class="feedBackFrame" frameborder="no" style="display:none;" src="<%=Parameters.ROOT_PATH%>/frames/logoutFrame.jsp" ></iframe></body></html>
