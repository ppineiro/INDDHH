<%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@include file="../components/scripts/server/startInc.jsp" %><HTML><head><title><%=LabelManager.getName(labelSet,"titSys")%></title><script>
	var WORK_AREA_MAX = 4;
	var WORK_AREA_MIN = 158;
	//////////////////////////
	//pasar a  framesLayout.js SIN DEFER!!
	////////////////////////////
	var expr_workArea_w = 0;
	var expr_workArea_h = 0;
	
	function getExpr_workarea_width(){
		return expr_workArea_w;
	}
	function getExpr_workarea_height(){
		return expr_workArea_h;
	}

	function getExpr_workarea_toc_height() {
		if (expr_workArea_h==0) {
			return 0;
		} else {
			return (document.body.offsetHeight - 41) + "px";
		}
	}
	
	function update_expr(){
		expr_workArea_w = document.body.offsetWidth - (145 + 8) + (145 - document.getElementById("workArea").offsetLeft + 4) + "px";
		expr_workArea_h = (document.body.offsetHeight - 36) + "px";
		document.recalc();
	}
	function window.onresize(){
		update_expr();
	}
	</script><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/frames.css" rel="styleSheet" type="text/css" media="screen"><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/frames/frames.js" language="Javascript" defer="true"></script></head><body><!---------------------TOPAREA---FRAME--------------------------------><iframe name="topFrame" id="topFrame" src="FramesAction.do?action=top" scrolling="NO" TABINDEX=-1 FRAMEBORDER=0></iframe><!---------------------WORKAREA--FRAME---------------------------------><iframe name="workArea" id="workArea" src="FramesAction.do?action=splash" scrolling="NO"  TABINDEX=1 FRAMEBORDER=0 onload="update_expr()"></iframe><!---------------------TOCAREA---FRAME---------------------------------><iframe name="tocArea" id="tocArea" src="FramesAction.do?action=menu" scrolling="NO" TABINDEX=-1 FRAMEBORDER=0></iframe><!---------------------MESSAGES FRAME----------------------------------><iframe name="iframeMessages" id="iframeMessages" class="feedBackFrame" frameborder="no" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp"  style="display:block" ></iframe><!---------------------SUBMIT FRAME----------------------------------><iframe name="iframeResult" id="iframeResult"  class="feedBackFrame" frameborder="no" style="display:none;)" ></iframe></body></html><script>
	update_expr();
</script>