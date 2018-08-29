(function () {
  var Pos = CodeMirror.Pos;

  function forEach(arr, f) {
    for (var i = 0, e = arr.length; i < e; ++i) f(arr[i]);
  }

  function arrayContains(arr, item) {
    if (!Array.prototype.indexOf) {
      var i = arr.length;
      while (i--) {
        if (arr[i] === item) {
          return true;
        }
      }
      return false;
    }
    return arr.indexOf(item) != -1;
  }

  function scriptHint(editor, keywords, getToken, options) {
    // Find the token at the cursor
    var cur = editor.getCursor(), token = getToken(editor, cur), tprop = token;
    token.state = CodeMirror.innerMode(editor.getMode(), token.state).state;

    // If it's not a 'word-style' token, ignore the token.
    if (!/^[\w$_]*$/.test(token.string)) {
      token = tprop = {start: cur.ch, end: cur.ch, string: "", state: token.state,
                       type: token.string == "." ? "property" : null};
    }
    // If it is a property, find out what it is a property of.
    while (tprop.type == "property") {
      tprop = getToken(editor, Pos(cur.line, tprop.start));
      if (tprop.string != ".") return;
      tprop = getToken(editor, Pos(cur.line, tprop.start));
      if (tprop.string == ')') {
        var level = 1;
        do {
          tprop = getToken(editor, Pos(cur.line, tprop.start));
          switch (tprop.string) {
          case ')': level++; break;
          case '(': level--; break;
          default: break;
          }
        } while (level > 0);
        tprop = getToken(editor, Pos(cur.line, tprop.start));
        if (tprop.type.indexOf("variable") === 0)
          tprop.type = "function";
        //else return; // no clue
        else if(tprop.type.indexOf("property") !== 0) return; // no clue
      }
      if (!context) var context = [];
      context.push(tprop);
    }
    return {list: getCompletions(token, context, keywords, options),
            from: Pos(cur.line, token.start),
            to: Pos(cur.line, token.end)};
  }

  function apiaHint(editor, options) {
    return scriptHint(editor, javascriptKeywords,
                      function (e, cur) {return e.getTokenAt(cur);},
                      options);
  };
  CodeMirror.apiaHint = apiaHint; // deprecated
  CodeMirror.registerHelper("hint", "apia", apiaHint);

  function getCoffeeScriptToken(editor, cur) {
  // This getToken, it is for coffeescript, imitates the behavior of
  // getTokenAt method in javascript.js, that is, returning "property"
  // type and treat "." as indepenent token.
    var token = editor.getTokenAt(cur);
    if (cur.ch == token.start + 1 && token.string.charAt(0) == '.') {
      token.end = token.start;
      token.string = '.';
      token.type = "property";
    }
    else if (/^\.[\w$_]*$/.test(token.string)) {
      token.type = "property";
      token.start++;
      token.string = token.string.replace(/\./, '');
    }
    return token;
  }

  function coffeescriptHint(editor, options) {
    return scriptHint(editor, coffeescriptKeywords, getCoffeeScriptToken, options);
  }
  CodeMirror.coffeescriptHint = coffeescriptHint; // deprecated
  CodeMirror.registerHelper("hint", "coffeescript", coffeescriptHint);

  var stringProps = ("charAt charCodeAt indexOf lastIndexOf substring substr slice trim trimLeft trimRight " +
                     "toUpperCase toLowerCase split concat match replace search").split(" ");
  var arrayProps = ("length concat join splice push pop shift unshift slice reverse sort indexOf " +
                    "lastIndexOf every some filter forEach map reduce reduceRight ").split(" ");
  var funcProps = "prototype apply call bind".split(" ");
  var javascriptKeywords = ("break case catch continue debugger default delete do else false finally for function " +
                  "if in instanceof new null return switch throw true try typeof var void while with " +
                  "ApiaFunctions").split(" ");
  var coffeescriptKeywords = ("and break catch class continue delete do else extends false finally for " +
                  "if in instanceof isnt new no not null of off on or return switch then throw true try typeof until void while with yes").split(" ");

  function getCompletions(token, context, keywords, options) {
    var found = [], start = token.string;
    function maybeAdd(str) {
      if (str.indexOf(start) == 0 && !arrayContains(found, str)) found.push(str);
    }
    function gatherCompletions(obj, execute) {
      if (typeof obj == "string") forEach(stringProps, maybeAdd);
      else if (obj instanceof Array) forEach(arrayProps, maybeAdd);
      else if (obj instanceof Function && !execute) forEach(funcProps, maybeAdd);
      else if (obj instanceof Function && execute) obj = obj();
      for (var name in obj) maybeAdd(name);
    }

    if (context) {
      // If this is a property, see if it belongs to some object we can
      // find in the current environment.
      var execute = false;
      var obj = context.pop(), base;
      if(obj.string == "ApiaFunctions")
    	  execute = true;
      if (obj.type.indexOf("variable") === 0) {
        if (options && options.additionalContext)
          base = options.additionalContext[obj.string];
        base = base || window[obj.string];
      } else if (obj.type == "string") {
        base = "";
      } else if (obj.type == "atom") {
        base = 1;
      } else if (obj.type == "function") {
        if (window.jQuery != null && (obj.string == '$' || obj.string == 'jQuery') &&
            (typeof window.jQuery == 'function'))
          base = window.jQuery();
        else if (window._ != null && (obj.string == '_') && (typeof window._ == 'function'))
          base = window._();
      }
      while (base != null && context.length) {
    	if(execute && typeOf(base) == "function")
          base = base()[context.pop().string];
    	else
    	  base = base[context.pop().string];
      }
      if (base != null) gatherCompletions(base, execute);
    }
    else {
      // If not, just look in the window object and any local scope
      // (reading into JS mode internals to get at the local and global variables)
      for (var v = token.state.localVars; v; v = v.next) maybeAdd(v.name);
      for (var v = token.state.globalVars; v; v = v.next) maybeAdd(v.name);
      gatherCompletions(window);
      forEach(keywords, maybeAdd);
    }
    return found;
  }
})();

//Agregamos las clases a window para que puedan ser encontradas por los hint's
ApiaFunctions = {
	getEntityForm: {
		setProperty: {},
		getProperty: {},
		closeForm: {},
		openForm: {},
		clearForm: {},
		getField: {
			fldType: "",
			getForm: {},
			index: "",
			setProperty: {},
			getProperty: {},
			clearValue: {},
			getValue: {},
			setValue: {},
			getLabel: {},
			isInGrid: {}
		},
		getAllFields: [],
		getFieldColumn: [],
		getFormTitle: "",
		getFormName: ""
	},
	getProcessForm: {
		setProperty: {},
		getProperty: {},
		closeForm: {},
		openForm: {},
		clearForm: {},
		getField: {
			fldType: "",
			getForm: {},
			index: "",
			setProperty: {},
			getProperty: {},
			clearValue: {},
			getValue: {},
			setValue: {},
			getLabel: {},
			isInGrid: {}
		},
		getAllFields: [],
		getFieldColumn: [],
		getFormTitle: "",
		getFormName: ""
	},
	getForm: {
		setProperty: {},
		getProperty: {},
		closeForm: {},
		openForm: {},
		clearForm: {},
		getField: {
			fldType: "",
			getForm: {},
			index: "",
			setProperty: {},
			getProperty: {},
			clearValue: {},
			getValue: {},
			setValue: {},
			getLabel: {},
			isInGrid: {}
		},
		getAllFields: [],
		getFieldColumn: [],
		getFormTitle: "",
		getFormName: ""
	},
	getAllForms: [],
	getRootPath: "",
	getCurrentStep: "",
	changeTab: {},
	getTabTitle: "",
	getTabNumber: 0,
	getFormNamesInTab: [],
	getFormsInTab: [],
	getCurrentTaskName: "",
	toJSNumber: 0,
	toApiaNumber: "",
	getModalReturn: {},
	getModalValue: "",
	getModalShowValue: "",
	getModalSelectedRow: [],
	getDocPath: {},
	admEntity: {},
	disableActionButton: {},
	enableActionButton: {},
	hideActionButton: {},
	showActionButton: {},
	disableOptionButton: {},
	enableOptionButton: {},
	hideOptionButton: {},
	showOptionButton: {},
	openTab: {},
	closeTab: {}
};
ActionButton = {};
ActionButton.BTN_CONFIRM	 		= 0;
ActionButton.BTN_NEXT 				= 1;
ActionButton.BTN_PREV 				= 2;
ActionButton.BTN_SIGN 				= 3;
ActionButton.BTN_SAVE 				= 4;
ActionButton.BTN_RELEASE 			= 5;
ActionButton.BTN_DELEGATE 			= 6;
ActionButton.BTN_SHARE 				= 7;
OptionButton = {};
OptionButton.BTN_VIEW_DOCS	= 100;
OptionButton.BTN_PRINT		= 101;
IProperty = {};
IProperty.PROPERTY_NAME						= "";
IProperty.PROPERTY_SIZE						= "";
IProperty.PROPERTY_READONLY 				= "";
IProperty.PROPERTY_DISABLED 				= "";
IProperty.PROPERTY_FONT_COLOR 				= "";
IProperty.PROPERTY_VALUE 					= "";
IProperty.PROPERTY_REQUIRED 				= "";
IProperty.PROPERTY_COLSPAN 					= "";
IProperty.PROPERTY_ROWSPAN 					= "";
IProperty.PROPERTY_MODAL 					= "";
IProperty.PROPERTY_ROWS 					= "";
IProperty.PROPERTY_BOLD 					= "";
IProperty.PROPERTY_UNDERLINED 				= "";
IProperty.PROPERTY_ALIGNMENT 				= "";
IProperty.PROPERTY_IMAGE 					= "";
IProperty.PROPERTY_COL_WIDTH 				= "";
IProperty.PROPERTY_GRID_HEIGHT 				= "";
IProperty.PROPERTY_HIDE_GRID_BTN			= "";
IProperty.PROPERTY_VISIBILITY_HIDDEN		= "";
IProperty.PROPERTY_TRANSIENT 				= "";
IProperty.PROPERTY_GRID_TITLE 				= "";
IProperty.PROPERTY_TOOLTIP 					= "";
IProperty.PROPERTY_VALUE_COLOR 				= "";
IProperty.PROPERTY_GRID_FORM 				= "";
IProperty.PROPERTY_INPUT_AS_TEXT			= "";
IProperty.PROPERTY_NO_DOWNLOAD 				= "";
IProperty.PROPERTY_NO_ERASE					= "";
IProperty.PROPERTY_NO_LOCK 					= "";
IProperty.PROPERTY_NO_HISTORY 				= "";
IProperty.PROPERTY_NO_MODIFY 				= "";
IProperty.PROPERTY_HIDE_SIGN_ICONS 			= "";
IProperty.PROPERTY_URL 						= "";
IProperty.PROPERTY_GRID_HIDE_BTN_ORDER 		= "";
IProperty.PROPERTY_GRID_HIDE_BTN_INCLUDE	= "";
IProperty.PROPERTY_REGEXP_MESSAGE 			= "";
IProperty.PROPERTY_PAGED_GRID 				= "";
IProperty.PROPERTY_PAGED_GRID_SIZE 			= "";
IProperty.PROPERTY_GRID_ALTER_IN_LAST_PAGE 	= "";
IProperty.PROPERTY_GRID_PRINT_HORIZONTAL 	= "";
IProperty.PROPERTY_STORE_MODAL_QUERY_RESULT	= "";
IProperty.PROPERTY_INCLUDE_FIRST_ROW		= "";
IProperty.PROPERTY_MAX_REG_GRID 			= "";
IProperty.PROPERTY_GRID_LABEL				= "";
IProperty.PROPERTY_GRID_QUERY				= "";
IProperty.PROPERTY_HIDE_DOC_PERMISSIONS 	= "";
IProperty.PROPERTY_VERIFY_SIGNATURE_ONLY 	= "";
IProperty.PROPERTY_GRID_HIDE_BTN_ADD 		= "";
IProperty.PROPERTY_GRID_HIDE_BTN_DEL 		= "";
IProperty.PROPERTY_HIDE_DOC_UPLOAD 			= "";
IProperty.PROPERTY_HIDE_DOC_DOWNLOAD 		= "";
IProperty.PROPERTY_HIDE_DOC_ERASE 			= "";
IProperty.PROPERTY_HIDE_DOC_LOCK 			= "";
IProperty.PROPERTY_HIDE_DOC_HISTORY 		= "";
IProperty.PROPERTY_HIDE_DOC_SIGN 			= "";
IProperty.PROPERTY_DISPLAY_NONE 			= "";
IProperty.PROPERTY_DONT_BREAK_RADIO			= "";
IProperty.PROPERTY_CHECKED					= "";