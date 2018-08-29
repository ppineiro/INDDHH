
function INDDHH_JS_GOOGLE_ANALYTICS(evtSource) { 
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
  
  var myForm=ApiaFunctions.getForm("TRM_TITULO");
  if (myForm != null) {
  		var nro=ApiaFunctions.getForm("TRM_TITULO").getField("TRM_GOOGLE_ANALYTICS_ACCOUNT_NRO_STR").getValue();
  		var name=ApiaFunctions.getForm("TRM_TITULO").getField("TRM_GOOGLE_ANALYTICS_ACCOUNT_NAME_STR").getValue();

	    ga('create', nro, 'auto', name);
  		ga(name+'.send', 'pageview');
  }  




return true; // END
} // END
