			/* RESET - START */
			body,td,pre,textarea,input,select		{ font-family: verdana; font-size: 10px; margin: 0px; }
			th			{ font-family: verdana; font-size: 10px; font-weight: normal;} 
			/* RESET - END */
			
			/* FIXES  - START */
			.removeMootoolsCenterPosition { position: inherit !important; top: inherit !important; left: inherit !important;}
			/* FIXES  - END */
			
			/* Generic style - START */
			
			.block { background-color: #D3D3D3; font-weight: bold; height: 100%; left: 0; line-height: 276px; opacity: 0.5; position: fixed; text-align: center; top: 0; vertical-align: middle; width: 100%; z-index: 100; }
			.right { float: right; }
			.hidden { display: none !important; }
			.disclaimer { font-size: 9px; color: gray; text-align: center;}
			a:visited, a:active, a:link { text-decoration: none; color: black; font-weight: bold; }
			.ieWarning { color: red; font-weight: bold; text-align: center; }

			div.field { margin-bottom: 2px; margin-right: 3px;}
			div.field span { display: inline-block; margin-right: 3px; }
			div.field input[type=submit] {margin-left: 3px;}
			
			form div.field span { width: 60px; }

			div.mainHeader { padding: 5px 5px 2px; margin-bottom: 2px; border-bottom: 1px solid black; position: fixed; top: 0; width: 99%; background-color: white; }
			div.mainHeader div.field { display: inline !important; }
			
			/* Generic style - END */
			
			/* Generic windows - START */
			
			.windowExtended { display: inherit !important; width: 99% !important; height: 350px !important;}
			.windowMaximized { background-color: grey; width: 100% !important; height: 100% !important; position: fixed; margin: 0px !important; border: none !important; top: 0; left: 0;}
			.windowMaximized .windowContent { background-color: white; width: 92%; height: 80%;}
			
			.windowHelp { z-index: 1000; }
			.windowHelp .windowContent { height: 88% !important; width: 95% !important; }
			.windowHelp .windowContent .content { overflow: auto; }
			.windowHelp .windowContent .contentHelp { padding-left: 10px; }
			.windowHelp .windowContent .content  table td{ vertical-align: top; }
			.window { border: 1px solid #D3D3D3; display: inline-block; height: 250px; margin-left: 5px; margin-top: 5px; width: 32%; }
			.window div.header { border-bottom: 1px solid #D3D3D3; padding: 4px 2px; background-color: #DDDDDD; }
			.window div.header h3 { display: inline; }
			.window .content { width: 100%; height: 89%; border: 0px; }
			.window .buttons { float: right; margin-right: 5px; text-align: right; }
			
			.buttons .button { display: inline-block; cursor: pointer; margin-left: 3px; }
			.buttons .buttonReload {}
			.buttons .buttonExpand {}
			.buttons .buttonMaximize {}
			.buttons .buttonClose {}
			.buttons .buttonCompress { display: none;}
			.buttons .buttonMinimize { display: none;}
			
			.windowExtended .buttons .buttonExpand { display: none !important;}
			.windowExtended .buttons .buttonCompress { display: inline !important;}
			.windowMaximized .buttons .buttonExpand { display: none !important;}
			.windowMaximized .buttons .buttonCompress { display: none !important;}
			.windowMaximized .buttons .buttonMaximize { display: none !important; }
			.windowMaximized .buttons .buttonMinimize { display: inline !important; }
			.windowMaximized .content { height: 93%; }
			
			.getStarted { text-align: center; padding-top: 40px; }
			
			/* Generic windows - END */

			.workarea { margin-top: 35px; }
			
			<% if (! _logged)  { %>
				/* Estilo visual de no logeado - START */
				.ieWarningLogin { float: right; position: absolute; left: 200px; top: 39px; }
				
				.tdCellLeft { vertical-align: top; }
				.tdCellRight { padding-bottom: 10px; vertical-align: bottom; width: 300px; }
				
				/* Estilo visual de no logeado - END */
			<% } %>