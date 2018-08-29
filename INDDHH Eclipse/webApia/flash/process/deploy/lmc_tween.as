/*
tweening prototypes
version 1.1.8
Ladislav Zigo,lacoz@web.de

added colorTo(null) or only colorTo() to reset color transformation of movieclip to normal mode (thanks for tip to James Rowley)
AsBroadcaster initialization now not removes old listeners (thanks to Ivan Dembicki) 


*/

// to avoid reseting tweenManger when loading another .swf
if(_global.$tweenManager == undefined){
	_global.$tweenManager = new zigo.tweenManager();
} else {
	_global.$tweenManager.playing = false;
}
// easing equations 
// from Robert Penner, www.robertpenner.com 
com.robertpenner.easing.Back;
com.robertpenner.easing.Bounce;
com.robertpenner.easing.Circ;
com.robertpenner.easing.Cubic;
com.robertpenner.easing.Elastic;
com.robertpenner.easing.Expo;
com.robertpenner.easing.Linear;
com.robertpenner.easing.Quad;
com.robertpenner.easing.Quart;
com.robertpenner.easing.Quint;
com.robertpenner.easing.Sine;
//
var Mp = MovieClip.prototype;
Mp.addListener = function() {
 if (!this._listeners) {
  AsBroadcaster.initialize(this);
 }
 this.addListener.apply(this,arguments);
};
ASSetPropFlags(Mp, "addListener", 1, 0)

// == core methods ==
Mp.tween = function(props, pEnd, seconds, animType,
				delay, callback, extra1, extra2) {
	if (_global.$tweenManager.isTweenLocked(this)){
		trace("tween not added, this movieclip is locked");
		return;
	}	
	if (arguments.length<2) {
		trace("tween not added, props & pEnd must be defined");
		return;
	}
	// parse arguments to valid type:
	// parse properties
	if (typeof (props) == "string") {
		props = [props];
	}
	// parse end values
	// if pEnd is not array 
	if (pEnd.length == undefined ) {
		pEnd = [pEnd];
	} 
	// parse time properties
	if(seconds == undefined) {
		seconds = 2;
	}else if (seconds<0.01){
		seconds = 0;
	}
	if (delay<0.01 || delay == undefined) {
		delay = 0;
	}
	// parse animtype to reference to equation function 
	switch(typeof(animType)){
	case "string":
	//string
		animType = animType.toLowerCase();
		if (animType == "linear") {
			var eqf = com.robertpenner.easing.Linear.easeNone;
		} else if (animType.indexOf("easeoutin") == 0) {
			var t = animType.substr(9);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			var eqf = com.robertpenner.easing[t].easeOutIn;
		} else if (animType.indexOf("easeinout") == 0) {
			var t = animType.substr(9);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			var eqf = com.robertpenner.easing[t].easeInOut;
		} else if (animType.indexOf("easein") == 0) {
			var t = animType.substr(6);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			var eqf = com.robertpenner.easing[t].easeIn;
		} else if (animType.indexOf("easeout") == 0) {
			var t = animType.substr(7);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			var eqf = com.robertpenner.easing[t].easeOut;
		}
		if (eqf == undefined) {
			// set default tweening equation
			var eqf = com.robertpenner.easing.Expo.easeOut;
		}
		break;
	case "function":
	// function
		var eqf = animType;
		break;
	case "object":
		// object from custom easing
		if (animType.ease != undefined && animType.pts != undefined ){
			var eqf = animType.ease;
			extra1 = animType.pts;
		}else{
			var eqf = com.robertpenner.easing.Expo.easeOut;
		}
		break;
	default:
		var eqf = com.robertpenner.easing.Expo.easeOut;
	}

	// parse callback function
	switch(typeof (callback)) {
	case "function":
		callback = {func:callback, scope:this._parent};
		break;
	case "string":
		var ilp, funcp, scope, args, a;
		ilp = callback.indexOf("(");
		funcp = callback.slice(0, ilp);
		
		scope = eval(funcp.slice(0, funcp.lastIndexOf(".")));
		func = eval(funcp);
		args = callback.slice(ilp+1, callback.lastIndexOf(")")).split(",");
		for (var i = 0; i<args.length; i++) {
			a = eval(args[i]);
			if (a != undefined) {
				args[i] = a;
			}
		}
		callback = {func:func, scope:scope, args:args };
		break;
	}
	if(_global.$tweenManager.autoStop){
		// automatic removing tweens as in Zeh proto
		_global.$tweenManager.removeTween(this,props)		
	}
	if(delay > 0){
		_global.$tweenManager.addTweenWithDelay(delay,this, props, pEnd, seconds, eqf, callback, extra1, extra2);
	}else{
		_global.$tweenManager.addTween(this, props, pEnd, seconds, eqf, callback, extra1, extra2);
	}	
};
ASSetPropFlags(Mp, "tween", 1, 0);
Mp.stopTween = function(props) {
	if (typeof (props) == "string") {
		props = [props];
	}
	_global.$tweenManager.removeTween(this, props);
};
ASSetPropFlags(Mp, "stopTween", 1, 0);
Mp.isTweening = function() {
	//returns boolean
	return _global.$tweenManager.isTweening(this);
};
ASSetPropFlags(Mp, "isTweening", 1, 0);
Mp.getTweens = function() {
	// returns count of running tweens
	return _global.$tweenManager.getTweens(this);
};
ASSetPropFlags(Mp, "getTweens", 1, 0);
//
Mp.lockTween = function() {
	// 
	_global.$tweenManager.lockTween(this,true);
};
ASSetPropFlags(Mp, "lockTween", 1, 0);
//
Mp.unlockTween = function() {
	// 
	_global.$tweenManager.lockTween(this,false);
};
//
ASSetPropFlags(Mp, "unlockTween", 1, 0);
Mp.isTweenLocked = function() {
	// 
	return _global.$tweenManager.isTweenLocked(this);
};
ASSetPropFlags(Mp, "isTweenLocked", 1, 0);

// == shortcut methods == 
// these methods only passes parameters to tween method
Mp.alphaTo = function (destAlpha, seconds, animType, delay, callback, extra1, extra2) {
	this.tween(["_alpha"],[destAlpha],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(Mp, "alphaTo", 1, 0);
Mp.brightnessTo = function (bright, seconds, animType, delay, callback, extra1, extra2) {
	// destionation color transform matrix
	var percent = 100 - Math.abs(bright);
  	var offset = 0;
  	if (bright > 0) offset = 256 * (bright / 100);
 	var destCt = {ra: percent, rb:offset,
			ga: percent, gb:offset,
			ba: percent,bb:offset}
	//
	this.tween(["_ct_"],[destCt],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(Mp, "brightnessTo", 1, 0);
Mp.colorTo = function (destColor, seconds, animType, delay, callback, extra1, extra2) {
	// destionation color transform matrix
	var destCt;
	if (destColor == undefined || destColor == null){
		destCt = {rb:0, ra:100, gb:0, ga:100, bb:0, ba:100};
	}else {
		destCt = {rb: destColor >> 16, ra:0,
				  gb: (destColor & 0x00FF00) >> 8, ga:0,
				  bb: destColor & 0x0000FF,ba:0}
	}
	//
	this.tween(["_ct_"],[destCt],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(Mp, "colorTo", 1, 0);
Mp.colorTransformTo = function (ra, rb, ga, gb, ba, bb, aa, ab, seconds, animType, delay, callback, extra1, extra2) {
	// destionation color transform matrix
	var destCt = {ra: ra ,rb: rb , ga: ga, gb: gb, ba: ba, bb: bb, aa: aa, ab: ab}
	//
	this.tween(["_ct_"],[destCt],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(Mp, "colorTransformTo", 1, 0);
Mp.scaleTo = function (destScale, seconds, animType, delay, callback, extra1, extra2) {
	this.tween(["_xscale", "_yscale"],[destScale, destScale],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(Mp, "scaleTo", 1, 0);
Mp.slideTo = function (destX, destY, seconds, animType, delay, callback, extra1, extra2) {
	this.tween(["_x", "_y"],[destX, destY],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(Mp, "slideTo", 1, 0);
Mp.rotateTo = function (destRotation, seconds, animType, delay, callback, extra1, extra2) {
	this.tween(["_rotation"],[destRotation],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(Mp, "rotateTo", 1, 0);
// frameTo shorcut method
Mp.getFrame = function() {
	return this._currentframe;
};
ASSetPropFlags(Mp, "getFrame", 1, 0);
Mp.setFrame = function(fr) {
	this.gotoAndStop(Math.round(fr));
};
ASSetPropFlags(Mp, "setFrame", 1, 0);
Mp.addProperty("_frame", Mp.getFrame, Mp.setFrame);
ASSetPropFlags(Mp, "_frame", 1, 0);
//
Mp.frameTo = function(endframe, duration, animType, delay, callback, extra1, extra2) {
	if (endframe == undefined) {
		endframe = this._totalframes;
	}
	this.tween("_frame", endframe, duration, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(Mp, "frameTo", 1, 0);
Mp.brightOffsetTo = function(percent, seconds, animType, delay, callback, extra1, extra2) {
	var offset = 256*(percent/100);
	var destCt = {ra:100, rb:offset, ga:100, gb:offset, ba:100, bb:offset};
	this.tween(["_ct_"], [destCt], seconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(Mp, "brightOffsetTo", 1, 0);
Mp.contrastTo = function(percent, seconds, animType, delay, callback, extra1, extra2) {
	// from Robert Penner color toolkit
	var t = {};
	t.ra = t.ga=t.ba=percent;
	t.rb = t.gb=t.bb=128-(128/100*percent);
	this.tween(["_ct_"], [t], seconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(Mp, "contrastTo", 1, 0);
delete Mp;
