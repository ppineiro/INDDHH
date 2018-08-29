<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="com.dogma.vo.IFldType"%><html style="overflow:hidden;"><head><link href="<system:util show="context" />/page/design/forms/formsDesigner/designer.css" rel="stylesheet" type="text/css" ><link href="<system:util show="context" />/page/design/forms/formsDesigner/tabs.css" rel="stylesheet" type="text/css" ><script type="text/javascript">
	var LBL_UP 	 = '<system:label show="text" label="btnUp" forScript="true" />';
	var LBL_DOWN = '<system:label show="text" label="btnDown" forScript="true" />';
	var LBL_ADD	 = '<system:label show="text" label="btnAgr" forScript="true" />';
	var LBL_DEL	 = '<system:label show="text" label="btnDel" forScript="true" />';
	var LBL_YES	 = '<system:label show="text" label="lblYes" forScript="true" />';
	var LBL_NO	 = '<system:label show="text" label="lblNo" forScript="true" />';
	var LBL_CLOSE = '<system:label show="text" label="lblCloseWindow" forScript="true" />';
	var LBL_STR_TYPE = '<system:label show="text" label="lblStr" forScript="true" />';
	var LBL_NUM_TYPE = '<system:label show="text" label="lblNum" forScript="true" />';
	var LBL_DATE_TYPE = '<system:label show="text" label="lblDate" forScript="true" />';
	var LBL_CLEAR_FORM_TITLE = '<system:label show="text" label="flaClearForm" forScript="true" />';
	var LBL_CLEAR_FORM_TEXT = '<system:label show="text" label="flaClearFormText" forScript="true" />';
	var LBL_COL_WITH_FIELDS = '<system:label show="text" label="flaColWithFields" forScript="true" />';
	var LBL_DEL_COLUMN = '<system:label show="text" label="btnDelCol" forScript="true" />';
	var LBL_MIN_WIDTH_REACHED = '<system:label show="text" label="flaMinWidthReached" forScript="true" />';
	var LBL_CELL_OCCUPIED = '<system:label show="text" label="flaCellOcupied" forScript="true" />';
	var LBL_CELL_EMPTY = '<system:label show="text" label="flaCellEmpty" forScript="true" />';
	var LBL_OUT_OF_BOUNDS = '<system:label show="text" label="flaOutOfBounds" forScript="true" />';
	var LBL_MIN_NOT_REACHED = '<system:label show="text" label="flaMinSizeNotReached" forScript="true" />';
	
	var ATTRIBUTES_MODAL= '<system:util show="context"/>/page/design/forms/formsDesigner/modals/attModal.jsp';
	var MDL_DATA_MODAL 	= '<system:util show="context"/>/page/design/forms/formsDesigner/modals/modalData.jsp';
	var BUS_CLA_MODAL	= '<system:util show="context"/>/page/design/forms/formsDesigner/modals/busClaModal.jsp';
	var TABLE_FLDS_SORT_MODAL	= '<system:util show="context"/>/page/design/forms/formsDesigner/modals/tableFieldsSortModal.jsp';
	var IMG_FOLDER = '<system:util show="context" />/page/design/forms/formsDesigner/img/';
	
	var TYPE_FORM		=  '-1';
	var TYPE_INPUT		=  '<%= IFldType.TYPE_INPUT %>';
	var TYPE_SELECT		=  '<%= IFldType.TYPE_SELECT %>';
	var TYPE_CHECK		=  '<%= IFldType.TYPE_CHECK %>';
	var TYPE_RADIO		=  '<%= IFldType.TYPE_RADIO %>';
	var TYPE_BUTTON		=  '<%= IFldType.TYPE_BUTTON %>';
	var TYPE_AREA		=  '<%= IFldType.TYPE_AREA %>';
	var TYPE_LABEL		=  '<%= IFldType.TYPE_LABEL %>';
	var TYPE_TITLE		=  '<%= IFldType.TYPE_TITLE %>';
	var TYPE_FILE		=  '<%= IFldType.TYPE_FILE %>';
	var TYPE_MULTIPLE	=  '<%= IFldType.TYPE_MULIPLE %>';
	var TYPE_HIDDEN		=  '<%= IFldType.TYPE_HIDDEN %>';
	var TYPE_PASSWORD	=  '<%= IFldType.TYPE_PASSWORD %>';	
	var TYPE_IMAGE		=  '<%= IFldType.TYPE_IMAGE %>';
	var TYPE_GRID		=  '<%= IFldType.TYPE_GRID %>';
	var TYPE_HREF		=  '<%= IFldType.TYPE_HREF %>';
	var TYPE_EDITOR		=  '<%= IFldType.TYPE_EDITOR %>';
	var TYPE_TREE		=  '<%= IFldType.TYPE_TREE %>';
	var TYPE_CAPTCHA	=  '<%= IFldType.TYPE_CAPTCHA %>';
	
</script><script type="text/javascript" src="<system:util show="context" />/js/dropMenu/MooDropMenu.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/forms/formsDesigner/lib/MooResize.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/forms/formsDesigner/lib/slideGallery.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/forms/formsDesigner/properties.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/forms/formsDesigner/fields.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/forms/formsDesigner/gridCell.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/forms/formsDesigner/designer.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/forms/formsDesigner/gridSchema.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/forms/formsDesigner/historyStack.js"></script></head><body><div class="form-designer-container"><div class="grid-layout"><div class="toolbar-container"><%@include file="toolbar.jsp" %></div><div class="grid-container"><div style="height: 100%; width: 100%"><ul id="gridContainer"></ul></div><div class="tooltip-container"><div id="tooltipInfo"></div></div></div></div></div><div class="form-options-container"><div class="half-container" id="topOptsContainer"><div class='tab-container'><div class='tab-content-boxshadow'><div class='tabbed skin-wet-asphalt round' id='skinable'><ul><li id='schemaTab' class='active'><div class="iconTab schemaIcon"></div><div class="labelTab"><system:label show="text" label="flaOutline"/></div></li><li id='attsTab'><div class="iconTab attsIcon"></div><div class="labelTab"><system:label show="text" label="flaAtr"/></div></li><li id='propsTabMax' style="display:none"><div class="iconTab propsIcon"></div><div class="labelTab" style="margin-right:5px;"><system:label show="text" label="lblProps"/></div><div class="iconTab max-min-props-icon" id="minPropsTab"></div></li></ul></div><div class='tab-content-bg'><div class='tab-content tab-selectable' id='schemaTabContainer'><%@include file="gridSchema.jsp" %></div><div class='tab-content tab-selectable' id='attsTabContainer'><%@include file="attributes.jsp" %></div><div class='tab-content tab-selectable' id='propsTabMaxContainer'><%@include file="properties.jsp" %></div></div></div></div></div><div class="half-container" id="bottomOptsContainer"><div style="padding-top: 10px;height: 100%;box-sizing: border-box;"><div class='tab-container'><div class='tab-content-boxshadow'><div class='tabbed skin-wet-asphalt round' id='skinable'><ul><li id='propsTab' class='active'><div class="iconTab propsIcon"></div><div class="labelTab" style="margin-right:5px;"><system:label show="text" label="lblProps"/></div><div class="iconTab max-min-props-icon" id="maxPropsTab"></div></li></ul></div><div class='tab-content-bg'><div class='tab-content' style="display:block;"><%@include file="properties.jsp" %></div></div></div></div></div></div></div></body></html>			

