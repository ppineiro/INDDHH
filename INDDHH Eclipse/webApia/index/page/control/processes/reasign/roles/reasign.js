
var spModalReaRols;
var allRoles;

function initReasignRolesMdlPage(){
	var mdlReasignRolesContainer = $('mdlReasignRolesContainer');
	if (mdlReasignRolesContainer.initDone) return;
	mdlReasignRolesContainer.initDone = true;

	mdlReasignRolesContainer.blockerModal = new Mask();
	
	spModalReaRols = new Spinner($('mdlBodyReasignRoles'),{message:WAIT_A_SECOND});
	
	$('mdlBodyReasignRoles').formChecker = new FormCheck(
		'mdlBodyReasignRoles',
		{
			submit:false,
			display : {
				keepFocusOnError : 1,
				tipsPosition: 'left',
				tipsOffsetX: -10
			}
		}
	);
	
	$('closeReasignRolesModal').addEvent("click", function(e) {
		e.stop();
		closeReasignRolesModal();
	});
	
	$('btnConfirmReasignRolesModal').addEvent('click', function(evt){
		if (!$('mdlBodyReasignRoles').formChecker.isFormValid()){
			return;
		}
		
		if (!uniqueMapping()){
			showMessage(MSG_NO_UNIQUE_MAPPING, GNR_TIT_WARNING, 'modalWarning');
			return;
		}
		
		var strRoles = ""; //format: rolId�poolId�index;rolId�poolId�index...
		$('tableDataRoles').getElements("tr").each(function (trRol){
			if (strRoles != "") strRoles += ";";
			strRoles += trRol.getRowContentStr();
		});
		
		if(PRIMARY_SEPARATOR_IN_BODY) {
			new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=setRoles&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { SYS_PANELS.closeLoading(); modalProcessXml(resXml); }
			}).send('roles=' + strRoles);	
		} else {
			new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=setRoles&isAjax=true&roles=' + strRoles + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { SYS_PANELS.closeLoading(); modalProcessXml(resXml); }
			}).send();	
		}
					
	});
	
	$('btnAdd').addEvent("click",function(e){
		e.stop();
		createTrRole("","","","");
		fixTable($('tableDataRoles'));
	});
	
	$('btnDelete').addEvent("click",function(e){
		e.stop();
		if (selectionCount($('tableDataRoles')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			getSelectedRows($('tableDataRoles')).each(processTrDelete);
			fixTable($('tableDataRoles'));
		}
	});
	
	allRoles = new Array();
}

function showReasignRolesModal(proInstId){   
	var mdlReasignRolesContainer = $('mdlReasignRolesContainer');
	mdlReasignRolesContainer.removeClass('hiddenModal');
	mdlReasignRolesContainer.position();
	mdlReasignRolesContainer.blockerModal.show();
	mdlReasignRolesContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlReasignRolesContainer.proInstId = proInstId;	
	
	spModalReaRols.show(true);
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadProInst&isAjax=true&id=' + proInstId + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { setModal(resXml); spModalReaRols.hide(true); }
	}).send();
}

function setModal(resXml){
	var tableDataRoles = $('tableDataRoles');
	tableDataRoles.getElements("tr").each(processTrDelete);
	
	allRoles = new Array();
	
	var result = resXml.getElementsByTagName("result")
	if (result != null && result.length > 0 && result.item(0) != null) {
		var genData = result.item(0).getElementsByTagName("genData").item(0);
		var roles = result.item(0).getElementsByTagName("roles");
		var maping = result.item(0).getElementsByTagName("mapping");
		
		//Datos generales
		$('proTit').innerHTML = genData.getAttribute("title");
		$('regInst').innerHTML = genData.getAttribute("regInst");
		$('proAction').innerHTML = genData.getAttribute("action");
		$('creDte').innerHTML = genData.getAttribute("createDate");
		$('priority').innerHTML = genData.getAttribute("priority");
		
		
		//Todos los roles
		if (roles != null && roles.length > 0 && roles.item(0) != null) {
			roles = roles.item(0).getElementsByTagName("role");
			
			for (var i = 0; i < roles.length; i++){
				var xmlRole = roles[i];
				var roleId = xmlRole.getAttribute("roleId");
				var roleName = xmlRole.getAttribute("roleName");
				allRoles.push({'roleId':roleId, 'roleName': roleName});
			}
		}
		
		//Maping
		if (maping != null && maping.length > 0 && maping.item(0) != null) {
			maping = maping.item(0).getElementsByTagName("role");
			
			for (var i = 0; i < maping.length; i++){
				var xmlRole = maping[i];
				var roleId = xmlRole.getAttribute("roleId");
				var poolId = xmlRole.getAttribute("poolId");
				var poolName = xmlRole.getAttribute("poolName");
				var index = xmlRole.getAttribute("index");
				createTrRole(roleId,poolId,poolName,index);
			}
		}
	}
	fixTable(tableDataRoles);
}

function createTrRole(roleId,poolId,poolName,index){	
	var tr = new Element("tr",{'class':'selectableTR'}).inject($('tableDataRoles'));
	tr.addEvent("click",function(e){ this.toggleClass("selectedTR"); });
					
	//td1 ROL
	var td1 = new Element("td", {'align':'center'}).inject(tr);
	var div1 = new Element('div', {styles: {width: '180px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
	var selectRole = new Element('select',{'class':"validate['required']",styles:{width:'95%'}}).inject(div1);
	var option = new Option("","");
	option.inject(selectRole);
	for (var i = 0; i < allRoles.length; i++){
		option = new Option(allRoles[i].roleName,allRoles[i].roleId);
		option.inject(selectRole);
		if (roleId == allRoles[i].roleId){
			selectRole.selectedIndex = i+1;
		}
	}
	selectRole.value = roleId;
	$('mdlBodyReasignRoles').formChecker.register(selectRole);
	
	//td2 POOL
	var td2 = new Element("td", {'align':'center'}).inject(tr);
	var div2 = new Element('div', {styles: {width: '180px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
	var inputPoolName = new Element("input",{'type':'text','class':"validate['required'] autocomplete",'value':poolName,styles:{width:'95%'}}).inject(div2); 
	var inputPoolId = new Element("input",{'type':'hidden','value':poolId}).inject(div2);
	inputPoolName.poolId = inputPoolId;
	$('mdlBodyReasignRoles').formChecker.register(inputPoolName);
	addPoolBehavior(inputPoolName);
	
	//td3 INDEX
	var td3 = new Element("td", {'align':'center'}).inject(tr);
	var div3 = new Element('div', {styles: {width: '50px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
	var inputIndex = new Element('input',{'type':'text','value':index, 'class': "validate['required']",styles:{width:'95%'}}).inject(div3);
	inputIndex.addEvent("keypress",function(e){
		if (e.key < '0' || e.key > '9'){
			if (e.key != "delete" && e.key != "tab" && e.key != "backspace" && e.key != "left" && e.key != "right"){
				e.stop();
			}
		} 
	});
	$('mdlBodyReasignRoles').formChecker.register(inputIndex);
			
	tr.getRowContentStr = function (){ //format: rolId�poolId�index
		var tds = this.getElements("td");
		var rolId = tds[0].getElement("div").getElement("select").value;
		var poolId = tds[1].getElement("div").getElements("input")[1].value;
		var index = tds[2].getElement("div").getElement("input").value;
		var ret = rolId + PRIMARY_SEPARATOR + poolId + PRIMARY_SEPARATOR + index;		
		return ret;
	}
}

function addPoolBehavior(inputPoolName){
	var extraSQL = " and (pool_all_envs = 1 or pool_id_auto in (select pool_id from env_pool where env_id = ?))"
	extraSQL = extraSQL.replace("?",ENV_ID);
	setAutoCompleteGeneric(inputPoolName, inputPoolName.poolId, 'search', 'pool', 'pool_name', 'pool_id_auto', 'pool_name', false, true, false, true, "", null, extraSQL);
	inputPoolName.addEvent('optionNotSelected', function(evt) {
		this.value = "";
		this.poolId.value = "";
	});
	inputPoolName.addEvent('optionSelected', function(evt) {
		
	});
}

function processTrDelete(tr){
	var tds = tr.getElements("td");
	$('mdlBodyReasignRoles').formChecker.dispose(tds[0].getElement("div").getElement("select"));
	$('mdlBodyReasignRoles').formChecker.dispose(tds[1].getElement("div").getElement("input"));
	$('mdlBodyReasignRoles').formChecker.dispose(tds[2].getElement("div").getElement("input"));
	tr.destroy();	
}

function fixTable(table){
	var trs = table.getElements("tr");
	for (var i = 0; i < trs.length; i++){
		var tr = trs[i];
		if (i % 2 == 0) tr.addClass("trOdd"); else tr.removeClass("trOdd");
		if (i == trs.length-1) tr.addClass("lastTr"); else tr.removeClass("lastTr");		
	}
	addScrollTable(table);
}

function closeReasignRolesModal(){
	var mdlReasignRolesContainer = $('mdlReasignRolesContainer');
    mdlReasignRolesContainer.addClass('hiddenModal');
    mdlReasignRolesContainer.blockerModal.hide();	    
}

function uniqueMapping(){
	var unique = true;
	var allReg = new Array();
	var trs = $('tableDataRoles').getElements("tr");
	for (var i = 0; i < trs.length && unique; i++){
		var strContent = trs[i].getRowContentStr().toUpperCase();
		if (arrayContain(allReg, strContent)){
			unique = false;
		}
		allReg[allReg.length] = strContent;
	}
	
	return unique;
}

function arrayContain(array,element){
	var contain = false;
	if (array != null && array.length > 0){
		var i = 0;
		while (i < array.length && !contain){
			contain = (array[i] == element);
			i++;
		}
	}
	return contain;	
}

