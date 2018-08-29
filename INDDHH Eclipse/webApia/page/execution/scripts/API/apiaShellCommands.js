var ApiaShellCommand = {}

ApiaShellCommand.URL_API_REQUEST_AJAX = '/apia.design.ShellCommandsAction.run';

/************************************************/
/*****************  COMANDOS  *******************/
/************************************************/
ApiaShellCommand.commandNameCompleteTask = 'completeTask';
ApiaShellCommand.commandNameExecuteBussinessClass = 'execBusClass';
ApiaShellCommand.commandNameHelp = 'help';
ApiaShellCommand.commandNameList = 'list';
ApiaShellCommand.commandNameListAttribute = ApiaShellCommand.commandNameList + ApiaShellCommand.commandTokenSeparator + ApiaShellCommand.listTypeAttribute;
ApiaShellCommand.commandNameListBusinessClass = ApiaShellCommand.commandNameList + ApiaShellCommand.commandTokenSeparator + ApiaShellCommand.listTypeBusinessClass;
ApiaShellCommand.commandNameListEntity = ApiaShellCommand.commandNameList + ApiaShellCommand.commandTokenSeparator + ApiaShellCommand.listTypeEntity;
ApiaShellCommand.commandNameListProcess = ApiaShellCommand.commandNameList + ApiaShellCommand.commandTokenSeparator + ApiaShellCommand.listTypeProcess;
ApiaShellCommand.commandNameListQuery = ApiaShellCommand.commandNameList + ApiaShellCommand.commandTokenSeparator + ApiaShellCommand.listTypeQuery;
ApiaShellCommand.commandNameQuery = 'query';
ApiaShellCommand.commandNameStartProcess = 'startProcess';
ApiaShellCommand.commandNameWorkTask = 'workTask';

/**************************************************/
/*****************  LIST TYPES  *******************/
/**************************************************/
ApiaShellCommand.listTypeAttribute = 'attribute';
ApiaShellCommand.listTypeBusinessClass = 'busClass';
ApiaShellCommand.listTypeEntity = 'entity';
ApiaShellCommand.listTypeProcess = 'process';
ApiaShellCommand.listTypeQuery = 'query';

/**********************************************/
/*****************  OTHERS  *******************/
/**********************************************/

ApiaShellCommand.commandTokenSeparator = ' ';

/************************************************/
/******************  GENERICO  ******************/
/************************************************/
/**
 * Ejecuta el/los comando/s de 'command' 
 * 
 * Parameters:
 * 'command' (String): comando simple o multiples (separados por punto y coma ";") 
 * 
 * Return:
 * Array con los mensajes a mostrar. Realiza lo que corresponda en nuevos tabs
 */
ApiaShellCommand.executeCommand = function(command){
	var request = new Request({
		method: 'post',
		async: false,
		url: CONTEXT + ApiaShellCommand.URL_API_REQUEST_AJAX + '?action=executeCommand&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send("command=" + command);
};

/**
 * Genera la sintaxis de ejcucion de varios comandos de forma simultanea
 * 
 * Parameters:
 * 'arrCommands' (String[]): array de comandos simples o multiples (separados por punto y coma ";") 
 * 
 * Return:
 * Array con los mensajes a mostrar. Realiza lo que corresponda en nuevos tabs
 */
ApiaShellCommand.executeCommands = function(arrCommands){
	var commands = '';
	if (arrCommands && arrCommands.length > 0){
		for (var i = 0; i < arrCommands.length; i++){
			if (commands != '') commands += ';'
			commands += arrCommands[i];
		}
	}
	return ApiaShellCommand.executeCommand(commands);
}

/*******************************************************/
/******************  COMPLETAR TAREA  ******************/
/*******************************************************/
/**
 * Genera la sintaxis para el comando 'completeTask'
 * 
 * Parameters:
 * 'tskName' (String): Nombre de la tarea a completar 
 * 'proInstId' (Integer): Identificador de instancia de proceso
 * 'arrEntAtts' ({attName,attValue}[]): Array de Atributos de Entidad (opcional)
 * 'arrProAtts' ({attName,attValue}[]): Array de Atributos de Proceso (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandCompleteTask = function(tskName, proInstId, arrEntAtts, arrProAtts){
	var command = ApiaShellCommand.commandNameCompleteTask + ApiaShellCommand.commandTokenSeparator
					+ tskName + ApiaShellCommand.commandTokenSeparator
					+ proInstId;
	if (arrEntAtts && arrEntAtts.length){
		command += ApiaShellCommand.commandTokenSeparator + '-eatt';
		for (var i = 0; i < arrEntAtts.length; i++){
			command += ApiaShellCommand.commandTokenSeparator + traslateKeyValue(arrEntAtts[i]);
		}
	}
	if (arrProAtts && arrProAtts.length){
		command += ApiaShellCommand.commandTokenSeparator + '-patt';
		for (var i = 0; i < arrProAtts.length; i++){
			command += ApiaShellCommand.commandTokenSeparator + traslateKeyValue(arrProAtts[i]);
		}
	}
	return command;
}

/**
 * Genera el comando 'completeTask' y lo ejecuta
 * 
 * Parameters:
 * 'tskName' (String): Nombre de la tarea a completar 
 * 'proInstId' (Integer): Identificador de instancia de proceso
 * 'arrEntAtts' ({attName,attValue}[]): Array de Atributos de Entidad (opcional)
 * 'arrProAtts' ({attName,attValue}[]): Array de Atributos de Proceso (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 * 
 */
ApiaShellCommand.executeCommandCompleteTask = function(tskName, proInstId, arrEntAtts, arrProAtts){
	var command = ApiaShellCommand.generateCommandCompleteTask(tskName, proInstId, arrEntAtts, arrProAtts);
	ApiaShellCommand.executeCommand(command);
}

/**
 * Genera la sintaxis para la ayuda del comando 'completeTask' 
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandCompleteTaskHelp = function() {
	return ApiaShellCommand.commandNameCompleteTask + ApiaShellCommand.commandTokenSeparator + '-h';
};

/**
 * Genera la ayuda para el comando 'completeTask' y lo ejecuta 
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandCompleteTaskHelp = function() {
	var command = ApiaShellCommand.generateCommandCompleteTaskHelp();
	ApiaShellCommand.executeCommand(command);
};

/*****************************************************************/
/******************  EJECUTAR CLASE DE NEGOCIO  ******************/
/*****************************************************************/
/**
 * Genera la sintaxis para el comando 'execBusClass'
 * 
 * Parameters:
 * 'busClassName' (String): Nombre de la clase negocio a ejecutar 
 * 'parameters' ({paramName,paramValue}[]): Array de Parametros de entrada de la clase de negocio (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandBusinessClass = function(busClassName, parameters){
	var command = ApiaShellCommand.commandNameExecuteBussinessClass + ApiaShellCommand.commandTokenSeparator
					+ busClassName;
	if (parameters && parameters.length){
		command += ApiaShellCommand.commandTokenSeparator + '-params';
		for (var i = 0; i < parameters.length; i++){
			command += ApiaShellCommand.commandTokenSeparator + traslateKeyValue(parameters[i]);
		}
	}
	return command;
}

/**
 * Genera el comando 'execBusClass' y lo ejecuta
 * 
 * Parameters:
 * 'busClassName' (String): Nombre de la clase negocio a ejecutar 
 * 'parameters' ({paramName,paramValue}[]): Array de Parametros de entrada de la clase de negocio (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandBusinessClass = function(busClassName, parameters){
	var command = ApiaShellCommand.generateCommandBusinessClass(busClassName,parameters);
	ApiaShellCommand.executeCommand(command);
}

/**
 * Genera la sintaxis para la ayuda del comando 'execBusClass' 
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandBusinessClassHelp = function() {
	return ApiaShellCommand.commandNameExecuteBussinessClass + ApiaShellCommand.commandTokenSeparator + '-h';
};

/**
 * Genera la ayuda para el 'execBusClass' y lo ejecuta 
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandBusinessClassHelp = function() {
	var command = ApiaShellCommand.generateCommandBusinessClassHelp();
	ApiaShellCommand.executeCommand(command);
};

/*********************************************/
/******************  AYUDA  ******************/
/*********************************************/
/**
 * Genera la sintaxis para el comando 'help' 
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandHelp = function() {
	return ApiaShellCommand.commandNameHelp;
};

/**
 * Genera la sintaxis para el comando 'help' y lo ejecuta 
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandHelp = function() {
	var command = ApiaShellCommand.generateCommandHelp();
	ApiaShellCommand.executeCommand(command);
};

/**********************************************/
/******************  LISTAR  ******************/
/**********************************************/
/**
 * Genera la sintaxis para el comando 'list'
 * 
 * Parameters:
 * 'type' (String): Indica el tipo de listado 
 * 'name' (String): Nombre del objeto a listar sus propiedades (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandList = function(type, name){
	var command = ApiaShellCommand.commandNameList + ApiaShellCommand.commandTokenSeparator + type;
	if (name && name != ''){
		command += ApiaShellCommand.commandTokenSeparator + name;
	}
	return command;
}

/**
 * Genera la sintaxis para el comando 'list' y lo ejecuta
 * 
 * Parameters:
 * 'type' (String): Indica el tipo de listado 
 * 'name' (String): Nombre del objeto a listar sus propiedades (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandList = function(type, name){
	var command = ApiaShellCommand.generateCommandList(type, name);
	ApiaShellCommand.executeCommand(command);
}

/**
 * Genera la sintaxis para el comando 'list' tipo 'query'
 * 
 * Parameters:
 * 'qryName' (String): Nombre de la consulta a listar sus propiedades (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandListQuery = function(qryName){
	return ApiaShellCommand.generateCommandList(ApiaShellCommand.listTypeQuery,qryName);
}

/**
 * Genera la sintaxis para el comando 'list' tipo 'query' y lo ejecuta
 * 
 * Parameters:
 * 'qryName' (String): Nombre de la consulta a listar sus propiedades (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandListQuery = function(qryName){
	ApiaShellCommand.executeCommandList(ApiaShellCommand.listTypeQuery,qryName);
}

/**
 * Genera la sintaxis para el comando 'list' tipo 'busClass'
 * 
 * Parameters:
 * 'busClassName' (String): Nombre de la clase de negocio a listar sus propiedades (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandListBusClass = function(busClassName){
	return ApiaShellCommand.generateCommandList(ApiaShellCommand.listTypeBusinessClass,busClassName);
}

/**
 * Genera la sintaxis para el comando 'list' tipo 'busClass' y lo ejecuta
 * 
 * Parameters:
 * 'busClassName' (String): Nombre de la clase de negocio a listar sus propiedades (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandListBusClass = function(busClassName){
	ApiaShellCommand.executeCommandList(ApiaShellCommand.listTypeBusinessClass,busClassName);
}

/**
 * Genera la sintaxis para el comando 'list' tipo 'process'
 * 
 * Parameters:
 * 'proName' (String): Nombre de la clase de negocio a listar sus propiedades (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandListProcess = function(proName){
	return ApiaShellCommand.generateCommandList(ApiaShellCommand.listTypeListProcess,proName);
}

/**
 * Genera la sintaxis para el comando 'list' tipo 'process' y lo ejecuta
 * 
 * Parameters:
 * 'proName' (String): Nombre de la clase de negocio a listar sus propiedades (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandListProcess = function(proName){
	ApiaShellCommand.executeCommandList(ApiaShellCommand.listTypeProcess,proName);
}

/**
 * Genera la sintaxis para el comando 'list' tipo 'attribute'
 * 
 * Parameters:
 * 'attName' (String): Nombre del atributo a listar sus propiedades (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandListAttribute = function(attName){
	return ApiaShellCommand.generateCommandList(ApiaShellCommand.listTypeAttribute,attName);
}

/**
 * Genera la sintaxis para el comando 'list' tipo 'attribute' y lo ejecuta
 * 
 * Parameters:
 * 'attName' (String): Nombre del atributo a listar sus propiedades (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandListAttribute = function(attName){
	ApiaShellCommand.executeCommandList(ApiaShellCommand.listTypeAttribute,attName);
}

/**
 * Genera la sintaxis para el comando 'list' tipo 'entity'
 * 
 * Parameters:
 * 'entName' (String): Nombre de la entidad a listar sus propiedades (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandListEntity = function(entName){
	return ApiaShellCommand.generateCommandList(ApiaShellCommand.listTypeEntity,entName);
}

/**
 * Genera la sintaxis para el comando 'list' tipo 'entity' y lo ejecuta
 * 
 * Parameters:
 * 'entName' (String): Nombre de la entidad a listar sus propiedades (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandListEntity = function(entName){
	ApiaShellCommand.executeCommandList(ApiaShellCommand.listTypeEntity,entName);
}

/**
 * Genera la sintaxis para la ayuda del comando 'list' 
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandListHelp = function() {
	return ApiaShellCommand.commandNameList + ApiaShellCommand.commandTokenSeparator + '-h';
};

/**
 * Genera la sintaxis para la ayuda del comando 'list' 
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandListHelp = function() {
	var command = ApiaShellCommand.generateCommandListHelp();
	ApiaShellCommand.executeCommand(command);
};

/*********************************************************/
/******************  EJECUTAR CONSULTA  ******************/
/*********************************************************/
/**
 * Genera la sintaxis para el comando 'query'
 * 
 * Parameters:
 * 'qryName' (String): Nombre de la consulta a ejecutar 
 * 'max' (Integer): Cantidad maxima de resultados a obtener (opcional)
 * 'arrFilters' ({filterName,filterValue}[]): Array de Filtros de la consulta (opcional)
 * 'open' (boolean): Indica si la consulta se debe abrir en nuevo tab (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandQuery = function(qryName, max, arrFilters, open){
	var command = ApiaShellCommand.commandNameQuery + ApiaShellCommand.commandTokenSeparator
					+ qryName;
	if (max && max != ''){
		command += ApiaShellCommand.commandTokenSeparator + '-max' + ApiaShellCommand.commandTokenSeparator + max;
	}
	if (arrFilters && arrFilters.length){
		command += ApiaShellCommand.commandTokenSeparator + '-filters';
		for (var i = 0; i < arrFilters.length; i++){
			command += ApiaShellCommand.commandTokenSeparator + traslateKeyValue(arrFilters[i]);
		}
	}
	if (open){
		command += ApiaShellCommand.commandTokenSeparator + '-open';
	}
	return command;
}

/**
 * Genera la sintaxis para el comando 'query' y lo ejecuta
 * 
 * Parameters:
 * 'qryName' (String): Nombre de la consulta a ejecutar 
 * 'max' (Integer): Cantidad maxima de resultados a obtener (opcional)
 * 'arrFilters' ({filterName,filterValue}[]): Array de Filtros de la consulta (opcional)
 * 'open' (boolean): Indica si la consulta se debe abrir en nuevo tab (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandQuery = function(qryName, max, arrFilters, open){
	var command = ApiaShellCommand.generateCommandQuery(qryName, max, arrFilters, open);
	ApiaShellCommand.executeCommand(command);
}

/**
 * Genera la sintaxis para la ayuda del comando 'query' 
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandQueryHelp = function() {
	return ApiaShellCommand.commandNameQuery + ApiaShellCommand.commandTokenSeparator + '-h';
};

/**
 * Genera la sintaxis para la ayuda del comando 'query' y lo ejecuta
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandQueryHelp = function() {
	var command = ApiaShellCommand.generateCommandQueryHelp();
	ApiaShellCommand.executeCommand(command);
};

/*******************************************************/
/******************  INICIAR PROCESO  ******************/
/*******************************************************/
/**
 * Genera la sintaxis para el comando 'startProcess'
 * 
 * Parameters:
 * 'proName' (String): Nombre del proceso 
 * 'busEntInstNum' (Integer): Identificador de la instancia de entidad (opcional)
 * 'proInstNum' (Integer): Identificador de la instancia de proceso (opcional)
 * 'arrAttributes' ({attName,attValue}[]): Array de Atributos de Entidad (opcional)
 * 'open' (boolean): Indica si la consulta se debe abrir en nuevo tab (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandStartProcess = function(proName, busEntInstNum, proInstNum, arrAttributes, open){
	var command = ApiaShellCommand.commandNameStartProcess + ApiaShellCommand.commandTokenSeparator
					+ proName;
	if (busEntInstNum && busEntInstNum != ''){
		command += ApiaShellCommand.commandTokenSeparator + '-busEntInstNum' + ApiaShellCommand.commandTokenSeparator + busEntInstNum;
	}
	if (proInstNum && proInstNum != ''){
		command += ApiaShellCommand.commandTokenSeparator + '-proInstNum' + ApiaShellCommand.commandTokenSeparator + proInstNum;
	}
	if (arrAttributes && arrAttributes.length){
		command += ApiaShellCommand.commandTokenSeparator + '-att';
		for (var i = 0; i < arrAttributes.length; i++){
			command += ApiaShellCommand.commandTokenSeparator + traslateKeyValue(arrAttributes[i]);
		}
	}
	if (open){
		command += ApiaShellCommand.commandTokenSeparator + '-open';
	}
	return command;
}

/**
 * Genera la sintaxis para el comando 'startProcess' y lo ejecuta
 * 
 * Parameters:
 * 'proName' (String): Nombre del proceso 
 * 'busEntInstNum' (Integer): Identificador de la instancia de entidad (opcional)
 * 'proInstNum' (Integer): Identificador de la instancia de proceso (opcional)
 * 'arrAttributes' ({attName,attValue}[]): Array de Atributos de Entidad (opcional)
 * 'open' (boolean): Indica si la consulta se debe abrir en nuevo tab (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandStartProcess = function(proName, busEntInstNum, proInstNum, arrAttributes, open){
	var command = ApiaShellCommand.generateCommandStartProcess(proName, busEntInstNum, proInstNum, arrAttributes, open);
	ApiaShellCommand.executeCommand(command);
}

/**
 * Genera la sintaxis para la ayuda del comando 'startProcess' 
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandStartProcessHelp = function() {
	return ApiaShellCommand.commandNameStartProcess + ApiaShellCommand.commandTokenSeparator + '-h';
};

/**
 * Genera la sintaxis para la ayuda del comando 'startProcess' y lo ejecuta 
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandStartProcessHelp = function() {
	var command = ApiaShellCommand.generateCommandStartProcessHelp();
	ApiaShellCommand.executeCommand(command);
};

/******************************************************/
/******************  TRABAJAR TAREA  ******************/
/******************************************************/
/**
 * Genera la sintaxis para el comando 'workTask'
 * 
 * Parameters:
 * 'tskName' (String): Nombre de la tarea 
 * 'arrEntAttributes' ({attName,attValue}[]): Array de Atributos de Entidad (opcional)
 * 'arrProtAttributes' ({attName,attValue}[]): Array de Atributos de Proceso (opcional)
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandWorkTask = function(tskName, arrEntAttributes, arrProtAttributes){
	var command = ApiaShellCommand.commandNameWorkTask + ApiaShellCommand.commandTokenSeparator
					+ tskName;
	if (arrEntAttributes && arrEntAttributes.length){
		command += ApiaShellCommand.commandTokenSeparator + '-eatt';
		for (var i = 0; i < arrEntAttributes.length; i++){
			command += ApiaShellCommand.commandTokenSeparator + traslateKeyValue(arrEntAttributes[i]);
		}
	}
	if (arrProtAttributes && arrProtAttributes.length){
		command += ApiaShellCommand.commandTokenSeparator + '-patt';
		for (var i = 0; i < arrProtAttributes.length; i++){
			command += ApiaShellCommand.commandTokenSeparator + traslateKeyValue(arrProtAttributes[i]);
		}
	}
	return command;
}

/**
 * Genera la sintaxis para el comando 'workTask' y lo ejecuta
 * 
 * Parameters:
 * 'tskName' (String): Nombre de la tarea 
 * 'arrEntAttributes' ({attName,attValue}[]): Array de Atributos de Entidad (opcional)
 * 'arrProtAttributes' ({attName,attValue}[]): Array de Atributos de Proceso (opcional)
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandWorkTask = function(tskName, arrEntAttributes, arrProtAttributes){
	var command = ApiaShellCommand.generateCommandWorkTask(tskName, arrEntAttributes, arrProtAttributes);
	ApiaShellCommand.executeCommand(command);
}

/**
 * Genera la sintaxis para la ayuda del comando 'workTask' 
 * 
 * Return:
 * String con la sintaxis del comando para ejecutar
 */
ApiaShellCommand.generateCommandWorkTaskHelp = function() {
	return ApiaShellCommand.commandNameWorkTask + ApiaShellCommand.commandTokenSeparator + '-h';
};

/**
 * Genera la sintaxis para la ayuda del comando 'workTask' y lo ejecuta 
 * 
 * El resultado de la ejecución es cargado en el contenedor
 */
ApiaShellCommand.executeCommandWorkTaskHelp = function() {
	var command = ApiaShellCommand.generateCommandWorkTaskHelp();
	ApiaShellCommand.executeCommand(command);
};

/***********************************************************/
/******************  PROCESAR RESPUESTAS  ******************/
/***********************************************************/
/**
 * Formato de XML de respuesta recibido:
 * 
 * <result>
 *	<ShellCommandResponse>
 *		<CommandResponse>
 *			<ShowLines>
 *				<Line></Line>
 *				<Line></Line>
 *				...
 *				<Line></Line>
 *			</ShowLines>
 *			<Open url='' title=''></Open>
 *		</CommandResponse>
 *		...
 *		<CommandResponse>
 * 			...
 *		</CommandResponse>
 *	</ShellCommandResponse>
 * </result>
 * 
 * Agrega al contenedor de respuestas las lineas a mostrar en consola para cada comando.
 * Abre los tabs que correspondan.
 * 
 */
function processXMLShellCommandsResponse(){
	SYS_PANELS.closeAll();
	var ret = new Array();
	var ajaxCallXml = getLastFunctionAjaxCall();
	var result = ajaxCallXml.getElementsByTagName("result"); //tag: result
	var shellCommandResponse = result != null && result.length > 0 ? result[0].getElementsByTagName("ShellCommandResponse") : null; //tag: ShellCommandResponse
	if (shellCommandResponse && shellCommandResponse.length > 0){
		var arrCommandRespose = shellCommandResponse[0].getElementsByTagName("CommandResponse"); //tag: CommandResponse
		for (var i = 0; i < arrCommandRespose.length; i++){
			var commandResponse = arrCommandRespose[i]; //tag: CommandResponse
			
			var hashResponse = {
					'command': '',
					'result': null,
					'sintax': ''
			};
			
			var sintax = commandResponse.getAttribute('execution'); 
			if (sintax) {
				hashResponse.sintax = sintax;
			}
			
			var command = commandResponse.getElementsByTagName("Command");
			if (command != null && command.length > 0){
				command = command[0];
				hashResponse.command = command.textContent;
			}
			
			var showLines = commandResponse.getElementsByTagName("ShowLines"); //tag: ShowLines
			if (showLines && showLines.length > 0){
				//tiene lines a mostrar en consola
				var lines = showLines[0].getElementsByTagName("Line"); //tag: Line
				if (lines && lines.length > 0){
					var commLines = new Array();
					for (var l = 0; l < lines.length; l++){
						commLines.push(lines[l].textContent);
					}
					hashResponse.result = commLines;
				}
			}
			
			var open = commandResponse.getElementsByTagName("Open"); //tag: Open
			if (open && open.length > 0){
				open = open[0];
				var urlOpen = open.getAttribute("url");
				var urlTitle = open.getAttribute("title");
				if (urlOpen && urlOpen != ""){
//					alert("open: title=" + urlTitle + " // url=" + urlOpen);
					
					var TAB_CONTAINER = document.getElementById("tabContainer");
					if (TAB_CONTAINER == null && window.parent != null && window.parent.document != null){
						//iframe
						TAB_CONTAINER = window.parent.document.getElementById("tabContainer");
					}
					if (TAB_CONTAINER == null) {
						TAB_CONTAINER = new Object();
						TAB_CONTAINER.addNewTab = function(name, url) {
							showMessage(Generic.formatMsg(ERR_OPEN_URL, name, url));
						}
					} else {
						TAB_CONTAINER.addNewTab(urlTitle, urlOpen + TAB_ID_REQUEST, null);
					}
				}
			}
			ret.push(hashResponse);
		}
	}
	
	ApiaShellCommand.addResult(ret);
}

/*************************************************************/
/*****************  CONTENEDOR RESPUESTAS  *******************/
/*************************************************************/
/**
 * Formato:
 * 
 * [{command : '', result : [line1, line2, ..., lineN] }, {command : '', result : [line1, line2, ..., lineN] }, ... ]
 * 
 */
ApiaShellCommand.resultContainer = null;

/**
 * Añade las respuetas del último comando ejecutado.
 * 
 * Parameters:
 * 'response' (Array<{String,Array<String>}>): Array de string que representan las lineas a mostrar
 * 
 */
ApiaShellCommand.addResult = function(response){
	if (ApiaShellCommand.resultContainer == null){
		ApiaShellCommand.resultContainer = new Array();
	}
	if (response && response.length > 0){
		for (var i = 0; i < response.length; i++){
			ApiaShellCommand.resultContainer.push(response[i]);
		}
	}
}

/**
 * Retorna el contenedor de respuestas actual.
 */
ApiaShellCommand.getResultContainer = function(){
	return ApiaShellCommand.resultContainer;
}

/**
 * Inicializa el contenedor de respuetas.
 */
ApiaShellCommand.cleanResultContainer = function(){
	ApiaShellCommand.resultContainer = null;
}

/************************************************/
/******************  AUXILIAR  ******************/
/************************************************/
function traslateKeyValue(keyValue){
	var ret = '';
	if (keyValue){
		ret += keyValue[0].toUpper(); //clave
		ret += '"';
		ret += keyValue[1]; //valor 
		ret += '"';
	}
}


