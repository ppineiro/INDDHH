
 
import com.qlod.LoaderItemClass;

class com.qlod.LoaderClass {
	
	
	/*********************************************************************************
	 * 								vars
	 *********************************************************************************/
	
	private static var DEFAULT_TIMEOUT_MS:Number = 10 * 1000;
	private static var DEFAULT_INTERVAL_MS = 100;
	private static var DEFAULT_MIN_STEPS = 1;
	
	private var iIntervalId:Number;
	private var iTimeoutIntervalId:Number;
	private var iBytesLoaded:Number;
	private var iBytesTotal:Number;
	private var iTimeoutMs:Number;
	private var bTimeoutEnabled:Boolean;
	private var iIntervalMs:Number;
	private var iStartTimeMs:Number;
	private var iMinSteps:Number;
	private var iCurrentStep:Number;

	private var aQueue:Array;
	
	static var DefaultBroadcaster; // used for utilizing a different Event Broadcasting Decorator class.
	
	var addListener:Function;
	var removeListener:Function;
	private var broadcastMessage:Function;
	private var _listeners:Array;
	
	private var sUrl:String;
	private var target; // type changes throughout - should be rewritten
	private var oListener:Object;
	private var oCurrentItem:Object;
	private var funcWaitUntil:Function;
	
	private var iId:Number;
	
	/*********************************************************************************
	 * 								constructor
	 *********************************************************************************/
	
	function LoaderClass(piTimeoutMs, piIntervalMs, piMinSteps) {
		//trace("LoaderClass " + arguments);
		if (arguments[0] == 'NO_INIT') return;
		
		iIntervalId = -1;
		iTimeoutIntervalId = -1;
		iBytesLoaded = 0;
		iBytesTotal = 1;
		iTimeoutMs = 0;
		bTimeoutEnabled = true;
		iIntervalMs = 0;
		iStartTimeMs = 0;
		iMinSteps = 1;
		iCurrentStep = 1;
	
		aQueue = [];
		
		setTimeoutMs(piTimeoutMs);
		setIntervalMs(piIntervalMs);
		setMinSteps(piMinSteps);
		
		if (DefaultBroadcaster != undefined) {
			DefaultBroadcaster.initialize(this);
		} else {
			if (AsBroadcaster == undefined) {
				trace("ERROR in LoaderClass: AsBroadcaster undefined");
			} else {
				trace("com.qlod.LoaderClass: using AsBroadcaster");	
				AsBroadcaster.initialize(this);
			};
		};
	};
	
	/*********************************************************************************
	 * 								public methods
	 *********************************************************************************/
	
	function load(pLoc, psUrl, poListener ) {
		//trace("LoaderClass.load " + arguments);
		return enqueue.apply(this, [true].concat(arguments));
	};
	
	function observe(pLoc, psUrl, poListener ) {
		//trace("LoaderClass.observe " + arguments);
		return enqueue.apply(this, [false].concat(arguments));
	};
	
	function clear() {
		aQueue.length = 0;
		removeCurrent();
	};
	
	function removeCurrent() {
		if (isLoading()) {
			var currentLoc = targetToLoc();
			if (checkLocation(currentLoc)) {
				currentLoc.unloadMovie();	
			};
			endTimeout();
			endLoading();
		};	
	};
	
	function remove(pId) {
		if (oCurrentItem.iId == pId) {
			removeCurrent();
			return true;	
		};
		for(var i=0; i<aQueue.length; i++) {
			if (aQueue[i].iId == pId) {
				aQueue.splice(i, 1);
				return true;	
			};	
		};
		return false;	
	};
	
	function getTimeoutMs() {
		return iTimeoutMs;	
	};
	
	function setTimeoutMs(piMilliseconds) {
		iTimeoutMs = checkIntGreaterZero(piMilliseconds, constructor.DEFAULT_TIMEOUT_MS);
		if (iTimeoutIntervalId != -1) {
			startTimeout();
		};
		return iTimeoutMs;	
	};
	
	function disableTimeout() {
		endTimeout();
		bTimeoutEnabled = false;	
	};
	
	function enableTimeout() {
		bTimeoutEnabled = true;
		startTimeout();	
	};
	 
	function getIntervalMs() {
		return iIntervalMs;	
	};
	
	function setIntervalMs(piMilliseconds) {
		iIntervalMs = checkIntGreaterZero(piMilliseconds, constructor.DEFAULT_INTERVAL_MS);
		if (isLoading()) {
			clearInterval(iIntervalId);
			iIntervalId = -1;
			startInterval();
		};
		return iIntervalMs;	
	};
	
	function getMinSteps() {
		return iMinSteps;	
	};
	
	function setMinSteps(piMinSteps) {
		return iMinSteps = checkIntGreaterZero(piMinSteps, constructor.DEFAULT_MIN_STEPS);	
	};
	
	function isLoading() {
		return iIntervalId != -1;
	};
	
	function getBytesLoaded() {
		var bytesToShow = Math.min(iBytesLoaded, Math.floor(iBytesTotal * iCurrentStep / iMinSteps ));
		// i wonder why NaN ever showed up, but it did, 
		// so it is more robust to check for NaN explicitely
		return (isNaN(bytesToShow)) ? 0 : bytesToShow;
	};
	
	function getBytesTotal() {
		return iBytesTotal;
	};
	
	function getKBLoaded() {
		return getBytesLoaded() >> 10;
	};
	
	function getKBTotal() {
		return getBytesTotal() >> 10;
	};
	
	function getPercent() {
		return getBytesLoaded() * 100 / iBytesTotal;
	};
	
	function getDuration() {
		return getTimer() - iStartTimeMs;
	};
	
	function getSpeed() {
		return Math.floor(getBytesLoaded() * 1000 / getDuration());
	};
	
	function getEstimatedTotalTime() {
		return Math.floor(getBytesTotal() / getSpeed());
	};
	
	function getTarget() {
		return oCurrentItem.target;
	};
	
	function getTargetObj() {
		return (typeof(oCurrentItem.target) == 'object') ? oCurrentItem.target : eval(oCurrentItem.target);
	};
	
	function getUrl() {
		return oCurrentItem.sUrl;
	};
	
	function getPriority(pId) {       
		var i,len = aQueue.length;
		for (i=0;i<len;i++) {                                 
			if (aQueue[i].iId == pId) return ++i;
		};
		return (oCurrentItem.iId == pId) ? 0 : null;
	};
	 
	function setPriority(pId,nPri) {                        
		if (nPri>=0) {
			var i,len = aQueue.length;    
			for(i=0;i<len;i++) {
				if (aQueue[i].iId == pId) {
					if (nPri==0) {
						aQueue.splice(0,0,aQueue.splice(i,1)[0]);
						aQueue.splice(1,0,oCurrentItem);
						removeCurrent();
						return true;
					} else {
						aQueue.splice(nPri-1,0,aQueue.splice(i,1)[0]);
						return true;	
					};
				};
			};
		};
		return false;       
	};

	
	/*********************************************************************************
	 * 								private methods
	 *********************************************************************************/
	
	function broadcastOnQueueStart() {
		broadcastMessage("onQueueStart", this);	
	};
	
	function broadcastOnQueueStop() {
		broadcastMessage("onQueueStop", this);	
	};
	 
	function broadcastOnLoadStart() {
		broadcastMessage("onLoadStart", this);	
	};
	
	function broadcastOnLoadComplete(pbResult) {
		broadcastMessage("onLoadComplete", pbResult, this);
	};
	
	function broadcastOnLoadTimeout() {
		broadcastMessage("onLoadTimeout", this);		
	};
	
	function broadcastOnLoadProgress() {
		broadcastMessage("onLoadProgress", this);
	};
	
	function _load() {
		startTimeout();
		oCurrentItem.load();	
	};	
	
	function _observe() {
		iBytesTotal = 1;
		iBytesLoaded = 0;	
		iCurrentStep = 1;
		iStartTimeMs = getTimer();
		funcWaitUntil = null;
		//
		oCurrentItem.addListenerTo(this);
		//
		broadcastOnLoadStart();
		broadcastOnLoadProgress();
		//
		if (oCurrentItem.bDoLoad) {
			_load();	
		};
	};
	
	function enqueue(doLoad, pLoc, psUrl, poListener) {
		trace("enqueue " + arguments);	
		//
		var sUrl = checkUrl(psUrl, pLoc);
		//
		var target = locToTarget(pLoc);
		trace("target == "+target+":"+typeof target);
		if (target == null) {
			if (doLoad) {
				trace("Warning: com.qlod.LoaderClass.load: Invalid location parameter: " + pLoc);
			} else {
				trace("Warning: com.qlod.LoaderClass.load: Invalid location parameter: " + pLoc);
			};
		};
		//
		var additionalArguments = arguments.slice(4);
		//
		var id = ++iId;
		//
		aQueue.push(new LoaderItemClass(target, sUrl, doLoad, additionalArguments, id, poListener));
		if (! isLoading()) {
			startLoading();
		};
		return id;
	};
	
	function checkUrl(psUrl, pLoc) {
		if (typeof(psUrl) == 'string') return psUrl;
		if (typeof(pLoc._url) == 'string') return pLoc._url;
		return "";	
	};
	
	function isQueueEmpty() {
		return aQueue.length == 0;
	};
	
	function loadNext() {
		oCurrentItem = aQueue.shift();	
		_observe();	
	};
	
	function startLoading() {
		broadcastOnQueueStart();
		startInterval();		
		loadNext();
	};
	
	function stopLoading() {
		endInterval();
		endTimeout();
	};
	
	function startTimeout() {
		if (iTimeoutIntervalId != -1) {
			clearInterval(iTimeoutIntervalId);
		};
		if (bTimeoutEnabled) {
			iTimeoutIntervalId = setInterval(this, "onTimeout", iTimeoutMs);
		};
	};
	
	function endTimeout() {
		if (iTimeoutIntervalId != -1) {
			clearInterval(iTimeoutIntervalId);
			iTimeoutIntervalId = -1;
		};
	};
	
	function onTimeout() {
		endTimeout();
		broadcastOnLoadTimeout();		
		endLoading(false);
	};
	
	function locToTarget(loc) {
		if (locIsNumber(loc)) return "_level" + loc;
		if (locIsPath(loc)) return loc; 
		if (locIsLevel(loc)) return loc;
		if (locIsMovieClip(loc)) return TargetPath(loc);
		if (locIsLoadableObject(loc)) return loc;
		if (loc instanceof String && loc.length > 0) return loc;
		return null;
	};
	
	function targetToLoc() {
		return oCurrentItem.targetToLoc();
	};
	
	function locIsNumber(loc) {
		return typeof(loc) == 'number';	
	};
	
	function locIsPath(loc) {
		return typeof(loc) == 'string' && typeof(eval(loc)) == 'movieclip' && (eval(loc) != _level0 || loc == "_level0");
	};
	
	function locIsLevel(loc) {
		return loc.indexOf("_level") == 0 && ! isNaN(loc.substring(6));	
	};
	
	function locIsMovieClip(loc) {
		return typeof(loc) == 'movieclip';
	};
	
	function locIsLoadableObject(loc) {
		//eg. movieclip, sound, xml, loadvars
		return typeof(loc.getBytesTotal) == 'function' && typeof(loc.getBytesLoaded) == 'function';	
	};
	
	function startInterval() {
		if (iIntervalId != -1) {
			endInterval();
		};
		iIntervalId = setInterval(this, "onInterval", iIntervalMs);
	};
	
	function endInterval() {
		if (iIntervalId != -1) {
			clearInterval(iIntervalId);
			iIntervalId = -1;
		};
	};
	
	function onInterval() {
		var currentLoc = targetToLoc();
		// for some reason not being correctly converted to target, so try again.
		currentLoc = (typeof currentLoc == "string") ? eval(currentLoc) : currentLoc;
		if (! checkLocation(currentLoc)) return;
		if (! checkBytesTotal(currentLoc)) return;
		if (! checkBytesLoaded(currentLoc)) return;
		endTimeout();
		//
		broadcastOnLoadProgress();
		checkComplete(currentLoc);	
		iCurrentStep++;
	};
	
	function checkLocation(poCurrentLoc) {
		if (poCurrentLoc == undefined) {
			broadcastOnLoadProgress();
			return false;
		};
		return true;
	};
	
	function checkBytesTotal(poCurrentLoc) {
		var iBytesTotal = poCurrentLoc.getBytesTotal();
		if (iBytesTotal < 4) {
			broadcastOnLoadProgress();
			return false;
		};
		this.iBytesTotal = iBytesTotal;
		return true;
	};
	
	function checkBytesLoaded(poCurrentLoc) {
		var iBytesLoaded = poCurrentLoc.getBytesLoaded();
		if (iBytesLoaded < 1) {
			broadcastOnLoadProgress();
			return false;
		};
		this.iBytesLoaded = iBytesLoaded;	
		return true;
	};
	
	function checkComplete(poCurrentLoc) {
		if (iBytesTotal > 10 
		&& iBytesTotal - iBytesLoaded < 10 
		&& iCurrentStep >= iMinSteps
		&& (funcWaitUntil == null || funcWaitUntil(poCurrentLoc))) { 
			endLoading(true);
			return true;
		}
		return false;
	};
	
	function waitUntilPropertiesAreInitialized(pMc) {
		return pMc._width != undefined && pMc._height != undefined && pMc._visible != undefined && pMc._url != undefined;
	};
	
	function endCurrentLoading(pbResult) {
		broadcastOnLoadComplete(pbResult);
		oCurrentItem.removeListenerFrom(this);
	};
	
	function endLoading(pbResult) {
		endCurrentLoading(pbResult);
		//
		if (isQueueEmpty()) {
			endInterval();
			broadcastOnQueueStop();
		} else {
			loadNext();	
		};
	};
	
	function checkIntGreaterZero(piValue, piDefaultValue) {
		if (piValue == undefined || isNaN(piValue) || piValue <= 0) return piDefaultValue;
		return piValue;
	};
	
};