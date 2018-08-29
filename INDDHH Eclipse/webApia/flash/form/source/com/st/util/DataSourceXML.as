/* Clase encargada da brindar los paths para los XMLs */
class com.st.util.DataSourceXML {
	function DataSourceXML(){
		}
		
	public function getDataSources(place:String):Void {
		_global.isLoaded=false;
		switch (place) {
		case "true" :
			trace("in server");
			_global.DEBUG_IN_IDE = false;
			_global.FORM_ACTION = "administration.FormAction.do?xml=true"+_global.windowId+"&action=";
			_global.FORM_DEFINITION_XML =  _global.FORM_ACTION + "xmlFormDefinition";
			_global.XML_ENTITIES=_global.FORM_ACTION + "xmlEntities";
			_global.XML_ENTITIES_ATT=_global.FORM_ACTION + "xmlEntAtt";			
			_global.ATT_XML =  _global.FORM_ACTION + "xmlAttributes";
			_global.XML_FIELD_EVENTS = _global.FORM_ACTION + "xmlFieldEvents";
			_global.XML_FORM_EVENTS = _global.FORM_ACTION + "xmlFormEvents";
			_global.XML_CLASSES = _global.FORM_ACTION + "xmlClasses";
			_global.BIND_XML = _global.FORM_ACTION + "xmlBind";
			_global.XML_PROPS = _global.FORM_ACTION + "xmlProperties";
			_global.LABELS_TXT_DATAURL =   _global.FORM_ACTION + "getLabels";
			_global.PROPBAR = _global.SWF_OBJ_PATH + "PropBar.swf";
			_global.COD_XML=_global.FORM_ACTION+"xmlModalData";
			break;

			default :
			trace("in debug");
			_global.DEBUG_IN_IDE = true;
			_global.SWF_OBJ_PATH = "";  	
			_global.FORM_ACTION = "";
			_global.FORM_DEFINITION_XML = _global.FORM_ACTION + "formDefinition.xml";
			_global.XML_ENTITIES=_global.FORM_ACTION + "entities.xml";
			_global.XML_ENTITIES_ATT=_global.FORM_ACTION + "xmlEntAtt.xml";
			_global.ATT_XML =  _global.FORM_ACTION + "attributes.xml";
			_global.XML_FIELD_EVENTS = _global.FORM_ACTION + "xmlFieldEvents.xml";
			_global.XML_FORM_EVENTS = _global.FORM_ACTION + "xmlFormEvents.xml";
			_global.XML_CLASSES = _global.FORM_ACTION + "xmlClasses.xml";
			_global.BIND_XML = _global.FORM_ACTION + "evtBindings.xml";
			_global.XML_PROPS = _global.FORM_ACTION + "properties.xml";
			_global.COD_XML=_global.FORM_ACTION+"xmlModalData.xml";
			_global.LABELS_TXT_DATAURL =  "labels.txt";
			//_global.PROPBAR =  "../deploy/PropBar.swf";
			_global.PROPBAR =  "PropBar.swf";
			trace("URL'S LOADED");
			break;
		}
	}
}
