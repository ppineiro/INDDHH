<%@include file="includes/startInc.jsp" %><html><head><script type="text/javascript" >
	 		function init(){
				setTimeout(function(){
	 				var parent = window.parent;
	 	 			while(parent != parent.parent) {
	 	 				parent = parent.parent;
	 	 			}
	 	 			parent.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/page/redirectToLogin.jsp"; 
	 			},3000);
		 	}
		</script><style type="text/css">
			.message{
				background-color: rgb(249, 237, 184);
			    border: 1px solid rgb(237, 201, 103);
		    	color: #707070;
		    	padding: 5px 20px;
		    	width: 68%;
		    	margin-left: 10%;
		    	text-align: center;
    		}
			.outer {
			    display: table;
			    position: absolute;
			    height: 100%;
			    width: 100%;
			}
			.middle {
			    display: table-cell;
			    vertical-align: middle;
			}
			.inner {
			    margin-left: auto;
			    margin-right: auto; 
			    width: /*whatever width you want*/;
			}
	
		</style></head><body onload="init()"><div id="bodyDiv"><div class="outer"><div class="middle"><div class="inner"><div class="message"><system:label show="text" label="msgInvalidSession" forScript="true" /></div></div></div></div></div></body></html>




