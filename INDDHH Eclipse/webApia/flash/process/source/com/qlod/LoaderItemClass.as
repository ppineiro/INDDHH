
class com.qlod.LoaderItemClass {

	var target;
	var sUrl;
	var bDoLoad;
	var aArgs;
	var iId;
	var oListener;
	var funcWaitUntil;
	var waitUntilPropertiesAreInitialized;

	function LoaderItemClass( target, sUrl, doLoad, aArgs, id, oListener) {
		trace("LoaderItemClass " + arguments);
		this.target = target;
		this.sUrl = sUrl;
		this.bDoLoad = doLoad;
		this.aArgs = aArgs;
		this.iId = id;
		this.oListener = oListener;
	};
	
	function load() {
		var loc = target;
		trace("_load " + loc+":"+typeof loc);	
		//
		if( typeof( loc.load) == 'function'){
			loc.load.apply( loc, [sUrl].concat( aArgs));
		} else if( typeof( loc.loadSound) == 'function'){
			loc.loadSound.apply( loc, [sUrl].concat( aArgs));
		} else {
			funcWaitUntil = waitUntilPropertiesAreInitialized;
			if( aArgs[0].toUpperCase() == 'POST'){
				loadMovie( sUrl, loc, 'POST');
			} else if( aArgs[0].toUpperCase() == 'GET'){
				loadMovie( sUrl, loc, 'GET');
			} else {
				loadMovie( sUrl, loc);
			};
		};
	};	
	
	function targetToLoc() {
		return ( typeof( target) == 'string') ? eval( target) : target;	
	};
	
	function addListenerTo(broadcaster) {
		if (oListener != undefined) {
			broadcaster.addListener( oListener);	
		};	
	};
	
	function removeListenerFrom(broadcaster) {
		if (oListener != undefined) {
			broadcaster.removeListener(oListener);	
		};	
	};

};