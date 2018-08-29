/*
tweening prototypes
version 1.1.1
Ladislav Zigo,lacoz@inmail.sk
*/
// to avoid reseting tweenManger when loading another .swf
class com.st.util.lmc_tween.as{
if ($tweenManager == undefined){
_global.$tweenManager = new zigo.tweenManager();
}
// easing equations 
// from Robert Penner, www.robertpenner.com 
com.robertpenner.easing.Circ;
com.robertpenner.easing.Cubic;
com.robertpenner.easing.Expo;
com.robertpenner.easing.Quad;
com.robertpenner.easing.Quart;
com.robertpenner.easing.Quint;
com.robertpenner.easing.Sine;
// default from Macromedia
mx.transitions.easing.Back;
mx.transitions.easing.Bounce;
mx.transitions.easing.Elastic;
mx.transitions.easing.None;
mx.transitions.easing.Strong;
mx.transitions.easing.Regular;

// == core methods ==
MovieClip.prototype.tween = function(props, pEnd, seconds, animType,
				delay, callback, extra1, extra2) {
	if (arguments.length<2) {
		trace("error: props & pEnd must be defined");
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
	if (seconds<0.01 || seconds == undefined) {
		seconds = 2;
	}
	if (delay<0.01 || delay == undefined) {
		delay = 0;
	}
	var now = getTimer();
	var tstart = now+delay*1000;
	var tend = tstart+seconds*1000;
	// parse animtype to reference to equation function 
	if(typeof(animType) == "string"){
		animType = animType.toLowerCase();
		if (animType == "linear") {
			var eqf = mx.transitions.easing.None.easeNone;
		} else if (animType.indexOf("easeinout") == 0) {
			var t = animType.substr(9);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			var eqf = com.robertpenner.easing[t].easeInOut;
			if(eqf == undefined){
				var eqf = mx.transitions.easing[t].easeInOut;	
			}
		} else if (animType.indexOf("easein") == 0) {
			var t = animType.substr(6);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			var eqf = com.robertpenner.easing[t].easeIn;
			if(eqf == undefined){
				var eqf = mx.transitions.easing[t].easeIn;	
			}
		} else if (animType.indexOf("easeout") == 0) {
			var t = animType.substr(7);
			t = t.charAt(0).toUpperCase()+t.substr(1);
			var eqf = com.robertpenner.easing[t].easeOut;
			if(eqf == undefined){
				var eqf = mx.transitions.easing[t].easeOut;	
			}
		}
		if (eqf == undefined) {
			// set default tweening equation
			var eqf = mx.transitions.easing.Strong.easeOut;
		}
	} else if (typeof(animType) == "function"){
		// function
		var eqf = animType;
	} else if (typeof(animType) == "object"){
		// object from custom easing
		if (animType.ease != undefined && animType.pts != undefined ){
			var eqf = animType.ease;
			extra1 = animType.pts;
		}else{
			var eqf = mx.transitions.easing.Strong.easeOut;
		}
	}else{
		var eqf = mx.transitions.easing.Strong.easeOut;
	}

	// parse callback function
	if (typeof (callback) == "function") {
		callback = {func:callback, scope:this._parent};
	}
	// pass parameters to tweenManager static method 
	$tweenManager.addTween(this, props, pEnd, seconds, delay, eqf, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "tween", 1, 0);
MovieClip.prototype.stopTween = function(props) {
	if (typeof (props) == "string") {
		props = [props];
	}
	$tweenManager.removeTween(this, props);
};
ASSetPropFlags(MovieClip.prototype, "stopTween", 1, 0);
MovieClip.prototype.isTweening = function() {
	//returns boolean
	return $tweenManager.isTweening(this);
};
ASSetPropFlags(MovieClip.prototype, "isTweening", 1, 0);
MovieClip.prototype.getTweens = function() {
	// returns count of running tweens
	return $tweenManager.getTweens(this);
};
ASSetPropFlags(MovieClip.prototype, "getTweens", 1, 0);
//
// == shortcut methods == 
// these methods only passes parameters to tween method
MovieClip.prototype.alphaTo = function (destAlpha, seconds, animType, delay, callback, extra1, extra2) {
	this.tween(["_alpha"],[destAlpha],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(MovieClip.prototype, "alphaTo", 1, 0);
MovieClip.prototype.colorTo = function (destColor, seconds, animType, delay, callback, extra1, extra2) {
	// destionation color transform matrix
	var destCt = {rb: destColor >> 16, ra:0,
				  gb: (destColor & 0x00FF00) >> 8, ga:0,
				  bb: destColor & 0x0000FF,ba:0}
	//
	this.tween(["_ct_"],[destCt],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(MovieClip.prototype, "colorTo", 1, 0);
MovieClip.prototype.colorTransformTo = function (ra, rb, ga, gb, ba, bb, aa, ab, timeSeconds, animType, delay, callback, extra1, extra2) {
	// destionation color transform matrix
	var destCt = {ra: ra ,rb: rb , ga: ga, gb: gb, ba: ba, bb: bb, aa: aa, ab: ab}
	//
	this.tween(["_ct_"],[destCt],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(MovieClip.prototype, "colorTransformTo", 1, 0);
MovieClip.prototype.scaleTo = function (destScale, seconds, animType, delay, callback, extra1, extra2) {
	this.tween(["_xscale", "_yscale"],[destScale, destScale],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(MovieClip.prototype, "scaleTo", 1, 0);
MovieClip.prototype.slideTo = function (destX, destY, seconds, animType, delay, callback, extra1, extra2) {
	this.tween(["_x", "_y"],[destX, destY],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(MovieClip.prototype, "slideTo", 1, 0);
MovieClip.prototype.rotateTo = function (destRotation, seconds, animType, delay, callback, extra1, extra2) {
	this.tween(["_rotation"],[destRotation],seconds,animType,delay,callback,extra1,extra2)
}
ASSetPropFlags(MovieClip.prototype, "rotateTo", 1, 0);
}
