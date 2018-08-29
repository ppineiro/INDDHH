/* Clase encargada da brindar los paths para los XMLs */
class com.st.util.DataSourceXML {
	function DataSourceXML(){
		}
		
	public function getDataSources(place:String):Void {
		/*
		_global.isXMLexception=function(x:XML){
			if(x.firstChild.nodeName == "EXCEPTION"){
				return true;
			}else{
				return false;
			}
		}
		*/
		switch (place) {
		case "true" :
			trace("in server");
			
			_global.DEBUG_IN_IDE = false;
			_global.PROCESS_ACTION = "administration.ProcessAction.do?xml=true"+_global.windowId+_global.toPrint+"&action=";
			_global.LABELS_TXT_DATAURL =   _global.PROCESS_ACTION + "getLabels";
			_global.PROCESS_XML_DATAURL =  _global.PROCESS_ACTION + "xmlProDefinition";
			_global.ALL_TASKS_DATAURL =  _global.PROCESS_ACTION + "xmlTasks";
			_global.PRESET_TASKS_DATAURL =  _global.PROCESS_ACTION + "xmlCustomTasks";
			_global.ALL_PROCESS_DATAURL = _global.PROCESS_ACTION + "xmlProcesses";
			_global.XML_ENT_FORMS = _global.PROCESS_ACTION + "xmlEntForms";
			_global.entParams ="";
			_global.XML_PRO_FORMS = _global.PROCESS_ACTION + "xmlProForms";
			_global.XML_POOLS_URL = _global.PROCESS_ACTION + "xmlPools";
			_global.XML_EVENTS = _global.PROCESS_ACTION + "xmlEvents";
			_global.XML_CLASSES = _global.PROCESS_ACTION + "xmlClasses";
			_global.XML_STATES = _global.PROCESS_ACTION + "xmlStates";
			_global.XML_ROL = _global.PROCESS_ACTION + "xmlRoles";
			_global.XML_CONDITION = _global.PROCESS_ACTION + "xmlValCondition";
			_global.XML_ATT = _global.PROCESS_ACTION + "xmlAttributes";
			_global.XML_BIND = _global.PROCESS_ACTION + "xmlBindings";
			_global.XMLSTRING = _global.PROCESS_ACTION+"xmlEventsDefinition";
			_global.XML_ATTS_URL = _global.PROCESS_ACTION+"xmlWebServiceAttributes";
			_global.XML_CAL = _global.PROCESS_ACTION + "xmlCalendars";
			break;

			default :
			trace("in debug");
			_global.DEBUG_IN_IDE = true;
			_global.SWF_OBJ_PATH = "";  	
			_global.PROCESS_ACTION = "";
			_global.LABELS_TXT_DATAURL = 	"labels.txt";
			_global.PROCESS_XML_DATAURL = "../source/sampleXML/test_process_2.xml";
			_global.ALL_TASKS_DATAURL = 	"../source/sampleXML/getAllTasksXML.xml";	
			_global.PRESET_TASKS_DATAURL = 	"../source/sampleXML/customTasks.xml";	
			_global.ALL_PROCESS_DATAURL = 	"../source/sampleXML/getAllSubProcessXML.xml";
			_global.XML_ENT_FORMS = 	"../source/sampleXML/getTaskForms.xml";
			_global.entParams ="";
			_global.XML_PRO_FORMS = 	"../source/sampleXML/getTaskForms.xml";
			_global.XML_POOLS_URL = 	"../source/sampleXML/getTaskPools.xml";
			_global.XML_EVENTS = 		"../source/sampleXML/events.xml";
			_global.XML_CLASSES = 		"../source/sampleXML/classes.xml";
			_global.XML_STATES = 		"../source/sampleXML/states.xml";
			_global.XML_ROL = 			"../source/sampleXML/getTaskRol.xml";
			_global.XML_CONDITION = 	"";
			_global.XML_ATT =			"../source/sampleXML/attributes.xml";
			_global.XML_BIND =			"../source/sampleXML/evtBindings.xml";
			_global.XML_ATTS_URL =		"../source/sampleXML/getTaskPools.xml";
			_global.XML_CAL =		"../source/sampleXML/getCalendars.xml";
			break;
		}
	}
}
