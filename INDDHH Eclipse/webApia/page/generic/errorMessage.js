var GNR_TITILE_MESSAGES		= "Messages";
var GNR_TITILE_EXCEPTIONS	= "Exceptions";
function doLoad(){
	var xml = StringtoXML(document.getElementById("txt").value);
	modalProcessXml(xml);
}
