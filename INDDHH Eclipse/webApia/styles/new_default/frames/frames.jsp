<%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><meta http-equiv="X-UA-Compatible" content="IE=7" /><title><%=LabelManager.getName(labelSet,"titSys")%></title><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/frames.css" rel="styleSheet" type="text/css" media="screen"><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/feedBackFrame.js"<%=defer%>></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/modalController.js"<%=defer%>></script><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/frames/frames.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/tocSizer.js" language="Javascript"<%=defer%>></script><%@include file="../../../programs/chat/include/framesJs.jsp" %><script language="javascript">
		var images=new Object();
		images["execution.TaskListAction"]="tasks.gif";
		images["administration.FormAction"]="design.gif";
		images["administration.ProcessAction"]="design.gif";
		images["security"]="security.gif";
		images["execution"]="execution.gif";
		images["administration"]="administration.gif";
		images["analitic"]="administration.gif";
		images["configuration"]="administration.gif";
	</script><script language="javascript">
	var WORK_AREA_MAX = 4;
	var WORK_AREA_MIN = 158;
	//////////////////////////
	//pasar a  framesLayout.js SIN DEFER!!
	////////////////////////////
	var expr_workArea_w = 0;
	var expr_workArea_h = 0;
	
		function sizeMe(){
			var width=(document.body.offsetWidth+2);
			var height=(window.innerHeight);
			if(navigator.userAgent.indexOf("MSIE")>0){
				width=document.body.clientWidth;
				window.event.cancelBubble = true;
				height=document.documentElement.clientHeight;
			}
			document.getElementById("workArea").style.height=((height-document.getElementById("topFrame").clientHeight-5))+"px";
			document.getElementById("workArea").style.width=(width-156)+"px";
			document.getElementById("topFrame").style.width=(width)+"px";
			document.getElementById("tocArea").style.height=((height-document.getElementById("topFrame").clientHeight-10))+"px";
			document.getElementById("tocArea").style.width="156px";
			window.frames["tocArea"].updateHeight();
			window.frames["tocArea"].adjustBack(154);
			tocSizer.style.height=((height-document.getElementById("topFrame").clientHeight-10))+"px";
	}
	function init(){
	
		document.getElementById("workArea").onmouseover = function() {
															document.getElementById("tocArea").setAttribute("already_sized", "false");
															sizeMe();
														}
		sizeMe();
		window.onresize=function(){
			sizeMe();
		}
	}
	function toggleExplorer(){
		if(document.getElementById("tocArea").style.display=="none"){
			document.getElementById("tocArea").style.display="block";
			document.getElementById("tocSizer").style.display="block";
			document.getElementById("workArea").style.width=(document.getElementById("workArea").clientWidth-156)+"px";
			document.getElementById("workArea").style.left="158px";				
		}else{
			document.getElementById("tocArea").style.display="none";
			document.getElementById("tocSizer").style.display="none";
			document.getElementById("workArea").style.width=(document.getElementById("workArea").clientWidth+156)+"px";
			document.getElementById("workArea").style.left="4px";
		}
	}
	function setBackground(){
		var currentModule="";
		try{
			currentModule=window.frames["workArea"].getCurrentModule();
		}catch(e){}
		//currentModule=currentModule.split(".")[0];
		if(currentModule=="execution.TasksListAction"){
			var imageURL="url(<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/"+images[currentModule]+")";
			for(var i=0;i<2;i++){
				window.frames["workArea"].document.getElementById("frameContent"+i).onload=function(){
					var imageURL="url(<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/tasks.gif)";
					var body=window.frames["workArea"].frames[this.id].document.body;
					body.style.backgroundImage=imageURL;
					body.style.backgroundRepeat="no-repeat";
					body.style.backgroundPosition="95% 90%";
				}
			}
		}else if(images[currentModule]){
			var imageURL="url(<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/"+images[currentModule]+")";
			window.frames["workArea"].document.body.style.backgroundImage=imageURL;
			window.frames["workArea"].document.body.style.backgroundRepeat="no-repeat";
			window.frames["workArea"].document.body.style.backgroundPosition="95% 90%";
		}else if(images[currentModule.split(".")[0]]){
			var imageURL="url(<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/"+images[currentModule.split(".")[0]]+")";
			window.frames["workArea"].document.body.style.backgroundImage=imageURL;
			window.frames["workArea"].document.body.style.backgroundRepeat="no-repeat";
			window.frames["workArea"].document.body.style.backgroundPosition="95% 90%";
		}
	}
	

	</script><%@include file="../../../programs/chat/include/framesScripts.jsp" %></head><body onLoad="init()" scroll="no"><iframe name="topFrame" id="topFrame" src="FramesAction.do?action=top&style=new_default" scrolling="NO" TABINDEX=-1 FRAMEBORDER=0></iframe><iframe onload="setBackground()" name="workArea" id="workArea" src="FramesAction.do?action=splash" scrolling="NO"  TABINDEX=1 FRAMEBORDER=0></iframe><iframe name="tocArea" id="tocArea" src="FramesAction.do?action=menu" scrolling="NO" TABINDEX=-1 FRAMEBORDER=0></iframe><iframe style="z-index:9999990;" name="iframeResult" id="iframeResult" class="feedBackFrame" frameborder="no" style="display:none;" ></iframe><iframe style="z-index:99999999;" name="iframeMessages" id="iframeMessages" class="feedBackFrame" frameborder="no" style="" src="<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory %>/frames/feedBackWin.jsp"></iframe><iframe style="z-index:99999999;" name="iframeLogout" id="iframeLogout" class="feedBackFrame" frameborder="no" style="display:none;" src="<%=Parameters.ROOT_PATH%>/frames/logoutFrame.jsp" ></iframe></body></html>

