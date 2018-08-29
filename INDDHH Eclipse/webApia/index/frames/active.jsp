<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><!----------------------------------------------------------------------------------------><!--  Auxiliary inclusion start (Constants, parameters, etc)							--><!----------------------------------------------------------------------------------------><%@include file="../components/scripts/server/startInc.jsp" %><html><head><meta http-equiv="refresh" content="<%= com.dogma.Parameters.KEEP_ACTIVE_SECONDS %>"><script type="text/javascript">
			var status = window.parent.document.getElementById("divTituloWaitStatusMessage");
			var statusImage = window.parent.document.getElementById("divTituloWaitStatusImage");
			var statusImageCont = window.parent.document.getElementById("divTituloWaitStatusImageContainer");

			if (status != null) {
				var statusMessage = "<%= uData.getStatusMessage() %>";
				if (statusMessage != "") {				
					status.innerHTML = statusMessage;
					status.style.display = "block";
				} else {
					status.style.display = "none";
				}
			}
			
			var statusPorcentaje = <%= uData.getStatusProgress() %>;
			if (statusImage != null) {
				if (statusPorcentaje != 0) {				
					statusImage.style.width = (statusPorcentaje * 2) + "px";
					statusImage.style.display = "block";
				} else {
					statusImage.style.display = "none";
				}
			}

			if (statusImageCont != null) {
				if (statusPorcentaje != 0) {				
					statusImageCont.style.display = "block";
				} else {
					statusImageCont.style.display = "none";
				}
			}
		</script></head><body>
		KEEP ACTIVE
	</body></html>
