var facilis={
    parsers:{
        input:{},
        output:{}
    },
    baseUrl:"src/",
    validation:{},
    documentation:{},
    controller:{},
    game:{},
    extend:function(subclass, superclass) {
        "use strict";
        function o() { this.constructor = subclass; }
        o.prototype = superclass.prototype;
        return (subclass.prototype = new o());
    },
    promote:function(subclass, prefix) {
        "use strict";

        var subP = subclass.prototype, supP = (Object.getPrototypeOf&&Object.getPrototypeOf(subP))||subP.__proto__;
        if (supP) {
            subP[(prefix+="_") + "constructor"] = supP.constructor; // constructor is not always innumerable
            for (var n in supP) {
                if (subP.hasOwnProperty(n) && (typeof supP[n] == "function")) { subP[prefix + n] = supP[n]; }
            }
        }
        return subclass;
    },
    extendProperty:function(classEl,property,getter,setter){
        var descriptor=null;
        
            try{
                descriptor=Object.getOwnPropertyDescriptor(classEl.prototype,property);
            }catch(e){}
        if(descriptor){
            Object.defineProperty(element,property,null);
            Object.defineProperty(element,"_base_"+property,descriptor);
        }
        Object.defineProperty(classEl,property,{get:getter,set:setter});
    }
};

(function() {

    facilis.Ticker = createjs.Ticker;
    
}());

(function() {

    function Event(type, bubbles, cancelable) {
        this.BaseEvent_constructor(type, bubbles, cancelable);
    }
    
    var element = facilis.extend(Event, createjs.Event);
    
    facilis.Event = facilis.promote(Event, "BaseEvent");
    
}());

(function() {

    /*function EventDispatcher() {
        this.BaseEventDispatcher_constructor();
    }
    
    var element = facilis.extend(EventDispatcher, facilis.EventDispatcher);*/
    
    facilis.EventDispatcher = createjs.EventDispatcher;//facilis.promote(EventDispatcher, "BaseEventDispatcher");
    
}());

(function() {

    function Point(x,y) {
        this.BasePoint_constructor(x,y);
    }
    
    var element = facilis.extend(Point, createjs.Point);
    
    facilis.Point = facilis.promote(Point, "BasePoint");
    
}());

(function() {

    function Container() {
        this.BaseContainer_constructor();
    }
    
    var element = facilis.extend(Container, createjs.Container);
    
    element.setMask=function(m){
        this.mask=m;
    }
    
    element.baseAddChild=element.addChild;
    element.addChild=function(el){
        this.baseAddChild(el);
        this.dispatchEvent(new facilis.Event("changed",true));
    }
    
    facilis.Container = facilis.promote(Container, "BaseContainer");
    
}());

(function() {

    function Shape(graphics) {
        this.BaseShape_constructor(graphics);
    }
    
    var element = facilis.extend(Shape, createjs.Shape);
    
    facilis.Shape = facilis.promote(Shape, "BaseShape");
    
}());

(function() {

    function Rectangle(x, y, width, height) {
        this.BaseRectangle_constructor(x, y, width, height);
    }
    
    var element = facilis.extend(Rectangle, createjs.Rectangle);
	
	element.contains = function(point){
		return ( point.x>=this.x && point.x<=(this.x+this.width) && point.y>=this.y && point.y<=(this.y+this.height)  );
	}
    
    facilis.Rectangle = facilis.promote(Rectangle, "BaseRectangle");
    
}());

(function() {

    function Sprite(spriteSheet, frameOrAnimation) {
        this.BaseSprite_constructor(spriteSheet, frameOrAnimation);
    }
    
    var element = facilis.extend(Sprite, createjs.Sprite);
    
    facilis.Sprite = facilis.promote(Sprite, "BaseSprite");
    
}());

(function() {

    function SpriteSheet(data) {
        this.BaseSpriteSheet_constructor(data);
    }
    
    var element = facilis.extend(SpriteSheet, createjs.SpriteSheet);
    
    facilis.SpriteSheet = facilis.promote(SpriteSheet, "BaseSpriteSheet");
    
}());

(function() {

    function Graphics() {
        this.BaseGraphics_constructor();
    }
    
    var element = facilis.extend(Graphics, createjs.Graphics);
    
    element.lineStyle = function( lineWidth, color, alpha ){
        this.setStrokeStyle(lineWidth);
        color=this.hexToRgbA(color,((alpha==null)?1:alpha))
        this.beginStroke(color);
    }
    
    element.hexToRgbA=function(hex,alpha) {
        if(hex && hex.indexOf("#")>=0){
            var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
            return "rgba("+parseInt(result[1], 16)+","+parseInt(result[2], 16)+","+parseInt(result[3], 16)+","+alpha+")";
        }
        return hex;
    }
    
    facilis.Graphics = facilis.promote(Graphics, "BaseGraphics");
    
}());

(function() {

    function Shadow(color, offsetX, offsetY, blur) {
        this.BaseShadow_constructor(color, offsetX, offsetY, blur);
    }
    
    var element = facilis.extend(Shadow, createjs.Shadow);
    
    facilis.Shadow = facilis.promote(Shadow, "BaseShadow");
    
}());

(function() {

    function Text(text,font,color) {
        this.BaseText_constructor(text,font,color);
    }
    
    var element = facilis.extend(Text, createjs.Text);
    
    facilis.Text = facilis.promote(Text, "BaseText");
    
}());

(function() {

    function BaseElement() {
        this.Container_constructor();
        this.addEventListener("removed",this.onRemove.bind(this));
    }
    var element = facilis.extend(BaseElement, facilis.Container);
    facilis.BaseElement = facilis.promote(BaseElement, "Container");
    element.addShape=function(s){
        this.addChild(s);
    };
    
    element.onRemove=function(){
        this.removeAllEventListeners();
    }
    
    element.FindPointofIntersection=function(A, B, E, F/*, asSegment = true, RoundUp = false*/ ){
		
		A=new facilis.Point(A.x,A.y);
		B=new facilis.Point(B.x,B.y);
		E=new facilis.Point(E.x,E.y);
		F=new facilis.Point(F.x,F.y);
		
        var RoundUp=false;
        var asSegment=true;
        

        var a1= B.y-A.y;
        var b1= A.x-B.x;
        var c1= B.x*A.y - A.x*B.y;
        var a2= F.y-E.y;
        var b2= E.x-F.x;
        var c2= F.x*E.y - E.x*F.y;

        var Denominator=a1*b2 - a2*b1;
        if (Denominator == 0) {
            return null;
        }
        var ip = new facilis.Point();
        if (RoundUp)
        {
            ip.x = Math.round((b1 * c2 - b2 * c1) / Denominator);
            ip.y = Math.round((a2 * c1 - a1 * c2) / Denominator);
        }
        else
        {
            ip.x=(b1*c2 - b2*c1)/Denominator;
            ip.y = (a2 * c1 - a1 * c2) / Denominator;
        }		

        if (asSegment)
        {
            if(Math.pow(ip.x - B.x, 2) + Math.pow(ip.y - B.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
            {
               return null;
            }

            if(Math.pow(ip.x - A.x, 2) + Math.pow(ip.y - A.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
            {
               return null;
            }

            if(Math.pow(ip.x - F.x, 2) + Math.pow(ip.y - F.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
            {
               return null;
            }

            if(Math.pow(ip.x - E.x, 2) + Math.pow(ip.y - E.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
            {
               return null;
            }
        }
        return ip;
    }
    
    element.makeDegree=function(el,w,h){
        w=w||40;
        h=h||90;
        el.graphics=(el.graphics||new facilis.Graphics());
        el.graphics.beginLinearGradientFill(["rgba(0,0,0,0.15)","rgba(255,255,255,0.01)"],[.3,1],w,h,0,0);
    }
    
    
}());

(function() {

    function Key() {
        this.Container_constructor();
        
        if (!Key.allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }

        this.setup();
    }
    
    Key.initialized = false;
    Key.keysDown = {};

    Key.allowInstantiation=false;
    Key._instance;
    
    Key.getInstance=function(){
        if (facilis.View._instance == null) {
            Key.allowInstantiation = true;
            Key._instance = new facilis.Key();
            //this._instance.appendMe();
            Key.allowInstantiation = false;
        }
        return View._instance;
    }

    Key.KEY_DOWN		= "keyDown";
    Key.KEY_UP			= "keyUp";

    
    
    var element = facilis.extend(Key, {});
    
    element.setup = function() {
        Key.initialize();
    };
    
    
    Key.initialize=function(){
        if (!Key.initialized) {
            document.addEventListener("keydown", this.keyPressed.bind(this));
            document.addEventListener("keyup", this.keyReleased.bind(this));
            //document.addEventListener(Event.DEACTIVATE, this.clearKeys.bind(this));
            Key.initialized = true;
        }        
    }
    Key.isDown=function(keyCode) {
        if (!Key.initialized) {
            throw new Error("Key class has yet been initialized.");
        }
        return Key.keysDown[keyCode];
    }

    Key.keyPressed=function(event) {
        Key.keysDown[event.keyCode] = true;
        if(Key._instance){
            Key._instance.dispatchEvent(new facilis.Event(Key.KEY_DOWN));
        }
    }

    Key.keyReleased=function(event) {
        if (Key.keysDown[event.keyCode]) {
            Key.keysDown[event.keyCode]=false;
        }
        if (Key._instance) {
            Key.dispatchEvent(new facilis.Event(Key.KEY_UP));
        }
    }

    Key.clearKeys=function(event) {
        Key.keysDown = {};
    }

    Key.stopKeyPropagation=function(e){
        if (!(  e.keyCode==Keyboard.TAB || e.keyCode==Keyboard.SHIFT)) {
            e.stopPropagation();
        }
    }

    Key.blur=function() {
        if (_stage) {
            _stage.focus = null;
        }
    }
    
    element.setup();


    facilis.Key = facilis.promote(Key, "Container");
    
    
    facilis.Keyboard = {
        
        A :  65,
 	 	ALTERNATE :  18,
 	 	AUDIO :  0x01000017,
 	 	B :  66,
 	 	BACK :  0x01000016,
 	 	BACKQUOTE :  192,
 	 	BACKSLASH :  220,
 	 	BACKSPACE :  8,
 	 	BLUE :  0x01000003,
 	 	C :  67,
 	 	CAPS_LOCK :  20,
 	 	CHANNEL_DOWN :  0x01000005,
 	 	CHANNEL_UP :  0x01000004,
 	 	CharCodeStrings : Array,
 	 	COMMA :  188,
 	 	COMMAND :  15,
 	 	CONTROL :  17,
 	 	D :  68,
 	 	DELETE :  46,
 	 	DOWN :  40,
 	 	DVR :  0x01000019,
 	 	E :  69,
 	 	END :  35,
 	 	ENTER :  13,
 	 	EQUAL :  187,
 	 	ESCAPE :  27,
 	 	EXIT :  0x01000015,
 	 	F :  70,
 	 	F1 :  112,
 	 	F10 :  121,
 	 	F11 :  122,
 	 	F12 :  123,
 	 	F13 :  124,
 	 	F14 :  125,
 	 	F15 :  126,
 	 	F2 :  113,
 	 	F3 :  114,
 	 	F4 :  115,
 	 	F5 :  116,
 	 	F6 :  117,
 	 	F7 :  118,
 	 	F8 :  119,
 	 	F9 :  120,
 	 	FAST_FORWARD :  0x0100000A,
 	 	G :  71,
 	 	GREEN :  0x01000001,
 	 	GUIDE :  0x01000014,
 	 	H :  72,
 	 	HELP :  0x0100001D,
 	 	HOME :  36,
 	 	I :  73,
 	 	INFO :  0x01000013,
 	 	INPUT :  0x0100001B,
 	 	INSERT :  45,
 	 	J :  74,
 	 	K :  75,
 	 	KEYNAME_BEGIN :  "Begin",
 	 	KEYNAME_BREAK :  "Break",
 	 	KEYNAME_CLEARDISPLAY :  "ClrDsp",
 	 	KEYNAME_CLEARLINE :  "ClrLn",
 	 	KEYNAME_DELETE :  "Delete",
 	 	KEYNAME_DELETECHAR :  "DelChr",
 	 	KEYNAME_DELETELINE :  "DelLn",
 	 	KEYNAME_DOWNARROW :  "Down",
 	 	KEYNAME_END :  "End",
 	 	KEYNAME_EXECUTE :  "Exec",
 	 	KEYNAME_F1 :  "F1",
 	 	KEYNAME_F10 :  "F10",
 	 	KEYNAME_F11 :  "F11",
 	 	KEYNAME_F12 :  "F12",
 	 	KEYNAME_F13 :  "F13",
 	 	KEYNAME_F14 :  "F14",
 	 	KEYNAME_F15 :  "F15",
 	 	KEYNAME_F16 :  "F16",
 	 	KEYNAME_F17 :  "F17",
 	 	KEYNAME_F18 :  "F18",
 	 	KEYNAME_F19 :  "F19",
 	 	KEYNAME_F2 :  "F2",
 	 	KEYNAME_F20 :  "F20",
 	 	KEYNAME_F21 :  "F21",
 	 	KEYNAME_F22 :  "F22",
 	 	KEYNAME_F23 :  "F23",
 	 	KEYNAME_F24 :  "F24",
 	 	KEYNAME_F25 :  "F25",
 	 	KEYNAME_F26 :  "F26",
 	 	KEYNAME_F27 :  "F27",
 	 	KEYNAME_F28 :  "F28",
 	 	KEYNAME_F29 :  "F29",
 	 	KEYNAME_F3 :  "F3",
 	 	KEYNAME_F30 :  "F30",
 	 	KEYNAME_F31 :  "F31",
 	 	KEYNAME_F32 :  "F32",
 	 	KEYNAME_F33 :  "F33",
 	 	KEYNAME_F34 :  "F34",
 	 	KEYNAME_F35 :  "F35",
 	 	KEYNAME_F4 :  "F4",
 	 	KEYNAME_F5 :  "F5",
 	 	KEYNAME_F6 :  "F6",
 	 	KEYNAME_F7 :  "F7",
 	 	KEYNAME_F8 :  "F8",
 	 	KEYNAME_F9 :  "F9",
 	 	KEYNAME_FIND :  "Find",
 	 	KEYNAME_HELP :  "Help",
 	 	KEYNAME_HOME :  "Home",
 	 	KEYNAME_INSERT :  "Insert",
 	 	KEYNAME_INSERTCHAR :  "InsChr",
 	 	KEYNAME_INSERTLINE :  "InsLn",
 	 	KEYNAME_LEFTARROW :  "Left",
 	 	KEYNAME_MENU :  "Menu",
 	 	KEYNAME_MODESWITCH :  "ModeSw",
 	 	KEYNAME_NEXT :  "Next",
 	 	KEYNAME_PAGEDOWN :  "PgDn",
 	 	KEYNAME_PAGEUP :  "PgUp",
 	 	KEYNAME_PAUSE :  "Pause",
 	 	KEYNAME_PREV :  "Prev",
 	 	KEYNAME_PRINT :  "Print",
 	 	KEYNAME_PRINTSCREEN :  "PrntScrn",
 	 	KEYNAME_REDO :  "Redo",
 	 	KEYNAME_RESET :  "Reset",
 	 	KEYNAME_RIGHTARROW :  "Right",
 	 	KEYNAME_SCROLLLOCK :  "ScrlLck",
 	 	KEYNAME_SELECT :  "Select",
 	 	KEYNAME_STOP :  "Stop",
 	 	KEYNAME_SYSREQ :  "SysReq",
 	 	KEYNAME_SYSTEM :  "Sys",
 	 	KEYNAME_UNDO :  "Undo",
 	 	KEYNAME_UPARROW :  "Up",
 	 	KEYNAME_USER :  "User",
 	 	L :  76,
 	 	LAST :  0x01000011,
 	 	LEFT :  37,
 	 	LEFTBRACKET :  219,
 	 	LIVE :  0x01000010,
 	 	M :  77,
 	 	MASTER_SHELL :  0x0100001E,
 	 	MENU :  0x01000012,
 	 	MINUS :  189,
 	 	N :  78,
 	 	NEXT :  0x0100000E,
 	 	NUMBER_0 :  48,
 	 	NUMBER_1 :  49,
 	 	NUMBER_2 :  50,
 	 	NUMBER_3 :  51,
 	 	NUMBER_4 :  52,
 	 	NUMBER_5 :  53,
 	 	NUMBER_6 :  54,
 	 	NUMBER_7 :  55,
 	 	NUMBER_8 :  56,
 	 	NUMBER_9 :  57,
 	 	NUMPAD :  21,
 	 	NUMPAD_0 :  96,
 	 	NUMPAD_1 :  97,
 	 	NUMPAD_2 :  98,
 	 	NUMPAD_3 :  99,
 	 	NUMPAD_4 :  100,
 	 	NUMPAD_5 :  101,
 	 	NUMPAD_6 :  102,
 	 	NUMPAD_7 :  103,
 	 	NUMPAD_8 :  104,
 	 	NUMPAD_9 :  105,
 	 	NUMPAD_ADD :  107,
 	 	NUMPAD_DECIMAL :  110,
 	 	NUMPAD_DIVIDE :  111,
 	 	NUMPAD_ENTER :  108,
 	 	NUMPAD_MULTIPLY :  106,
 	 	NUMPAD_SUBTRACT :  109,
 	 	O :  79,
 	 	P :  80,
 	 	PAGE_DOWN :  34,
 	 	PAGE_UP :  33,
 	 	PAUSE :  0x01000008,
 	 	PERIOD :  190,
 	 	PLAY :  0x01000007,
 	 	PREVIOUS :  0x0100000F,
 	 	Q :  81,
 	 	QUOTE :  222,
 	 	R :  82,
 	 	RECORD :  0x01000006,
 	 	RED :  0x01000000,
 	 	REWIND :  0x0100000B,
 	 	RIGHT :  39,
 	 	RIGHTBRACKET :  221,
 	 	S :  83,
 	 	SEARCH :  0x0100001F,
 	 	SEMICOLON :  186,
 	 	SETUP :  0x0100001C,
 	 	SHIFT :  16,
 	 	SKIP_BACKWARD :  0x0100000D,
 	 	SKIP_FORWARD :  0x0100000C,
 	 	SLASH :  191,
 	 	SPACE :  32,
 	 	STOP :  0x01000009,
 	 	STRING_BEGIN :  "",
 	 	STRING_BREAK :  "",
 	 	STRING_CLEARDISPLAY :  "",
 	 	STRING_CLEARLINE :  "",
 	 	STRING_DELETE :  "",
 	 	STRING_DELETECHAR :  "",
 	 	STRING_DELETELINE :  "",
 	 	STRING_DOWNARROW :  "",
 	 	STRING_END :  "",
 	 	STRING_EXECUTE :  "",
 	 	STRING_F1 :  "",
 	 	STRING_F10 :  "",
 	 	STRING_F11 :  "",
 	 	STRING_F12 :  "",
 	 	STRING_F13 :  "",
 	 	STRING_F14 :  "",
 	 	STRING_F15 :  "",
 	 	STRING_F16 :  "",
 	 	STRING_F17 :  "",
 	 	STRING_F18 :  "",
 	 	STRING_F19 :  "",
 	 	STRING_F2 :  "",
 	 	STRING_F20 :  "",
 	 	STRING_F21 :  "",
 	 	STRING_F22 :  "",
 	 	STRING_F23 :  "",
 	 	STRING_F24 :  "",
 	 	STRING_F25 :  "",
 	 	STRING_F26 :  "",
 	 	STRING_F27 :  "",
 	 	STRING_F28 :  "",
 	 	STRING_F29 :  "",
 	 	STRING_F3 :  "",
 	 	STRING_F30 :  "",
 	 	STRING_F31 :  "",
 	 	STRING_F32 :  "",
 	 	STRING_F33 :  "",
 	 	STRING_F34 :  "",
 	 	STRING_F35 :  "",
 	 	STRING_F4 :  "",
 	 	STRING_F5 :  "",
 	 	STRING_F6 :  "",
 	 	STRING_F7 :  "",
 	 	STRING_F8 :  "",
 	 	STRING_F9 :  "",
 	 	STRING_FIND :  "",
 	 	STRING_HELP :  "",
 	 	STRING_HOME :  "",
 	 	STRING_INSERT :  "",
 	 	STRING_INSERTCHAR :  "",
 	 	STRING_INSERTLINE :  "",
 	 	STRING_LEFTARROW :  "",
 	 	STRING_MENU :  "",
 	 	STRING_MODESWITCH :  "",
 	 	STRING_NEXT :  "",
 	 	STRING_PAGEDOWN :  "",
 	 	STRING_PAGEUP :  "",
 	 	STRING_PAUSE :  "",
 	 	STRING_PREV :  "",
 	 	STRING_PRINT :  "",
 	 	STRING_PRINTSCREEN :  "",
 	 	STRING_REDO :  "",
 	 	STRING_RESET :  "",
 	 	STRING_RIGHTARROW :  "",
 	 	STRING_SCROLLLOCK :  "",
 	 	STRING_SELECT :  "",
 	 	STRING_STOP :  "",
 	 	STRING_SYSREQ :  "",
 	 	STRING_SYSTEM :  "",
 	 	STRING_UNDO :  "",
 	 	STRING_UPARROW :  "",
 	 	STRING_USER :  "",
 	 	SUBTITLE :  0x01000018,
 	 	T :  84,
 	 	TAB :  9,
 	 	U :  85,
 	 	UP :  38,
 	 	V :  86,
 	 	VOD :  0x0100001A,
 	 	W :  87,
 	 	X :  88,
 	 	Y :  89,
 	 	YELLOW :  0x01000002,
 	 	Z :  90
        
    
    }
    
}());

(function() {

    function IconManager() {
        
        if (!IconManager.allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }

        this.url=facilis.baseUrl+"assets/Icons.png";
        this.icons=null;
        
        this.setup();
    }
    
    IconManager._instance=null;
    IconManager.allowInstantiation=false;
    
    IconManager.getInstance=function(){
        if (IconManager._instance == null) {
            IconManager.allowInstantiation = true;
            IconManager._instance = new facilis.IconManager();
            IconManager.allowInstantiation = false;
        }
        return IconManager._instance;
    }
    
    
    var element = facilis.extend(IconManager, {});
    
    /*
        element.BaseClassSetup=element.setup;
    */
    element.setup = function() {
        
        var frames=[];
        IconManager.frameIndexes={};
        var count=0;
        for(var i in IconManager.defs.frames){
            var f=IconManager.defs.frames[i].frame;
            frames.push([f.x,f.y,f.w,f.h]);
            IconManager.frameIndexes[i]=count;
            count++;
        }
        
        
        var data = {
            images: [this.url],
            frames: frames,//{width:20, height:20},
            /*animations: {
                stand:0,
                run:[1,5],
                jump:[6,8,"run"]
            }*/
        };
        this.icons = new facilis.SpriteSheet(data);
        
        /*
        var loader = new createjs.LoadQueue();
        loader.addEventListener("fileload", this.loaded.bind(this));
        loader.loadFile(this.url);*/

        
    };
    
    /*element.loaded=function(e){
        this.icons=e.result.children[0].children;
    }*/
    
    element.getIcon=function(n) {
        var name=n;
        var icon = null;
        if(this.icons){
            name=name.split(".");
            name=name[name.length-1];
            icon = new facilis.Sprite(this.icons);
            if(IconManager.frameIndexes[name]){
                icon.gotoAndStop(IconManager.frameIndexes[name]);
            }else{
                console.log("Error no existe el icono : "+name);
                //throw new Error("Error no existe el icono : "+name);
                icon.gotoAndStop(0);
            }
        }

        return icon;
    }
    
    
    
    
    IconManager.defs={"frames": {

"AdhocProcess":
{
	"frame": {"x":0,"y":0,"w":20,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":20,"h":21},
	"sourceSize": {"w":20,"h":21}
},
"Cancel":
{
	"frame": {"x":22,"y":0,"w":17,"h":17},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":17,"h":17},
	"sourceSize": {"w":17,"h":17}
},
"CollapsedIcon":
{
	"frame": {"x":41,"y":0,"w":21,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":21,"h":21},
	"sourceSize": {"w":21,"h":21}
},
"Compensation":
{
	"frame": {"x":64,"y":0,"w":14,"h":17},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":14,"h":17},
	"sourceSize": {"w":14,"h":17}
},
"ComplexGateway":
{
	"frame": {"x":80,"y":0,"w":17,"h":18},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":17,"h":18},
	"sourceSize": {"w":17,"h":18}
},
"Conditional":
{
	"frame": {"x":99,"y":0,"w":17,"h":17},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":17,"h":17},
	"sourceSize": {"w":17,"h":17}
},
"EmbeddedProcess":
{
	"frame": {"x":0,"y":23,"w":20,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":20,"h":21},
	"sourceSize": {"w":20,"h":21}
},
"Error":
{
	"frame": {"x":22,"y":23,"w":19,"h":20},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":19,"h":20},
	"sourceSize": {"w":19,"h":20}
},
"EventBasedGateway":
{
	"frame": {"x":43,"y":23,"w":20,"h":20},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":20,"h":20},
	"sourceSize": {"w":20,"h":20}
},
"ExclusiveGateway":
{
	"frame": {"x":65,"y":23,"w":15,"h":15},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":15,"h":15},
	"sourceSize": {"w":15,"h":15}
},
"InclusiveGateway":
{
	"frame": {"x":82,"y":23,"w":20,"h":20},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":20,"h":20},
	"sourceSize": {"w":20,"h":20}
},
"Link":
{
	"frame": {"x":104,"y":23,"w":13,"h":17},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":13,"h":17},
	"sourceSize": {"w":13,"h":17}
},
"Message":
{
	"frame": {"x":0,"y":46,"w":18,"h":16},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":18,"h":16},
	"sourceSize": {"w":18,"h":16}
},
"MessageFilled":
{
	"frame": {"x":20,"y":46,"w":18,"h":15},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":18,"h":15},
	"sourceSize": {"w":18,"h":15}
},
"Multiple":
{
	"frame": {"x":40,"y":46,"w":21,"h":19},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":21,"h":19},
	"sourceSize": {"w":21,"h":19}
},
"MultipleFilled":
{
	"frame": {"x":63,"y":46,"w":21,"h":19},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":21,"h":19},
	"sourceSize": {"w":21,"h":19}
},
"ParallelGateway":
{
	"frame": {"x":86,"y":46,"w":17,"h":17},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":17,"h":17},
	"sourceSize": {"w":17,"h":17}
},
"Permited":
{
	"frame": {"x":105,"y":46,"w":18,"h":18},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":18,"h":18},
	"sourceSize": {"w":18,"h":18}
},
"ReferenceProcess":
{
	"frame": {"x":85,"y":67,"w":20,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":20,"h":21},
	"sourceSize": {"w":20,"h":21}
},
"ReusableProcess":
{
	"frame": {"x":0,"y":67,"w":20,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":20,"h":21},
	"sourceSize": {"w":20,"h":21}
},
"Signal":
{
	"frame": {"x":22,"y":67,"w":16,"h":16},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":16,"h":16},
	"sourceSize": {"w":16,"h":16}
},
"TaskManual":
{
	"frame": {"x":40,"y":67,"w":21,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":21,"h":21},
	"sourceSize": {"w":21,"h":21}
},
"TaskReceive":
{
	"frame": {"x":63,"y":67,"w":20,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":20,"h":21},
	"sourceSize": {"w":20,"h":21}
},
"TaskReference":
{
	"frame": {"x":85,"y":67,"w":20,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":20,"h":21},
	"sourceSize": {"w":20,"h":21}
},
"TaskScript":
{
	"frame": {"x":107,"y":67,"w":21,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":21,"h":21},
	"sourceSize": {"w":21,"h":21}
},
"TaskSend":
{
	"frame": {"x":0,"y":90,"w":20,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":20,"h":21},
	"sourceSize": {"w":20,"h":21}
},
"TaskService":
{
	"frame": {"x":22,"y":90,"w":20,"h":21},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":20,"h":21},
	"sourceSize": {"w":20,"h":21}
},
"TaskUser":
{
	"frame": {"x":44,"y":90,"w":21,"h":22},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":21,"h":22},
	"sourceSize": {"w":21,"h":22}
},
"Terminate":
{
	"frame": {"x":67,"y":90,"w":14,"h":15},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":14,"h":15},
	"sourceSize": {"w":14,"h":15}
},
"Timer":
{
	"frame": {"x":83,"y":90,"w":18,"h":19},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":18,"h":19},
	"sourceSize": {"w":18,"h":19}
}},
"meta": {
	"app": "Adobe Flash Professional",
	"version": "14.1.0.96",
	"image": "Icons.png",
	"format": "RGBA8888",
	"size": {"w":128,"h":128},
	"scale": "1"
}
};
    

    facilis.IconManager = facilis.promote(IconManager, "Object");
    
}());

(function() {

    function AbstractElement() {
        this.BaseElement_constructor();
        
        this._selected=false;
        this._elementType=null;
        this.data=null;

        this.setup();
    }
    
    facilis.EventDispatcher.initialize(AbstractElement.prototype);
    
    AbstractElement.lineWidth				= 1.4;
    AbstractElement.color					= "#AACCFF";
    AbstractElement.lineColor				= "#666666";

    AbstractElement.ELEMENT_CLICK		     = "onElementClick";
    AbstractElement.ELEMENT_CLICKED			 = "onElementClicked";
    AbstractElement.ELEMENT_OVER			 = "onElementOver";
    AbstractElement.ELEMENT_OUT				 = "onElementOut";
    AbstractElement.ELEMENT_DROP 			 = "onElementDrop";
    AbstractElement.ELEMENT_DROPIN			 = "onElementDropIn";
    AbstractElement.ELEMENT_DROPOUT			 = "onElementDropOut";
    AbstractElement.ELEMENT_MOVED			 = "onElementMoved";
    AbstractElement.ELEMENT_MOVE_END		 = "onElementMovedEnd";
    AbstractElement.ELEMENT_ADDED			 = "onElementAdded";
    AbstractElement.ELEMENT_DELETE			 = "onElementDelete";
    AbstractElement.ELEMENT_DELETED			 = "onElementDeleted";
    AbstractElement.ELEMENT_DRAGGED			 = "onElementDragged";
    AbstractElement.ELEMENT_DOUBLE_CLICKED	 = "onElementDoubleClicked";
    AbstractElement.ELEMENT_SELECTED		 = "onElementSelected";
    AbstractElement.ELEMENT_UNSELECTED		 = "onElementUnselected";
    
    
    var element = facilis.extend(AbstractElement, facilis.BaseElement);

    element.setup = function() {
        
        this.addEventListener("click", this.onClicked.bind(this));
        this.addEventListener("mousedown", this.onClick.bind(this));
        this.addEventListener("rollover", this.onMouseOver.bind(this));
        this.addEventListener("rollout", this.onMouseOut.bind(this));
        this.addEventListener("dblclick", this.onDoubleClick.bind(this)); 
        
        this.cursor = "pointer";
        
        this.offset = Math.random()*10;
        this.count = 0;
    } ;

    element.onClicked = function (event) {
        event.stopPropagation();
        this.dispatchMouseEvent(facilis.AbstractElement.ELEMENT_CLICKED,event);
    };
    
    element.onClick = function (event) {
        event.stopPropagation();
        this.dispatchMouseEvent(facilis.AbstractElement.ELEMENT_CLICK,event);
    };
    
    element.onMouseOver = function (event) {       
        event.stopPropagation();
        this.dispatchMouseEvent(facilis.AbstractElement.ELEMENT_OVER,event);
    };
    
    element.onMouseOut = function (event) {
        event.stopPropagation();
        this.dispatchMouseEvent(facilis.AbstractElement.ELEMENT_OUT,event);
    };
    
    element.onDoubleClick = function (event) {
        event.stopPropagation();
        this.dispatchMouseEvent(facilis.AbstractElement.ELEMENT_DOUBLE_CLICKED,event);
    };
    
    element.dispatchMouseEvent=function(name,evt){
        var event=new facilis.Event(name);
        event.x=evt.rawX;
        event.y=evt.rawY;
        event.localX=evt.rawX;
        event.localY=evt.rawY;
        event.stageX=evt.stageX;
        event.stageY=evt.stageY;
        
        this.dispatchEvent(event);
    }
    
    element.removeMe=function() {
        if(!this._removed){
            /*var removeMe = function() {
                this.parent.removeChild(this);
            }
            if(this.width>View.getInstance().getStageWidth() || this.height>View.getInstance().getStageHeight()){*/
                this.parent.removeChild(this);
            /*}else {
                Tweener.addTween(this, { alpha:0, time:.5, transition:"easeInOutBounce", onComplete:removeMe } );
            }*/
        }
    }
    
    element.select=function() {
        this._selected = true;
        this.shadow = new facilis.Shadow("#00FF00", 0, 0, 15);
        
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_SELECTED));
    }

    element.unselect=function() {
        if (this._selected) {
            this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_UNSELECTED));
        }
        this._selected = false;
        this.shadow = null;
        /*this.filters = [];
        var b=this.getBounds();
        //this.cache(-10, -10, 100, 100);*/
    }
    
    element.appear=function() {
        //this.alpha = 0;
        //Tweener.addTween(this, { alpha:1, time:0, transition:"easeOutInBounce"} );
        //facilis.Tween.get(this, {override:true}).to({ alpha: 1 }/*, 1000, facilis.Ease.getPowInOut(4) );*/
    }

    element.LocalhitTest=function(x,y){
        if(this.hitTest(x,y))
            return true;
        
        var p={};
        for (var i = 0; i < this.numChildren;i++ ) {
            var el = this.getChildAt(i);
            el.globalToLocal(x,y,p);
            if(el.hitTest(p.x,p.y))
                return true;
        }
        return false;
    }
    
    element.hitTestMe=function(e) {

    }
    
    element.hitTestObject=function(el){
        //if ( this.x >= el.x + el.width || this.x + this.width <= el.x || this.y >= el.y + el.height || this.y + this.height <= el.y ) 
		if ( this.x >= el.x + el._width || this.x + this._width <= el.x || this.y >= el.y + el._height || this.y + this._height <= el.y ) 
            return false;
    
        return true;
    }
    
    element.hitTestBase=element.hitTest;
    
    element.hitTest=function(x,y){
        return this.hitTestBase(x,y);
    }

    
    /*element.listeners = {};
    element.addListener=function(type, listener) {
        var list = this.listeners[type];
        if (!list) {
            list = [];
            this.listeners[type] = list;
        }
        list.push(listener);
    }

    element.removeListener=function(type, listener) {
        var list = this.listeners[type];
        if (list) {
            for (var i = 0; i < list.length; i++ ) {
                if (list[i]==listener) {
                    list.splice(i, 1);
                }
            }
            if (list.length==0) {
                this.listeners[type] = null;
            }
        }
    }
    
    element.__addEventListener=element.addEventListener;
    element.addEventListener=function(type, listener, useCapture, priority, useWeakReference) {
        //this.addListener(type, listener);
        this.__addEventListener(type, listener, useCapture, priority, useWeakReference);
    }
    
    element.__removeEventListener=element.removeEventListener;
    element.removeEventListener=function(type, listener, useCapture) {
        //this.removeListener(type, listener);
        this.__removeEventListener(type, listener, useCapture);
    }*/

    element.removeEventListeners=function(type) {
        this.removeAllEventListeners(type);
    }
    
    element.removeAllEventListenersFrom=function(eventType) {
        this.removeAllEventListeners(eventType);
    }
    
    facilis.AbstractElement = facilis.promote(AbstractElement, "BaseElement");
    
}());

(function() {

    function SizableElement() {
        this.BaseElement_constructor();
        
        /*this.tickEnabled=false;
        this.tickChildren=false;*/
        
        this.__width =0;
		this.__height  = 0;
		
		this._minWidth  = 0;
		this._minHeight  = 0;
        
        this.cacheThreshold=20;
		
        this.setup();
    }
    
    var element = facilis.extend(SizableElement, facilis.BaseElement);

    element.setup = function() {
        this.addEventListener("changed",this.childrenChanged.bind(this));
    };
    
    element.getRealHeight=function() {
        return parseInt(this.__height);
    };

    element.getRealWidth=function() {
        return parseInt(this.__width);
    };
    
    element.getCachedArea=function() {
        return { x:-this.cacheThreshold,y:-this.cacheThreshold,width:this._width+this.cacheThreshold+50,height:this._height+this.cacheThreshold+50 };
    };
    
    element.setCached=function(cached){
        this._cached=cached;
        this.uncache();
        if(cached){ 
            var a=this.getCachedArea();
            this.cache(a.x,a.y,a.width,a.height);
        }
        this.refreshCache();
    };
    
    element.refreshCache=function(){
        if(this._cached)
            this.updateCache();
    };
    
    element.childrenChanged=function(e){
        this.refreshCache();
    };

    Object.defineProperty(element, '_height', {
        get: function() { return this.__height; },
        set: function(newValue) { this.__height = parseInt(newValue);}
    });
    
    Object.defineProperty(element, '_width', {
        get: function() { return this.__width; },
        set: function(newValue) { this.__width = parseInt(newValue);}
    });
    
    Object.defineProperty(element, 'minHeight', {
        get: function() { return this._minHeight; },
        set: function(newValue) { this._minHeight = parseInt(newValue); }
    });
    
    Object.defineProperty(element, 'minWidth', {
        get: function() { return this._minWidth; },
        set: function(newValue) { this._minWidth = parseInt(newValue); }
    });

    
    facilis.SizableElement = facilis.promote(SizableElement, "BaseElement");
    
}());

(function() {

    function Drag() {
        this.AbstractElement_constructor();
        
        this.moving = false;
		
        this._startX = 0;
        this._startY = 0;
        
        this._startLocalX = 0;
        this._startLocalY = 0;
        
        this._stage=null;
        this._center = false;
        
		this._dragBoundaries = null;
    
    }
    
    var element = facilis.extend(Drag, facilis.AbstractElement);
    
    Drag.DRAG_EVENT				 = "drag";
    Drag.STOP_EVENT				 = "stop";
    Drag.RESET_EVENT			 = "resetStart";

    Drag.dragDisable             = false;



    element.AbstractElementSetup=element.setup;
    element.setup = function() {
        this.AbstractElementSetup();
        
        this.addEventListener("pressmove", this.pressMove.bind(this));
        //this.addEventListener("mouseup", this.onMouseUp);
        //this.addEventListener("added", this.addedToStage);
        
    };
    
    this.addedToStage=function(e) {
        this._stage = this.stage;
        this.removeEventListener("added", this.addedToStage);
    }
    
    
    element.pressMove=function(e) {
        var el = e.currentTarget;
        if(!Drag.dragDisable){
            if (!el.moving) {
                el._startX = Math.round(el.x);
                el._startY = Math.round(el.y);
                el._startLocalX = Math.round(e.localX);
                el._startLocalY = Math.round(e.localY);
                el.removeListenersUp();
                el.addEventListener("pressup", el.pressUp.bind(this));
            }
            
            var p={};
            el.parent.globalToLocal(e.stageX,e.stageY,p);
            
            /*el.x = e.stageX-el._startLocalX;
            el.y = e.stageY-el._startLocalY;*/
            
            el.x = Math.round(p.x-el._startLocalX);
            el.y = Math.round(p.y-el._startLocalY);
            
            el.moving = true;
            /*if(!_stage){
                _stage = this.stage;
            }*/
            

            //this.startDrag(center);
            //this.startDrag(this.center, this.getDragLimits());
            
            el.parent.setChildIndex(el, el.parent.numChildren-1);
            this.dispatchEvent(new facilis.Event(facilis.Drag.DRAG_EVENT));
            //this.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
        }
        e.stopPropagation();
    }
    element.pressUp=function(e) {
        var el = e.currentTarget;
        if(!Drag.dragDisable){
            //el.stopDrag();
            el.dispatchEvent(new facilis.Event(Drag.DRAG_EVENT));
            el.dispatchEvent(new facilis.Event(Drag.STOP_EVENT));
        }
        if(el.moving){
            el.moving = false;
        }
        el.removeListenersUp();

        el._startX = el.x;
        el._startY = el.y;

        e.stopPropagation();
        if(el.moving){
            el.moving = false;
        }
    }
    
    element.removeListenersUp=function () {
        this.removeEventListener("pressup", this.pressUp.bind(this));
    }

    

    element.moveX=function (_x) {
        this.x = this._startX +_x;
    }

    element.moveY=function (_y) {
        this.y = this._startY +_y;
    }

    element.resetStart=function () {
        _startX = this.x;
        _startY = this.y;
        this.dispatchEvent(new facilis.Event(Drag.RESET_EVENT));
    }

    element.moveTo=function(_x,_y) {
        this.x = _x;
        _startX = _x;
        this.y = _y;
        _startY = _y;
    }

    element.getDragLimits=function() {
        var rx = this.width / 2;
        var ry = this.height / 2;
        var w = this.stage.stageWidth - rx;
        var h = this.stage.stageHeight - ry;

        w += this.width;
        h += this.height;

        var p = new facilis.Point(w, h);
        p = this.parent.globalToLocal(p);
        w = p.x;
        h = p.y;
        var rect = new facilis.Rectangle(rx, ry, w, h);
        return rect;
    }
    
    Object.defineProperty(element, 'movedX', {
        get: function() { return this.x-this._startX; }
    });
    
    Object.defineProperty(element, 'movedY', {
        get: function() { return this.y-this._startY; }
    });
    
	Object.defineProperty(element, 'dragBoundaries', {
        set: function(newValue) { 
			if(newValue==null || newValue instanceof facilis.Rectangle)
				this._dragBoundaries = newValue; 
		
		}
    });
	
    /*element.baseX=element.x;
    element.x=null;*/
    Object.defineProperty(element, 'x', {
        get: function() { return this.baseX; },
        set: function(newValue) { 
			if(!this._dragBoundaries || 
			  (this._dragBoundaries && this._dragBoundaries.contains(new facilis.Point(newValue,this._dragBoundaries.y))) ){
				this.baseX = newValue;
				this._startX = newValue; 
			}
        }
    });
    
    /*element.baseY=element.y;
    element.y=null;*/
    Object.defineProperty(element, 'y', {
        get: function() { return this.baseY; },
        set: function(newValue) { 
			if(!this._dragBoundaries || 
			  (this._dragBoundaries && this._dragBoundaries.contains(new facilis.Point(this._dragBoundaries.x,newValue))) ){
				this.baseY = newValue;
				this._startY = newValue; 
			 }
        }
    });
    
    Object.defineProperty(element, 'center', {
        get: function() { return this._center; },
        set: function(newValue) { this._center = newValue; }
    });
    

    facilis.Drag = facilis.promote(Drag, "AbstractElement");
    
}());

(function() {

    function Sizer() {
        this.Drag_constructor();
        
        this._sizerRectangle=null;
        
        this.radio=2;
        
        this.width=5;
        this.height=5;
        
    }
    
    var element = facilis.extend(Sizer, facilis.Drag);

    element.DragSetup=element.setup;
    element.setup = function() {
        this.DragSetup();
        var graphics = new facilis.Graphics();
        graphics.beginFill("#AAAAAA",0);			
        graphics.drawRect(0,0, 5, 5);
        graphics.endFill();
        graphics.lineStyle(1,"#000000");
        graphics.beginFill("#AAAAAA");			
        graphics.drawCircle( this.radio, this.radio, this.radio);
        graphics.endFill();
        this.addShape(new facilis.Shape(graphics));
    };
    
    element.mouseDown=function(e) {
        var el = e.currentTarget;
        if(!Drag.dragDisable){
            if (!moving) {
                _startX = this.x;
                _startY = this.y;
            }
            moving = true;
            /*if(!_stage){
                _stage = this.stage;
            }*/
            /*_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
            _stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
            this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);*/
            this.startDrag(center,_sizerRectangle);
            this.parent.setChildIndex(this, this.parent.numChildren-1);
            //this.dispatchEvent(new facilis.Event("drag"));
            e.stopPropagation();
        }
    }
    
    /*element.baseHeight=element.height;
    Object.defineProperty(element, 'height', {
        get: function() { return (element.baseHeight || (this.radio*2)); },
        set: function(newValue) { this.baseHeight = newValue; }
    });
    
    element.baseWidth=element.width;
    Object.defineProperty(element, 'width', {
        get: function() { return (element.baseWidth || (this.radio*2)); },
        set: function(newValue) { this.baseWidth = newValue; }
    });*/

    Object.defineProperty(element, 'boundaries', {
        set: function(newValue) { 
			this._sizerRectangle = newValue;
			this.dragBoundaries = newValue;
		}
    });
    
    facilis.Sizer = facilis.promote(Sizer, "Drag");
    
}());

(function() {

    function Sizable() {
        this.BaseElement_constructor();
        
        this.sizeNW=null;
		this.sizeNE=null;
		this.sizeSW=null;
		this.sizeSE=null;
		this.sizers=null;
		
		this._width=0;
		this._height=0;
		
		this._xDifference = 0;
		this._yDifference = 0;
		
		this._xStart = 0;
		this._yStart = 0;
		this._sizing = false;
		
		this.__minWidth=0;
		this.__minHeight = 0;
		
		this._sizableElement=null;
        
        this.setup();
    }
    
    Sizable.RESIZE_EVENT				 = "resize";
    Sizable.RESIZE_COMPLETE_EVENT		 = "resizeComplete";
    
    var element = facilis.extend(Sizable, facilis.Drag);

    element.DragSetup=element.setup;
    element.setup = function() {
        this.DragSetup();
    };
    
    
    element.setSizableElement=function(toSize) {
        if (!toSize || !(toSize instanceof facilis.SizableElement))
            throw Error("Object must be facilis.SizableElement");
            
        this._sizableElement = toSize;
        this._sizableElement.x = 0;
        this._sizableElement.y = 0;
        this.addChild(this._sizableElement);
        this._width = this._sizableElement.width;
        this._height = this._sizableElement.height;
        try {
            this._width = (this._sizableElement).getRealWidth();
            this._height = (this._sizableElement).getRealHeight();
        }catch (e) {

        }
        this.updateSizablePosition();
        this.addEventListener(facilis.AbstractElement.ELEMENT_OVER, this.enableSizers.bind(this));
        this.addEventListener(facilis.AbstractElement.ELEMENT_OUT, this.disableSizers.bind(this));

        //this.addEventListener("added", this.addedToStage.bind(this));
        this.addedToStage(null);
        this.addEventListener(facilis.Drag.STOP_EVENT,this.onDragged.bind(this));
    }

    element.onDragged=function(e) {
        this.updateMinSize();
    }

    element.getElement=function() {
        return this._sizableElement;
    }

    element.startSizers=function() {
        this.sizers = new facilis.BaseElement();
        this.addChild(this.sizers);
        this.sizeNE = new facilis.Sizer();
        this.sizeNW = new facilis.Sizer();
        this.sizeSE = new facilis.Sizer();
        this.sizeSW = new facilis.Sizer();
        this.sizers.addChild(this.sizeNE);
        this.sizers.addChild(this.sizeNW);
        this.sizers.addChild(this.sizeSE);
        this.sizers.addChild(this.sizeSW);

        this.initSizers();

        /*this.sizeNE.addEventListener(facilis.Drag.DRAG_EVENT, this.onSizerDrag.bind(this));
        this.sizeNE.addEventListener(facilis.Drag.STOP_EVENT, this.onSizerStop.bind(this));
        this.sizeNW.addEventListener(facilis.Drag.DRAG_EVENT, this.onSizerDrag.bind(this));
        this.sizeNW.addEventListener(facilis.Drag.STOP_EVENT, this.onSizerStop.bind(this));
        this.sizeSE.addEventListener(facilis.Drag.DRAG_EVENT, this.onSizerDrag.bind(this));
        this.sizeSE.addEventListener(facilis.Drag.STOP_EVENT, this.onSizerStop.bind(this));
        this.sizeSW.addEventListener(facilis.Drag.DRAG_EVENT, this.onSizerDrag.bind(this));
        this.sizeSW.addEventListener(facilis.Drag.STOP_EVENT, this.onSizerStop.bind(this));*/
        
        this.sizeNE.addEventListener(facilis.AbstractElement.ELEMENT_CLICK, this.setDragEvents.bind(this));
        this.sizeNW.addEventListener(facilis.AbstractElement.ELEMENT_CLICK, this.setDragEvents.bind(this));
        this.sizeSE.addEventListener(facilis.AbstractElement.ELEMENT_CLICK, this.setDragEvents.bind(this));
        this.sizeSW.addEventListener(facilis.AbstractElement.ELEMENT_CLICK, this.setDragEvents.bind(this));

    }
    
    element.setDragEvents=function(e){
        e.target.addEventListener(facilis.Drag.DRAG_EVENT, this.onSizerDrag.bind(this));
        e.target.addEventListener(facilis.Drag.STOP_EVENT, this.onSizerStop.bind(this));
    }
    
    element.removeDragEvents=function(e){
        e.target.removeEventListener(facilis.Drag.DRAG_EVENT, this.onSizerDrag.bind(this));
        e.target.removeEventListener(facilis.Drag.STOP_EVENT, this.onSizerStop.bind(this));
    }

    element.initSizers=function() {
        this.positionSizer(this.sizeNE,this._width/2,-this._height/2);
        this.positionSizer(this.sizeNW,-this._width/2,-this._height/2);
        this.positionSizer(this.sizeSE,this._width/2,this._height/2);
        this.positionSizer(this.sizeSW, -this._width / 2, this._height / 2);
        this.updateMinSize();
    }


    element.onSizerDrag=function(e) {
        /*
        problema de performance
        this.dispatchEvent(new facilis.Event(Sizable.RESIZE_EVENT));*/
        this.updateSizerPos(e.currentTarget);
    }

    element.onSizerStop=function(e) {
        this.removeDragEvents(e);
        this.updateSizerPos(e.currentTarget);
        this._sizing = false;
        this._width = this._sizableElement._width;
        this._height = this._sizableElement._height;
        this.x -= ((this._xStart - e.target.x)/2);
        this.y -= ((this._yStart - e.target.y)/2);
        this.updateSizablePosition();
        this.initSizers();
        this.dispatchEvent(new facilis.Event(facilis.Sizable.RESIZE_EVENT));
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROP));
        this.dispatchEvent(new facilis.Event(facilis.Sizable.RESIZE_COMPLETE_EVENT));
    }

    element.updateSizerPos=function(sizer) {
        if (!this._sizing) {
            this._xStart = sizer.x;
            this._yStart = sizer.y;
        }
        this._sizing = true;
        var xPeer;
        var yPeer;
        if (sizer==this.sizeNW) {
            xPeer = this.sizeSW;
            yPeer = this.sizeNE;
        }else if (sizer==this.sizeNE) {
            xPeer = this.sizeSE;
            yPeer = this.sizeNW;
        }else if (sizer== this.sizeSW) {
            xPeer = this.sizeNW;
            yPeer = this.sizeSE;
        }else {
            xPeer = this.sizeNE;
            yPeer = this.sizeSW;
        }
        xPeer.x = sizer.x;
        yPeer.y = sizer.y;
        this.changeSize( Math.abs(yPeer.x - sizer.x) , Math.abs(xPeer.y - sizer.y));
        var positionerX = this.sizeNW;
        var positionerY = this.sizeNW;
        if (positionerX.x > this.sizeNE.x) {
            positionerX = this.sizeNE;
        }
        if (positionerY.y > this.sizeSW.y) {
            positionerY = this.sizeSW;
        }
        this._sizableElement.x = (positionerX.x + (positionerX.width/2));
        this._sizableElement.y = (positionerY.y + (positionerY.height / 2));

        //this.dispatchEvent(new facilis.Event("resize"));
    }

    element.updateSizablePosition=function() {
        this._sizableElement.x = -this._width / 2;
        this._sizableElement.y = -this._height / 2;
    }

    element.positionSizer=function(sizer,x,y) {
        sizer.x = x-(sizer.width/2);
        sizer.y = y-(sizer.height/2);
    }

    element.changeSize=function(width, height) {
        this._sizableElement.setSize(width, height);
    }

    element.showSizers=function() {
        this.sizers.visible = true;
    }

    element.hideSizers=function() {
        this.sizers.visible = false;
    }

    element.setSize=function(w, h) {
        this.dispatchEvent(new facilis.Event(Sizable.RESIZE_EVENT));
        var auxX = this.x;
        var auxY = this.y;
        this._width = w;
        this._height = h;
        this._sizableElement.setSize(w, h);
        this._sizableElement.x = -(this._width/2);
        this._sizableElement.y = -(this._height/2);
        this.initSizers();
        this.x = auxX;
        this.y = auxY;
        this.dispatchEvent(new facilis.Event(Sizable.RESIZE_COMPLETE_EVENT));
    }

    element.enableSizers=function(e) {
        /*Tweener.addTween(sizeNE,{alpha:1,time:.5,transition:"easeInQuart"});
        Tweener.addTween(sizeNW,{alpha:1,time:.5,transition:"easeInQuart"});
        Tweener.addTween(sizeSE,{alpha:1,time:.5,transition:"easeInQuart"});
        Tweener.addTween(sizeSW,{alpha:1,time:.5,transition:"easeInQuart"});*/
    }

    element.disableSizers=function(e) {
        /*Tweener.addTween(sizeNE,{alpha:0,time:.5,transition:"easeOutQuart"});
        Tweener.addTween(sizeNW,{alpha:0,time:.5,transition:"easeOutQuart"});
        Tweener.addTween(sizeSE,{alpha:0,time:.5,transition:"easeOutQuart"});
        Tweener.addTween(sizeSW,{alpha:0,time:.5,transition:"easeOutQuart"});*/
    }

    element.getElementWidth=function() {
        return _sizableElement.width;
    }

    element.getElementHeight=function() {
        return this._sizableElement.height;
    }

    element.getRealHeight=function() {
        return this._height;
    }

    element.getRealWidth=function() {
        return this._width;
    }

    element._added = false;
    element.addedToStage=function(e) {
        this._added = true;
        this.startSizers();
        this.removeEventListener("added", this.addedToStage);
        this.updateMinSize();
    }

    element.updateMinSize=function() {
        if (this._added && this._sizableElement instanceof facilis.SizableElement) {
            if (this._sizableElement.minHeight != 0 && this._sizableElement.minWidth != 0) {
                var maxHW = 10000;
                var minWidth = this._sizableElement.minWidth;
                var minHeight = this._sizableElement.minHeight;

                var yTL = this.y - (this.getRealHeight() / 2);
                var xTL = this.x - (this.getRealWidth() / 2);

                var nwP = new facilis.Point(-10, -10);
                var neP = new facilis.Point((minWidth + xTL), -10);
                var swP = new facilis.Point( -10, ( yTL + minHeight ) );
                var seP = new facilis.Point((minWidth + xTL),  (yTL + minHeight));

                this.parent.localToGlobal(nwP.x,nwP.y,nwP);
                this.parent.localToGlobal(neP.x,neP.y,neP);
                this.parent.localToGlobal(swP.x,swP.y,swP);
                this.parent.localToGlobal(seP.x,seP.y,seP);

                this.sizeNW.parent.globalToLocal(nwP.x,nwP.y,nwP);
                this.sizeNE.parent.globalToLocal(neP.x,neP.y,neP);
                this.sizeSW.parent.globalToLocal(swP.x,swP.y,swP);
                this.sizeSE.parent.globalToLocal(seP.x,seP.y,seP);

                this.sizeNW.boundaries = new facilis.Rectangle( nwP.x, nwP.y, ( (xTL + this._width) - minWidth), ((yTL + this._height) - minHeight ) );
                this.sizeNE.boundaries = new facilis.Rectangle(neP.x, neP.y, maxHW, (( (yTL + this._height) - minHeight ) )  );

                this.sizeSW.boundaries = new facilis.Rectangle( swP.x, swP.y,  (( (xTL + this._width) - minWidth)), maxHW );
                this.sizeSE.boundaries = new facilis.Rectangle(seP.x, seP.y, maxHW, maxHW  );
            }
        }
    }

    element.centerSizableElement=function() {
        var p = new facilis.Point(this._sizableElement.x, this._sizableElement.y);
        this.localToGlobal(p.x,p.y,p);
        this._sizableElement.x = this.getRealWidth() / -2;
        this._sizableElement.y = this.getRealHeight() / -2;
        this.parent.globalToLocal(p.x,p.y,p);
        this.x = p.x+(this.getRealWidth() / 2);
        this.y = p.y + (this.getRealHeight() / 2);
        this.updateMinSize();
        this.dispatchEvent(new facilis.Event(facilis.Sizable.RESIZE_EVENT));
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROP));
    }

    
    

    facilis.Sizable = facilis.promote(Sizable, "Drag");
    
}());

(function() {

    function Element(elementClass) {
        this.Sizable_constructor();
        
        this.elementClass=elementClass;
        
        this._sizableEnabled = true;
		
		this.contents=[];
		
		this.container=null;
		this.elementId=null;

        //this.setup();
        this.addEventListener("added",function(e){
            e.target.AddedSetup();
        });
    }
    
    //static public//
    
    
    var element = facilis.extend(Element, facilis.Sizable);
    
    //element.SizableSetup=element.setup;
    element.AddedSetup = function() {
        //this.SizableSetup();
        
        var sizableEl = new this.elementClass();//MovieClip(new (LibraryManager.getInstance().getClass(className) as Class) as MovieClip);
        try{
            this._sizableEnabled = sizableEl.sizable;
        }catch (e) {
            this._sizableEnabled = true;
        }
        this.setSizableElement(sizableEl);
        if(!this._sizableEnabled){
            this.hideSizers();
        }

        this.addEventListener(facilis.Drag.DRAG_EVENT, this.onElementMoved.bind(this));
        this.addEventListener(facilis.Drag.STOP_EVENT, this.onDrop.bind(this));
        //this.addEventListener(facilis.Drag.STOP_EVENT, this.onElementMoveEnd.bind(this));
        this.addEventListener(facilis.Sizable.RESIZE_EVENT, this.onElementMoved.bind(this));
        this.addEventListener(facilis.Sizable.RESIZE_EVENT, this.onResizeDrop.bind(this));
        this.addEventListener(facilis.AbstractElement.ELEMENT_OUT, this.onOut.bind(this));
        //this.cache((-sizableEl._width-10)/2,(-sizableEl._height-10)/2,(sizableEl._width+10)/2,(sizableEl._height+10)/2);
        //this.cache(sizableEl.x-20,sizableEl.y-20,sizableEl._width+20,sizableEl._height+20);
    };
    
    
    
    
    element.testCrash=function(el1, el2) {
        if((el1.elementType=="task" && el2.elementType=="pool")|| (el2.elementType=="task" && el1.elementType=="pool")){
            trace("hitTestMe " + el1.elementType + ": " + el1.getRealWidth() + " " + el1.getRealHeight() +" " + el1.x + " " + el1.y + " ---> " + el2.elementType + ": " + el2.getRealWidth() + " " + el2.getRealHeight() +" " + el2.x + " " + el2.y  );
        }
        if ((el1.x > el2.x && el2.x<(el1.x + el1.getRealWidth())) ||
        (el2.x > el1.x && el1.x<(el2.x + el2.getRealWidth()))){
            if ((el1.y > el2.y && el2.y<(el1.y + el1.getRealHeight())) ||
            (el2.y > el1.y && el1.x<(el2.y + el2.getRealHeight()))) {
                return true;
            }
        }
        return false;
    }

    element.hitTestMe=function(e) {
        var el = (e.target).dispatcher;
        //testCrash(el, this);
        this.resetStart();
        if (this.containsContent(el)) {
            return;
        }
        
        var dropOut = (el.hitTest(this) && (facilis.validation.RuleManager.getInstance().checkDropRule([el, this])));
        var dropIn = (this.hitTest(el) && facilis.validation.RuleManager.getInstance().checkDropRule([this, el]));
        var i;
        if (dropIn ) {
            i = 0;
            this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROPIN));
        }else if (el.isInsideMe(this) && dropOut && !this.container) {
            if (!el.containsContent(this)) {
                this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROPOUT));
            }
        }
    }

    element.hitTest=function(el) {
        if (el && el != this && el.parent) {
            if (( (!this.getElement().hitArea && this.hitTestObject(el) && !( this.hitTestContents(el)) && this.isInsideMe(el) ) 
            )) {
                return true;
            }else if (this.getElement().hitArea && el.getElement() && el.elementType=="middleevent") {
                return HitTest.complexHitTestObject(this.getElement().hitArea, el.getElement(),10);
            }
        }
        return false;
    }

    element.hitTestContents=function(el) {
        for (var i = 0; i < this.contents.length; i++ ) {
            var content = this.contents[i];
            if (content.hitTest(el)  && (facilis.validation.RuleManager.getInstance().checkDropRule([el, content])) ) {
                return true;
            }
        }
        return false;
    }

    element.isInsideMe=function(el) {
        if (!this.getElement().hitArea) {
            var thisX = this.x - (this.width / 2);
            var thisY = this.y - (this.height / 2);
            var elX = el.x - (el.getRealWidth() / 2);
            var elY = el.y - (el.getRealHeight() / 2);
            var thisP = new facilis.Point(thisX, thisY);
            var elP = new facilis.Point(elX, elY);
            if ((this.width > el.getRealWidth() && this.height > el.getRealHeight()) &&
            ((el.getRealWidth() + elX) < (this.width + thisX) && (el.getRealHeight() + elY) < (this.height + thisY)) &&
            ( elX>thisX && elY>thisY )
            ) {
                return true;
            }
        }
        return false;
    }

    element.remove=function() {
        if(this.parent){
            this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DELETE));
            if (this.getContainer()) {
                this.getContainer().removeContent(this);
            }
            var toDel = [];
            for (var i = 0; i < this.contents.length; i++ ) {
                if (!isInnerElement(this, this.contents[i])) {
                    toDel.push(this.contents[i]);
                }
            }
            while (toDel.length > 0) {
                toDel[0].remove();
                toDel.splice(0, 1);
            }
            removeInnerElements();
            View.getInstance().removeAnElement(this);
            this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DELETED));
        }
    }

    element.removeInnerElements=function() {
        try{
            var dropin = this.getElement();
            var inner = dropin.getInnerElements();
            for (var i = inner.length-1; i > -1; i-- ) {
                inner[i].remove();
            }
        }catch (e) {}
    }

    element.onResizeDrop=function(e) {
        //for (var i = 0; i < contents.length; i++ ) {
        var i = this.contents.length;
        while(i>0) {
            /*if ( !this.hitTest(contents[i]) ) {
                var el = (contents[i]);
                el.setContainer(null);
                el.setAlpha(1);
            }*/
            i--;
            if ( !this.hitTest(this.contents[i]) ) {
                var el = (this.contents[i]);
                //this.contents.splice(0,1);
                if (el) {
                    el.setAlpha(1);
                    el.setContainer(null);
                }
            }
        }
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROP));
        this.setAlpha(1);
    }

    element.onDrop=function(e) {
        //if (this.movedX != 0 || this.movedY != 0) {
            var siblingHit = false;
            if (this.container) {
                var siblings = this.container.getContents();
                for (var i = 0; i < siblings.length; i++ ) {
                    if ((siblings[i]).hitTest(this)) {
                        siblingHit = true;
                        break;
                    }
                }
            }
            if (!this.container ||
            ( this.container && (!this.container.hitTest(this) || siblingHit))
            //( this.container && (!this.container.isInsideMe(this)) )
            ) {
                this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROP));
            }
        //}
        this.setAlpha(1);
    }

    element.isParentContained=function(el) {
        if (this.contains(el)) {
            return true;
        }
    }

    element.isInnerElement=function(el,inner) {
        try {
            if (el) {
                var dropin = el.getElement();
                if ( dropin.containsInnerElement(inner) ) {
                    return true;
                }
            }
        }catch (e) {
        }
        return false;
    }

    element.setContainer=function(el, fromDrop) {
        if (this.container && this.isInnerElement(this.container , this)) {
            return;
        }
        if (this.container != el && !this.containsContent(el) && el != null) {
            if (!facilis.validation.RuleManager.getInstance().getDropRules().validate([el,this])) {
                return;
            }
            if (this.container) {
                this.container.removeContent(this);
                this.container.removeEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.updateFromContainer.bind(this));
                this.container.removeEventListener(facilis.AbstractElement.ELEMENT_DRAGGED, this.updateFromContainer.bind(this));
                this.container.removeEventListener(facilis.Drag.STOP_EVENT, this.resetAfterContainerMoved.bind(this));
            }
            this.container = el; 
            this.container.addContent(this);
            this.container.addEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.updateFromContainer.bind(this));
            this.container.addEventListener(facilis.AbstractElement.ELEMENT_DRAGGED, this.updateFromContainer.bind(this));
            this.container.addEventListener(facilis.Drag.STOP_EVENT, this.resetAfterContainerMoved.bind(this));
            if (this.container.parent == this.parent) {
                this.container.setAlpha(1);
            }
        }else if (el == null) {
            if (this.container) {
                this.container.removeContent(this);
                this.container.removeEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.updateFromContainer.bind(this));
                this.container.removeEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.updateFromContainer.bind(this));
                this.container.removeEventListener(facilis.Drag.STOP_EVENT, this.resetAfterContainerMoved.bind(this));
                this.container = el;
            }
        }
        if (this.getData().attributes.name == "middleevent") {
            var attached = false;
			if (fromDrop)
				attached = true;
            var lines = View.getInstance().getLineView().getLinesOf(this);
            if (lines) {
                for (var i = 0; i < lines.length; i++ ) {
                    if ((lines[i]).getStartElement() == el || (lines[i]).getEndElement() == el) {
                        this.setContainer(null);
                        return;
                    }
                }
            }
            if (el && el.getData() && (el.getData().attributes.name == "task" || el.getData().attributes.name == "csubflow") ) {
                this.getData().firstChildNode.children[0].attributes.value = "TRUE";
                attached = true;
            }else {
                this.getData().firstChildNode.children[0].attributes.value = "FALSE";
            }
            this.getElement().setTypeDisabled("Message", "false");
            this.getElement().setTypeDisabled("None", attached.toString());
            this.getElement().setTypeDisabled("Multiple", (!attached).toString());
			this.getElement().setTypeDisabled("Error", (!attached).toString());
            this.getElement().disableLineConditions();
            if (el && el.getData() && (el.getData().attributes.name == "task" || el.getData().attributes.name == "csubflow")) {
                el.getElement().setAttachedEventType();
            }
        }
    }

    element.updateFromContainer=function(e) {
        var el = (e.currentTarget);
        if (!this.container) {
            el.removeEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.updateFromContainer);
            el.removeEventListener(facilis.Drag.STOP_EVENT, this.resetAfterContainerMoved);
            if(el.container){
                el.container.removeEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.updateFromContainer);
                el.container.removeEventListener(facilis.Drag.STOP_EVENT, this.resetAfterContainerMoved);
            }
        }else{
            try{
                this.moveX(this.container.movedX);
                this.moveY(this.container.movedY);
                this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DRAGGED));
            }
            catch (err) {
                try{
                    el.removeEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.updateFromContainer);
                    el.removeEventListener(facilis.Drag.STOP_EVENT, this.resetAfterContainerMoved);
                    if(el.container){
                        el.container.removeEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.updateFromContainer);
                        el.container.removeEventListener(facilis.Drag.STOP_EVENT, this.resetAfterContainerMoved);
                    }
                }
                catch (err) {
                }
            }
        }
    }

    element.resetAfterContainerMoved=function(e) {
        this.resetStart();
    }

    element.getContainer=function() {
        return this.container;
    }

    element.addContent=function(el) {
        if (!this.containsContent(el)) {
            this.contents.push(el);
        }
        this.setAlpha(1);
    }

    element.removeContent=function(el) {
        for (var i = 0; i < this.contents.length; i++ ) {
            if ((this.contents[i]) === el) {
                this.contents.splice(i, 1);
                break;
            }
        }
    }

    element.containsContent=function(el) {
        for (var i = 0; i < this.contents.length;i++ ) {
            if ( (el==(this.contents[i])) || ((this.contents[i]).containsContent(el)) ) {
                return true;
            }
        }
        return false;
    }

    element.setAlpha=function(a) {
        if (this) {
            if(this.parent){
                if (!this.container) {
                    this.parent.setChildIndex(this, this.parent.numChildren-1);
                }else if (this.container && (this.parent == this.container.parent)) {
                    this.parent.setChildIndex(this, this.parent.getChildIndex(this.container));
                }else {
                    this.parent.setChildIndex(this, this.parent.numChildren - 1);
                }
            }
            for (var i = 0; i < this.contents.length; i++ ) {
                var el = (this.contents[i]);
                el.setAlpha(a);
            }
            this.alpha = a;
        }
    }

    element.onElementMoved=function(e) {
        this.setAlpha(.5);
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_MOVED));
        if (this.container && !this.container.hitTest(this) && !this.isInnerElement(this.container,this)) {
            this.getContainer().removeContent(this);
            this.setContainer(null);
        }
    }

    element.onOut=function(e) {
        if(this.contents.length>0){
            this.setAlpha(1);
        }
    }

    element.getData=function() {
        if (!this.data) {
            this.data = (facilis.ElementAttributeController.getInstance().getElementAttributes( this.elementType ));//.cloneNode(true);
            this.data.attributes.id = this.id;
        }
        delete this.data.attributes.containerId;
        if (this.container) {
            this.data.attributes.containerId = this.container.getData().attributes.id;
        }
        this.data.attributes.attached = "";
        var w = this.getElement().width;
        var h = this.getElement().height;
        try {
            var sizable = (this.getElement());
            w=sizable.getRealWidth();
            h=sizable.getRealHeight();
        }
        catch (e) { }
        /*var x = (this.x - (w / 2));
        var y = (this.y - (h / 2));
        this.data.attributes.x = (x > 0)?x:0;
        this.data.attributes.y = (y > 0)?y:0;
        this.data.attributes.width = w;
        this.data.attributes.height = h;

        for (var i = 0; i < this.data.children.length; i++ ) {
            if (this.data.children[i].nodeName=="subElements") {
                this.data.children.splice(i, 1);
            }
        }*/
        return this.data;
    }
    
    Object.defineProperty(element, 'elementId', {
        get: function() { 
            if (!this._elementId) {
                //this._elementId = View.getInstance().getUniqueId();
            }
            return this._elementId;
        },
        set: function(val){
            this._elementId=val;
        }
    });

    element.resetId=function() {
        this.elementId = View.getInstance().getUniqueId();
        this.getData().attributes.id = this.id;
    }

    element.setData=function(d) {
        this.data = d;
    }

    element.getExportData=function() {
        if (!this.container) {
            return this.getSubExportData();
        }	
        return null;
    }

    element.getSubExportData=function() {
        var node = this.getData().cloneNode(true);
        if (this.contents.length > 0) {
            var children;
            for (var s = 0; s < node.children.length; s++ ) {
                if (node.children[s].nodeName=="subElements") {
                    children = node.children[s];
                }
            }
            if (!children) {
                children = new XMLNode(1, "subElements");
                node.appendChild(children);
            }
            for (var i = 0; i < this.contents.length;i++) {
                children.appendChild((this.contents[i]).getSubExportData());
            }
        }
        return node;
    }

    element.getContents=function(){
        return this.contents;
    }

    element.removeDropEvents=function() {
        this.removeEventListener(facilis.Drag.DRAG_EVENT, this.onElementMoved);
        this.removeEventListener(facilis.Drag.STOP_EVENT, this.onDrop);
        this.removeEventListener(facilis.Sizable.RESIZE_EVENT, this.onElementMoved);
        this.removeEventListener(facilis.Sizable.RESIZE_EVENT, this.onResizeDrop);
        this.removeEventListener(facilis.AbstractElement.ELEMENT_OUT, this.onOut);
    }
    
    element.getIntersectionWidthSegment=function(start,end){
        if(this._sizableElement.getIntersectionWidthSegment){
            return this._sizableElement.getIntersectionWidthSegment(start,end);
        }
        return null;
    }

    //PERFORMANCE FIX
    element.LocalhitTest=function(x,y){
        if(this.hitTest(x,y))
            return true;
        
        var p={};
        this._sizableElement.globalToLocal(x,y,p);
        return this._sizableElement.hitTest(p.x,p.y);
    }
    
    facilis.Element = facilis.promote(Element, "Sizable");
    
}());

(function() {

    function DropInElement() {
        this.SizableElement_constructor();
        
        //private//

        //this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(DropInElement, facilis.SizableElement);
    
    element.SizableElementSetup=element.setup;
    element.setup = function() {
        this.SizableElementSetup();
        
        this.innerElements=[];
		this._innerElements=new facilis.BaseElement();
        
        this.addChild(this._innerElements);
        
    };
    
    
    element.addInnerElement=function(el) {
        for (var i = 0; i < this.innerElements.length; i++ ) {
            if (el==this.innerElements[i]) {
                return;
            }
        }
        el.setContainer(this.parent);
        this.innerElements.push(el);
        //_innerElements.addChild(el);
        this.addSubElement(el);
        this.sortInnerElements();
    }

    element.removeInnerElementIndex=function(index) {
        this.innerElements.splice(index, 1);
    }

    element.changeInnerElementPosition=function(index1, index2) {
        var auxSubEls = this.innerElements.slice(0, index1);
        var subElement = this.innerElements[index1];
        var auxSubEls2 = this.innerElements.slice(index1 + 1);

        var auxSubEls3 = [];
        auxSubEls3 = auxSubEls3.concat(auxSubEls, auxSubEls2);

        auxSubEls = auxSubEls3.slice(0, index2);
        auxSubEls2 = auxSubEls3.slice(index2);
        auxSubEls3 = [];
        auxSubEls3 = auxSubEls3.concat(auxSubEls, subElement, auxSubEls2);
        this.innerElements = auxSubEls3;
    }

    element.containsInnerElement=function(el)
    {
        for (var i = 0; i < this.innerElements.length; i++ ) {
            if (el==this.innerElements[i]) {
                return true;
            }
        }
        return false;
    }

    element.addSubElement=function(el) {

    }

    element.getInnerElements=function() {
        return this.innerElements;
    }

    element.sortInnerElements=function(){}

    element.hideAllInner=function() {
        for (var i = 0; i < this.innerElements.length; i++ ) {
            (this.innerElements[i]).visible = false;
        }
    }

    element.showAllInner=function() {
        for (var i = 0; i < this.innerElements.length; i++ ) {
            (this.innerElements[i]).visible = true;
        }
    }



    facilis.DropInElement = facilis.promote(DropInElement, "SizableElement");
    
}());

(function() {

    function ElementAttributeController() {
        //this.url=facilis.baseUrl+"model/elements.json";
        this.url=facilis.baseUrl+"model/elements.xml";
        if (!ElementAttributeController.allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }

        this.setup();
    }
    
    ElementAttributeController._instance=null;
    ElementAttributeController.allowInstantiation=false;
    ElementAttributeController.getInstance=function(){
        if (facilis.ElementAttributeController._instance == null) {
            ElementAttributeController.allowInstantiation = true;
            ElementAttributeController._instance = new facilis.ElementAttributeController();
            //this._instance.appendMe();
            ElementAttributeController.allowInstantiation = false;
        }
        return ElementAttributeController._instance;
    }
    
    var element = facilis.extend(ElementAttributeController, {});
    
    element.setup = function() {
        //this.BaseClassSetup();
        
        var loader = new createjs.LoadQueue();

        loader.addEventListener("fileload", this.loaded.bind(this));
        loader.loadFile(this.url);

        
    };
    
    element.loaded=function(e){
        //this.elements=e.result.elements;
        element.cleanNodes(e.result.children[0]);
        this.elements=e.result.children[0].children;
    }
    
    element.cleanNodes=function(el){
        var reBlank = /^\s*$/;
        for(var i=0;i<el.children.length;i++){
            if(el.children[i].nodeName=="#text" && reBlank.test(el.children[i].nodeValue)){
                el.removeChild(el.children[i]);
                i--;
            }else{
                this.cleanNodes(el.children[i]);
            }
        }
    }
    
    element.getElementAttributes=function(name) {
        var atts = null;
        for (var i = 0; i < this.elements.length; i++ ) {
            if ( this.elements[i].getAttribute("name")==name) {
                atts = this.elements[i].cloneNode(true);
            }
        }
        /*for (var i = 0; i < this.elements.length; i++ ) {
            if ( this.elements[i].name==name) {
                atts = JSON.parse( JSON.stringify(this.elements[i]) );
            }
        }*/
        return atts;
    }


    facilis.ElementAttributeController = facilis.promote(ElementAttributeController, "Object");
    
}());

(function() {

    function MultiSelect() {
        this.BaseElement_constructor();
        
        //private//

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(MultiSelect, facilis.BaseElement);
    
    
    element.setup = function() {
        //this.BaseClassSetup();
    };
    
    element.onAddedToStage=function(e) {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        clickableArea.addEventListener(MouseEvent.MOUSE_DOWN, onmouseDown);
    }

    element.onmouseDown=function(e) {
        if (MultiSelect.MULTISELECT_ENABLED && Key.isDown(Keyboard.SHIFT)) {
            this.dispatchEvent(new Event(MultiSelect.ON_START));
            clickableArea.stage.addEventListener(MouseEvent.MOUSE_MOVE, onmouseMove);
            clickableArea.stage.addEventListener(MouseEvent.MOUSE_UP, onmouseUp);
            startX = this.mouseX;
            startY = this.mouseY;
        }
    }
    element.onmouseMove=function(e) {
        this.graphics.clear();
        this.graphics.beginFill(0xAABBAA, 0);
        this.graphics.lineStyle(1, 0xAABBAA, .6);
        var sX = (startX < this.mouseX)?startX:this.mouseX;
        var sY = (startY < this.mouseY)?startY:this.mouseY;
        var w = Math.abs(startX - this.mouseX)+2;
        var h = Math.abs(startY - this.mouseY) + 2;
        sX -= 2;
        sY -= 2;
        this.graphics.drawRect(sX, sY, w, h);
        _selectionRectangle = new Rectangle(sX, sY, w, h);
        this.graphics.endFill();
    }
    element.onmouseUp=function(e) {
        this.graphics.clear();
        clickableArea.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onmouseMove);
        clickableArea.stage.removeEventListener(MouseEvent.MOUSE_UP, onmouseUp);
        this.dispatchEvent(new Event(MultiSelect.ON_SELECT));
    }
    
    
    Object.defineProperty(element, 'selectionRectangle', {
        get: function() { 
            return this._selectionRectangle;
        },
        set: function(val){
            this._selectionRectangle = rect;
        }
    });



    facilis.MultiSelect = facilis.promote(MultiSelect, "BaseElement");
    
}());

(function() {

    function AbstractView() {
        this.BaseElement_constructor();
        
		this.dispatcherElement=null;

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(AbstractView, facilis.BaseElement);
    
    element.setup = function() {
        this.elements=[];
        
    };
    
    
    
    element.addElement = function(el) {
        el.appear();
        this.addChild(el);

        el.addEventListener(facilis.AbstractElement.ELEMENT_ADDED,this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_DELETE, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_DELETED, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_MOVE_END, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_CLICK, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_CLICKED, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_DOUBLE_CLICKED, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_DROP, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_DROPIN, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_DROPOUT, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_OVER, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_OUT, this.dispatchOut.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_DOUBLE_CLICKED, this.dispatchOut.bind(this));
        el.addEventListener(facilis.Sizable.RESIZE_EVENT, this.dispatchOut.bind(this));
        el.addEventListener(facilis.Sizable.RESIZE_COMPLETE_EVENT, this.dispatchOut.bind(this));

        facilis.View.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DROP, el.hitTestMe.bind(el));

        this.dispatcherElement = el;
        el.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_ADDED));

        this.elements.push(el);
    }

    element.removeElement = function(el) {

        el.removeEventListener(facilis.AbstractElement.ELEMENT_ADDED,this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_DELETE, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_DELETED, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_MOVE_END, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_CLICK, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_CLICKED, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_DROP, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_DROPIN, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_DROPOUT, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_OVER, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_OUT, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.AbstractElement.ELEMENT_DOUBLE_CLICKED,this.dispatchOut.bind(this));
        el.removeEventListener(facilis.Sizable.RESIZE_EVENT, this.dispatchOut.bind(this));
        el.removeEventListener(facilis.Sizable.RESIZE_COMPLETE_EVENT, this.dispatchOut.bind(this));

        facilis.View.getInstance().removeEventListener(facilis.AbstractElement.ELEMENT_DROP, el.hitTestMe);

        //this.removeChild(el);
        el.removeMe();
        for (var i = 0; i < this.elements.length;i++ ) {
            if (this.elements[i]==el) {
                this.elements.splice(i,1);
            }
        }
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DELETED));
    }

    element.dispatchOut = function(e) {
        e.stopPropagation();
        this.dispatcherElement = e.target;
        this.dispatchEvent(new facilis.Event(e.type));
    }

    Object.defineProperty(element, 'dispatcher', {
        get: function() { 
            return this.dispatcherElement;;
        }
    });
    
    element.getElements = function(){
        return this.elements;
    }

    element.getExportData = function(){ 
        return null;
    }

    element.scale = function(ratio) {
        this.scaleX = ratio;
        this.scaleY = ratio;
    }

    element.clearAllElementEvents = function() {
        for (var i = 0; i < this.elements.length; i++ ) {
            var el = this.elements[i];
            el.removeAllEventListeners();
        }
    }

    element.clear = function() {
        while (0 < this.elements.length) {
            var el = this.elements[0];
            this.elements.splice(0, 1);
            el.parent.removeChild(el);
        }
    }
    


    facilis.AbstractView = facilis.promote(AbstractView, "BaseElement");
    
}());

(function() {

    function ElementView() {
        this.AbstractView_constructor();
        
        if (!ElementView.allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }
    }
    
    ElementView._instance=null;
    ElementView.allowInstantiation=false;
    ElementView.getInstance=function(){
        if (ElementView._instance == null) {
            ElementView.allowInstantiation = true;
            ElementView._instance = new facilis.ElementView();
            ElementView._instance.appendMe();
            ElementView.allowInstantiation = false;
        }
        return ElementView._instance;
    }
    
    
    var element = facilis.extend(ElementView, facilis.AbstractView);
    
    element.AbstractViewSetup=element.setup;
    element.setup = function() {
        this.AbstractViewSetup();
    };
    
    element.appendMe=function() {
        facilis.View.getInstance()._stage.addChild(ElementView._instance);
    }

    element.getExportData=function(){ 
        var els = [];
        for (var i = 0; i<this.elements.length; i++) {
            var el = this.elements[i].getExportData();
            if (el) {
                els.push(el);
            }
        }
        return els;
    }

    

    facilis.ElementView = facilis.promote(ElementView, "AbstractView");
    
}());

(function() {

    function LaneView() {
        this.AbstractView_constructor();
        
        if (!LaneView.allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }
    }
    
    LaneView._instance=null;
    LaneView.allowInstantiation=false;
    LaneView.getInstance=function(){
        if (LaneView._instance == null) {
            LaneView.allowInstantiation = true;
            LaneView._instance = new facilis.LaneView();
            LaneView._instance.appendMe();
            LaneView.allowInstantiation = false;
        }
        return LaneView._instance;
    }
    
    
    var element = facilis.extend(LaneView, facilis.AbstractView);
    
    element.AbstractViewSetup=element.setup;
    element.setup = function() {
        this.AbstractViewSetup();
    };
    
    element.appendMe=function() {
        facilis.View.getInstance()._stage.addChild(LaneView._instance);
    }

    element.getExportData=function(){ 
        var els = [];
        for (var i = 0; i<this.elements.length; i++) {
            var el = this.elements[i].getExportData();
            if (el) {
                els.push(el);
            }
        }
        return els;
    }

    

    facilis.LaneView = facilis.promote(LaneView, "AbstractView");
    
}());

(function() {

    function LineView() {
        this.AbstractView_constructor();
        
        if (!LineView.allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }

    }
    
    LineView._instance=null;
    LineView.allowInstantiation=false;
    LineView.getInstance=function(){
        if (LineView._instance == null) {
            LineView.allowInstantiation = true;
            LineView._instance = new facilis.LineView();
            LineView._instance.appendMe();
            LineView.allowInstantiation = false;
        }
        return LineView._instance;
    }
    
    
    var element = facilis.extend(LineView, facilis.AbstractView);
    
    element.AbstractViewSetup=element.setup;
    element.setup = function() {
        this.AbstractViewSetup();
    };
    
    element.appendMe=function() {
        facilis.View.getInstance()._stage.addChild(LineView._instance);
    }

    element.getExportData=function(){ 
        var els = [];
        for (var i = 0; i<this.elements.length; i++) {
            var el = this.elements[i].getExportData();
            if (el) {
                els.push(el);
            }
        }
        return els;
    }

    
    element.addLine=function(s, e) {
        if (this.isValidLine(s, e)) {
            var line = this.getNewLine(s, e);
            this.addElement(line);
            line.refreshWholeLine();
            return line;
        }
        return null;
    }

    element.getLine=function(s, e) {
        if (this.isValidLine(s, e)) {
            var line = this.getNewLine(s, e);
            line.refreshWholeLine();
            return line;
        }
        return null;
    }

    element.addALine=function(line) {
        if (line) {
            this.addElement(line);
            line.refreshWholeLine();
            return line;
        }
        return null;
    }

    element.getNewLine=function(s, e) {
        if (this.isValidLine(s, e)) {
            var line = new facilis.LineObject(s, e);
            line.addEventListener(facilis.LineObject.VERTEXES_CHANGED, this.dispatchOut.bind(this));
            line.addEventListener(facilis.LineObject.VERTEXES_TO_CHANGE, this.dispatchOut.bind(this));
            return line;
        }
        return null;
    }

    element.isValidLine=function(s, e) {
        if (s==null || e==null) {
            return false;
        }
        for (var i = 0; i < this.elements.length; i++ ) {
            var line = this.elements[i];
            if ( (line.startElement==s && line.lastElement==e) /*||
                (line.startElement==e && line.lastElement==s)*/ ) {
                return false;
            }
        }
        return true;
    }

    element.appendMe=function() {
        facilis.View.getInstance()._stage.addChild(LineView._instance);
    }
    
    element.getLinesOf=function(e) {
        var lines = [];
        for (var i = 0; i < this.elements.length;i++ ) {
            if ( (this.elements[i]).startElement === e ||
            (this.elements[i]).lastElement === e) {
                lines.push(this.elements[i]);
            }
        }
        return lines;
    }

    element.getLinesStartingIn=function(e) {
        var lines = [];
        for (var i = 0; i < this.elements.length;i++ ) {
            if ( (this.elements[i]).startElement === e) {
                lines.push(this.elements[i]);
            }
        }
        return lines;
    }

    element.getLinesEndingIn=function(e) {
        var lines = [];
        for (var i = 0; i < this.elements.length;i++ ) {
            if ( (this.elements[i]).lastElement === e) {
                lines.push(this.elements[i]);
            }
        }
        return lines;
    }
    

    facilis.LineView = facilis.promote(LineView, "AbstractView");
    
}());

(function() {

    function AbstractMainView() {
        this.AbstractView_constructor();
    }
    
    
    var element = facilis.extend(AbstractMainView, facilis.AbstractView);
    
    element.AbstractViewSetup=element.setup;
    element.setup = function() {
        this.AbstractViewSetup();
        this._mainStage=null;
		
		this._backWidth = null;
		this._backHeight = null;
		
		this._backX = null;
		this._backY = null;
		
		this.mainPool;
		this.back;
		this.scroll;
		this.multiSelect;
		this.wasMoving;

		this.selectedElements=[];
		this.selectedLines=[];
        
    }
    
    element.init=function(s){
        
        this._mainStage = s;
        //this._stage = s;
        
        this.scroll = new facilis.ScrollContent();
        s.addChild(this.scroll);
        this._stage = this.scroll.getContent();
        
        this.initBack();
        this.scroll.updateSize(this._backWidth,this._backHeight);


        facilis.LaneView.getInstance();
        facilis.LineView.getInstance();
        facilis.ElementView.getInstance();

        facilis.ElementView.getInstance().parent.setChildIndex(facilis.ElementView.getInstance(), facilis.ElementView.getInstance().parent.numChildren - 1);

        //facilis.LaneView.getInstance().filters = [new DropShadowFilter(8, 45, Style.DROPSHADOW, .8, 10, 10, .3, 1, false)];
        //facilis.LineView.getInstance().filters = [new DropShadowFilter(8, 45, Style.DROPSHADOW, .8, 10, 10, .3, 1, false)];
        //facilis.ElementView.getInstance().filters = [new DropShadowFilter(8, 45, Style.DROPSHADOW, .8, 10, 10, .3, 1, false)];

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_CLICK, this.onElementClick.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_CLICK, this.onElementClick.bind(this));
        facilis.LineView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_CLICK, this.onElementClick.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DOUBLE_CLICKED, this.dispatchOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DOUBLE_CLICKED, this.dispatchOut.bind(this));
        facilis.LineView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DOUBLE_CLICKED, this.dispatchOut.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_CLICKED, this.onElementClicked.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_CLICKED, this.onElementClicked.bind(this));
        facilis.LineView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_CLICKED, this.onLineClicked.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_OVER, this.dispatchOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_OVER, this.dispatchOut.bind(this));
        facilis.LineView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_OVER, this.dispatchOut.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_OUT, this.dispatchOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_OUT, this.dispatchOut.bind(this));
        facilis.LineView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_OUT, this.dispatchOut.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DROPIN, this.dispatchOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DROPIN, this.dispatchOut.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_MOVE_END, this.dispatchOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_MOVE_END, this.dispatchOut.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DELETE, this.dispatchOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DELETE, this.dispatchOut.bind(this));
        facilis.LineView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DELETE, this.dispatchOut.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DELETED, this.dispatchOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DELETED, this.dispatchOut.bind(this));
        facilis.LineView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DELETED, this.dispatchOut.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.onElementMoved.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_MOVED, this.onElementMoved.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_MOVE_END, this.onElementMoveEnd.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_MOVE_END, this.onElementMoveEnd.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DROP, this.onElementDrop.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DROP, this.onElementDrop.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DROPIN, this.onElementDropIn.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DROPIN, this.onElementDropIn.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DROPOUT, this.onElementDropOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_DROPOUT, this.onElementDropOut.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_ADDED, this.dispatchOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_ADDED, this.dispatchOut.bind(this));

        facilis.LineView.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_ADDED, this.dispatchOut.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.Sizable.RESIZE_EVENT, this.dispatchOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.Sizable.RESIZE_EVENT, this.dispatchOut.bind(this));

        facilis.ElementView.getInstance().addEventListener(facilis.Sizable.RESIZE_COMPLETE_EVENT, this.dispatchOut.bind(this));
        facilis.LaneView.getInstance().addEventListener(facilis.Sizable.RESIZE_COMPLETE_EVENT, this.dispatchOut.bind(this));

        //facilis.ElementView.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        //facilis.Key.getInstance().addEventListener(facilis.Key.KEY_DOWN, keyDown);
        
        this.zoomScroll=new facilis.ZoomScroll();
        this.mainStage.addChild(this.zoomScroll);
        this.zoomScroll.positionMe();
        this.zoomScroll.addEventListener(facilis.ZoomScroll.ON_ZOOMEND,this.onZoomed.bind(this));
    };
    
    
    
    element.initBack=function() {
        this.back = new facilis.BaseElement();
        this._stage.addChild(this.back);
        this._stage.setChildIndex(this.back,0);
        this.back.addEventListener("click", this.stageClick.bind(this) );
        window.addEventListener("resize",this.onStageResize.bind(this));
        //back.stage.addEventListener(Event.RESIZE, onStageResize);
        /*back.stage.scaleMode = StageScaleMode.NO_SCALE;
        back.stage.align = StageAlign.TOP_LEFT;*/

        this.multiSelect = new facilis.MultiSelect(this.back);
        this.back.addChild(this.multiSelect);
        this.multiSelect.addEventListener(facilis.MultiSelect.ON_SELECT, this.onMultiSelect.bind(this));
        this.multiSelect.addEventListener(facilis.MultiSelect.ON_START, this.onMultiSelectStart.bind(this));

        this.drawBack();
    }

    element.enableMultiSelect=function() {
        MultiSelect.MULTISELECT_ENABLED = true;
    }

    element.getElementsBounds=function() {
        var w=0;
        var h=0;
        var x=1000000;
        var y=1000000;
        var el;
        for (var i = 0; i < this.getElementView().getElements().length; i++ ) {
            el = (this.getElementView().getElements()[i]);
            if ((parseInt(el._width/2) + parseInt(el.x))>w) {
                w=(parseInt(el._width/2) + parseInt(el.x));
            }
            if ((parseInt(el._height/2) + parseInt(el.y)) > h) {
                h=(parseInt(el._height/2) + parseInt(el.y));
            }
            if(x<parseInt(el.x))
                x=parseInt(el.x);
                
            if(y<parseInt(el.y))
                y=parseInt(el.y);
            
        }
        i = 0;
        for (i = 0; i < this.getLaneView().getElements().length; i++ ) {
            el = (this.getLaneView().getElements()[i]);
            if (el.elementType!="swimlane" && (parseInt(el._width/2) + parseInt(el.x))>w) {
                w=(parseInt(el._width/2) + parseInt(el.x));
            }
            if (el.elementType!="swimlane" && (parseInt(el._height/2) + parseInt(el.y)) > h) {
                h=(parseInt(el._height/2) + parseInt(el.y));
            }
            if(x<parseInt(el.x))
                x=parseInt(el.x);
                
            if(y<parseInt(el.y))
                y=parseInt(el.y);
        }
        return {x:x,y:y,width:w,height:h};
    }
    
    element.getElementsWidth=function() {
        var w = 0;
        var el;
        for (var i = 0; i < this.getElementView().getElements().length; i++ ) {
            el = (this.getElementView().getElements()[i]);
            if ((parseInt(el._width/2) + parseInt(el.x))>w) {
                w=(parseInt(el._width/2) + parseInt(el.x));
            }
        }
        i = 0;
        for (i = 0; i < this.getLaneView().getElements().length; i++ ) {
            el = (this.getLaneView().getElements()[i]);
            if (el.elementType!="swimlane" && (parseInt(el._width/2) + parseInt(el.x))>w) {
                w=(parseInt(el._width/2) + parseInt(el.x));
            }
        }
        return w;
    }

    element.getElementsHeight=function() {
        var h = 0;
        var el;
        for (var i = 0; i < this.getElementView().getElements().length; i++ ) {
            el = (this.getElementView().getElements()[i]);
            if ((parseInt(el._height/2) + parseInt(el.y)) > h) {
                h=(parseInt(el._height/2) + parseInt(el.y));
            }
        }
        i = 0;
        for (i = 0; i < this.getLaneView().getElements().length; i++ ) {
            el = (this.getLaneView().getElements()[i]);
            if (el.elementType!="swimlane" && (parseInt(el._height/2) + parseInt(el.y)) > h) {
                h=(parseInt(el._height/2) + parseInt(el.y));
            }
        }
        return h;
    }

    element.getStageWidth=function() {
        return this.back.stage.canvas.width;//this.back.stage.stageWidth;
    }

    element.getStageHeight=function() {
        return this.back.stage.canvas.height;//this.back.stage.stageHeight;
    }

    element.getElementView=function() {
        return facilis.ElementView.getInstance();
    }

    element.getLineView=function() {
        return facilis.LineView.getInstance();
    }

    element.getLaneView=function() {
        return facilis.LaneView.getInstance();
    }

    element.getBack=function(){
        //return this.back.getBounds();
        return new facilis.Rectangle(0,0,this._backWidth,this._backHeight);
    }

    element._zoomed=1;
    element.zoom=function(z) {
        element._zoomed=z;
        facilis.LineView.getInstance().scale(z);
        facilis.LaneView.getInstance().scale(z);
        facilis.ElementView.getInstance().scale(z);
        /*this.back.scaleX = z;
        this.back.scaleY = z;
        this.scroll.updateSize(this._backWidth,this._backHeight);
        this.drawBack();
        var centerPoint = new facilis.Point(this._stage.stage.stageWidth / 2, this._stage.stage.stageHeight / 2);
        this.centerPoint = this.localToGlobal(centerPoint);
        this.centerPoint = facilis.ElementView.getInstance().globalToLocal(centerPoint);
        this.dispatchOut(new facilis.Event(facilis.View.ON_ZOOM));*/
    }
    
    element.resetZoom=function(){
        this.zoomScroll.resetZoom();
    }
    
    element.onZoomed=function(){
        this.drawBack();
    }

    element.keyDown=function(e) {
        if (facilis.Key.isDown(facilis.Keyboard.DELETE)	) {
            removeSelectedElements();
        }
    }

    element.removeSelectedElements=function() {
        if(!View.canDelete){return}
        var deleted = false;
        while(this.selectedElements.length!=0) {
            try {
                (this.selectedElements[0]).remove(); 
            }
            catch (e) { }
            try {
                this.selectedElements.splice(0,1);
                deleted = true;
            }
            catch (e) { }
        }
        while(selectedLines.length!=0) {
            try {
                (selectedLines[0]).remove(); 
            }
            catch (e) { }
            try {
                selectedLines.splice(0,1);
                deleted = true;
            }
            catch (e) { }
        }
        if (deleted) {
            this.dispatchEvent(new facilis.Event(facilis.View.ON_DELETE));
        }
    }

    element.isSelected=function(el) {
        if (el instanceof facilis.Element) {
            for (var i = 0; i < this.selectedElements.length; i++) {
                if ( (this.selectedElements[i]) == el) {
                    return true;
                }
            }
        }else if (el instanceof facilis.LineObject) {
            for (var u = 0; u < this.selectedLines.length; u++) {
                if ( (this.selectedLines[u]) == el) {
                    return true;
                }
            }
        }
        return false;
    }

    element.select=function(el) {
        //if (!isSelected(el)) {
            if (el instanceof facilis.Element) {
                this.selectedElements.push(el);
            }else if (el instanceof facilis.LineObject) {
                this.selectedLines.push(el);
            }
        //}
        this.dispatchEvent(new facilis.Event(facilis.View.ON_SELECT));
    }

    element.unselect=function(el) {
        if (el instanceof facilis.Element) {
            for (var i = 0; i < this.selectedElements.length; i++) {
                if ( (this.selectedElements[i]) == el) {
                    this.selectedElements.splice(i, 1);
                }
            }
        }
        if (el instanceof facilis.LineObject) {
            for (var u = 0; u < selectedLines.length; u++) {
                if ( (selectedLines[u]) == el) {
                    selectedLines.splice(u, 1);
                }
            }
        }
    }

    element.unselectAll=function() {
        while(this.selectedElements.length!=0) {
            this.selectedElements[0].unselect();
            this.selectedElements.splice(0,1);
        }
        while(this.selectedLines.length!=0) {
            (this.selectedLines[0]).unselect();
            this.selectedLines.splice(0,1);
        }
        this.selectedElements = [];
        this.selectedLines = [];
        this.dispatchEvent(new facilis.Event(facilis.View.ON_UNSELECT_ALL));
    }

    element.stageClick=function(e) {
        this.unselectAll();
        this.dispatchEvent(new facilis.Event(facilis.View.ON_SELECT));
        this.dispatchEvent(new facilis.Event(facilis.View.VIEW_CLICK));
    }

    element.getSelectedElements=function() {
        var sel = [];
        for (var i = 0; i < this.selectedElements.length;i++ ) {
            sel.push(this.selectedElements[i]);
        }
        i = 0;
        for (i = 0; i < this.selectedLines.length;i++ ) {
            sel.push(this.selectedLines[i]);
        }
        return sel;
    }

    element.onStageResize=function(e) {
        this._mainStage.canvas.width = window.innerWidth-30;
        this._mainStage.canvas.height = window.innerHeight-30; 
        this.drawBack();
        this.scroll.updateSize();
        this.zoomScroll.positionMe();
        this.dispatchEvent(new facilis.Event(Event.RESIZE));
    }
    
    element.drawBack=function() {
        if(this.back){
            this._backWidth = this.getStageWidth();
            this._backHeight = this.getStageHeight();

            var w = this._backWidth;
            var h = this._backHeight;

            var nw = this.getElementsWidth();
            if (nw > w) {
                w = nw + 20;
            }
            var nh = this.getElementsHeight();
            if (nh > h) {
                h = nh + 20;
            }
            w += 30;
            h += 30;
            if (this.mainPool) {
                this.mainPool.setSize(w, h);
                this.mainPool.moveTo(this.mainPool.width / 2, this.mainPool.height / 2);
            }
            
            
            
            if(!this.back.graphics)
                this.back.graphics=new facilis.Graphics();

            this.back.graphics.clear();
            this.back.graphics.beginFill("rgba(255,255,255,.1)");
            
            
            w=w*this._zoomed;
            h=h*this._zoomed;

            if(this._backWidth!=w || this._backHeight!=h){
                this.back.uncache();
                this._backWidth=w;
                this._backHeight=h;

                this.back.graphics.drawRect(0, 0, w, h);
                this.back.graphics.endFill();
                
                this.back.removeAllChildren();
                this.back.addShape(new facilis.Shape(this.back.graphics));
                this.back.setBounds(0,0,w,h);
                this.back.cache(0,0,w,h);
            }
        }
        this.dispatchEvent(new facilis.Event(Event.RESIZE));
    }

    element.setSize=function(w, h) {
        this._backWidth = w;
        this._backHeight = h;
    }

    element.setPosition=function(_x, _y) {
        this._backX = _x;
        this._backY = _y;
    }

    element.onElementClicked=function(e) {
        var el = e.target.dispatcher;
        if(!this.wasMoving){
            if (!facilis.Key.isDown(facilis.Keyboard.CONTROL)) {
                this.unselectAll();
            }

            if (!this.isSelected(el)) {
                el.select();
                this.select(el);
            }else {
                el.unselect();
                this.unselect(el);
            }
        }
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_CLICKED));
        this.wasMoving = false;
    }

    element.onElementClick=function(e) {
        var el = e.target.dispatcher;
        if (!facilis.Key.isDown(facilis.Keyboard.CONTROL) && !el.selected) {
            this.unselectAll();
        }
        this.dispatchOut(e);
    }

    element.onLineClicked=function(e) {
        var el = e.target.dispatcher;
        if (!facilis.Key.isDown(facilis.Keyboard.CONTROL)) {
            this.unselectAll();
        }
        if (!this.isSelected(el)) {
            el.select();
            this.select(el);
        }else{
            el.unselect();
            this.unselect(el);
        }
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_CLICKED));
    }

    element.dispatchOut=function(e) {
        e.stopPropagation();
        if(e.target && e.target.dispatcher){
            //super.dispatcherElement = e.target.dispatcher;
        }
        this.dispatchEvent(new facilis.Event(e.type));
    }

    element.onElementMoved=function(e) {
        var el = e.target.dispatcher;
        for (var i = 0; i < this.selectedElements.length; i++ ) {
            var el2 = (this.selectedElements[i]);
            if(el!=el2){
                el2.moveX(el.movedX);
                el2.moveY(el.movedY);
                el2.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DRAGGED));
            }
        }
        if (((el).movedX != 0 && (el).movedY != 0 )) {
            this.wasMoving = true;
        }
        this.dispatchOut(e);
    }

    element.onElementMoveEnd=function(e) {
        var el = e.target.dispatcher;
        for (var i = 0; i < this.selectedElements.length; i++ ) {
            if (this.selectedElements[i] != el) {
                (this.selectedElements[i]).dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROP));
            }
        }
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_MOVE_END));
    }

    element.drop = null;
    element.onElementDrop=function(e) {
        e.stopPropagation();
        var v = e.target;
        this.dispatcherElement = v.dispatcher;
        //var p = new Point(dispatcherElement.x, dispatcherElement.y);
        //p = stage.globalToLocal(dispatcherElement.parent.localToGlobal(p));
        //v.addChild(dispatcherElement);
        //dispatcherElement.x = p.x;
        //dispatcherElement.y = p.y;
        drop = this.dispatcherElement;
        drop.setContainer(null);
        this.drawBack();
/*
        MapUndoHandler.a_imprimir += "Testeando trace...\n";
        MapUndoHandler.testTrace();
        MapUndoHandler.a_imprimir += "Antes de lanzar el dispatchEvent\n";
*/			
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROP));
    }

    element.onElementDropIn=function(e) {
        var v = e.target;
        var container = v.dispatcher;
        if (!drop.getContainer()) {
            if(facilis.validation.RuleManager.getInstance().getDropRules().validate([container, drop])){
                drop.setContainer(container);
                //container.addContent(drop);
                this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROP));
            }
        }
    }

    element.onElementDropOut=function(e) {
        var v = e.target;
        var droppedOut = v.dispatcher;
        if (!droppedOut.getContainer()) {
            if(facilis.validation.RuleManager.getInstance().getDropRules().validate([drop, droppedOut])){
                droppedOut.setContainer(drop);
                this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROP));
            }
        }
        //container.addContent(drop);
    }

    Object.defineProperty(element, 'dispatcher', {
        get: function() { 
            return this.dispatcherElement;;
        }
    });
    
    Object.defineProperty(element, '_stage', {
        get: function() { 
            /*if(this._mainStage)
                return this._mainStage;
            
            return this.stage;*/
            return this.scroll.getContent();
        }
    });

    element.onMultiSelectStart=function(e) {
        if(!facilis.Key.isDown(facilis.Keyboard.CONTROL)){
            this.unselectAll();
        }
    }

    element.onMultiSelect=function(e) {
        var rect = multiSelect.selectionRectangle;
        var els = facilis.ElementView.getInstance().getElements();
        els = els.concat(facilis.LineView.getInstance().getElements());
        els = els.concat(facilis.LaneView.getInstance().getElements());
        var sP = new Point(rect.x, rect.y);
        var eP = new Point(rect.width + rect.x, rect.height + rect.y);
        sP = multiSelect.localToGlobal(sP);
        eP = multiSelect.localToGlobal(eP);
        sP = facilis.ElementView.getInstance().globalToLocal(sP);
        eP = facilis.ElementView.getInstance().globalToLocal(eP);
        var selRect = new facilis.Rectangle(sP.x, sP.y, Math.abs(eP.x - sP.x), Math.abs(eP.y - sP.y));
        var swimLanes = [];
        var selectSwimlanes = false;
        for (var i = 0; i < els.length; i++ ) {
            if (els[i] instanceof facilis.LineObject) {
                var segs = (els[i]).getSegments();
                for (var n = 0; n < segs.length; n++ ) {
                    var sp = (segs[n]).getStartPoint();
                    var ep = (segs[n]).getEndPoint();
                    sp = segs[n].localToGlobal(sp);
                    ep = segs[n].localToGlobal(ep);
                    sp = facilis.ElementView.getInstance().globalToLocal(sp);
                    ep = facilis.ElementView.getInstance().globalToLocal(ep);
                    /*var lx = (sp.x < ep.x)?sp.x:ep.x;
                    var ly = (sp.y < ep.y)?sp.y:ep.y;
                    var lw = Math.abs(ep.x - sp.x);
                    var lh = Math.abs(ep.y - sp.y);
                    lw = (lw > 0)?lw:2;
                    lh = (lh > 0)?lh:2;

                    var lineRect=new facilis.Rectangle(lx, ly, lw, lh);
                    if(  selRect.intersects(lineRect)  ){*/
                    var seg = new facilis.Segment(sp, ep);
                    if(seg.intersects(selRect)){
                        (els[i]).select();
                        select(els[i]);
                        break;
                    }
                }
            }else {
                if (selRect.intersects(getElementRectangle(els[i]))) {
                    (els[i]).select();
                    select(els[i]);
                    if ((els[i]).elementType == "pool") {
                        selectSwimlanes = true;
                    }
                }
                if ( (els[i]).elementType == "swimlane") {
                    swimLanes.push( (els[i]) );
                }
            }
        }
        if (selectSwimlanes) {
            for (var s = 0; s < swimLanes.length; s++ ) {
                (swimLanes[s]).select();
                select(swimLanes[s]);
            }
        }
    }

    element.getElementRectangle=function(el) {
        var elx = (el.x - (el.width / 2));
        var ely = (el.y - (el.height / 2));
        return new facilis.Rectangle(elx,ely,el.width,el.height);
    }

    
    

    facilis.AbstractMainView = facilis.promote(AbstractMainView, "AbstractView");
    
}());

(function() {

    function ScrollContent() {
        this.BaseElement_constructor();
        
        this._content;
        this._scrollBarV;
        this._scrollBarH;
        
        this.isDragging = false;

        this.lastPos = new facilis.Point();
        this.firstPos = new facilis.Point();
        this.firstPanelPos = new facilis.Point();
        this.diff = new facilis.Point();
        this.inertia = new facilis.Point();
        this.min = new facilis.Point();
        this.max = new facilis.Point();

        this.touchX;
        this.touchY;

        this.panelWidth;

        this.panelHeight;

        this.__mask;

        this._minBarAlpha = .2;
        this._barDist = 25;

        this.setup();
    }
    
    ScrollContent.SPACE_SCROLL = false;
		
    var element = facilis.extend(ScrollContent, facilis.BaseElement);
    
    element.setup = function() {
        this._content = new facilis.BaseElement();
        this.addChild(this._content);

        // initialize mask
        this.__mask = new facilis.Shape();
        this.addChild(this.__mask);

        this._scrollBarV=new facilis.BaseElement();
        this._scrollBarH = new facilis.BaseElement();
        this.addChild(this._scrollBarV);
        this.addChild(this._scrollBarH);

        this.setEvents();
    };
    
    element.scrollFactor = 10;
    element.useVertical = true;
    element.useHorizontal = true;    


    element.getContent=function(){
        return this._content;
    }

    element.updateSize=function(w, h) {
        if (w) {
            this.panelWidth = w;
        }else {
            this.panelWidth = facilis.View.getInstance().getStageWidth();
        }
        if (h) {
            panelHeight = h;
        }else {
            panelHeight = facilis.View.getInstance().getStageHeight();
        }
        this.updateMask();
        this.drawScrollBars();
    }

    element.updateMask=function() { 
        this.__mask.graphics.clear();
        this.__mask.graphics.beginFill(0);
        this.__mask.graphics.drawRect(0,0,facilis.View.getInstance().getStageWidth(), facilis.View.getInstance().getStageHeight());
        this.__mask.graphics.endFill();
        this._content.setMask(this.__mask);
    }




    //element.handleAddedToStage(e) {
    element.setEvents=function() {
        this.addEventListener("mousedown", this.handleMouseDown.bind(this));
        //facilis.Ticker.addEventListener("tick", this.handleEnterFrame.bind(this));
        
    }

    /**
     * Listener for mouse movement
     * @param e information for mouse
     */
    element.handleMouseMove=function(e) {
        var _contentWidth = facilis.View.getInstance()._backWidth;//facilis.View.getInstance().getBack().width;
        var _contentHeight = facilis.View.getInstance()._backHeight;//facilis.View.getInstance().getBack().height;

        var totalX = e.localX - this.firstPos.x;
        var totalY = e.localY - this.firstPos.y;

        // movement detection with this.scrollFactor
        if (this.useVertical && Math.abs(totalY) > this.scrollFactor) {
            this.isDragging = true;
        }
        if (this.useHorizontal && Math.abs(totalX) > this.scrollFactor) {
            this.isDragging = true;
        }

        if (this.isDragging) {

            if (this.useVertical) {
                if (totalY < this.min.y) {
                    totalY = this.min.y - Math.sqrt(this.min.y-totalY);
                }
                if (totalY > this.max.y) {
                    totalY = this.max.y + Math.sqrt(totalY - this.max.y);
                }
                this._content.y = this.firstPanelPos.y + totalY;
            }

            if (this.useHorizontal) {
                if (totalX < this.min.x) {
                    totalX = this.min.x - Math.sqrt(this.min.x-totalX);
                }
                if (totalX > this.max.x) {
                    totalX = this.max.x + Math.sqrt(totalX - this.max.x);
                }
                this._content.x = this.firstPanelPos.x + totalX;
            }
        }
    }

    /**
     * Listener for mouse up action
     * @param e information for mouse
     */
    element.handleMouseUp=function(e) {
        //clearInterval(this.intervalReference);
        //facilis.Ticker.removeEventListener("tick", this.handleEnterFrame.bind(this));
            
        var _contentWidth = facilis.View.getInstance()._backWidth;//facilis.View.getInstance().getBack().width;
        var _contentHeight = facilis.View.getInstance()._backHeight;//facilis.View.getInstance().getBack().height;

        if (stage.hasEventListener("pressmove") )	{
            stage.removeEventListener("pressmove", this.handleMouseMove);
        }
        this.isDragging = false;
        // setting this.inertia power
        if (this.useVertical) {
            this.inertia.y = diff.y;
        }
        if (this.useHorizontal) {
            this.inertia.x = diff.x;
        }

        stage.removeEventListener("mouseup", this.handleMouseUp.bind(this));
    }

    /**
     * Listener for mouse down
     * @param e information for mouse
     */
    
    element.intervalReference;
    element.handleMouseDown=function(e) {  
        
        //clearInterval(this.intervalReference);
        var ref=this;
        this.intervalReference=setInterval(function(){
            ref.handleEnterFrame(ref);
        },100);
        /*if (facilis.Ticker.hasEventListener("tick") )	{
            facilis.Ticker.removeEventListener("tick", this.handleEnterFrame.bind(this));
        }
        
        facilis.Ticker.addEventListener("tick", this.handleEnterFrame.bind(this));*/
        //if ((Key.isDown(Keyboard.SPACE) && ScrollContent.SPACE_SCROLL) || !ScrollContent.SPACE_SCROLL) {
            var _contentWidth = facilis.View.getInstance()._backWidth;//facilis.View.getInstance().getBack().width;
            var _contentHeight = facilis.View.getInstance()._backHeight;//facilis.View.getInstance().getBack().height;

            if (!this.stage.hasEventListener("pressmove")) {
                this.stage.addEventListener("pressmove", this.handleMouseMove.bind(this));
                this.stage.addEventListener("mouseup", this.handleMouseUp.bind(this));
            }
            this.inertia.y = 0;
            this.inertia.x = 0;

            this.firstPos.x = e.localX;
            this.firstPos.y = e.localY;

            this.firstPanelPos.x = this._content.x;
            this.firstPanelPos.y = this._content.y;

            this.min.x = Math.min(-this._content.x, -_contentWidth + this.panelWidth - this._content.x);
            this.min.y = Math.min(-this._content.y, -_contentHeight + panelHeight - this._content.y);

            this.max.x = -this._content.x;
            this.max.y = -this._content.y;

            this.drawScrollBars();
        //}
    }

    element.drawScrollBars=function() {
        try{
        var _contentWidth = facilis.View.getInstance().getBack().width;
        var _contentHeight = facilis.View.getInstance().getBack().height;

        _scrollBarV.graphics.clear();
        if (this.useVertical) {
            _scrollBarV.graphics.beginFill(0x888899,1);
            //_scrollBarV.graphics.drawRoundRect(2,0,6, panelHeight * Math.this.max(0, panelHeight / _contentHeight), 8);
            var h = (panelHeight - _barDist) * Math.max(0, panelHeight / _contentHeight);
            _scrollBarV.graphics.drawRoundRect(2,_barDist,6, h, 8);
            _scrollBarV.graphics.endFill();
        }

        _scrollBarH.graphics.clear();
        if (this.useHorizontal) {
            _scrollBarH.graphics.beginFill(0x888899,1);
            //_scrollBarH.graphics.drawRoundRect(0,2, this.panelWidth * Math.max(0, this.panelWidth / _contentWidth), 6, 8);
            var w = (this.panelWidth - _barDist) * Math.max(0, this.panelWidth / _contentWidth);
            _scrollBarH.graphics.drawRoundRect(_barDist,2, w, 6, 8);
            _scrollBarH.graphics.endFill();
        }
        }catch (e){}
    }

    /**
     * Listener for enter frame event
     * @param e event information
     */
    element.handleEnterFrame=function(e) {

        var _contentWidth = facilis.View.getInstance().getBack().width;
        var _contentHeight = facilis.View.getInstance().getBack().height;

        this.diff.y = e.localY - this.lastPos.y;
        this.diff.x = e.localX - this.lastPos.x;

        this.lastPos.y = e.localY;
        this.lastPos.x = e.localX;
        if (!this.isDragging) {

            // movements while non dragging

            if (this.useVertical) {
                if (this._content.y > 0) {
                    this.inertia.y = 0;
                    this._content.y *= 0.8;
                    if (this._content.y < 1) {
                        this._content.y = 0;
                    }
                }
                if (_contentHeight >= this.panelHeight && this._content.y < this.panelHeight - _contentHeight) {
                    this.inertia.y = 0;

                    var goal = this.panelHeight - _contentHeight;
                    this.diff = this.goal - this._content.y;

                    if (this.diff > 1) {
                        this.diff *= 0.2;
                    }
                    this._content.y += this.diff;
                }
                if (_contentHeight < panelHeight && this._content.y < 0) {
                    this.inertia.y = 0;
                    this._content.y *= 0.8;
                    if (this._content.y > -1) {
                        this._content.y = 0;
                    }
                }
                if (Math.abs(this.inertia.y) > 1) {
                    this._content.y += this.inertia.y;
                    this.inertia.y *= 0.95;
                } else {
                    this.inertia.y = 0;
                }
                if (this.inertia.y != 0) {
                    if (this._scrollBarV.alpha < 1) {
                        this._scrollBarV.alpha = Math.min(1, this._scrollBarV.alpha+0.1);
                    }
                    this._scrollBarV.y = this.panelHeight * Math.min(1, (-this._content.y / _contentHeight));
                } else {
                    if (this._scrollBarV.alpha > this._minBarAlpha) {
                        this._scrollBarV.alpha = Math.max(0, this._scrollBarV.alpha-0.1);
                    }
                }
            }
            if (this.useHorizontal) {
                if (this._content.x > 0) {
                    this.inertia.x = 0;
                    this._content.x *= 0.8;
                    if (this._content.x < 1) {
                        this._content.x = 0;
                    }
                }

                if (_contentWidth >= this.panelWidth && this._content.x < this.panelWidth - _contentWidth) {
                    this.inertia.x = 0;

                    goal = this.panelWidth - _contentWidth;
                    diff = goal - this._content.x;

                    if (diff > 1) {
                        diff *= 0.2;
                    }
                    this._content.x += diff;
                }

                if (_contentWidth < this.panelWidth && this._content.x < 0) {
                    this.inertia.x = 0;
                    this._content.x *= 0.8;
                    if (this._content.x > -1) {
                        this._content.x = 0;
                    }
                }

                if (Math.abs(this.inertia.x) > 1) {
                    this._content.x += this.inertia.x;
                    this.inertia.x *= 0.95;
                } else {
                    this.inertia.x = 0;
                }

                if (this.inertia.x != 0) {
                    if (this._scrollBarH.alpha < 1) {
                        this._scrollBarH.alpha = Math.min(1, this._scrollBarH.alpha+0.1);
                    }
                    _scrollBarH.x = this.panelWidth * Math.min(1, (-this._content.x / _contentWidth));
                } else {
                    if (this._scrollBarH.alpha > this._minBarAlpha) {
                        this._scrollBarH.alpha = Math.max(0, this._scrollBarH.alpha-0.1);
                    }
                }
            }

        } else {
            if (this.useVertical) {
                if (this._scrollBarV.alpha < 1) {
                    this._scrollBarV.alpha = Math.min(1, this._scrollBarV.alpha+0.1);
                }
                this._scrollBarV.y = this.panelHeight * Math.min(1, (-this._content.y / _contentHeight));
            }

            if (this.useHorizontal) {
                if (this._scrollBarH.alpha < 1) {
                    this._scrollBarH.alpha = Math.min(1, this._scrollBarH.alpha+0.1);
                }
                this._scrollBarH.x = this.panelWidth * Math.min(1, (-this._content.x / _contentWidth));
            }
        }
    }
    
    
    


    facilis.ScrollContent = facilis.promote(ScrollContent, "BaseElement");
    
}());

(function() {

    function View() {
        this.AbstractMainView_constructor();
        
        if (!View.allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }

        this.jsCommandDisabled = false;
        this._inApia=false;
        this._offline=false;
        this.scaleWindow=false;

		this._proId="";
		this._proVerId="";
		this._proName="";
		this._envName="";
		
		
        this.copiedElements=[];

        this.mainProcessData=null;
        this._rootPath = "";
		
		this.langId="";
		this.bgColor="";

        this.uid = 0;
    }
    
    	
    View.VIEW_CLICK 		="viewClick";
    View.ON_SELECT  		="onSelected";
    View.ON_UNSELECT_ALL	="onUnSelectAll";
    View.ON_DELETE 			="onDeleted";
    View.ON_BEFORE_LOAD 	=	"onBeforeLoad";
    View.ON_LOAD		 	=	"onLoad";
    View.ON_CLEAR		 	=	"onClear";
    View.ON_ZOOM		 	=	"onZoom";
    View.ON_BEFORE_PASTE 	=	"onBeforePaste";
    View.ON_PASTE		 	=	"onPaste";

    View.canDelete = true;
    View.complexDoc = true;
    View.showCircles = false;
    View.importDisconnectedArtifacts = false;
    
    View.max_width=null;
	View.max_height=null;
		
    
    
    View._instance=null;
    View.allowInstantiation=false;
    View.getInstance=function(){
        if (facilis.View._instance == null) {
            View.allowInstantiation = true;
            View._instance = new facilis.View();
            //this._instance.appendMe();
            View.allowInstantiation = false;
        }
        return View._instance;
    }
    
    var element = facilis.extend(View, facilis.AbstractMainView);
    
    element.AbstractMainViewSetup=element.setup;
    element.setup = function() {
        this.AbstractMainViewSetup();
    };


    element.abstractInit=element.init;
    element.init=function(_stage) {
        if(this.stage && !_stage)
            _stage=this.stage;
        
        this.abstractInit(_stage);
        if (View.showCircles) {
            /*var mc = new MovieClip();
            mc.graphics.beginFill(0x000000);
            mc.graphics.drawCircle(0, 0, 10);
            mc.graphics.endFill();
            _stage.addChild(mc);
            mc.x = 500;
            mc.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) { 
                View.getInstance().resetElementIds();
                var model = Parser.getInstance().parseOut(View.getInstance().getExportXML());
                trace(model);
                jsCommand("modelOut('"+model+"')");
            } );

            var mc2 = new MovieClip();
            mc2.graphics.beginFill(0x004400);
            mc2.graphics.drawCircle(0, 0, 10);
            mc2.graphics.endFill();
            _stage.addChild(mc2);
            mc2.x = 600;
            mc2.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) { 
                loadModel("model.xpdl");
            } );*/
        }
        
    }
    
    
    element.removeAnElement=function(el) {
        if(el){
            if (el.parent == this.getLaneView()) {
                this.getLaneView().removeElement(el);
            }else {
                this.getElementView().removeElement(el);
            }
        }
    }

    
    element.getUniqueId=function() {
        this.uid++;
        return this.uid;
    }

    
    element.getExportXML=function() { 
        resetElementIds();
        var els= facilis.ElementView.getInstance().getElements();
        var lanes = facilis.LaneView.getInstance().getElements();
        var parents = []
        for (var i = 0; i < els.length; i++ ) {
            var el = (els[i]);
            if (!el.getContainer()) {
                parents.push(el);
            }
        }
        i = 0;
        for (i = 0; i < lanes.length; i++ ) {
            el = (lanes[i]);
            if (!el.getContainer()) {
                parents.push(el);
            }
        }
        i = 0;
        var mainPoolNode = getMainProcessExportData();
        var mainSubElements;
        for (i = 0; i < mainPoolNode.children.length; i++ ) {
            if (mainPoolNode.children[i].nodeName=="subElements") {
                mainSubElements = mainPoolNode.children[i];
            }
        }
        if (!mainSubElements) {
            mainSubElements = new XMLNode(1, "subElements");
        }
        var deps;
        i = 0;
        var u;
        for (i = 0; i < parents.length; i++ ) {
            el = (parents[i]);
            if (el.elementType == "pool") {
                deps = getPoolDependencies(el);
                var poolNode = el.getExportData();
                var subElements = getSubNode(poolNode, "subElements");
                u = 0;
                for (u = 0; u < deps.length; u++ ) {
                    subElements.appendChild((deps[u]).getExportData());
                }
                mainSubElements.appendChild(poolNode);
            }
            //else {
                deps = getElementDepencencies(el);
                u = 0;
                for (u = 0; u < deps.length;u++ ) {
                    mainSubElements.appendChild((deps[u]).getExportData());
                }
                if (el.elementType != "pool") {
                    mainSubElements.appendChild(el.getExportData());
                }
            //}
        }
        mainPoolNode.appendChild(mainSubElements);
        return mainPoolNode;
    }

    element.getParsedModel=function() {
        return Parser.getInstance().parseOut(facilis.View.getInstance().getExportXML());
    }

    element.getPoolDependencies=function(el) {
        var deps = []
        for (var i = 0; i < el.getContents().length; i++) {
            var subEl = el.getContents()[i];
            if (subEl.elementType != "pool") {
                var lines = getElementDepencencies(subEl);
                for ( var u = 0; u < lines.length; u++ ) {
                    if(lines[u]){
                        deps.push(lines[u]);
                    }
                }
            }
        }
        return deps;
    }

    element.getElementDepencencies=function(el) {
        var deps = []
        var data= el.getData();
        var allDeps = facilis.LineView.getInstance().getLinesOf(el);

        var InputSet = new XMLNode(1, "InputSets");
        var OutputSet = new XMLNode(1, "OutputSets");
        var i = 0;
        for (i = 0; i < allDeps.length; i++ ) {
            var line = allDeps[i];
            if (line.getStartElement() == el) {
                var endType = (line.getEndElement()).elementType;
                if (endType == "group" || endType == "dataobject" || endType == "textannotation" ) {
                    var outputset = new XMLNode(1, "OutputSet");
                    var output = new XMLNode(1, "Output");
                    outputset.appendChild(output);
                    output.attributes.ArtifactId=(line.getEndElement()).getData().attributes.id;
                    OutputSet.appendChild(output);
                }
                deps.push(allDeps[i]);
            }else {
                var startType = (line.getStartElement()).elementType;
                if(startType=="group" || startType=="dataobject" || startType=="textannotation" ){
                    var inputset = new XMLNode(1, "InputSet");
                    var input = new XMLNode(1, "Input");
                    inputset.appendChild(input);
                    input.attributes.ArtifactId=(line.getStartElement()).getData().attributes.id;
                    InputSet.appendChild(inputset);
                }
            }
        }
        el.getData().appendChild(OutputSet);
        el.getData().appendChild(InputSet);
        i = 0;
        if (el.elementType != "pool") {
            for (i = 0; i < el.getContents().length; i++ ) {
                var lines = getElementDepencencies(el.getContents()[i]);
                for ( var u = 0; u < lines.length; u++ ) {
                    if(lines[u]){
                        deps.push(lines[u]);
                    }
                }
            }
        }
        return deps;
    }

    element.getMainProcessData=function() {
        if (!this.mainProcessData) {
            this.mainProcessData = facilis.ElementAttributeController.getInstance().getElementAttributes("back");
            this.mainProcessData.attributes.id = facilis.View.getInstance().getUniqueId();
            this.mainProcessData.attributes.process = facilis.View.getInstance().getUniqueId();
        }
        return this.mainProcessData;
    }

    element.setMainProcessAction=function(type) {
        var back = this.getMainProcessData();
        var bpmn=back.firstElementChild;
        for (var u = 0; u < bpmn.children.length; u++ ) {
            if (bpmn.children[u].getAttribute("name") == "protype") {
                bpmn.children[u].setAttribute("value",type);
            }
        }
        return this.mainProcessData;
    }


    element.resetMainProcessData=function() {
        this.mainProcessData = null;
        this.dispatchEvent(new facilis.Event(facilis.View.VIEW_CLICK));
    }

    element.setMainProcessData=function(main) {
        this.mainProcessData=main;
    }

    element.getMainProcessExportData=function() {
        var node = this.getMainProcessData().cloneNode(true);
        node.attributes.name = "pool";
        return node;
    }


    element.loadModel=function(url) {
        var loader = new createjs.LoadQueue();
        
          loader.addEventListener("fileload", this.loadXML.bind(this));
          loader.loadFile({src:url, type:createjs.AbstractLoader.XML});
        
        /*loader.addEventListener(Event.COMPLETE, loadXML); 
        loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
        loader.load(new URLRequest(url));*/
    }

    element.loadXML=function(evt) {
        this.dispatchEvent(new facilis.Event(facilis.View.ON_DELETE));
        this.dispatchEvent(new facilis.Event(facilis.View.ON_BEFORE_LOAD));
        this.clearAll();
        /*var xDoc = new XMLDocument();
        xDoc.ignoreWhite = true;
        var xml = new XML(evt.target.data);*/
        //var xml = removeNamespaces(evt.target.data);
        var xml = evt.result;
        
        //Parser.getInstance().parseIn(xDoc)
        var p=new facilis.parsers.ParserIn();
        var parsed=p.parse(xml);
        
        //xDoc.parseXML(xml.toString());
        var drawer = new facilis.ModelDrawer();
        drawer.drawModel(parsed);
        //drawer.drawModel(Parser.getInstance().parseIn(xDoc));
        this.dispatchEvent(new facilis.Event(facilis.View.ON_LOAD));
        //flashLoaded();
        //this.dispatchEvent(new facilis.Event(LOADED));

    }

    element.loading_xpdl = false;
		
    element.loadModelString=function(xmlStr) {
        this.dispatchEvent(new facilis.Event(facilis.View.ON_DELETE));
        this.dispatchEvent(new facilis.Event(facilis.View.ON_BEFORE_LOAD));
        this.clearAll();
        if (xmlStr != "") {
			this.loading_xpdl = true;
            /*var xDoc = new XMLDocument();
            xDoc.ignoreWhite = true;
            var xml = new XML(str);
            xDoc.parseXML(xml.toString());*/
            var doc=   ( new window.DOMParser() ).parseFromString(xmlStr, "text/xml");
            var drawer = new facilis.ModelDrawer();
            //var parsed = Parser.getInstance().parseIn(doc.firstChild);
            
            var p=new facilis.parsers.ParserIn();
            var parsed=p.parse(doc);
            
            drawer.drawModel(parsed);
			this.loading_xpdl = false;
            this.dispatchEvent(new facilis.Event(facilis.View.ON_LOAD));
        }
        //this.flashLoaded();
    }

    element.jsCommand=function(comm) {
        if(!jsCommandDisabled){
            var url = 'javascript:'+comm;
            var request = new URLRequest(url);
            try {
                navigateToURL(request, '_self'); // second argument is target
            } catch (e) {
                trace("Error occurred!");
            }
            //ExternalInterface.call(comm);
        }
    }

    Object.defineProperty(element, 'rootPath', {
        get: function() { 
            return this._rootPath;
        },
        set: function(val) {
            this._rootPath=val;
        }
    });
    
    Object.defineProperty(element, 'inApia', {
        get: function() { 
            return this._inApia;
        },
        set: function(val) {
            this._inApia=val;
        }
    });

    
    Object.defineProperty(element, 'offline', {
        get: function() { 
            return this._offline;
        },
        set: function(val) {
            this._offline=val;
        }
    });
    
    Object.defineProperty(element, 'mainStage', {
        get: function() { 
            return this._mainStage;
        }
    });
	
	Object.defineProperty(element, 'proId', {
        get: function() { 
            return this._proId;
        },
        set: function(val) {
            this._proId=val;
        }
    });
	
	Object.defineProperty(element, 'proVerId', {
        get: function() { 
            return this._proVerId;
        },
        set: function(val) {
            this._proVerId=val;
        }
    });
	
	Object.defineProperty(element, 'proName', {
        get: function() { 
            return this._proName;
        },
        set: function(val) {
            this._proName=val;
        }
    });
	
	Object.defineProperty(element, 'envName', {
        get: function() { 
            return this._envName;
        },
        set: function(val) {
            this._envName=val;
        }
    });


    element.checkDrop=function(mc) {
        if (mc != null) {
            var pt = new facilis.Point(mc.x, mc.y);
            pt = mc.parent.localToGlobal(pt);
            var pt2 = new facilis.Point(mc.x, mc.y);
            pt2 = mc.stage.localToGlobal(pt2);
            for (var i = 0; i < _mainStage.numChildren; i++ ) {
                var test = _mainStage.getChildAt(i);
                if (_mainStage.getChildAt(i).hitTestPoint(pt.x,pt.y,true) &&
                    _mainStage.getChildAt(i)!=scroll
                ) {
                    return false;
                }
            }
            if (WindowManager.getInstance().hitTestPoint(pt.x, pt.y, true)) {
                return false;
            }
            return true;
        }
        return false;
    }

    element.clearAll=function() {
        facilis.LaneView.getInstance().clearAllElementEvents();
        facilis.ElementView.getInstance().clearAllElementEvents();
        facilis.LineView.getInstance().clearAllElementEvents();
        facilis.LaneView.getInstance().clear();
        facilis.ElementView.getInstance().clear();
        facilis.LineView.getInstance().clear();
        this.dispatchEvent(new facilis.Event(facilis.View.ON_CLEAR));
    }

    element.startMainPool=function() {
        /*mainPool= new Element("view.elements.lanes.BackElement");
        mainPool.elementType = "back";
        getLaneView().addElement(mainPool);
        drawBack();*/
        //this.addElement(mainPool);
    }

    element.checkDropIns=function(el) {
        var els=getLaneView().getElements();
        for (var i = 0; i < els.length; i++ ) {
            if ( (els[i]).hitTest(el) && facilis.validation.RuleManager.getInstance().getDropInRules().validate([els[i], el])) {
                return true;
            }
        }
        return false;
    }

    element.getNextElement=function(el) {
        var type = el.elementType;
        var count = 0;
        var els = _instance.getElementView().getElements();
        for (var i = 0; i < els.length;i++ ) {
            if ((els[i]).elementType == type) {
                count++;
            }
        }
        els = _instance.getLaneView().getElements();
        i = 0;
        for (i = 0; i < els.length;i++ ) {
            if ((els[i]).elementType == type) {
                count++;
            }
        }
        return count;
    }

    element.refreshElementAttributes=function() {
        this.dispatchEvent(new facilis.Event(facilis.View.VIEW_CLICK));
        this.dispatchEvent(new facilis.Event(AbstractElement.ELEMENT_CLICKED));
    }

    element.getElements=function() {
        var els = []
        for (var i = 0; i < facilis.ElementView.getInstance().getElements().length;i++ ) {
            els.push(facilis.ElementView.getInstance().getElements()[i]);
        }
        i = 0;
        for (i = 0; i < facilis.LaneView.getInstance().getElements().length;i++ ) {
            els.push(facilis.LaneView.getInstance().getElements()[i]);
        }
        return els;
    }

    element.getElementsAndLines=function() {
        var els = []
        els = els.concat(facilis.ElementView.getInstance().getElements());
        els = els.concat(facilis.LaneView.getInstance().getElements());
        els = els.concat(facilis.LineView.getInstance().getElements());

        return els;
    }

    element.resetElementIds=function() {
        uid = 0;
        var mainData = this.getMainProcessData();
        mainData.attributes.id = View.getInstance().getUniqueId();
        mainData.attributes.process = View.getInstance().getUniqueId();
        for (var i = 0; i < facilis.ElementView.getInstance().getElements().length;i++ ) {
            (facilis.ElementView.getInstance().getElements()[i]).resetId();
        }
        i = 0;
        for (i = 0; i < facilis.LaneView.getInstance().getElements().length;i++ ) {
            (facilis.LaneView.getInstance().getElements()[i]).resetId();
        }
        i = 0;
        for (i = 0; i < facilis.LineView.getInstance().getElements().length;i++ ) {
            (facilis.LineView.getInstance().getElements()[i]).resetId();
        }
    }

    element.copySelectedElements=function() {
        copiedElements = []
        var middleEvents = []
        var pools = []
        var lanes = []
        var data;
        for (var i = 0; i < this.selectedElements.length; i++ ) {
            if ((this.selectedElements[i]).elementType != "pool" &&
            (this.selectedElements[i]).elementType != "middleevent" &&
            (this.selectedElements[i]).elementType != "swimlane"
            ) {
                data = (this.selectedElements[i]).getData().cloneNode(true);
                copiedElements.push(data);
            }
            if ((this.selectedElements[i]).elementType == "middleevent") {
                data = (this.selectedElements[i]).getData().cloneNode(true);
                middleEvents.push(data);
            }
            if ((this.selectedElements[i]).elementType == "pool") {
                data = (this.selectedElements[i]).getData().cloneNode(true);
                pools.push(data);
            }
            if ((this.selectedElements[i]).elementType == "swimlane") {
                data = (this.selectedElements[i]).getData().cloneNode(true);
                lanes.push(data);
            }
        }
        i = 0;
        for (i = 0; i < middleEvents.length; i++ ) {
            copiedElements.push(middleEvents[i]);
        }
        i = 0;
        if(copiedElements.length>0){
            for (i = 0; i < this.selectedLines.length; i++ ) {
                data = (this.selectedLines[i]).getData().cloneNode(true);
                copiedElements.push(data);
            }
        }
        i = 0;
        for (i = 0; i < pools.length; i++ ) {
            copiedElements.push(pools[i]);
        }
        i = 0;
        for (i = 0; i < lanes.length; i++ ) {
            copiedElements.push(lanes[i]);
        }
    }

    element.pasteCopiedElements=function(x, y) {
        this.dispatchEvent(new facilis.Event(facilis.View.ON_BEFORE_PASTE));
        this.unselectAll();
        var els = []
        var toPasteElements = []
        var toPasteLines = []
        var ids = new {};
        var i = 0;
        if(this.copiedElements.length>0){
            var minx = parseInt(this.copiedElements[0].attributes.x) - (parseInt(this.copiedElements[0].attributes.width) / 2);
            var miny = parseInt(this.copiedElements[0].attributes.y) - (parseInt(this.copiedElements[0].attributes.height) / 2);
            for (i = 0; i < this.copiedElements.length; i++ ) {
                if (this.copiedElements[i].attributes.name != "sflow" && this.copiedElements[i].attributes.name != "swimlane" &&  this.copiedElements[i].attributes.name != "mflow" && this.copiedElements[i].attributes.name != "association") {
                    var elX = parseInt(this.copiedElements[i].attributes.x) - (parseInt(this.copiedElements[i].attributes.width) / 2);
                    var elY = parseInt(this.copiedElements[i].attributes.y) - (parseInt(this.copiedElements[i].attributes.height) / 2);
                    if (minx >= elX) {
                        minx = elX;
                    }
                    if (miny >= elY) {
                        miny = elY;
                    }
                }
            }
            var p = new facilis.Point(x, y);
            //p = target.parent.localToGlobal(p);
            p = View.getInstance().getElementView().globalToLocal(p);

            var xDif = (p.x) - (minx);
            var yDif = (p.y) - (miny);
            i = 0;
            for (i = 0; i < this.copiedElements.length; i++ ) {
                var clonedData = this.copiedElements[i].cloneNode(true);
                ids[clonedData.attributes.id] = _instance.getUniqueId();
                clonedData.attributes.id = ids[clonedData.attributes.id];
                if(clonedData.attributes.startid && clonedData.attributes.endid){
                    toPasteLines.push(clonedData);
                }else {
                    clonedData.attributes.x = parseInt(clonedData.attributes.x)+ xDif;
                    clonedData.attributes.y = parseInt(clonedData.attributes.y) + yDif;
                    toPasteElements.push(clonedData);
                }
            }
            var m = new ModelDrawer();
            i = 0;
            for (i = 0; i < toPasteElements.length; i++ ) {
                var el = m.draw(toPasteElements[i]);
                if (el) {
                    els.push(el);
                }
            }
            i = 0;
            for (i = 0; i < toPasteLines.length; i++ ) {
                var toPasteLine = toPasteLines[i];
                toPasteLine.attributes.startid = ids[toPasteLines[i].attributes.startid];
                toPasteLine.attributes.endid = ids[toPasteLines[i].attributes.endid];

                var vertex;
                var u = 0;
                for (u = 0; u < toPasteLine.children.length; u++ ) {
                    if (toPasteLine.children[u].localName=="vertex") {
                        vertex = toPasteLine.children[u];
                        break;
                    }
                }
                u = 0;
                if(vertex){
                    for (u = 0; u < vertex.children.length; u++ ) {
                        vertex.children[u].attributes.XCoordinate = parseInt(vertex.children[u].attributes.XCoordinate) + xDif;
                        vertex.children[u].attributes.YCoordinate = parseInt(vertex.children[u].attributes.YCoordinate) + yDif;
                    }
                }
                var ln = m.draw(toPasteLines[i]);
                if (ln) {
                    els.push(ln);
                }
            }
        }
        this.dispatchEvent(new facilis.Event(facilis.View.ON_PASTE));
        i = 0;
        for (i = 0; i < els.length; i++ ) {
            els[i].dispatchEvent(new facilis.Event(AbstractElement.ELEMENT_ADDED));
        }
        return els;
    }

    element.hasCopiedElements=function() { 
        if(this.copiedElements){
            return (this.copiedElements.length > 0);
        }
        return false;
    }

    element.selectAll=function() {
        var el;
        for (var e = 0; e < getElementView().getElements().length; e++ ) {
            el = getElementView().getElements()[e];
            el.select();
            select(el);
        }
        e = 0;
        for (e = 0; e < getLineView().getElements().length; e++ ) {
            el = getLineView().getElements()[e];
            el.select();
            select(el);
        }
        e = 0;
        for (e = 0; e < getLaneView().getElements().length; e++ ) {
            el = getLaneView().getElements()[e];
            el.select();
            select(el);
        }

    }

    element.getSubNode=function(n, name) {
        for (var i = 0; i < n.children.length;i++ ) {
            if (((n.children[i]).attributes.name==name || (n.children[i]).nodeName==name) && ( (n.children[i]).attributes.disabled != "true" ) ) {
                return (n.children[i]);
            }
            if (((n.children[i]).attributes.name == name || (n.children[i]).nodeName == name) && ( (n.children[i]).attributes.disabled == "true" ) ) {
                return null;
            }
        }
        i = 0;
        for (i = 0; i < n.children.length; i++ ) {
            if(n.children[i].nodeName!="subElements" && ( (n.children[i]).attributes.disabled != "true" ) ){
                var subNode = getSubNode((n.children[i]), name);
                if (subNode) {
                    return subNode;
                }
            }
        }
        return null;
    }


    element.getMaximizedWidth=function() {
        return max_width;
    }

    element.getMaximizedHeight=function() {
        return max_height;
    }

    element.setMaximizedWidth=function(m_width) {
        max_width = m_width;
    }

    element.setMaximizedHeight=function(m_height) {
        max_height = m_height;
    }
    
    
    
    
    facilis.View = facilis.promote(View, "AbstractMainView");
    
    
    
}());

(function() {

    function ZoomScroll() {
        this.BaseElement_constructor();
        
        this.back;
		this.handle;
		
		this._width=200;
		this._height = 20;
		
		this._backW = null;
		this._backH = null;
		
		this._zoom;

        this.setup();
    }
    
    ZoomScroll.ON_ZOOM = "onZoomed";
    ZoomScroll.ON_ZOOMEND = "onZoomEnd";
    
    
    var element = facilis.extend(ZoomScroll, facilis.BaseElement);

    
    element.setup = function() {
        this.back = new facilis.BaseElement();
        this.handle = new facilis.BaseElement();
        this.addChild(this.back);
        this.addChild(this.handle);
        this.drawBack();
        this.drawHandle();
        this.handle.addEventListener("pressmove", this.onHandleDownMove.bind(this));
        this.handle.addEventListener("pressup", this.pressUp.bind(this));
        facilis.View.getInstance().addEventListener(Event.RESIZE, this.onResize.bind(this));
        //facilis.View.getInstance()._stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    } ;

    element.drawBack=function() {
        this.back.graphics=new facilis.Graphics();
        
        this.back.graphics.lineStyle(2,"#999999");
        
        this.back.graphics.beginFill("rgba(99,99,99,.9)");
        this.back.graphics.drawRoundRect(0, 0, this._width, this._height, 15, 15);
        this.back.graphics.endFill();

        this.back.graphics.lineStyle(1,"#666666");

        this.back.graphics.beginFill("rgba(240,240,240,.9)");
        this.back.graphics.drawRoundRect( ( this._width/2-( (this._width-20)/2 ) ), ( this._height/2-( (5)/2 ) ), this._width-20, 5, 5, 5);
        this.back.graphics.endFill();
        
        this.back.graphics.lineStyle(2,"#999999");
        
        this.back.graphics.moveTo((this._width / 2), -2);
        this.back.graphics.lineTo((this._width / 2), 5);
        this.back.graphics.moveTo((this._width / 2), this._height-5);
        this.back.graphics.lineTo((this._width / 2), this._height+2);
        this.back.addShape(new facilis.Shape(this.back.graphics));
        //this.back.cache(-(this._width+20 / 2),-10,(this._width+20 / 2),this._height+20);
        this.back.cache(-10,-10,this._width+10,this._height+10);

    }

    element.drawHandle=function() {
        this.handle.graphics=new facilis.Graphics();
        this.handle.graphics.beginFill("rgba(99,99,99,.01)");
        this.handle.graphics.drawRect( -15, -15, 30, 30);
        this.handle.graphics.endFill();
        
        this.handle.graphics.lineStyle(2,"#999999");
        
        this.handle.graphics.beginFill("rgba(99,99,99,.9)");
        //this.handle.graphics.drawRoundRect(0, 0, 15, 15, 15, 15);
        this.handle.graphics.drawCircle(0, 0, 8);
        this.handle.graphics.endFill();
        this.handle.x = (this._width / 2);// - (this.handle.width / 2);
        this.handle.y = (this._height / 2);// - (this.handle.height / 2);
        this.handle.addShape(new facilis.Shape(this.handle.graphics));
        this.handle.cache(-10,-10,20,20);

    }

    element.onHandleDownMove=function(e) { 
        e.stopPropagation();
        var x = 10;
        var w = (this._width - 20);
        //this.handle.startDrag(false, new Rectangle(x, this._height / 2, w, 0));
        
        var p={};
        this.handle.parent.globalToLocal(e.stageX,0,p);
        
        this.handle.x = Math.min(w, Math.max(x, p.x));
        this.handle.y = this._height/2;
     
        this.updateZoom();
    }
    
    element.pressUp=function(e) { 
        e.stopPropagation();
        this.dispatchEvent(new facilis.Event(ZoomScroll.ON_ZOOMEND));
    }

    element.updateZoom=function() {
        var z =  this.handle.x - (this._width / 2);
        if (z<0) {
            z = Math.abs(z / 100) + 1;
            z = 1 / z;
        }else if (z == 0) {
            z = 1;
        }else if (z > 0) {
            z = (100+z) / 100;
        }
        this._zoom = z;
        this.dispatchEvent(new facilis.Event(ZoomScroll.ON_ZOOM));
        facilis.View.getInstance().zoom(z);
    }

    element.onResize=function(e) {
        this.positionMe(this._backW,this._backH);
    }

    element.positionMe=function(w, h) {
        if(!w){
            w = facilis.View.getInstance().getStageWidth();
        }
        this._backW = w;
        if(!h){
            h = facilis.View.getInstance().getStageHeight();
        }
        this._backH = h;
        this.x = (w - this._width) - 20;
        this.y = (h - this._height) - 20;
    }

    element.resetZoom=function() {
        this.handle.x = (this._width / 2);
        this._zoom = 1;
        facilis.View.getInstance().zoom(1);
    }

    element.onMouseWheel=function(e) {
        var w = (this._width - 20);
        var delta = 10;
        if (e.delta < 3) {
            delta = -10;
        }
        this.handle.x += delta;
        if (this.handle.x<10) {
            this.handle.x = 10;
        }
        if (this.handle.x>w) {
            this.handle.x = w;
        }
        this.updateZoom();
    }
    
    Object.defineProperty(element, 'zoom', {
        get: function() { return this._zoom; },
        set: function(z) { 
            this._zoom = z;
            this.handle.x = this._zoom * (this._width / 2);

            this.dispatchEvent(new facilis.Event(ZoomScroll.ON_ZOOM));
            facilis.View.getInstance().zoom(z);
        }
    });


    facilis.ZoomScroll = facilis.promote(ZoomScroll, "BaseElement");
    
}());


(function() {

    function RuleManager() {
        
    }
    
    RuleManager._instance=null;
    RuleManager.allowInstantiation=false;
    RuleManager.getInstance=function(){
        if (RuleManager._instance == null) {
            RuleManager.allowInstantiation = true;
            RuleManager._instance = new RuleManager();
            //this._instance.appendMe();
            RuleManager.allowInstantiation = false;
        }
        return RuleManager._instance;
    }
    
    var element = facilis.extend(RuleManager, {});

    element.getDropRules=function(){
        return {validate:function(){return true;}};
    }
    
    element.checkDropRule=function(){
        return true;
    }
    
    facilis.validation.RuleManager = facilis.promote(RuleManager, "Object");
    
}());

(function() {

    function ModelDrawer() {
        this.elements=[];
		this.artifacts=[];
		this.associations=[];
    }
    
    var element = facilis.extend(ModelDrawer, {});
    

    element.drawModel=function(el) {
        this.artifacts = new Array();
        this.associations = new Array();
        this.drawElement(el, null);
        this.drawElements(el, null);
        this.drawLines(el);
        this.drawSubEvents();
        this.drawAssociations();
        for (var i = 0; i < this.artifacts.length; i++ ) {
            if((this.artifacts[i]).elementType!="group"){
                var linesOf = facilis.View.getInstance().getLineView().getLinesOf(this.artifacts[i]);
                if ((!linesOf || (linesOf && linesOf.length == 0)) && !facilis.View.importDisconnectedArtifacts) {
                    (this.artifacts[i]).remove();
                }
            }
        }
    }


    element.drawElements=function(el, parent) {
        for (var i = 0; i < el.children.length; i++ ) {
            if (el.children[i].nodeName == "subElements") {
                this.drawElements(el.children[i],parent);
            }
            if (el.children[i].nodeName=="element") {
                var pt = this.drawElement(el.children[i], parent);
                if (el.children[i].getAttribute("name") != "csubflow") {
                    this.drawElements(el.children[i], pt);
                }
            }
        }
    }

    element.drawLines=function(el) {
        for (var i = 0; i < el.children.length; i++ ) {
            if (el.children[i].nodeName=="subElements") {
                this.drawLines(el.children[i]);
            }
            if (el.children[i].nodeName == "element") {
                if (el.children[i].getAttribute("name") == "association") {
                    this.associations.push(el.children[i]);
                }else{
                    this.drawLine(el.children[i]);
                    this.drawLines(el.children[i]);
                }
            }
        }
    }

    element.drawAssociations=function() {
        for (var i = 0; i < this.associations.length; i++ ) {
            this.drawLine(this.associations[i]);
        }
    }

    element.dotrace = false;

    element.drawElement=function(el, parent) {
        var name = el.getAttribute("name");
        this.dotrace = (name == "task");
        if (name == "task" || name == "csubflow" || name == "startevent" ||
        name == "middleevent" || name == "endevent" || name == "gateway" || 
        name == "datastore" || name == "textannotation" || name == "dataobject" || name == "datainput" || name == "dataoutput" ||
		name == "pool" || name == "esubflow" || name == "group" || (name == "swimlane"  && parent ) ) {
            var className = this.getClassName(name);
            var elem= new facilis.Element(className);
            elem.elementType = name;
            var width= el.getAttribute("width");
            var height = el.getAttribute("height");
            if (name == "pool" || name == "esubflow" || name == "swimlane" || name == "group") {
                var visible = (el.getAttribute("visible") != "false");
                if (visible) {
                    facilis.View.getInstance().getLaneView().addElement(elem);
                }else {
                    return null;
                }
                if(width && height){
                    elem.setSize(width, height);
                }
            }else {
                if (name == "textannotation") {
                    if(width && height){
                        elem.setSize(width, height);
                    }
                }
                facilis.View.getInstance().getElementView().addElement(elem);
            }
            var x= parseInt(el.getAttribute("x"));
            var y = parseInt(el.getAttribute("y"));
            var w = elem.getElement().width;
            var h = elem.getElement().height;
            try {
                w = (elem.getElement()).getRealWidth();
                h = (elem.getElement()).getRealHeight();
            }catch (e) { }
            elem.x = x + parseInt(w / 2);
            elem.y = y + parseInt(h / 2);

            //trace(elem.x+" "+elem.y+" "+(parent?parent.elementType:""));
            if (name == "textannotation" || name == "dataobject" || name == "datainput" || name == "dataoutput" || name == "group") {
                this.artifacts.push(elem);
            }
            var data = el.cloneNode(true);
            this.removeSubNodes(data);
            elem.setData(data);

            //elem.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROP));
            this.elements.push(elem);
            if (parent) {
                //elem.x = parent.x;
                //elem.y = parent.y;
                elem.setContainer(parent);
                if (name == "swimlane") {
                    (parent.getElement()).addInnerElement(elem);
                }
            }else {
                elem.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DROP));
            }
            this.setValues(elem);
            return elem;
        }else if (name == "back") {
            var back = el.cloneNode(true);
            this.removeSubNodes(back);
            facilis.View.getInstance().setMainProcessData(back);
        }
        return null;
    }

    element.removeSubNodes=function(data) {
        if(data.getAttribute("name")!="csubflow"){
            var subElements;
            for (var d = 0; d < data.children.length; d++ ) {
                if (data.children[d].nodeName == "subElements") {
                    subElements = data.children[d];
                    //(data.children[d]).removeNode();
                }
            }
            if(subElements){
                for (var i = (subElements.children.length-1); i >=0 ; i-- ) {
                    if (subElements.children[i].getAttribute("name") == "pool") {
                        if (subElements.children[i].getAttribute("visible")!="false") {
                            subElements.children[i].parentNode.removeChild(subElements.children[i]);
                        }
                    }else {
                        subElements.children[i].parentNode.removeChild(subElements.children[i]);
                    }
                }
            }
        }else {
            return;
        }
    }

    element.drawLine=function(el) {
        var start = this.getElement(el.getAttribute("startid"));
        var end = this.getElement(el.getAttribute("endid"));
        return this.getLineFromVertexes(el, start, end);
    }

    element.getLineFromVertexes=function(el, start, end) {
        var name = el.getAttribute("name");
        if (name == "association" || name == "mflow" || name == "sflow") {
            if(start && end){
                start.x = (start.x > 0)?start.x:600;
                start.y = (start.y > 0)?start.y:600;
                end.x = (end.x > 0)?end.x:600;
                end.y = (end.y > 0)?end.y:600;
                var startType = (start).elementType;
                var endType = (end).elementType;
                var startElement=start;
                var endElement = end;
                if (startType == "association" || startType == "mflow" || startType == "sflow") {
                    startElement = (start).middle;
                }
                if (endType == "association" || endType == "mflow" || endType == "sflow") {
                    endElement = (end).middle;
                }
                var line = facilis.View.getInstance().getLineView().addLine(startElement, endElement);
                (startElement).dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_MOVED));
                (endElement).dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_MOVED));
                if (line) {
                    try{
                        line.setData(el.cloneNode(true));
                        this.elements.push(line);
                        line.elementType = name;
                        line.callStartEndFunctions();
                        if (name == "association") {
                            line.setType("dotted");
                        }else if (name == "mflow") {
                            line.setType("dashed");
                            line.setCircle();
                        }else {
                            line.callStartEndFunctions();
                        }
                    }catch(e){}
                    line.elementType = name;
                    for (var i = 0; i < el.children.length; i++ ) {
                        if (el.children[i].nodeName == "vertex") {
                            this.setLineVertexes(line, el.children[i]);
                        }
                    }
                    this.setValues(line);
                    return line;
                }
            }
        }
    }

    element.setLineVertexes=function(line, vertexes) {
        var start = line.getStartElement();
        if (vertexes.children.length >= 3) {
            for (var i = 1; i < vertexes.children.length - 1; i++ ) {
                start=line.addVertex(start, line.getEndElement(), parseInt(vertexes.children[i].getAttribute("XCoordinate")), parseInt(vertexes.children[i].getAttribute("YCoordinate")));
            }
        }
    }

    element.drawSubEvents=function() {
        for (var i = 0; i < this.elements.length; i++ ) {
            if ((this.elements[i]).elementType == "middleevent") {
                if((this.elements[i]).getData().getAttribute("isattached") == "true") {
                    var target = (this.elements[i]).getData().getAttribute("target");
                    var container = this.getElement(target);
                    //this.elements[i].x = (container.x + (container.width / 2))-30;
                    //this.elements[i].y = (container.y + (container.height / 2)) - 10;
                    (this.elements[i]).setContainer(container);
                }/*else {
                    (this.elements[i]).setContainer(null);
                }*/
            }
        }
    }

    element.getClassName=function(name) {
        var pack = "view.elements.";
        var className = "";
        switch (name){
            case "task":
            className = "TaskElement";
            break;
            case "csubflow":
            className = "CSubFlowElement";
            break;
            case "esubflow":
            className = "ESubFlowElement";
            break;
            case "startevent":
            className = "StartEventElement";
            break;
            case "middleevent":
            className = "MiddleEventElement";
            break;
            case "endevent":
            className = "EndEventElement";
            break;
            case "gateway":
            className = "GatewayElement";
            break;
            case "pool":
            className = "PoolLane";
            break;
            case "group":
            className = "GroupLane";
            break;
            case "swimlane":
            className = "SwimLane";
            break;
            case "textannotation":
            className = "TextAnnotation";
            break;
            case "dataobject":
            className = "DataObject";
            break;
			case "datainput":
			className = "DataInput";
			break;
			case "dataoutput":
			className = "DataOutput";
			break;
			case "datastore":
			className = "DataStore";
			break;
        }

        return facilis[className];//pack + className;

        /*assosiation view.tools.Connector dotted
        mflow view.tools.Connector dashed
        sflow view.tools.Connector*/
    }

    element.getElement=function(id) {
        for (var i = 0; i < this.elements.length; i++ ) {
            var d = (this.elements[i]).getData();
            var e = this.elements;
            var elid = (this.elements[i]).getData().getAttribute("id");
            if (elid == id) {
                return this.elements[i];
            }
        }
    }

    element.setValues=function(el) {
        if(el != null) {
            var data = el.getData();
            for (var i = 0; i < data.children.length; i++ ) {
                var node = data.children[i];
                if(node.nodeName=="attGroup"){
                    for (var u = 0; u < node.children.length;u++ ) {
                        this.parseAttribute(el,node.children[u]);
                    }
                }
            }
        }
    }

    element.parseAttribute=function(el, att) {
        var type = att.getAttribute("type");
        var change = att.getAttribute("change");
        /*var disable = att.getAttribute("disable");
        var enable = att.getAttribute("enable");*/
        var value = att.getAttribute("value");
		var useLabelName = att.getAttribute("useLabelName");

		if (useLabelName == "true") {
			if (att.children != null && att.children.length > 1) {
				var levels = att.children[1].children[0].children;
				for (var j = 0; j < levels.length; j++) {
					if (levels[j].getAttribute("name") == "label") {	
						value = levels[j].getAttribute("value");
						break;
					}
				}
			}
		}
		
        if (att.getAttribute("disabled") == "true") {
            return;
        }
        if (type == "combo" || type == "text" || type == "checkbox" || type == "modal" || type == "modalArray" || type == "colorPicker") {
            if (change) {
                try {
					
					var theEl = el;
					if(el && el.getElement && el.getElement())
						theEl=el.getElement()

                    if(change.indexOf(",")<0){
						theEl[change](value);
                        //f(value);
                    }else {
                        var chgs = change.split(",");
                        for (var c = 0; c < chgs.length; c++ ) {
                            //var fnc = el.getElement()[chgs[c]];
                            //fnc(value);
                            theEl[chgs[c]](value);
                        }
                    }
                }catch (e) { }
            }
            var disable = "";
            var enable = "";
            if (type == "combo") {
                var options = att;//.firstChild;
                for (var o = 0; o < options.children.length;o++ ) {
                    if (options.children[o].getAttribute("value") == value) {
                        disable = options.children[o].getAttribute("disable");
                        enable = options.children[o].getAttribute("enable");
                        break;
                    }
                }
            }else if (type == "checkbox") {
                disable = (value == "true")?att.getAttribute("disable"):att.getAttribute("enable");
                enable = (value == "true")?att.getAttribute("enable"):att.getAttribute("disable");
            }
            disable = (disable)?disable:"";
            enable = (enable)?enable:"";
            if (disable != "") {
                this.setDisable(disable.split(","), "true", el);
            }
            if (enable != "") {
                this.setDisable(enable.split(","), "false", el);
            }
        }else {
            for (var i = 0; i < att.children.length;i++ ) {
                this.parseAttribute(el, att.children[i]);
            }
        }

    }



    element.setDisable=function(disabledNames,value,el) {
        var node = el.getData();
        var disabled = this.getSubNodesFromNames(node,disabledNames);
        for (var i = 0; i < disabled.length;i++ ) {
            var subNode = disabled[i];
            if (subNode) {
                subNode.setAttribute("disabled", value);
                if (value == "true") {
                    if(subNode.getAttribute("type")!="combo"){
                        subNode.setAttribute("value", "");
                    }/*else {
                        if (subNode.firstChild && subNode.firstChildNode.firstChild) {
                            var cmbValue = "";
                            for (var v = 0; v < subNode.firstChildNode.children.length; v++ ) {
                                if (subNode.firstChildNode.children[v].getAttribute("disabled") != "true") {
                                    cmbValue = subNode.firstChildNode.children[v].getAttribute("value");
                                    break;
                                }
                            }
                            subNode.getAttribute("value") = cmbValue;
                        }
                    }*/
                }
            }
        }
    }

    element.getSubNodesFromNames=function(n, names) {
        var namesObj = new Object();
        for (var i = 0; i < names.length; i++ ) {
            namesObj[names[i]] = true;
        }
        namesObj.subNodesCant = names.length;
        return this.getSubNodes(n, namesObj);
    }

    element.getSubNodes=function(n, names, nodes) {
        if (!nodes) {
            nodes = new Array();
        }
        if (names.subNodesCant == 0) {
            return nodes;
        }
        for (var i = 0; i < n.children.length;i++ ) {
            if (names[(n.children[i]).getAttribute("name")]) {
                names.subNodesCant--;
                nodes.push((n.children[i]));
            }
            if (names[(n.children[i]).nodeName]) {
                names.subNodesCant--;
                nodes.push((n.children[i]));
            }
            var subNodes = [];
            if (n.children[i].getAttribute("type") != "modalArray") {
                subNodes = this.getSubNodes((n.children[i]), names, null);
            }
            if (subNodes.length > 0) {
                nodes=nodes.concat(subNodes);
            }
        }
        /*i = 0;
        for (i = 0; i < n.children.length;i++ ) {
            var subNodes = getSubNodes((n.children[i]), names,nodes);
            if (subNodes.length > 0) {
                nodes=nodes.concat(subNodes);
            }
        }*/
        return nodes;
    }

    element.draw=function(data,parent) {
        if (data.getAttribute("startid") && data.getAttribute("endid")) {
            return this.drawLine(data);
        }else{
            var el = this.drawElement(data, parent);
            return el;
        }
    }


    facilis.ModelDrawer = facilis.promote(ModelDrawer, "Object");
    
}());


(function() {

    function ElementText() {
        this.BaseElement_constructor();
        
        this.textField=null;

        this.setup();
    }
    
    
    
    var element = facilis.extend(ElementText, facilis.BaseElement);

    element.setup = function() {
        
        this.textField = new facilis.Text(" ", "11px Arial", "#000");
        this.addChild(this.textField);
        //clickBlocker = new Sprite();
        //this.addChild(clickBlocker);
        this.text = " ";
        this.text = "";
        
    };
    
    Object.defineProperty(element, 'text', {
        set: function(newValue) { 
            this.textField.text = newValue?newValue:"";
        }
    });
    
    /*element.baseWidth=element.width;
    element.width=null;*/
    Object.defineProperty(element, 'width', {
        get: function() { return this.baseWidth; },
        set: function(newValue) { 
            this.baseWidth = newValue;
            this.textField.lineWidth = newValue;
            this.textField.width = newValue; 
        }
    });
    
    /*element.baseHeight=element.height;
    element.height=null;*/
    Object.defineProperty(element, 'height', {
        get: function() { return this.baseHeight; },
        set: function(newValue) { 
            this.baseHeight = newValue;
            var b = this.textField.getBounds();
            this.textField.y=(newValue-((b)?b.height:0))/2;
            this.textField.height = newValue; 
            //this.textField.lineHeight = 15;
        }
    });
    
    Object.defineProperty(element, 'textAlign', {
        get: function() { return this.textField.textAlign; },
        set: function(newValue) { 
            this.textField.textAlign = newValue; 
        }
    });
    
    
    

    facilis.ElementText = facilis.promote(ElementText, "BaseElement");
    
}());

(function() {

    function LaneSizers() {
        this.BaseElement_constructor();
        
        this.sizers=new facilis.BaseElement();
		
		this.lanes=[];
		this.laneHeights=[];
		
		this.laneSizers=[];
		
		this.sizing = false;
		this.actualSizer=new facilis.BaseElement();

        this.setup();
    }
    
    //static public//
    
	LaneSizers.LANE_SIZING = "LANE_SIZING";
	LaneSizers.LANE_SIZED = "LANE_SIZED";
    
    var element = facilis.extend(LaneSizers, facilis.BaseElement);
    
    
    element.setup = function() {
		this.addChild(this.sizers);
    };

    
    element.setLaneSizers = function(lns) {
        if (!this.sizing) {
            this.lanes = [];
            for (var i = 0; i < lns.length;i++ ) {
                this.lanes.push(lns[i]);
            }
            this.lanes.sort(
                function compare(a,b) {
                    if (a.y < b.y)
                        return -1;
                    
                    if (a.y > b.y)
                        return 1;
                    
                    return 0;
                }
            );//"y", Array.NUMERIC);
            this.drawSizers();
        }
    }

    element.drawSizers = function() {
        this.removeSizers();
        var w = this.parent.width;
        var h = this.parent.height;
        var lastH = 0;
        if (this.lanes.length > 1) {
            for (var i = 0; i < (this.lanes.length); i++ ) {
                var lane = (this.lanes[i]);
                if(i<(this.lanes.length-1)){
                    var laneSizer = new facilis.BaseElement();
                    laneSizer.graphics=new facilis.Graphics();
                    lastH += lane.getRealHeight();
                    w = lane.getRealWidth();
                    //this._icon.graphics.beginFill(this.topColor, 1); 
                    laneSizer.graphics.lineStyle(6,"rgba(0,0,0,.01)");
                    
                    laneSizer.graphics.lineTo(w, 0);
                    laneSizer.y = lastH;
                    laneSizer.useHandCursor = true;

                    laneSizer.graphics.lineStyle(2,"rgba(0,0,0,.8)");

                    laneSizer.graphics.moveTo(0, 0);
                    laneSizer.graphics.lineTo(w, 0);
                    //laneSizer.alpha = 0;
                    laneSizer.addShape(new facilis.Shape(laneSizer.graphics));
                    this.sizers.addChild(laneSizer);
                    this.laneSizers.push(laneSizer);
                }
                laneSizer.addEventListener("pressmove", this.sizerMouseDown.bind(this));
                laneSizer.addEventListener("pressup", this.sizerMouseUp.bind(this));
                
            }
        }
        this.setPerHeights();
    }

    element.removeSizers = function() {
		
		while(this.laneSizers.length>0){
			var laneSizer=this.laneSizers.pop();
			laneSizer.removeEventListener("pressmove", this.sizerMouseDown.bind(this));
            laneSizer.removeEventListener("pressup", this.sizerMouseUp.bind(this));
		}
		
        this.laneSizers = [];
        this.sizers.removeAllChildren();
    }

    element.dispatchLaneSizing = function(s) {
        var sizerId = 0;
        for (var i = 0; i < this.laneSizers.length; i++ ) {
            if (this.laneSizers[i] == s) {
                sizerId = i;
            }
        }
        /*if () {

        }*/
    }

    element.maxHeightPos=null;
    element.minHeightPos=null;
    element.sizerMouseDown = function(e) {
        e.stopPropagation();
        var sizer = e.currentTarget;
		var numEl = this.getIndex(sizer);

		this.sizing = true;
		
        this.actualSizer = sizer;
        sizer.alpha = .8;
        var x = 0;
        var w = 0;
        		
        y = (this.lanes[numEl]).y;
        if(!this.availableHeight){
            
			this.availableHeight = (this.lanes[numEl]).getRealHeight() + (this.lanes[numEl + 1]).getRealHeight()
			this.maxHeightPos = this.availableHeight-100;
            this.minHeightPos = (this.lanes[numEl]).y+100;
			this.availableHeight=true;
        }
        
        var p={};
        this.parent.globalToLocal(e.stageX,e.stageY,p);
        if(p.y>this.minHeightPos && p.y<this.maxHeightPos)
            sizer.y=p.y;
        
        this.dispatchEvent(new facilis.Event(facilis.LaneSizers.LANE_SIZING));
        this.y = 0;
    }

    element.sizerMouseUp = function(e) {
        e.stopPropagation();
        
        if(!this.actualSizer)
            return;
        
        var sizer = this.actualSizer;
        this.actualSizer = null;
        sizer.alpha = .1;
        /*this.stage.removeEventListener(MouseEvent.MOUSE_UP, sizerMouseUp);
        this.removeEventListener(MouseEvent.MOUSE_UP, sizerMouseUp);
        sizer.removeEventListener(MouseEvent.MOUSE_UP, sizerMouseUp);   
        sizer.stopDrag();*/
        this.y = 0;
        this.lanes.sort(function(a,b) {return a.y - b.y});
        var numEl = this.getIndex(sizer);
        var lane1 = (this.lanes[numEl]);
        var lane2 = (this.lanes[numEl + 1]);
        var totalHeight = lane1.getRealHeight() + lane2.getRealHeight();
        var oldY = 0;
        if (this.lanes[numEl-1]) {
            oldY=(this.lanes[numEl - 1]).y + (this.lanes[numEl - 1]).getRealHeight();
        }
        lane1.setSize(lane1.getRealWidth(), sizer.y - oldY);
        lane2.setSize(lane2.getRealWidth(), (totalHeight - lane1.getRealHeight()));
        lane2.y = sizer.y;
		this.availableHeight=false;
        this.sizing = false;
        this.y = 0;
        this.setPerHeights();
        this.dispatchEvent(new facilis.Event(facilis.LaneSizers.LANE_SIZED));
    }

    element.setPerHeights = function() {
        this.laneHeights = [];
        var totalH = 0;
        var lane;
        /*for (var i = 0; i < lanes.length; i++ ) {
            lane = (lanes[i]);
            totalH+=lane.getRealHeight();
        }*/
        var i = 0;
        for (i = 0; i < this.lanes.length; i++ ) {
            lane = (this.lanes[i]);
            //var h = lane.getRealHeight() / totalH;
            var h = lane.getRealHeight();
            this.laneHeights.push(h);
        }
    }

    element.setLaneHeights = function(heights) {
        this.laneHeights=heights;
    }

    element.getLaneHeights = function() {
        return this.laneHeights;
    }

    element.getIndex = function(sizer) {
        for (var i = 0; i < this.laneSizers.length;i++ ) {
            if (sizer===this.laneSizers[i]) {
                return i;
            }
        }
    }
    

    facilis.LaneSizers = facilis.promote(LaneSizers, "BaseElement");
    
}());

(function() {

    function AbstractLane() {
        this.DropInElement_constructor();
        
        this.FONT_COLOR = "#333333";
		this.FONT_SIZE = "10";
		this.FONT_FACE = "Tahoma";

        //this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(AbstractLane, facilis.DropInElement);
    
    element.DropInElementSetup=element.setup;
    element.setup = function() {
        this.sizable=true;
        this.DropInElementSetup();
        
        this._width = 300;
        this._height = 160;
        this._icon = new facilis.BaseElement();
        this.addChild(this._icon);

        this.txtName = new facilis.ElementText();
        /*this.txtName.selectable = false;
        this.txtName.multiline = true;
        this.txtName.wordWrap = true;

        var myformat:TextFormat = new TextFormat("Tahoma",10,FONT_COLOR);
        myformat.align = "center";
        txtName.defaultTextFormat=myformat;
        txtName.antiAliasType = AntiAliasType.ADVANCED;
        */
        this.addChild(this.txtName);

        this.redrawCube();
        /*try{
        var tahoma:Class = LibraryManager.getInstance().getClass("fonts.EmbedTahoma") as Class;
        Font.registerFont(tahoma);
        }catch(e){}*/
    };
    
    element.setSize = function(width, height) {
        this._width = width;
        this._height = height;
        this.redrawCube();
        this.alignText();
    }

    element.redrawCube = function() {
        this._icon.removeAllChildren();
        if(!this._icon.graphics)
            this._icon.graphics=new facilis.Graphics();
        
        this._icon.graphics.clear();
        this._icon.graphics.lineStyle(2,"rgb(0,0,0,0)");
        //_icon.graphics.beginFill(0xFFFFFF, 0); 
        this._icon.graphics.drawRect(0, 0, this._width, this._height);
        //_icon.graphics.endFill();
        this._icon.graphics.lineStyle(2,"rgb(0,0,0,.5)");
        facilis.LineUtils.dashTo(this._icon, 0, 0, this._width, 0, 5, 5);
        facilis.LineUtils.dashTo(this._icon, this._width, 0, this._width, this._height, 5, 5);
        facilis.LineUtils.dashTo(this._icon, this._width, this._height, 0, this._height, 5, 5);
        facilis.LineUtils.dashTo(this._icon, 0, this._height, 0, 0, 5, 5);
        
        this._icon.addShape(new facilis.Shape(this._icon.graphics));

        this.alignText();
    }

    element.setName = function(name) {
        this.txtName.text = name;
        this.txtName.embedFonts = true;

        this.alignText();
    }
    element.alignText = function() {
        
        this.txtName.textAlign="center";
        //this.txtName.textBaseline="hanging";
        
        //txtName.autoSize = TextFieldAutoSize.CENTER;
        //txtName.y = (_height / 2) - (txtName.height / 2);
        this.txtName.lineWidth = (this._height);
        
        this.txtName.y = this._height/2;
        this.txtName.width = (this._height);
        this.txtName.height = 30;
        this.txtName.rotation = -90;
        this.txtName.x = 0;
    }


    facilis.AbstractLane = facilis.promote(AbstractLane, "DropInElement");
    
}());

(function() {

    function PoolLane() {
        this.AbstractLane_constructor();
        
        this._subElements;
		this.subElementsArr=[];
		this.lanesSizer;
		
		this.laneHeights=[];
		
		this.defaultMinWidth = 300;
		this.defaultMinHeight = 100;

        //this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(PoolLane, facilis.AbstractLane);
    
    element.AbstractLaneSetup=element.setup;
    element.setup = function() {
        this.AbstractLaneSetup();
        
        this._width = 600;
        this._height = 300;
        this.redrawCube();
        this._subElements = new facilis.BaseElement();
        this.addChild(this._subElements);

        facilis.View.getInstance().addEventListener(facilis.View.ON_SELECT, this.unSelectSubElements.bind(this));
        facilis.View.getInstance().addEventListener(facilis.View.VIEW_CLICK, this.unSelectSubElements.bind(this));
        facilis.View.getInstance().addEventListener(facilis.AbstractElement.ELEMENT_ADDED, this.unSelectAllSubElements.bind(this));
        
        this.lanesSizer = new facilis.LaneSizers();
        
        this.lanesSizer.addEventListener(facilis.LaneSizers.LANE_SIZED, this.laneSized.bind(this));
        this.lanesSizer.addEventListener(facilis.LaneSizers.LANE_SIZING,this.laneSizing.bind(this));
        
        this.addChild(this.lanesSizer);
        this.minHeight = this.defaultMinHeight;
        this.minWidth = this.defaultMinWidth;
        
        
    };
    
    
    
    element.redrawCube = function() {
        this.sortInnerElements();
        this._icon.removeAllChildren();
        if(!this._icon.graphics)
            this._icon.graphics=new facilis.Graphics();
        
        this._icon.graphics.clear();
        
        this._icon.graphics.lineStyle(1,"#000000");
        
        this._icon.graphics.beginFill("rgba(255,255,255,0)");
        this._icon.graphics.drawRect(0, 0, this._width, this._height);
        var wdth = 30;
        if (this._width<wdth+10) {
            wdth = this._width * 0.9;
        }
        
        this._icon.graphics.lineStyle(1,"rgba(0,0,0,0)");
        
        this._icon.graphics.drawRect(10, 10, this._width-20, this._height-20);
        this._icon.graphics.endFill();
        this._icon.graphics.beginFill("rgba(255,255,255,.1)");
        
        this._icon.graphics.lineStyle(1,"#000000");

        
        this._icon.graphics.drawRect(0, 0, wdth, this._height);
        this._icon.graphics.endFill();
            
        this._icon.addShape(new facilis.Shape(this._icon.graphics));
    }

    element.sortElements = function() {
        var wdth = 30;
        if (this.subElementsArr) {
            var _y = 0;
            var sumH = 0;
            for (var i = 0; i < this.subElementsArr.length; i++ ) {
                var el = (this.subElementsArr[i]);
                if (this._width < wdth + 10) {
                    wdth = this._width * 0.9;
                }
                var h = this.laneHeights[i];

                if (i==(this.subElementsArr.length-1) || (sumH+h)>this._height) {
                    h = this._height - sumH;
                }

                sumH += h;
                (this.getInnerElements()[i]).x = this.x + wdth;
                (this.getInnerElements()[i]).y = this.y + _y;
                el.y = _y;
                el.x = wdth;
                _y += h;
            }
        }
        if(this.lanesSizer){
            this.lanesSizer.x = wdth;
        }
        
        try{this.updateCache();}catch(e){}
        this.drawLaneSizers();
    }

    element.sortInnerElements = function() {
        var wdth = 30;
        if (this.subElementsArr) {
            var _y = 0;
            var sumH = 0;
            for (var i = 0; i < this.subElementsArr.length; i++ ) {
                var el = (this.subElementsArr[i]);
                if (this._width < wdth + 10) {
                    wdth = this._width * 0.9;
                }
                var h = this.laneHeights[i];

                if (i==(this.subElementsArr.length-1) || (sumH+h)>this._height) {
                    h = this._height - sumH;
                }
                el.setSize((this._width - wdth), h);
                var inner = (this.getInnerElements()[i]);
                sumH += h;
                inner.setSize((this._width - wdth), h);
                inner.x = this.x + wdth;
                inner.y = this.y + _y;
                el.y = _y;
                el.x = wdth;
                _y += h;
            }
        }
        if(this.lanesSizer){
            this.lanesSizer.x = wdth;
        }
        this.drawLaneSizers();
    }

    element.addSubElement = function(el) {
        (el).removeAllEventListenersFrom(facilis.Sizable.RESIZE_COMPLETE_EVENT);
        (el).removeAllEventListenersFrom(facilis.Sizable.RESIZE_EVENT);
        var subElement = el.getElement();
        if (!this.laneHeights) {
            this.laneHeights = [];
        }
        if (subElement.getRealHeight() != 0) {
            this.laneHeights.push(subElement.getRealHeight());
        }else {
            if (this.laneHeights.length > 0) {
                var index = this.laneHeights.length - 1;
                this.laneHeights.splice((index), 1);
                this.laneHeights.push((this.subElementsArr[(index)]).getRealHeight());
            }
            if (this.laneHeights.length == 0) {
                this.laneHeights.push(this._height);
            }else{
                this.laneHeights.push(this.defaultMinHeight);
                this._height += this.defaultMinHeight;
            }
        }
        var order = el.getData().getAttribute("laneOrder");
        if (order!=null && parseInt(order) < this.subElementsArr.length) {
            var auxSubEls = this.subElementsArr.slice(0, parseInt(order));
            var auxSubEls2 = this.subElementsArr.slice(parseInt(order));
            var auxSubEls3 = [];
            auxSubEls3 = auxSubEls3.concat(auxSubEls, subElement, auxSubEls2);
            this.subElementsArr = auxSubEls3;
            this.changeInnerElementPosition((this.subElementsArr.length - 1), order);
            //this.subElementsArr.push(subElement);
        }else{
            this.subElementsArr.push(subElement);
        }
        this._subElements.addChild(subElement);
        el.removeAllEventListeners();
        
        subElement.addEventListener(facilis.AbstractElement.ELEMENT_CLICKED, this.selectSubElement.bind(this));
        subElement.addEventListener(facilis.AbstractElement.ELEMENT_CLICKED, this.stopLaneSizer.bind(this));
        
        //subElement.addEventListener(MouseEvent.MOUSE_DOWN, this.stopPropagation.bind(this));
        //subElement.addEventListener(MouseEvent.MOUSE_UP, this.stopPropagation.bind(this));
        
        el.addEventListener(facilis.Sizable.RESIZE_COMPLETE_EVENT, this.onLaneResized.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_DELETE, this.elementDeleted.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_SELECTED,this.onLaneSelected.bind(this));
        el.addEventListener(facilis.AbstractElement.ELEMENT_UNSELECTED, this.onLaneUnSelected.bind(this));
        
        this.updateParentSize();
        el.setSize(1, 1);
        el.moveTo( -900, -900);
        el.removeDropEvents();
        el.visible = false;
        this.updateMinimumSize();
    }

    element.selectSubElement = function(e) {
        //unSelectSubElements(e);
        e.stopPropagation();
        var el = e.target;
        for (var i = 0; i < this.subElementsArr.length; i++ ) {
            if (this.subElementsArr[i] == el) {
                //el.filters= [new GlowFilter(0x55FF44, 0.8, 8, 8, 2, 3, false, false)];
                (this.getInnerElements()[i]).dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_CLICKED));
            }
        }
    }

    element.onLaneSelected = function(e) {
        //(e.currentTarget).getElement().filters= [new GlowFilter(0x55FF44, 0.8, 8, 8, 2, 3, false, false)];
    }

    element.onLaneUnSelected = function(e) {
        //(e.currentTarget).getElement().filters= [];
    }

    element.elementDeleted = function(e) {
        var el = e.target;
        removeElement(el);
    }

    element.removeElement = function(el) {
        var deletedPer = 0;
        var deletedH = 0;
        for (var i = 0; i < this.getInnerElements().length;i++ ) {
            if (this.getInnerElements()[i]==el) {
                var subEl = this.subElementsArr[i];
                deletedH=(subEl).getRealHeight();
                
                subEl.addEventListener(MouseEvent.CLICK, selectSubElement);
                subEl.addEventListener(MouseEvent.MOUSE_DOWN, stopPropagation);
                subEl.addEventListener(MouseEvent.MOUSE_UP, stopPropagation);
                
                deletedPer = this.laneHeights[i];
                this.laneHeights.splice(i, 1);
                this._subElements.removeChild(subEl);
                this.subElementsArr.splice(i, 1);
                this.removeInnerElementIndex(i);
                break;
            }
        }
        if(this.subElementsArr.length>0){
            this._height -= deletedH;
        }
        if (this._height<this.defaultMinHeight) {
            this._height = this.defaultMinHeight;
        }
        var newPer = [];
        var deletedHeight = this.getRealHeight() * deletedPer;
        this.updateParentSize();
        this.updateMinimumSize();
    }

    element.unSelectSubElements = function(e) {
        for (var i = 0; i < this.subElementsArr.length; i++ ) {
            var selected = false;
            for (var u = 0; u < facilis.View.getInstance().getSelectedElements().length;u++ ) {
                if (this.getInnerElements()[i]==facilis.View.getInstance().getSelectedElements()[u]) {
                    selected = true;
                }
            }
            if(!selected){
                this.subElementsArr[i].filters = [];
            }
        }
    }

    element.unSelectAllSubElements = function(e) {
        for (var i = 0; i < this.subElementsArr.length; i++ ) {
            this.subElementsArr[i].filters = [];
        }
    }

    element.stopPropagation = function(e) {
        e.stopPropagation();
    }

    element.drawLaneSizers = function() {
        if(this.lanesSizer){
            this.lanesSizer.setLaneSizers(this.subElementsArr);
        }
    }

    element.stopLaneSizer = function(e) {
        lanesSizer.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
    }

    element.laneSized = function(e) {
        this.updateLaneSizes();
        this.parent.dispatchEvent(new facilis.Event(facilis.Sizable.RESIZE_COMPLETE_EVENT));
        this.laneHeights = this.lanesSizer.getLaneHeights();
        this.updateParentSize();
        this.updateMinimumSize();
    }

    element.updateLaneSizes = function() {
        for (var i = 0; i < this.subElementsArr.length; i++ ) {
            var lane = this.subElementsArr[i];
            if (lane.getRealHeight() != this.laneHeights[i]) {
                lane.setSize(lane.getRealWidth(), this.laneHeights[i]);
            }
        }
    }

    element.laneSizing = function(e) {
        this.parent.dispatchEvent(new facilis.Event(facilis.Sizable.RESIZE_EVENT));
    }

    element.updateMinimumSize = function() {
        this.minWidth = this.defaultMinWidth;
        this.minHeight = this.defaultMinHeight;
        if (this.subElementsArr.length > 0) {
            var minH = 0;
            for (var i = 0; i < (this.subElementsArr.length-1); i++ ) {
                minH += (this.subElementsArr[i]).getRealHeight();
            }
            minH += this.defaultMinHeight;
            this.minHeight = minH;
        }
        if (this._height<this.defaultMinHeight) {
            this._height = this.defaultMinHeight;
        }
        if (this.getRealHeight() < this.minHeight) {
            var px = this.x;
            var py = this.y;
            (this.parent).setSize(this._width, this._height);
            this.x = px;
            this.y = py;
        }
        if(this.parent){
            (this.parent).centerSizableElement();
        }
    }

    element.updateParentSize = function() {
        var lanesTotalHeight = 0;
        for (var i = 0; i < this.laneHeights.length; i++ ) {
            lanesTotalHeight += parseInt(this.laneHeights[i]);
        }
        if (this._height<lanesTotalHeight) {
            this._height = lanesTotalHeight;
        }
        var px = this.x;
        var py = this.y;
        (this.parent).setSize(this._width, this._height);
        this.x = px;
        this.y = py;
    }

    element.onLaneResized = function(e) {
        e.stopPropagation();
        var totalSum = 0;
        for (var t = 0; t < this.laneHeights.length; t++ ) {
            totalSum += this.laneHeights[t];
        }
        if (totalSum == this._height) {
            for (var i = 0; i < this.subElementsArr.length; i++ ) {
                var laneHeight = (e.currentTarget).getElement().getRealHeight();
                if (this.subElementsArr[i] == (e.currentTarget).getElement() && this._height != laneHeight && laneHeight > 1) {
                    this.laneHeights[i] = laneHeight;
                }
            }
        }
        this.sortElements();
    }
    
    


    facilis.PoolLane = facilis.promote(PoolLane, "AbstractLane");
    
}());

(function() {

    function SwimLane() {
        this.AbstractLane_constructor();
        this._width = 0;
        this._height = 0;

    }
    
    //static public//
    
    
    var element = facilis.extend(SwimLane, facilis.AbstractLane);
    
    element.AbstractLaneSetup=element.setup;
    element.setup = function() {
        this.AbstractLaneSetup();
        this._width = 0;
        this._height = 0;
        this.redrawCube();
    };
    
    element.redrawCube=function() {
        if(!this._icon.graphics)
            this._icon.graphics=new facilis.Graphics();
        
        this._icon.removeAllChildren();
        this._icon.graphics.clear();
        
        this._icon.graphics.lineStyle(1,"#000000");
        
        this._icon.graphics.drawRect(0, 0, this._width, this._height);
        var wdth = 30;
        if (this._width<wdth+10) {
            wdth = this._width * 0.9;
        }
        this._icon.graphics.beginFill("rgba(255,255,255,.01)");
        this._icon.graphics.drawRect(0, 0, wdth, this._height);
        this._icon.graphics.endFill();
        this._icon.addShape(new facilis.Shape(this._icon.graphics));
    }


    facilis.SwimLane = facilis.promote(SwimLane, "AbstractLane");
    
}());

(function() {

    function ActivityElement() {
        this.SizableElement_constructor();
        
        //this.setup();
    }
    
    var element = facilis.extend(ActivityElement, facilis.SizableElement);
    
    element.radius = 12;
    
    element.SizableElementSetup=element.setup;
    element.setup = function() {
        this.SizableElementSetup();
        this._width = 90;
        this._height = 60;
        this.iconSize = 20;
        
        this._name="";
        this.startTask = false;
        this.startType = "";

        this.lineWidth						= 1.4; //AbstractElement.lineWidth;
        this.color							= "#EBF4FF"; //AbstractElement.color;
        this.lineColor						= "rgba(0,0,0,.4)";//"#000000"; //AbstractElement.lineColor;
        
        this._icon = new facilis.BaseElement();
        this.subIcons = new facilis.BaseElement();
        this.topIcons = new facilis.BaseElement();
        
        this.addChild(this._icon);
        this.addChild(this.topIcons);
        this.addChild(this.subIcons);
        
        this.txtName = new facilis.ElementText();
        this.txtName.text="Default Task";
        this.txtName.width=this._width;
        
        /*txtName.autoSize = TextFieldAutoSize.CENTER;
        txtName.selectable = false;
        txtName.multiline = true;
        txtName.wordWrap = true;*/
        this.addChild(this.txtName);

        /*var myformat:TextFormat = new TextFormat();
        myformat.color = FONT_COLOR;
        myformat.size = FONT_SIZE;
        myformat.font = FONT_FACE;
        myformat.align = "center";
        txtName.defaultTextFormat = myformat;

        txtBlocker = new MovieClip();
        this.addChild(txtBlocker);*/    
        
        var tmp=function(e){
            e.currentTarget.removeEventListener("tick",tmp);
            e.currentTarget.redrawCube();
        };
        
        this.addEventListener("tick",tmp);
        //this.redrawCube();
        
        
    }

    element.setSize=function(width, height){
        _width = width;
        _height = height;
        redrawCube();
    }

    element.redrawCube=function() {
        if(!this._icon.graphics)
           this._icon.graphics=new facilis.Graphics();
           
        this._icon.removeAllChildren();
        this._icon.graphics.clear();
        
        this._icon.graphics.lineStyle(this.lineWidth,this.lineColor);
        this._icon.graphics.beginFill(this.color);
        this._icon.graphics.drawRoundRect(0, 0, this._width, this._height, this.radius, this.radius);
        this._icon.graphics.endFill();

        this._icon.addShape(new facilis.Shape(this._icon.graphics));
        
        this.makeDegree(this._icon);
        this._icon.graphics.drawRoundRect(0, 0, this._width, this._height, this.radius, this.radius);
        this._icon.graphics.endFill();
        this.positionIcons();
        this.txtName.width = this._width;
        this.txtName.height = this._height;
        /*txtBlocker.graphics.beginFill(0xFFFFFF, 0);
        txtBlocker.graphics.drawRoundRect(0, 0, _width, _height, radius, radius);
        txtBlocker.graphics.endFill();*/
        
        this.setCached(true);
    }

    element.positionIcons=function() {
        for (var i = 0; i < this.topIcons.numChildren;i++ ) {
            //this.topIcons.getChildAt(i).x = (this.iconSize + 1) * ( -i);
			this.topIcons.getChildAt(i).x = (this.iconSize + 1) * ( i);
        }
        i = (this.subIcons.numChildren - 1);
        for (i = (this.subIcons.numChildren - 1); i >= 0; i-- ) {
           this.subIcons.getChildAt(i).x = (this.iconSize + 1) * ( i);
        }
        this.subIcons.y = this._height - this.iconSize;
        if(this.subIcons.numChildren>0)
            this.subIcons.x = (this._width - (this.subIcons.numChildren*this.iconSize)) / 2;
        
        this.topIcons.y = 5;
        //if(this.topIcons.getBounds().width)
        //this.topIcons.x = (this._width - ((this.iconSize + 1)*this.topIcons.numChildren)) - 5;
		this.topIcons.x = 2;
        
        this.alignText();
    }

    element.addSubIcon=function(icon) {
        if (icon == null) {
            return;
        }
        this.subIcons.addChild(icon);
        icon.parent.swapChildren(icon, icon.parent.getChildAt(0));
        this.positionIcons();
    }

    element.addTopIcon=function(icon) {
        if (icon == null) {
            return;
        }
        this.topIcons.addChild(icon);
        this.positionIcons();
    }

    element.removeSubicon=function(icon) {
        if (icon && icon.parent==this.subIcons) {
            this.subIcons.removeChild(icon);
            this.positionIcons();
        }
        icon = null;
    }

    element.removeTopIcon=function(icon) {
        if (icon && icon.parent==this.topIcons) {
            this.topIcons.removeChild(icon);
            this.positionIcons();
        }
        icon = null;
    }

    element.loopTypeChange=function(loopType) {
        var icon = "";

        switch (loopType){
        case "Standard":
        icon = "icons.loopType.StandardLoop";
        break;
        case "MultiInstance":
        icon = "icons.loopType.MultiInstanceLoop";
        break;
        }

        if(this.loopIcon){
            this.removeSubicon(loopIcon);
            this.loopIcon = null;
        }
        if(icon!=""){
            this.loopIcon = facilis.IconManager.getInstance().getIcon(icon);
            this.addSubIcon(this.loopIcon);
        }
    }
    element.typeChange=function(type) {

    }

    element.setName=function(name) {
        this._name = name;
        this.txtName.text = name;
        this.alignText();
        this.refreshCache();
    }

    element.setNameText=function(name) {
        this.txtName.text = name;
        this.alignText();
        this.refreshCache();
    }

    element.getName=function(name) {
        return this._name;
    }

    element.alignText=function() {
        this.txtName.textAlign="center";
        //this.txtName.textBaseline="hanging";
        
        //txtName.autoSize = TextFieldAutoSize.CENTER;
        //txtName.y = (_height / 2) - (txtName.height / 2);
        this.txtName.width = (this._width);
        this.txtName.lineWidth = (this._width);
        this.txtName.height = (this._height);
        this.txtName.x=this._width/2;
        var h = this._height - (((this.topIcons.height > 0)?17:0) + ((this.subIcons.height > 0)?10:0));
        /*if ((this.txtName.height+this.txtName.y) > h) {
            //txtName.autoSize = TextFieldAutoSize.NONE;
            this.txtName.height = h;
            this.txtName.y = 0;
        }
        if (this.txtName.y < 17 && (this.topIcons.height > 0)) {
            this.txtName.y = 17;
        }*/
    }

    element.setDependencyProps=function(type) {
        var parent = this.parent;
        var lines = View.getInstance().getLineView().getLinesStartingIn(parent);
        for (var i = 0; i < lines.length; i++ ) {
            /*if ((lines[i] as AbstractElement).elementType == "sflow") {
                var data = getConditiontype(  (lines[i] as AbstractElement).getData() ).firstChild;
                enableAll(data);
                if (type != "Task" && type != "Sub-Process") {
                    disableValue(data, "Expression");
                }
            }*/
        }
    }

    element.getConditiontype=function(data) {
        for (var i = 0; i < data.firstChildNode.children.length; i++ ) {
            if (data.firstChildNode.children[i].attributes.name == "conditiontype") {
                return data.firstChildNode.children[i];
            }
        }
        return null;
    }

    element.disableValue=function(node, value) {
        for (var i = 0; i < node.children.length; i++ ) {
            if (node.children[i].attributes.value == value) {
                node.children[i].attributes.disabled = "true";
            }
        }
    }

    element.enableAll=function(node) {
        for (var i = 0; i < node.children.length; i++ ) {
            node.children[i].attributes.disabled = "false";
        }
    }

    element.setAttachedEventType=function() {
        /*var data = (this.parent as Element).getData().firstChild;
        var els = (this.parent as Element).getContents();
        for (var i = 0; i < els.length; i++ ) {
            if ((els[i] as Element).elementType == "middleevent") {
                setDisableTypeTo((els[i] as Element), "Message", "false");
                setDisableTypeTo((els[i] as Element), "Timer", "false");
                setSingleMessage(els[i], "false");
                if (startType == "Message"){
                    setDisableTypeTo((els[i] as Element), "Message", "true");
                    setSingleMessage(els[i], "true");
                }else if (startType == "Timer"){
                    setDisableTypeTo((els[i] as Element), "Timer", "true");
                    //setSingleMessage(els[i], "true");
                }
            }
        }*/
    }

    element.setDisableTypeTo=function(el, type, to) {
        el.getElement().setTypeDisabled(type, to);
    }

    element.setFirstTask=function(to) {
        /*try{
        startTask = ((to + "") == "true");
        var firsttask;
        var data = (this.parent as AbstractElement).getData();
        if(data){
            data = data.firstChild;
            for (var i = 0; i < data.children.length; i++ ) {
                if (data.children[i].attributes.name == "firsttask") {
                    firsttask = data.children[i];
                    break;
                }
            }
            if ((to + "") == "false") {
                startType = "";
            }
            if(firsttask){
                firsttask.attributes.value = to;
            }
        }
        setAttachedEventType();
        }catch (e) {
            trace(e);
        }*/
    }

    element.setStartType=function(type) {
        setFirstTask("true");
        startType = type;
        setAttachedEventType();
    }

    element.setSingleMessage=function(el,to) {
        var data = el.getData().firstChild;
        for (var i = 0; i < data.children.length; i++ ) {
            if (data.children[i].attributes.name == "trigger") {
                var triggers = data.children[i].firstChild;
                for (var t = 0; t < triggers.children.length;t++ ){
                    if(triggers.children[t].attributes.name == "multiple"){
                        var values = triggers.children[t].firstChild;
                        for (var v = 0; v < values.children.length; v++ ) {
                            if (values.children[v].attributes.name == "multmessagecatch") {
                                values.children[v].attributes.single = to;
                            }
                            if (values.children[v].attributes.name == "multmessagethrow") {
                                values.children[v].attributes.single = to;
                            }
                        }

                    }
                }
            }
        }
    }

    element.getIntersectionWidthSegment=function(s,e){
        var start=new facilis.Point(s.x,s.y);
        var end=new facilis.Point(e.x,e.y);
        
        this.globalToLocal(start.x,start.y,start);
        this.globalToLocal(end.x,end.y,end);
        
        var ret=(this.FindPointofIntersection(start,end,new facilis.Point(0,0),new facilis.Point(this._width,0)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,0),new facilis.Point(this._width,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,this._height),new facilis.Point(0,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(0,this._height),new facilis.Point(0,0))
                );
        
        if(ret){
            this.localToGlobal(ret.x,ret.y,ret);
        }else{
            console.log("failed activityelement intersection segment");
        }
        return ret;
        
    }

    

    facilis.ActivityElement = facilis.promote(ActivityElement, "SizableElement");
    
}());

(function() {

    function FlowElement() {
        this.ActivityElement_constructor();
        
        this.transactionIcon;
		this.transaction=false;

    }
    
    //static public//
    
    
    var element = facilis.extend(FlowElement, facilis.ActivityElement);
    
    element.ActivityElementSetup=element.setup;
    element.setup = function() {
        this.ActivityElementSetup();
        this.transactionIcon = new facilis.BaseElement();
        this.addChild(this.transactionIcon);
        this.typeChange("");
    };

    element.transactionChange=function(trans) {
        transaction = (trans == "true");
        this.redrawCube();
    }

    element.typeChange=function(type) {
        //var icon = "icons.processType.EmbeddedProcess";

        var icon = "";
        var current_filters = this.filters;

        if (this.border_filter) {
            var i = current_filters.indexOf(this.border_filter);
            current_filters.splice(i, 1);
            this.filters = current_filters;
        } else {
            this.filters = [];
            this.border_filter = null;
        }

        switch (type){
            case "Reusable":
                //icon = "icons.processType.ReusableProcess";
                var filt = new GlowFilter();
                filt.color = 0x000000;
                filt.blurX = 1.5;
                filt.blurY = 1.5;
                filt.strength = 255;

                //Los filtros no se agregan directamente al array, por convecion de as3					
                current_filters.push(filt);
                this.filters = current_filters;

                this.border_filter = filt;

                break;
            case "Reference":
                //icon = "icons.processType.ReferenceProcess";
                break;
        }

        if (this.typeIcon) {
            this.removeTopIcon(this.typeIcon);
            this.typeIcon = null;
        }
        if (icon != "") {
            this.typeIcon = (LibraryManager.getInstance().getInstancedObject(icon));
            this.addTopIcon(this.typeIcon);
        }
    }

    element.adhocChange=function(adhoc) {
        var icon = "";

        if (this.adhoc == "true") {
            this.icon = "icons.adhoc.AdhocProcess";			
        }

        if (this.adhocIcon) {
            this.removeSubicon(adhocIcon);
            this.adhocIcon = null;
        }

        if (icon != "") {
            adhocIcon = (LibraryManager.getInstance().getInstancedObject(icon));
            this.addSubIcon(adhocIcon);
            adhocIcon.parent.setChildIndex(adhocIcon, 0);
            positionIcons();
        }
    }

    element.redrawCube=function() {
        if(!this._icon.graphics)
           this._icon.graphics=new facilis.Graphics();
        
        if(!this.transactionIcon.graphics)
           this.transactionIcon.graphics=new facilis.Graphics();
           
        this._icon.removeAllChildren();
        this._icon.graphics.clear();
        this._icon.graphics.lineStyle(this.lineWidth,this.lineColor);
        this._icon.graphics.beginFill(this.color); 
        this._icon.graphics.drawRoundRect(0, 0, this._width, this._height, this.radius, this.radius);
        this._icon.graphics.endFill();
        this.makeDegree(this._icon);
        this._icon.graphics.drawRoundRect(0, 0, this._width, this._height, this.radius, this.radius);
        this._icon.graphics.endFill();
        
        this.transactionIcon.removeAllChildren();
        this.transactionIcon.graphics.clear();
        if (this.transaction) {
            this.transactionIcon.graphics.lineStyle(this.lineWidth, this.lineColor); 
            this.transactionIcon.graphics.drawRoundRect(-3, -3, this._width+6, this._height+6, this.radius, this.radius);
            this.transactionIcon.addShape(new facilis.Shape(this.transactionIcon.graphics));
        }
        this._icon.addShape(new facilis.Shape(this._icon.graphics));
        this.positionIcons();
        
        this.setCached(true);
    }

    facilis.FlowElement = facilis.promote(FlowElement, "ActivityElement");
    
}());


(function() {

    function TaskElement() {
        this.ActivityElement_constructor();
        
    }
    
    //static public//
    
    
    var element = facilis.extend(TaskElement, facilis.ActivityElement);
    
    element.ActivityElementSetup=element.setup;
    element.setup = function() {
        this.ActivityElementSetup();
        
        this._hitArea=new facilis.BaseElement();
        this.typeIcon=new facilis.BaseElement();
		
		
		this.sizable = false;
		this.taskType = "";
		this.loopType = "";
		
        
        if(!this._hitArea.graphics)
            this._hitArea.graphics=new facilis.Graphics();

        //this._hitArea.graphics.beginFill("rgba(0,33,0,.5)");
        
        this._hitArea.graphics.lineStyle(4,"rgba(0,33,0,.01)");
        this._hitArea.graphics.drawRoundRect(3, 3, this._width - 6, this._height - 6, this.radius, this.radius);
        
        //this._hitArea.graphics.endFill();
        //this._hitArea.graphics.drawRoundRect(4, 4, this._width - 8, this._height - 8, this.radius, this.radius);
        
        this._hitArea.mouseEnabled=false;
        
        this.addChild(this._hitArea);
        //this.hitArea = this._hitArea;
        this._hitArea.addShape(new facilis.Shape(this._hitArea.graphics));
        
    };
    
    
    
    element.typeChange=function(type) {
        this.taskType = type;
        var icon = "";

        switch (type){
        case "Send":
        icon = "icons.taskType.TaskSend";
        break;
        case "Receive":
        icon = "icons.taskType.TaskReceive";
        break;
        case "User":
        icon = "icons.taskType.TaskUser";
        break;
        case "Script":
        icon = "icons.taskType.TaskScript";
        break;
        case "Manual":
        icon = "icons.taskType.TaskManual";
        break;
        case "Reference":
        icon = "icons.taskType.TaskReference";
        break;
        case "Service":
        icon = "icons.taskType.TaskService";
        break;
        }

        if(this.typeIcon){
            this.removeTopIcon(this.typeIcon);
            this.typeIcon = null;
        }
        if(icon!=""){
            this.typeIcon = facilis.IconManager.getInstance().getIcon(icon);//(LibraryManager.getInstance().getInstancedObject(icon)) as MovieClip;
            this.addTopIcon(this.typeIcon);
        }

        //this.setAttachedEventType();

    }


    element.setAttachedEventType=function() {
        var data = (this.parent).getData().firstChild;
        var els = (this.parent).getContents();
        if (taskType == "") {
            if (data) {
                for (var u = 0; u < data.children.length; u++ ) {
                    if (data.children[u].attributes.name == "taskType") {
                        taskType = data.children[u].attributes.value;
                        break;
                    }
                }
            }
        }
        var disabledTo = false;
        //if (taskType == "User" || taskType == "Receive" || taskType == "Service") {
        if (this.taskType == "Send" || this.taskType == "Receive" || this.taskType == "Service" || this.taskType == "Script") {
            this.disabledTo = true;
        }
        for (var i = 0; i < els.length; i++ ) {
            if ((els[i]).elementType == "middleevent") {
                this.setDisableTypeTo((els[i]), "Message", disabledTo + "");
                //setDisableTypeTo((els[i]), "Message", "false");
                this.setDisableTypeTo((els[i]), "Timer", "false");
                this.setSingleMessage(els[i], "false");
                if (startType == "Message"){
                    this.setDisableTypeTo((els[i]), "Message", "true");
                    this.setSingleMessage(els[i], "true");
                }else if (startType == "Timer"){
                    //setDisableTypeTo((els[i]), "Timer", "true");
                    //setSingleMessage(els[i], "true");
                }
            }
        }
    }

    element.setMultiInMsgs=function(multi) {
        this.loopType = multi;
        this.setInMsgsTo();
    }

    element.setStartType=function(type) {
        this.setFirstTask("true");
        this.startType = type;
        this.setInMsgsTo();
        this.setAttachedEventType();
    }

    element.setFirstTask=function(to) {
        this.startTask = ((to + "") == "true");
        var firsttask;
        var data = (this.parent).getData();
        if(data){
            data = data.firstChild;
            for (var i = 0; i < data.children.length; i++ ) {
                if (data.children[i].attributes.name == "firsttask") {
                    firsttask = data.children[i];
                    break;
                }
            }
            if(firsttask){
                firsttask.attributes.value = to;
            }
            if ((to + "") == "false") {
                this.startType = "";
                this.setDisableType("Send", false);
                this.setDisableType("Script", false);
            }else {
                this.setDisableType("Send", true);
                this.setDisableType("Script", true);
            }
            this.setInMsgsTo();
            this.setOutMsgsTo();
        }
    }

    element.setOutMsgsTo=function() {
        var d = (this.parent).getData();
        if (d) {
            d = d.firstChild;
            for (var i = 0; i < d.children.length; i++ ) {
                if (d.children[i].attributes.name == "user" || d.children[i].attributes.name == "service" ) {
                    var msgs = d.children[i].firstChild;
                    for (var u = 0; u < msgs.children.length; u++ ) {
                        if (msgs.children[u].attributes.name == "outmessageref") {
                            msgs.children[u].attributes.disabled = startTask.toString();
                        }
                    }
                }
            }
        }
    }

    element.setInMsgsTo=function() {
        var to = false;
        if (this.startType == "Message" || this.loopType == "MultiInstance") {
            to = true;
        }
        var d = (this.parent).getData();
        this.setDisableType("Receive", to+"");
        this.setDisableType("Service", to+"");

        if (d) {
            d = d.firstChild;
            for (var i = 0; i < d.children.length; i++ ) {
                if (d.children[i].attributes.name == "user") {
                    var msgs = d.children[i].firstChild;
                    for (var u = 0; u < msgs.children.length; u++ ) {
                        if (msgs.children[u].attributes.name == "inmessageref") {
                            msgs.children[u].attributes.disabled = to.toString();
                        }
                        /*if (msgs.children[u].attributes.name == "outmessageref") {
                            msgs.children[u].attributes.disabled = to.toString();
                        }*/
                    }
                }
            }
            //View.getInstance().unselectAll();
            //View.getInstance().select(this.parent);
        }
    }

    element.setDisableType=function(type, to) {
        var d = (this.parent).getData();
        if (d) {
            d = d.firstChild;
            var selectedVal;
            var change;
            for (var i = 0; i < d.children.length; i++ ) {
                if (d.children[i].attributes.name == "taskType") {
                    var values = d.children[i].firstChild;
                    for (var v = 0; v < values.children.length; v++ ) {
                        if (values.children[v].attributes.value == type) {
                            values.children[v].attributes.disabled = to.toString();
                        }
                        if (!selectedVal && values.children[v].attributes.disabled != "true") {
                            selectedVal = values.children[v];
                        }
                    }
                    if (to=="true" && (d.children[i].attributes.value == type )) { 
                        d.children[i].attributes.value = selectedVal.attributes.value;
                    }else {
                        selectedVal = null;
                    }
                }
            }

            if (selectedVal) {
                typeChange(selectedVal.attributes.value);
                if(selectedVal.attributes.enable){
                    var enable = selectedVal.attributes.enable.split(",");
                    var toEn = {};
                    for (var en = 0; en < enable.length; en++ ) {
                        toEn[enable[en]] = true;
                    }
                    setDisabledTo(toEn,false);
                }
                if(selectedVal.attributes.disable){
                    var disable = selectedVal.attributes.disable.split(",");
                    var toDi = {};
                    for (var di = 0; di < disable.length; di++ ) {
                        toDi[disable[di]] = true;
                    }
                    setDisabledTo(toDi,true);
                }
            }

        }
    }


    element.setDisabledTo=function(types, to, data) {
        if (!data) {
            data = (this.parent).getData();
        }
        for (var i = 0; i < data.children.length; i++ ) {
            if (types[data.children[i].attributes.name]) {
                data.children[i].attributes.disabled = to.toString();
            }
            setDisabledTo(types,to,data.children[i]);
        }
    }

    element.setColor=function(col) {
        if (col && col != "") {
            if (col.indexOf("#") == 0 && col.length==7) {
                col = col.split("#")[1];
                this.color = parseInt(col, 16);
            }
        }else {
            this.color = "#EBF4FF";
        }
        this.redrawCube();
    }
    
    


    facilis.TaskElement = facilis.promote(TaskElement, "ActivityElement");
    
}());

(function() {

    function CSubFlowElement() {
        this.FlowElement_constructor();
        
        //private//

    }
    
    //static public//
    
    
    var element = facilis.extend(CSubFlowElement, facilis.FlowElement);
    
    element.FlowElementSetup=element.setup;
    element.setup = function() {
        this.FlowElementSetup();
        
        var className = "icons.activities.CollapsedIcon";
        var icon = facilis.IconManager.getInstance().getIcon(className);
        this.addSubIcon(icon);
        this._hitArea=new facilis.BaseElement();
        this._hitArea.graphics=new facilis.Graphics();

        //this._hitArea.graphics.beginFill("rgba(0,33,0,.5)");
        
        this._hitArea.graphics.lineStyle(4,"rgba(0,33,0,.01)");
        this._hitArea.graphics.drawRoundRect(3, 3, this._width - 6, this._height - 6, this.radius, this.radius);
        
        //this._hitArea.graphics.endFill();
        //this._hitArea.graphics.drawRoundRect(4, 4, this._width - 8, this._height - 8, this.radius, this.radius);
        
        this._hitArea.mouseEnabled=false;
        
        this.addChild(this._hitArea);
        //this.hitArea = this._hitArea;
        this._hitArea.addShape(new facilis.Shape(this._hitArea.graphics));
        
    };
    
    element.setEnableEntity=function(val) {
        var d = (this.parent).getData();
        if(d){
            var bpmn = d.firstChild;
            var apia = d.children[1];
            var subprocesstype = "";
            var skipfirsttask = "";
            for (var i = 0; i < bpmn.children.length; i++ ) {
                if (bpmn.children[i].attributes.name=="subprocesstype") {
                    subprocesstype = bpmn.children[i].attributes.value;
                }
                if (bpmn.children[i].attributes.name=="skipfirsttask") {
                    skipfirsttask = bpmn.children[i].attributes.value;
                }
            }
            var disabled = "true";
            if (skipfirsttask != "true" && subprocesstype == "Reusable") {
                disabled = "false";
            }
            for (var u = 0; u<apia.children.length; u++ ) {
                if (apia.children[u].attributes.name=="entity") {
                    apia.children[u].attributes.disabled = disabled;
                }
            }
            View.getInstance().refreshElementAttributes();
        }
    }

    element.setColor=function(col) {
        if (col && col != "") {
            if (col.indexOf("#") == 0 && col.length==7) {
                col = col.split("#")[1];
                color = parseInt(col, 16);
            }
        }else {
            color = "#EBF4FF";
        }
        redrawCube();
    }



    facilis.CSubFlowElement = facilis.promote(CSubFlowElement, "FlowElement");
    
}());

(function() {

    function EventElement() {
        this.SizableElement_constructor();
        
        this._icon=null;
		
		this.icons;
		this.typeIcon;
		
		this.eventType = "";
		
        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(EventElement, facilis.SizableElement);
    
    element.SizableElementSetup=element.setup;
    element.setup = function() {
        this.SizableElementSetup();
        
        this.backColor = "#FFFFFF";
		this.topLineAlpha = 0;
		this.topColor = "#FFFFFF";
		
		this.txtName=null;
		
		this.FONT_COLOR = "#333333";
		this.FONT_SIZE = "10";
		this.FONT_FACE = "Tahoma";
		
		this.lineWidth						= facilis.AbstractElement.lineWidth;
		this.color							= facilis.AbstractElement.color;
		this.lineColor						= facilis.AbstractElement.lineColor;
        
        this.topColor = "#FFFFFF";
        this.backColor = "#FFFFFF";
        this.topLineAlpha = 0;
        
        this._width = 30;
        this._height = 30;
        
        this._icon = new facilis.BaseElement();
        this.icons = new facilis.BaseElement();
        
        this.addChild(this._icon);
        this.addChild(this.icons);

        this.txtName = new facilis.ElementText();
        /*txtName = new ElementText();
        txtName.autoSize = TextFieldAutoSize.CENTER;
        txtName.selectable = false;
        txtName.multiline = true;
        txtName.wordWrap = true;
        txtName.width = 1;
        txtName.height = 1;
        
        var myformat:TextFormat = new TextFormat();
        myformat.color = FONT_COLOR;
        myformat.size = FONT_SIZE;
        myformat.font = FONT_FACE;
        myformat.align = "center";
        txtName.defaultTextFormat = myformat;*/

        this.addChild(this.txtName);

        this.redrawCube();
        
    };
    
    element.setSize=function(width, height) {
        this._width = width;
        this._height = height;
        this.redrawCube();
    }
    
    element.redrawCube=function() {
        this._icon.removeAllChildren();
        if(!this._icon.graphics)
            this._icon.graphics=new facilis.Graphics();
        
        this._icon.graphics.clear();
        this._icon.graphics.beginFill(this.topColor, 1); 
        this._icon.graphics.lineStyle(this.lineWidth,this.lineColor);
        this._icon.graphics.drawCircle(this._width / 2, this._width / 2, this._width / 2);
        this._icon.graphics.endFill();

        this._icon.graphics.lineStyle(this.lineWidth, this.lineColor,this.topLineAlpha); 
        
        this._icon.graphics.beginFill(this.backColor, .9); 
        this._icon.graphics.drawCircle(this._width / 2, this._width / 2, this._width / 2);
        this._icon.graphics.drawCircle(this._width / 2, this._width / 2, (this._width * (3 / 8)));
        this._icon.graphics.endFill();

        this._icon.graphics.lineStyle(this.lineWidth, this.lineColor); 
        
        this.makeDegree(this._icon,this._height,this._height);
        this._icon.graphics.drawCircle(this._width / 2, this._width / 2, this._width / 2);
        this._icon.graphics.endFill();
        
        this._icon.addShape(new facilis.Shape(this._icon.graphics));

        this.alignText();
        //this.dispatchEvent(new Event("elementResized"));
        
        this.setCached(true);
    }

    element.typeChange=function(type) {
        eventType = type;
        var icon = "";

        switch (type){
        case "Timer":
        icon = "icons.eventType.Timer";
        break;
        case "Message":
        icon = "icons.eventType.Message";
        break;
        case "Compensation":
        icon = "icons.eventType.Compensation";
        break;
        case "Conditional":
        icon = "icons.eventType.Conditional";
        break;
        case "Link":
        icon = "icons.eventType.Link";
        break;
        case "Signal":
        icon = "icons.eventType.Signal";
        break;
        case "Multiple":
        icon = "icons.eventType.Multiple";
        break;
        case "Error":
        //icon = "icons.eventType.Error";
			if (this instanceof facilis.MiddleEventElement)
				icon = "icons.eventType.ErrorNoFill";
			else if (this instanceof facilis.EndEventElement)
				icon = "icons.eventType.ErrorFill";
			else
				icon = "icons.eventType.Error";
        break;
        case "Cancel":
        icon = "icons.eventType.Cancel";
        break;
        case "Terminate":
        icon = "icons.eventType.Terminate";
        break;
        }

        if ((type == "Message" || type == "Signal") && (this.parent).elementType=="endevent") {
            icon += "Filled";
        }

        if(this.typeIcon){
            this.icons.removeChild(this.typeIcon);
            this.typeIcon = null;
        }
        if(icon!=""){
            this.typeIcon = facilis.IconManager.getInstance().getIcon(icon);
            this.icons.addChild(this.typeIcon);
        }
        this.positionIcon();
    }

    element.catchThrowChange=function(type) {
        var icon = "";

        switch (this.eventType){
            case "Timer":
            icon = "icons.eventType.Timer";
            break;
            case "Message":
            icon = "icons.eventType.Message";
            break;
            case "Compensation":
            icon = "icons.eventType.Compensation";
            break;
            case "Conditional":
            icon = "icons.eventType.Conditional";
            break;
            case "Link":
            icon = "icons.eventType.Link";
            break;
            case "Signal":
            icon = "icons.eventType.Signal";
            break;
            case "Multiple":
            icon = "icons.eventType.Multiple";
            break;
            case "Error":
            icon = "icons.eventType.Error";
            break;
            case "Cancel":
            icon = "icons.eventType.Cancel";
            break;
            case "Terminate":
            icon = "icons.eventType.Terminate";
            break;
        }
        if (type.toLowerCase() == "throw") {
            icon += "Filled";
        }
        if(this.typeIcon){
            this.icons.removeChild(this.typeIcon);
            this.typeIcon = null;
        }
        if(icon!=""){
            this.typeIcon = facilis.IconManager.getInstance().getIcon(icon);
            this.icons.addChild(this.typeIcon);
        }
        this.positionIcon();
    }


    element.positionIcon=function() {
		this.setCached(false);
        this.icons.x = (this._width / 2)-(this.icons.getBounds().width / 2);
        this.icons.y = (this._height / 2)-(this.icons.getBounds().height / 2);
		this.setCached(true);
    }

    element.setName=function(name) {
        this.txtName.text = name;
        this.alignText();
    }

    element.alignText=function() {
		this.setCached(false);
        this.txtName.textAlign="center";
        this.txtName.y = this._height ;
        this.txtName.width = (this._width * 2);
         
        this.txtName.lineWidth = (this._width * 2);
        //this.txtName.height = (this._height*2);
        
        this.txtName.x = (this._width/2);
		this.setCached(true);
    }
    
    element.getIntersectionWidthSegment=function(s,e){
		
        var start=new facilis.Point(s.x,s.y);
        var end=new facilis.Point(e.x,e.y);
        
        this.globalToLocal(start.x,start.y,start);
        this.globalToLocal(end.x,end.y,end);
        
        var ret=(this.FindPointofIntersection(start,end,new facilis.Point(0,0),new facilis.Point(this._width,0)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,0),new facilis.Point(this._width,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,this._height),new facilis.Point(0,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(0,this._height),new facilis.Point(0,0))
                );
        
        if(ret){
            this.localToGlobal(ret.x,ret.y,ret);
        }else{
            console.log("failed eventelement intersection segment");
        }
        return ret;
		/*
        var start=new facilis.Point(s.x,s.y);
        var end=new facilis.Point(e.x,e.y);
		
		this.globalToLocal(start.x,start.y,start);
        this.globalToLocal(end.x,end.y,end);
       
        var center=this._width/2;
        var size=this._width/2;
        
        var numberOfSides = 5;
        var Xcenter = this.parent.x;
        var Ycenter = this.parent.y;

        var p1=new facilis.Point(Xcenter +  size * Math.cos(0), Ycenter +  size *  Math.sin(0));
		var p2;
        var lines=[];
        for (var i = 1; i <= numberOfSides;i += 1) {
            p2=new facilis.Point(Xcenter + size * Math.cos(i * 2 * Math.PI / numberOfSides), Ycenter + size * Math.sin(i * 2 * Math.PI / numberOfSides));
			
			if(this.FindPointofIntersection(start,end,p1,p2))
                return this.FindPointofIntersection(start,end,p1,p2);
            
            p1=p2;
        }
        
        //if(ret){
        //    this.localToGlobal(ret.x,ret.y,ret);
        //}else{
            console.log("failed eventelement intersection segment");
        //}
        
        return null;*/
        
    }
    

    facilis.EventElement = facilis.promote(EventElement, "SizableElement");
    
}());

(function() {

    function StartEventElement() {
        this.EventElement_constructor();
        
        
        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(StartEventElement, facilis.EventElement);
    
    element.EventElementSetup=element.setup;
    element.setup = function() {
        this.EventElementSetup();
        this.lineWidth						= 1.4; //AbstractElement.lineWidth;
        this.color							= "#C9E2BA"; //AbstractElement.color;
        this.lineColor						= "#339900"; //AbstractElement.lineColor;
        this.topColor = this.color;
        this.backColor = this.color;
        this.redrawCube();
    } ;


    element.setFirstTaskType=function(type) {
        //si start es msg la primera no puede ser receive, y sin in si es user o service
        if (type == "") {
            type = eventType;
        }
        if (type == "") {
            var d = (this.parent).getData();
            if (d) {
                d = d.firstChild;
                for (var u = 0; u < d.children.length; u++ ) {
                    if (d.children[u].attributes.name == "eventdetailtype") {
                        type = d.children[u].attributes.value;
                    }
                }
            }
        }
        var lines = View.getInstance().getLineView().getLinesStartingIn(this.parent);
        for (var i = 0; i < lines.length; i++ ) {
            disableConditionexpression((lines[i]));
            var endingElement = ((lines[i]).getEndElement());
            if (endingElement.elementType == "task" || endingElement.elementType == "csubflow") {
                endingElement.getElement().setFirstTask("true");
                endingElement.getElement().setStartType(type);
            }
        }
    }

    element.disableConditionexpression=function(line) {
        var data = line.getData();
        if (data && data.firstChild) {
            data = data.firstChild;
            for (var i = 0; i < data.children.length; i++ ) {
                if (data.children[i].attributes.name == "conditionexpression") {
                    data.children[i].removeNode();
                }
            }
        }
    }

    element.setReadonlyNone=function() {
        var lines = View.getInstance().getLineView().getLinesStartingIn(this.parent);
        for (var i = 0; i < lines.length; i++ ) {
            var data =   (lines[i]).getData();
            if (data && data.attributes.name == "sflow") {
                data = data.firstChild;
                for (var u = 0; u < data.children.length; u++ ) {
                    if (data.children[u].attributes.name == "conditiontype") {
                        data.children[u].attributes.readonly = "true";
                        data.children[u].attributes.type = "text";
                        data.children[u].attributes.value = "None";
                    }
                }
            }
        }
    }
    
    
    facilis.StartEventElement = facilis.promote(StartEventElement, "EventElement");
    
}());

(function() {

    function MiddleEventElement() {
        this.EventElement_constructor();
        
        //private//

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(MiddleEventElement, facilis.EventElement);
    
    element.EventElementSetup=element.setup;
    element.setup = function() {
        this.EventElementSetup();
        
        this.lineWidth						= 1.4; //AbstractElement.lineWidth;
        this.color							= "#F1F0B1"; //AbstractElement.color;
        this.lineColor						= "#FFCC00"; //AbstractElement.lineColor;
        this.topColor = this.color;
        this.backColor = this.color;
        this.topLineAlpha=1;
        this.redrawCube();
    };
    
    
    
    
    
    element.setTypeDisabled=function(type, to) {
        var d = (this.parent).getData();
        if (d) {
            d = d.firstElementChild;
            var values;
            for (var i = 0; i < d.children.length; i++) {
                if (d.children[i].getAttribute("name") == "eventdetailtype") {
                    //var eventdetailtype = d.children[i];
                    values = d.children[i].firstElementChild;
                    break;
                }
            }
            i = 0;
            if (values) {
                var firstNotDis = null;
                for (i = 0; i < values.children.length; i++) {
                    if (values.children[i].getAttribute("value") == type) {
                        values.children[i].setAttribute("disabled", to + "");
                    }else if (firstNotDis == null &&  values.children[i].getAttribute("disabled") != "true") {
                        firstNotDis = values.children[i];
                    }
                }
				if(!facilis.view.View.loading_xpdl) {
					if (values.parentNode.getAttribute("value") == type && to == "true") {
						values.parentNode.setAttribute("value", firstNotDis.getAttribute("value"));
						typeChange(firstNotDis.getAttribute("value"));
					}
				}
            }
        }
    }

    element.setThrowCatchNode=function(to) {
        to = (to + "").toLowerCase();
        var d = (this.parent).getData().firstElementChild;
        var messagecatch;
        var messagethrow;
        var value = "";
        for (var i = 0; i < d.children.length; i++) {
            if (d.children[i].getAttribute("name") == "message") {
                var message = d.children[i].firstElementChild;
                for (var m = 0; m < message.children.length; m++ ) {
                    if (message.children[m].getAttribute("name") == "catchthrow") {
                        message.children[m].setAttribute("disabled", to);
                        value = message.children[m].getAttribute("value");
                    }
                    if (message.children[m].getAttribute("name")=="messagecatch") {
                        messagecatch = message.children[m];
                    }
                    if (message.children[m].getAttribute("name") == "messagethrow") {
                        messagethrow = message.children[m];
                    }
                }
                //d.children[i].setAttribute("disabled", to);
                break;
            }
        }
    }

    element.disableLineConditions=function() {
        var hide = "None";
        if ((this.parent).getData().firstElementChild.children[0].getAttribute("value") != "TRUE") {
        //	hide = "CONDITION";
        }
        var lines = facilis.View.getInstance().getLineView().getLinesStartingIn(this.parent);
        for (var l = 0; l < lines.length; l++ ) {
            var d = (lines[l]).getData();
            if (d) {
                d = d.firstElementChild;
                for (var i = 0; i < d.children.length; i++) {
                    if (d.children[i].getAttribute("type")=="text" && d.children[i].getAttribute("name") == "conditiontype") {
                        //d.children[i].setAttribute("hidden", hide);
                        d.children[i].setAttribute("value", hide);
                    }
                }
            }
        }
    }

    element.disableInLineConditions=function() {
        var hide = "None";
        if ((this.parent).getData().firstElementChild.children[0].getAttribute("value") != "TRUE") {
            //hide = "CONDITION";
        }
        var lines = facilis.View.getInstance().getLineView().getLinesEndingIn(this.parent);
        for (var l = 0; l < lines.length; l++ ) {
            var d = (lines[l]).getData();
            if (d) {
                d = d.firstElementChild;
                for (var i = 0; i < d.children.length; i++) {
                    if (d.children[i].getAttribute("name") == "conditiontype") {
                        //d.children[i].setAttribute("hidden", hide);
                        d.children[i].setAttribute("value", hide);
                        d.children[i].setAttribute("readonly", "true");
                        d.children[i].setAttribute("type", "text");
                    }
                }
            }
        }
    }

    element.setReadonlyNone=function() {
        var lines = facilis.View.getInstance().getLineView().getLinesStartingIn(this.parent);
        for (var i = 0; i < lines.length; i++ ) {
            var data =   (lines[i]).getData();
            if (data && data.getAttribute("name") == "sflow") {
                data = data.firstElementChild;
                for (var u = 0; u < data.children.length; u++ ) {
                    if (data.children[u].getAttribute("name") == "conditiontype") {
                        data.children[u].setAttribute("readonly", "true");
                        data.children[u].setAttribute("type", "text");
                        data.children[u].setAttribute("value", "None");
                    }
                }
            }
        }
    }
    


    facilis.MiddleEventElement = facilis.promote(MiddleEventElement, "EventElement");
    
}());

(function() {

    function EndEventElement() {
        this.EventElement_constructor();
        
        //private//

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(EndEventElement, facilis.EventElement);
    
    element.EventElementSetup=element.setup;
    element.setup = function() {
        this.EventElementSetup();
        
        this.lineWidth						= 1.4; //AbstractElement.lineWidth;
        this.color							= "#E9BABA"; //AbstractElement.color;
        this.lineColor						= "#CC0000"; //AbstractElement.lineColor;
        this.topColor = this.color;
        this.backColor = this.color;
        this.topLineAlpha=1;
        this.redrawCube();
    } ;


    facilis.EndEventElement = facilis.promote(EndEventElement, "EventElement");
    
}());

(function() {

    function GatewayElement() {
        this.SizableElement_constructor();
        
        this._icon=null;
		
		this.icons;
		this.typeIcon;
		
		this.gatewayType = "";
		this.executionType = "";
		
		this.txtName=null;
		
		this.FONT_COLOR = "#333333";
		this.FONT_SIZE = "10";
		this.FONT_FACE = "Tahoma";
		
		this.lineWidth						= 1.4;
		this.color							= "#FFEED6";
		this.lineColor						= "#FF9900";

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(GatewayElement, facilis.SizableElement);
    
    element.SizableElementSetup=element.setup;
    element.setup = function() {
        this.SizableElementSetup();
        
        this.sizable=false;
        
        this._width = 33;
        this._height = 33;
        
        this._icon = new facilis.BaseElement();
        this.icons = new facilis.BaseElement();
        
        this.addChild(this._icon);
        this.addChild(this.icons);

        this.txtName = new facilis.ElementText();
        this.addChild(this.txtName);
        this.redrawCube();
    };
    
    
    element.setSize=function(width, height) {
        this._width = width;
        this._height = height;
        this.redrawCube();
    }
		
    element.redrawCube=function() {
        if(!this._icon.graphics)
            this._icon.graphics=new facilis.Graphics();

        
        this._icon.graphics.lineStyle(this.lineWidth,this.lineColor);
        this._icon.graphics.beginFill(this.color, 1); 
        this._icon.graphics.moveTo(this._width / 2,0);
        this._icon.graphics.lineTo(this._width, this._height / 2);
        this._icon.graphics.lineTo(this._width / 2, this._height);
        this._icon.graphics.lineTo(0, this._height / 2);
        this._icon.graphics.lineTo(this._width / 2, 0);
        this._icon.graphics.endFill();
        this.makeDegree(this._icon,this._height,this._height);
        this._icon.graphics.moveTo(this._width / 2,0);
        this._icon.graphics.lineTo(this._width, this._height / 2);
        this._icon.graphics.lineTo(this._width / 2, this._height);
        this._icon.graphics.lineTo(0,this._height / 2);
        this._icon.graphics.lineTo(this._width / 2, 0);
        this._icon.graphics.endFill();
        this._icon.addShape(new facilis.Shape(this._icon.graphics));

        this.alignText();
        
        this.setCached(true);
    }
    
    element.getCachedArea=function() {
        var h=this._height+this.cacheThreshold+50;
        h+=200;
        return { x:-this.cacheThreshold,y:-this.cacheThreshold,width:this._width+this.cacheThreshold+50,height:h };
    };

    element.typeChange=function(type) {
        this.setCached(false);
		var icon = "";
        switch (type){
        case "Event":
        icon = "icons.gatewayType.EventBasedGateway";
        break;
        case "Data":
        icon = "icons.gatewayType.ExclusiveGateway";
        break;
        case "Exclusive":
        icon = "icons.gatewayType.ExclusiveGateway";
        break;
        case "Inclusive":
        icon = "icons.gatewayType.InclusiveGateway";
        break;
        case "Complex":
        icon = "icons.gatewayType.ComplexGateway";
        break;
        case "Parallel":
        icon = "icons.gatewayType.ParallelGateway";
        break;
        }
        if(this.typeIcon){
            this.icons.removeChild(this.typeIcon);
            this.typeIcon = null;
        }
        if(icon!=""){
            this.typeIcon = facilis.IconManager.getInstance().getIcon(icon);
            this.icons.addChild(this.typeIcon);
        }
        
        this.positionIcon();
		if (this.type == "Inclusive") {
			this.icons.x += 0.5;
			this.icons.y += 0.5;
		} else if (this.type == "Event") {
			this.icons.width += 1;
			this.icons.height += 1;
			this.icons.x += 0.5;
			this.icons.y += 0.5;
		}
		
        this.setExecutionOrder();
        this.setReadonlyExpression();
		this.setCached(true);
    }

    element.positionIcon=function() {
        this.icons.x = (this._width / 2)-(this.icons.getBounds().width / 2);
        this.icons.y = (this._height / 2)-(this.icons.getBounds().height / 2);
        
    }

    element.setName=function(name) {
        this.txtName.text = name;
        this.alignText();
    }

    element.alignText=function() {
        this.txtName.textAlign="center";
        this.txtName.y = this._height ;
        this.txtName.width = (this._width * 2);
         
        this.txtName.lineWidth = (this._width * 2);
        //this.txtName.height = (this._height*2);
        
        this.txtName.x = (this._width/2);
    }

    element.setDependencyProps=function(type) {
        var parent = this.parent;
        gatewayType = type;
        if (type == "Exclusive") {
            var d = (parent).getData().firstChildNode;
            for (var e = 0; e < d.children.length; e++ ) {
                if (d.children[e]=="exclusivetype") {
                    type = d.children[e].getAttribute("value");
                    break;
                }
            }
        }
        var lines = facilis.View.getInstance().getLineView().getLinesStartingIn(parent);
        for (var i = 0; i < lines.length; i++ ) {
            if ((lines[i]).elementType == "sflow") {
                var data = getConditiontype(  (lines[i]).getData() ).firstChildNode;
                enableAll(data);
                if (type == "Inclusive" || type == "Data") {
                    disableValue(data, "None");
                }
                if (type != "Data") {
                    disableValue(data, "Default");
                }
                if ((type != "Inclusive" && type != "Data") || type == "Complex") {
                    disableValue(data, "Expression");
                }
            }
        }
        updateExecution();
    }

    element.setExecutionType=function(type) {
        executionType = type;
        //setExecutionOrder();
    }
    
    element.t=null;
    element.updateExecution=function(action) {
        action=(action||"add");
        var d = (this.parent).getData();
        if (d) {
            for (var u = 0; u < d.children.length; u++ ) {
                var data = d.children[u];
                for (var i = 0; i < data.children.length; i++ ) {
                    if (data.children[i].getAttribute("name") == "executiontype") {
                        executionType = data.children[i].getAttribute("value");
                    }
                    if (data.children[i].getAttribute("name") == "gatewaytype") {
                        gatewayType = data.children[i].getAttribute("value");
                    }
                }
            }
            setExecutionOrder(action);
            //checkMiddleEvents(action);
            if(!t || (t && !t.running)){
                t = new Timer(300, 1);
                t.addEventListener(TimerEvent.TIMER, onTimer);
                t.start();
            }
        }
    }

    element.onTimer=function(e) {
        checkMiddleEvents();
    }

    element.setExecutionOrder=function(action) {
        action=(action||"add");
        var disabled = "true";
        if (this.gatewayType == "Exclusive" && this.executionType == "Automatic") {
            disabled = "false";
        }
        var parent = this.parent;
        var lines = facilis.View.getInstance().getLineView().getLinesStartingIn(parent);
        var i = 0;
        var countSflow = 0;
        var data;
        for (i = 0; i < lines.length; i++ ) {
            data =   (lines[i]).getData();
            if (data.getAttribute("name") == "sflow") {
                countSflow++;
            }
        }
        i = 0;
        if (action == "remove") {
            countSflow--;
        }
        if (countSflow == 1) {
            disabled = "true";
        }
        for (i = 0; i < lines.length; i++ ) {
            data =   (lines[i]).getData();
            if (data.getAttribute("name") == "sflow") {
                //data =   data.children[1]
                data =   data.children[0];
                for (var u = 0; u < data.children.length; u++ ) {
                    if (data.children[u].getAttribute("name") == "executionorder") {
                        data.children[u].setAttribute("disabled", disabled);
                    }
                }
                /*data =   data.parentNode.firstChildNode;
                var disableCondition = "true";
                if (lines.length > 1 && gatewayType != "Parallel") {
                    disableCondition = "false";
                }
                for (u = 0; u < data.children.length; u++ ) {
                    if (data.children[u].getAttribute("name") == "conditionexpression") {
                        //data.children[u].setAttribute("disabled", disableCondition);
                    }
                    if (data.children[u].getAttribute("name") == "conditiontype") {
                            data.children[u].setAttribute("disabled", disableCondition);
                    }
                }*/
            }
        }
        this.setReadonlyExpression();
    }

    element.getConditiontype=function(data) {
        for (var i = 0; i < data.firstChildNode.children.length; i++ ) {
            if (data.firstChildNode.children[i].getAttribute("name") == "conditiontype") {
                return data.firstChildNode.children[i];
            }
        }
        return null;
    }

    element.disableValue=function(node, value) {
        for (var i = 0; i < node.children.length; i++ ) {
            if (node.children[i].getAttribute("value") == value) {
                node.children[i].setAttribute("disabled", "true");
            }
        }
    }

    element.enableAll=function(node) {
        for (var i = 0; i < node.children.length; i++ ) {
            node.children[i].setAttribute("disabled", "false");
        }
    }

    element.setReadonlyExpression=function(action) {
        action=(action||"add");
        var lines = facilis.View.getInstance().getLineView().getLinesStartingIn(this.parent);
			var ro = false;
			var value = "Expression";
			var removeNone = false;
			if (gatewayType == "Exclusive" || gatewayType == "Inclusive") {
				//ro = true; -> Se agrega tipo de asociaciÃ³n Default
				//ro = false;
				/* No puede ser None, Solo condition o default
				if (lines.length == 1 || (lines.length == 2 && action == "remove")) {
					value = "None";
				}
				*/
				removeNone = true;
			} else if (gatewayType == "Parallel" || gatewayType == "Event") {
				ro = true;
				value = "None";
			}
			
			for (var i = 0; i < lines.length; i++ ) {
				var data =   (lines[i]).getData();
				if (data && data.getAttribute("name") == "sflow") {
					data = data.firstChildNode;
					for (var u = 0; u < data.children.length; u++ ) {
						if (data.children[u].getAttribute("name") == "conditiontype") {
							data.children[u].setAttribute("readonly", ro ? "true" : "false");
							data.children[u].setAttribute("type", ro ? "text" : "combo");
							//data.children[u].setAttribute("value", ro ? value : "None");
							//value = data.children[u].getAttribute("value");
							if(ro) {
								data.children[u].setAttribute("value", value);
							} else {
								if (removeNone && data.children[u].getAttribute("value") == "None")
									data.children[u].setAttribute("value", value);
								value = data.children[u].getAttribute("value");
							}
							
							if (removeNone) {
								
								for (var u2 = 0; u2 < data.children[u].children[0].children.length; u2++ ) {
									if (data.children[u].children[0].children[u2].getAttribute("value") == "None") {
										data.children[u].children[0].children[u2].removeNode();
										break;
									}
								}
							}
						}
						if (data.children[u].getAttribute("name") == "conditionexpression") {
							data.children[u].getAttribute("disabled") = (value=="None")?"true":"false";
						}
					}
				}
			}
    }

    element.checkMiddleEvents=function(type) {
        action=(action||"add");
        if(gatewayType=="Parallel"){
            var lines = facilis.View.getInstance().getLineView().getLinesStartingIn(this.parent);
            var setTo = false;
            var i = 0;
            var middleCount = 0;
            if(lines.length>0){
                for (i = 0; i < lines.length; i++ ) {
                    var line = lines[i];
                    var el = line.getEndElement();
                    var elType = el.elementType;
                    if (elType == "middleevent" && lines.length>1) {
                        //middleCount++;
                        //if(middleCount>1){
                            setTo = true;
                            break;
                        //}
                    }
                }
            }
            var typeNodeValues = getGatewayTypeNode().firstChildNode;
            i = 0;
            for (i = 0; i < typeNodeValues.children.length; i++ ) {
                var gType = typeNodeValues.children[i].getAttribute("value");
                if (gType == "Exclusive" || gType == "Inclusive") {
                    typeNodeValues.children[i].setAttribute("disabled", setTo+"");
                }
            }
        }
    }


    element.getGatewayTypeNode=function() {
        var d = (this.parent).getData();
        if (d) {
            for (var u = 0; u < d.children.length; u++ ) {
                var data = d.children[u];
                for (var i = 0; i < data.children.length; i++ ) {
                    if (data.children[i].getAttribute("name") == "gatewaytype") {
                        return data.children[i];
                    }
                }
            }
        }
        return null;
    }
    
    element.getIntersectionWidthSegment=function(s,e){
        
        var start=new facilis.Point(s.x,s.y);
        var end=new facilis.Point(e.x,e.y);
        
        this.globalToLocal(start.x,start.y,start);
        this.globalToLocal(end.x,end.y,end);
        
        var p1=new facilis.Point(this._width / 2,0)
        var p2=new facilis.Point(this._width, this._height / 2)
        var p3=new facilis.Point(this._width / 2, this._height)
        var p4=new facilis.Point(0, this._height / 2)
        
        var ret=(this.FindPointofIntersection(start,end,p1,p2) ||
                this.FindPointofIntersection(start,end,p2,p3) ||
                this.FindPointofIntersection(start,end,p3,p4) ||
                this.FindPointofIntersection(start,end,p4,p1)
                );
       
        
        if(ret){
            this.localToGlobal(ret.x,ret.y,ret);
        }else{
            console.log("failed gatewayelement intersection segment");
        }
       
        
        return ret;
        
    }
    


    facilis.GatewayElement = facilis.promote(GatewayElement, "SizableElement");
    
}());

(function() {

    function DataObject() {
        this.SizableElement_constructor();
        
        this._icon=null;
		//var _width = 40;
		//var _height = 60;
		
		this.radius = 10;
		
		this.sizable = false;
		
		this.txtName=null;
		
		this.txt_name = "";
		this.txt_state = "";
		
		this.FONT_COLOR = "#333333";
		this.FONT_SIZE = "10";
		this.FONT_FACE = "Tahoma";
		
		this.lineWidth						= facilis.AbstractElement.lineWidth;
		this.color							= facilis.AbstractElement.color;
		this.lineColor						= facilis.AbstractElement.lineColor;

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(DataObject, facilis.SizableElement);
    
    element.SizableElementSetup=element.setup;
    element.setup = function() {
        this.SizableElementSetup();
        
        this._width = 40;
        this._height = 60;
        this._icon = new facilis.BaseElement();
        this.addChild(this._icon);

        txtName = new facilis.ElementText();
        /*txtName.autoSize = TextFieldAutoSize.CENTER;
        txtName.selectable = false;
        txtName.multiline = true;
        txtName.wordWrap = true;
        txtName.width = 0;*/
        this.addChild(this.txtName);

        /*var myformat:TextFormat = new TextFormat();
        myformat.color = FONT_COLOR;
        myformat.size = FONT_SIZE;
        myformat.font = FONT_FACE;
        myformat.align = "center";
        txtName.defaultTextFormat = myformat;*/
        
        this.redrawCube();
    };

    
    element.setSize = function(width, height) {
        _width = width;
        _height = height;
        redrawCube();
    }

    element.redrawCube = function() {
        this._icon.removeAllChildren();
        if(!this._icon.graphics)
            this._icon.graphics=new facilis.Graphics();
        
        this._icon.graphics.clear();
        
        this._icon.graphics.lineStyle(this.lineWidth,this.lineColor);
        
        this._icon.graphics.beginFill(this.color); 
        this.drawSheet();
        this._icon.graphics.endFill();
        this.makeDegree(this._icon);
        this.drawSheet();
        this._icon.graphics.endFill();
        
        this._icon.addShape(new facilis.Shape(this._icon.graphics));
        //_icon.graphics.drawRoundRect(0, 0, _width, _height, radius, radius);
        
        this.setCached(true);
    }

    element.drawSheet = function() {

        this._icon.graphics.moveTo(0, 0);
        this._icon.graphics.lineTo(this._width - this.radius, 0);
        this._icon.graphics.lineTo(this._width,this.radius);
        this._icon.graphics.lineTo(this._width , this._height);
        this._icon.graphics.lineTo(0, this._height);
        this._icon.graphics.lineTo(0, 0);
        this._icon.graphics.lineTo(this._width - this.radius, 0);
        this._icon.graphics.endFill(); 
        this._icon.graphics.moveTo(this._width - this.radius, 0);
        this._icon.graphics.lineTo(this._width - this.radius, this.radius);
        this._icon.graphics.lineTo(this._width, this.radius);

    }

    element.setName = function(n) {
        if(n){
            txt_name = n;
        }else {
            txt_name = "";
        }
        updateText();
    }

    element.setState = function(s) {
        if(s){
            txt_state = s;
        }else {
            txt_state = "";
        }
        updateText();
    }

    element.updateText = function() {
        var txt = txt_name;
        if (txt_state != "") {
            txt += "\n[" + txt_state + "]";
        }
        txtName.text = txt;
        /*var myformat:TextFormat = new TextFormat();
        myformat.color = FONT_COLOR;
        myformat.size = FONT_SIZE;
        myformat.font = FONT_FACE;
        myformat.align = "center";
        txtName.setTextFormat(myformat);*/
        alignText();

    }

    element.alignText = function() {
        txtName.y = _height ;
        txtName.width = (_width * 2);
        txtName.x = (_width/2)-(txtName.width/2);
    }
    
    element.getIntersectionWidthSegment=function(start,end){
        //this.globalToLocal(start.x,start.y,start);
        //this.globalToLocal(end.x,end.y,end);
        var ret=(this.FindPointofIntersection(start,end,new facilis.Point(0,0),new facilis.Point(this._width,0)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,0),new facilis.Point(this._width,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,this._height),new facilis.Point(0,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(0,this._height),new facilis.Point(0,0))
                );
        //this.localToGlobal(ret.x,ret.y,ret);
        return ret;
        
    }
    

    facilis.DataObject = facilis.promote(DataObject, "SizableElement");
    
}());

(function() {

    function TextAnnotation() {
        this.SizableElement_constructor();
        
        this._icon=null;
		//var _width = 40;
		//var _height = 60;
		
		this.radius = 10;
		
		this.sizable = false;
		
		this.txtName=null;
		
		this.txt_name = "";
		this.txt_state = "";
		
		this.FONT_COLOR = "#333333";
		this.FONT_SIZE = "10";
		this.FONT_FACE = "Tahoma";
		
		this.lineWidth						= facilis.AbstractElement.lineWidth;
		this.color							= facilis.AbstractElement.color;
		this.lineColor						= facilis.AbstractElement.lineColor;

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(TextAnnotation, facilis.SizableElement);
    
    element.SizableElementSetup=element.setup;
    element.setup = function() {
        this.SizableElementSetup();
        
        this._width = 40;
        this._height = 20;
        this._icon = new facilis.BaseElement();
        this.addChild(this._icon);

        this.txtText = new facilis.ElementText();
        /*txtText.selectable = false;
        txtText.multiline = true;
        txtText.wordWrap = true;

        var myformat:TextFormat = new TextFormat();
        myformat.color = FONT_COLOR;
        myformat.size = FONT_SIZE;
        myformat.font = FONT_FACE;
        myformat.align = "center";
        txtText.defaultTextFormat = myformat;
        */
        this.addChild(this.txtText);

        this.redrawCube();
        
    } ;

    
    
    element.setSize = function(width, height) {
        this._width = width;
        this._height = height;
        this.redrawCube();
    }

    element.redrawCube = function() {
        this._icon.removeAllChildren();
        if(!this._icon.graphics)
            this._icon.graphics=new facilis.Graphics();
        
        this._icon.graphics.clear();
        
        this._icon.graphics.lineStyle(1,"rgba(0,0,0,.1)");
        
        this._icon.graphics.beginFill("#EAEAEA", 0.1);
        this._icon.graphics.drawRoundRect(0, 0, this._width, this._height, this.radius, this.radius);
        this._icon.graphics.endFill();
        
        this._icon.graphics.lineStyle(1.2,"rgba(0,0,0,.5)");
        
        
        this._icon.graphics.moveTo(this._width/2, this._height);
        this._icon.graphics.lineTo(0, this._height);
        this._icon.graphics.lineTo(0, 0);
        this._icon.graphics.lineTo((this._width / 2), 0);


        this._icon.addShape(new facilis.Shape(this._icon.graphics));
			
        this.alignText();
        //_icon.graphics.drawRoundRect(0, 0, _width, _height, radius, radius);
        
        this.setCached(true);
    }
    
    
    
    element.setText=function(text) {
        this.txtText.text = text;
        /*var myformat:TextFormat = new TextFormat();
        myformat.color = FONT_COLOR;
        myformat.size = FONT_SIZE;
        myformat.font = FONT_FACE;
        myformat.align = "center";
        txtText.setTextFormat(myformat);*/
        this.alignText();
    }

    element.alignText=function() {
        this.txtText.y = 0;
        this.txtText.width = this._width;
        this.txtText.height = this._height;
    }
    
    element.getIntersectionWidthSegment=function(start,end){
        //this.globalToLocal(start.x,start.y,start);
        //this.globalToLocal(end.x,end.y,end);
        var ret=(this.FindPointofIntersection(start,end,new facilis.Point(0,0),new facilis.Point(this._width,0)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,0),new facilis.Point(this._width,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,this._height),new facilis.Point(0,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(0,this._height),new facilis.Point(0,0))
                );
        //this.localToGlobal(ret.x,ret.y,ret);
        return ret;
        
    }

    facilis.TextAnnotation = facilis.promote(TextAnnotation, "SizableElement");
    
}());

(function() {

    function DataInput() {
        this.DataObject_constructor();
        
		this.subIcons;
		this.topIcons;
		
		this._curve_height = 10;
		this._line_height = 8;

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(DataInput, facilis.DataObject);
    
    element.DataObjectSetup=element.setup;
    element.setup = function() {
        this.DataObjectSetup();
           
		
		this._width = 60;//70;
		this._height = 61;//64;


		this.subIcons = facilis.BaseElement();
		this.topIcons = facilis.BaseElement();

		this.addChild(this.topIcons);
		this.addChild(this.subIcons);

		redrawCube();
		
    };

	element.redrawBaseCube = element.redrawCube;
    element.redrawCube = function() {
        element.redrawBaseCube();
        this.setCached(false);
		this.typeIcon = (facilis.IconManager.getInstance().getIcon("icons.dataobjectType.DataInput"));
		this.addTopIcon(this.typeIcon);
		this.setCached(true);
    }
	
	
	element.drawMediumLines=function() {
		var y = this._line_height + 1;

		this._icon.graphics.moveTo(0, y);

		this._icon.graphics.curveTo(this._width / 12, y + this._line_height - 2.2, this._width/2, y + this._line_height - 2);
		this._icon.graphics.curveTo(11*this._width / 12, y + this._line_height - 2.2, this._width, y);
		y += 4;

		this._icon.graphics.moveTo(0, y);
		this._icon.graphics.curveTo(this._width / 12, y + this._line_height - 2.2, this._width/2, y + this._line_height - 2);
		this._icon.graphics.curveTo(11 * this._width / 12, y + this._line_height - 2.2, this._width, y);

		y += 4;

		this._icon.graphics.moveTo(0, y);
		this._icon.graphics.curveTo(this._width / 12, y + this._line_height - 2.2, this._width/2, y + this._line_height - 2);
		this._icon.graphics.curveTo(11 * this._width / 12, y + this._line_height - 2.2, this._width, y);
	}
	
    element.setState = function(s) {
        if(s){
            txt_state = s;
        }else {
            txt_state = "";
        }
        updateText();
    }
    element.alignText = function() {
        txtName.y = _height ;
        txtName.width = (_width * 2);
        txtName.x = (_width/2)-(txtName.width/2);
    }
    
	
	
	
	
    element.positionIcons=function() {
        for (var i = 0; i < this.topIcons.numChildren;i++ ) {
            //this.topIcons.getChildAt(i).x = (this.iconSize + 1) * ( -i);
			this.topIcons.getChildAt(i).x = (this.iconSize + 1) * ( i);
        }
        i = (this.subIcons.numChildren - 1);
        for (i = (this.subIcons.numChildren - 1); i >= 0; i-- ) {
           this.subIcons.getChildAt(i).x = (this.iconSize + 1) * ( i);
        }
        this.subIcons.y = this._height - this.iconSize;
        if(this.subIcons.numChildren>0)
            this.subIcons.x = (this._width - (this.subIcons.numChildren*this.iconSize)) / 2;
        
        this.topIcons.y = 5;
        //if(this.topIcons.getBounds().width)
        //this.topIcons.x = (this._width - ((this.iconSize + 1)*this.topIcons.numChildren)) - 5;
		this.topIcons.x = 2;
        
        this.alignText();
    }

    element.addSubIcon=function(icon) {
        if (icon == null) {
            return;
        }
        this.subIcons.addChild(icon);
        icon.parent.swapChildren(icon, icon.parent.getChildAt(0));
        this.positionIcons();
    }

    element.addTopIcon=function(icon) {
        if (icon == null) {
            return;
        }
        this.topIcons.addChild(icon);
        this.positionIcons();
    }

    element.removeSubicon=function(icon) {
        if (icon && icon.parent==this.subIcons) {
            this.subIcons.removeChild(icon);
            this.positionIcons();
        }
        icon = null;
    }

    element.removeTopIcon=function(icon) {
        if (icon && icon.parent==this.topIcons) {
            this.topIcons.removeChild(icon);
            this.positionIcons();
        }
        icon = null;
    }
	
	
	element.multiIcon;
	element.typeIcon;
		
	element.setCollection=function(c) {

		if(multiIcon){
			this.removeSubIcon(multiIcon);
			this.multiIcon = null;
		}
		if(c == "true"){
			this.multiIcon = (facilis.IconManager.getInstance().getIcon("icons.loopType.MultiInstanceLoop"));
			this.addSubIcon(multiIcon);
		}
	}	
	
	element.typeChange=function(t) {
		var icon = "";

		switch (t){
			case "Input":
			icon = "icons.dataobjectType.DataInput";
			break;
			case "Output":
			icon = "icons.dataobjectType.DataOutput";
			break;
		}

		if(this.typeIcon) {
			this.removeTopIcon(typeIcon);
			this.typeIcon = null;
		}
		if(icon != "") {
			this.typeIcon = (facilis.IconManager.getInstance().getIcon(icon));
			this.addTopIcon(this.typeIcon);
		}
	}
	
    element.getIntersectionWidthSegment=function(start,end){
        //this.globalToLocal(start.x,start.y,start);
        //this.globalToLocal(end.x,end.y,end);
        var ret=(this.FindPointofIntersection(start,end,new facilis.Point(0,0),new facilis.Point(this._width,0)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,0),new facilis.Point(this._width,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,this._height),new facilis.Point(0,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(0,this._height),new facilis.Point(0,0))
                );
        //this.localToGlobal(ret.x,ret.y,ret);
        return ret;
        
    }

	
    facilis.DataInput = facilis.promote(DataInput, "DataObject");
    
}());

(function() {

    function DataObject() {
        this.SizableElement_constructor();
        
        this._icon=null;
		//var _width = 40;
		//var _height = 60;
		
		this.radius = 10;
		
		this.sizable = false;
		
		this.txtName=null;
		
		this.txt_name = "";
		this.txt_state = "";
		
		this.FONT_COLOR = "#333333";
		this.FONT_SIZE = "10";
		this.FONT_FACE = "Tahoma";
		
		this.lineWidth						= facilis.AbstractElement.lineWidth;
		this.color							= facilis.AbstractElement.color;
		this.lineColor						= facilis.AbstractElement.lineColor;

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(DataObject, facilis.SizableElement);
    
    element.SizableElementSetup=element.setup;
    element.setup = function() {
        this.SizableElementSetup();
        
        this._width = 40;
        this._height = 60;
        this._icon = new facilis.BaseElement();
        this.addChild(this._icon);

        txtName = new facilis.ElementText();
        /*txtName.autoSize = TextFieldAutoSize.CENTER;
        txtName.selectable = false;
        txtName.multiline = true;
        txtName.wordWrap = true;
        txtName.width = 0;*/
        this.addChild(this.txtName);

        /*var myformat:TextFormat = new TextFormat();
        myformat.color = FONT_COLOR;
        myformat.size = FONT_SIZE;
        myformat.font = FONT_FACE;
        myformat.align = "center";
        txtName.defaultTextFormat = myformat;*/
        
        this.redrawCube();
    };

    
    element.setSize = function(width, height) {
        _width = width;
        _height = height;
        redrawCube();
    }

    element.redrawCube = function() {
        this._icon.removeAllChildren();
        if(!this._icon.graphics)
            this._icon.graphics=new facilis.Graphics();
        
        this._icon.graphics.clear();
        
        this._icon.graphics.lineStyle(this.lineWidth,this.lineColor);
        
        this._icon.graphics.beginFill(this.color); 
        this.drawSheet();
        this._icon.graphics.endFill();
        this.makeDegree(this._icon);
        this.drawSheet();
        this._icon.graphics.endFill();
        
        this._icon.addShape(new facilis.Shape(this._icon.graphics));
        //_icon.graphics.drawRoundRect(0, 0, _width, _height, radius, radius);
        
        this.setCached(true);
    }

    element.drawSheet = function() {

        this._icon.graphics.moveTo(0, 0);
        this._icon.graphics.lineTo(this._width - this.radius, 0);
        this._icon.graphics.lineTo(this._width,this.radius);
        this._icon.graphics.lineTo(this._width , this._height);
        this._icon.graphics.lineTo(0, this._height);
        this._icon.graphics.lineTo(0, 0);
        this._icon.graphics.lineTo(this._width - this.radius, 0);
        this._icon.graphics.endFill(); 
        this._icon.graphics.moveTo(this._width - this.radius, 0);
        this._icon.graphics.lineTo(this._width - this.radius, this.radius);
        this._icon.graphics.lineTo(this._width, this.radius);

    }

    element.setName = function(n) {
        if(n){
            txt_name = n;
        }else {
            txt_name = "";
        }
        updateText();
    }

    element.setState = function(s) {
        if(s){
            txt_state = s;
        }else {
            txt_state = "";
        }
        updateText();
    }

    element.updateText = function() {
        var txt = txt_name;
        if (txt_state != "") {
            txt += "\n[" + txt_state + "]";
        }
        txtName.text = txt;
        /*var myformat:TextFormat = new TextFormat();
        myformat.color = FONT_COLOR;
        myformat.size = FONT_SIZE;
        myformat.font = FONT_FACE;
        myformat.align = "center";
        txtName.setTextFormat(myformat);*/
        alignText();

    }

    element.alignText = function() {
        txtName.y = _height ;
        txtName.width = (_width * 2);
        txtName.x = (_width/2)-(txtName.width/2);
    }
    
    element.getIntersectionWidthSegment=function(start,end){
        //this.globalToLocal(start.x,start.y,start);
        //this.globalToLocal(end.x,end.y,end);
        var ret=(this.FindPointofIntersection(start,end,new facilis.Point(0,0),new facilis.Point(this._width,0)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,0),new facilis.Point(this._width,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,this._height),new facilis.Point(0,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(0,this._height),new facilis.Point(0,0))
                );
        //this.localToGlobal(ret.x,ret.y,ret);
        return ret;
        
    }
    

    facilis.DataObject = facilis.promote(DataObject, "SizableElement");
    
}());

(function() {

    function DataOutput() {
        this.DataObject_constructor();
        
		this.subIcons;
		this.topIcons;
		
		this._curve_height = 10;
		this._line_height = 8;

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(DataOutput, facilis.DataObject);
    
    element.DataObjectSetup=element.setup;
    element.setup = function() {
        this.DataObjectSetup();
           
		
		this._width = 60;//70;
		this._height = 61;//64;


		this.subIcons = facilis.BaseElement();
		this.topIcons = facilis.BaseElement();

		this.addChild(this.topIcons);
		this.addChild(this.subIcons);

		redrawCube();
		
    };

	element.redrawBaseCube = element.redrawCube;
    element.redrawCube = function() {
        element.redrawBaseCube();
        this.setCached(false);
		this.typeIcon = (facilis.IconManager.getInstance().getIcon("icons.dataobjectType.DataOutput"));
		this.addTopIcon(this.typeIcon);
		this.setCached(true);
    }
	
	
	element.drawMediumLines=function() {
		var y = this._line_height + 1;

		this._icon.graphics.moveTo(0, y);

		this._icon.graphics.curveTo(this._width / 12, y + this._line_height - 2.2, this._width/2, y + this._line_height - 2);
		this._icon.graphics.curveTo(11*this._width / 12, y + this._line_height - 2.2, this._width, y);
		y += 4;

		this._icon.graphics.moveTo(0, y);
		this._icon.graphics.curveTo(this._width / 12, y + this._line_height - 2.2, this._width/2, y + this._line_height - 2);
		this._icon.graphics.curveTo(11 * this._width / 12, y + this._line_height - 2.2, this._width, y);

		y += 4;

		this._icon.graphics.moveTo(0, y);
		this._icon.graphics.curveTo(this._width / 12, y + this._line_height - 2.2, this._width/2, y + this._line_height - 2);
		this._icon.graphics.curveTo(11 * this._width / 12, y + this._line_height - 2.2, this._width, y);
	}
	
    element.setState = function(s) {
        if(s){
            txt_state = s;
        }else {
            txt_state = "";
        }
        updateText();
    }
    element.alignText = function() {
        txtName.y = _height ;
        txtName.width = (_width * 2);
        txtName.x = (_width/2)-(txtName.width/2);
    }
    
	
	
	
	
    element.positionIcons=function() {
        for (var i = 0; i < this.topIcons.numChildren;i++ ) {
            //this.topIcons.getChildAt(i).x = (this.iconSize + 1) * ( -i);
			this.topIcons.getChildAt(i).x = (this.iconSize + 1) * ( i);
        }
        i = (this.subIcons.numChildren - 1);
        for (i = (this.subIcons.numChildren - 1); i >= 0; i-- ) {
           this.subIcons.getChildAt(i).x = (this.iconSize + 1) * ( i);
        }
        this.subIcons.y = this._height - this.iconSize;
        if(this.subIcons.numChildren>0)
            this.subIcons.x = (this._width - (this.subIcons.numChildren*this.iconSize)) / 2;
        
        this.topIcons.y = 5;
        //if(this.topIcons.getBounds().width)
        //this.topIcons.x = (this._width - ((this.iconSize + 1)*this.topIcons.numChildren)) - 5;
		this.topIcons.x = 2;
        
        this.alignText();
    }

    element.addSubIcon=function(icon) {
        if (icon == null) {
            return;
        }
        this.subIcons.addChild(icon);
        icon.parent.swapChildren(icon, icon.parent.getChildAt(0));
        this.positionIcons();
    }

    element.addTopIcon=function(icon) {
        if (icon == null) {
            return;
        }
        this.topIcons.addChild(icon);
        this.positionIcons();
    }

    element.removeSubicon=function(icon) {
        if (icon && icon.parent==this.subIcons) {
            this.subIcons.removeChild(icon);
            this.positionIcons();
        }
        icon = null;
    }

    element.removeTopIcon=function(icon) {
        if (icon && icon.parent==this.topIcons) {
            this.topIcons.removeChild(icon);
            this.positionIcons();
        }
        icon = null;
    }
	
	
	element.multiIcon;
	element.typeIcon;
		
	element.setCollection=function(c) {

		if(multiIcon){
			this.removeSubIcon(multiIcon);
			this.multiIcon = null;
		}
		if(c == "true"){
			this.multiIcon = (facilis.IconManager.getInstance().getIcon("icons.loopType.MultiInstanceLoop"));
			this.addSubIcon(multiIcon);
		}
	}	
	
    element.getIntersectionWidthSegment=function(start,end){
        //this.globalToLocal(start.x,start.y,start);
        //this.globalToLocal(end.x,end.y,end);
        var ret=(this.FindPointofIntersection(start,end,new facilis.Point(0,0),new facilis.Point(this._width,0)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,0),new facilis.Point(this._width,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,this._height),new facilis.Point(0,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(0,this._height),new facilis.Point(0,0))
                );
        //this.localToGlobal(ret.x,ret.y,ret);
        return ret;
        
    }

	
    facilis.DataOutput = facilis.promote(DataOutput, "DataObject");
    
}());

(function() {

    function DataStore() {
        this.DataObject_constructor();
        
		this.subIcons;
		this.topIcons;
		
		this._curve_height = 10;
		this._line_height = 8;

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(DataStore, facilis.DataObject);
    
    element.DataObjectSetup=element.setup;
    element.setup = function() {
        this.DataObjectSetup();
           
		
		this._width = 60;//70;
		this._height = 61;//64;


		this.subIcons = facilis.BaseElement();
		this.topIcons = facilis.BaseElement();

		this.addChild(this.topIcons);
		this.addChild(this.subIcons);

		redrawCube();
		
    };

	element.redrawBaseCube = element.redrawCube;
    element.redrawCube = function() {
        element.redrawBaseCube();
        this.setCached(false);
		this.drawMediumLines();
		this.setCached(true);
    }
	
	
	element.drawMediumLines=function() {
		var y = this._line_height + 1;

		this._icon.graphics.moveTo(0, y);

		this._icon.graphics.curveTo(this._width / 12, y + this._line_height - 2.2, this._width/2, y + this._line_height - 2);
		this._icon.graphics.curveTo(11*this._width / 12, y + this._line_height - 2.2, this._width, y);
		y += 4;

		this._icon.graphics.moveTo(0, y);
		this._icon.graphics.curveTo(this._width / 12, y + this._line_height - 2.2, this._width/2, y + this._line_height - 2);
		this._icon.graphics.curveTo(11 * this._width / 12, y + this._line_height - 2.2, this._width, y);

		y += 4;

		this._icon.graphics.moveTo(0, y);
		this._icon.graphics.curveTo(this._width / 12, y + this._line_height - 2.2, this._width/2, y + this._line_height - 2);
		this._icon.graphics.curveTo(11 * this._width / 12, y + this._line_height - 2.2, this._width, y);
	}
	
    element.setState = function(s) {
        if(s){
            txt_state = s;
        }else {
            txt_state = "";
        }
        updateText();
    }
    element.alignText = function() {
        txtName.y = _height ;
        txtName.width = (_width * 2);
        txtName.x = (_width/2)-(txtName.width/2);
    }
    
	
	
	
	
    element.positionIcons=function() {
        for (var i = 0; i < this.topIcons.numChildren;i++ ) {
            //this.topIcons.getChildAt(i).x = (this.iconSize + 1) * ( -i);
			this.topIcons.getChildAt(i).x = (this.iconSize + 1) * ( i);
        }
        i = (this.subIcons.numChildren - 1);
        for (i = (this.subIcons.numChildren - 1); i >= 0; i-- ) {
           this.subIcons.getChildAt(i).x = (this.iconSize + 1) * ( i);
        }
        this.subIcons.y = this._height - this.iconSize;
        if(this.subIcons.numChildren>0)
            this.subIcons.x = (this._width - (this.subIcons.numChildren*this.iconSize)) / 2;
        
        this.topIcons.y = 5;
        //if(this.topIcons.getBounds().width)
        //this.topIcons.x = (this._width - ((this.iconSize + 1)*this.topIcons.numChildren)) - 5;
		this.topIcons.x = 2;
        
        this.alignText();
    }

    element.addSubIcon=function(icon) {
        if (icon == null) {
            return;
        }
        this.subIcons.addChild(icon);
        icon.parent.swapChildren(icon, icon.parent.getChildAt(0));
        this.positionIcons();
    }

    element.addTopIcon=function(icon) {
        if (icon == null) {
            return;
        }
        this.topIcons.addChild(icon);
        this.positionIcons();
    }

    element.removeSubicon=function(icon) {
        if (icon && icon.parent==this.subIcons) {
            this.subIcons.removeChild(icon);
            this.positionIcons();
        }
        icon = null;
    }

    element.removeTopIcon=function(icon) {
        if (icon && icon.parent==this.topIcons) {
            this.topIcons.removeChild(icon);
            this.positionIcons();
        }
        icon = null;
    }
	
	
	element.multiIcon;
	element.typeIcon;
		
	element.setCollection=function(c) {

		if(multiIcon){
			this.removeSubIcon(multiIcon);
			this.multiIcon = null;
		}
		if(c == "true"){
			this.multiIcon = (facilis.IconManager.getInstance().getIcon("icons.loopType.MultiInstanceLoop"));
			this.addSubIcon(multiIcon);
		}
	}

	element.typeChange=function(t) {
		var icon = "";

		switch (t){
			case "Input":
			icon = "icons.dataobjectType.DataInput";
			break;
			case "Output":
			icon = "icons.dataobjectType.DataOutput";
			break;
		}

		if(this.typeIcon) {
			this.removeTopIcon(typeIcon);
			this.typeIcon = null;
		}
		if(icon != "") {
			this.typeIcon = (facilis.IconManager.getInstance().getIcon(icon));
			this.addTopIcon(this.typeIcon);
		}
	}
	
	
    element.getIntersectionWidthSegment=function(start,end){
        //this.globalToLocal(start.x,start.y,start);
        //this.globalToLocal(end.x,end.y,end);
        var ret=(this.FindPointofIntersection(start,end,new facilis.Point(0,0),new facilis.Point(this._width,0)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,0),new facilis.Point(this._width,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(this._width,this._height),new facilis.Point(0,this._height)) ||
                this.FindPointofIntersection(start,end,new facilis.Point(0,this._height),new facilis.Point(0,0))
                );
        //this.localToGlobal(ret.x,ret.y,ret);
        return ret;
        
    }

	
    facilis.DataStore = facilis.promote(DataStore, "DataObject");
    
}());

(function() {

    function DashLine(target, onLength, offLength){
        this.element=target;
        if(!this.element.graphics)
            this.element.graphics=new facilis.Graphics();
            
        this.target = this.element.graphics;
        this.isLine = true;
        this.overflow = 0;
        this._curveaccuracy=6;
        this.pen = {x:0, y:0};
        
        //static public//

        this.setDash=function(onLength, offLength) {
            this.onLength = onLength;
            this.offLength = offLength;
            this.dashLength = this.onLength + this.offLength;
        }
        
        this.getDash=function() {
            return [this.onLength, this.offLength];
        }
        
        this.moveTo=function(x, y) {
            this.targetMoveTo(x, y);
        }

        
        this.lineTo=function(x,y) {
            var dx = x-this.pen.x,	dy = y-this.pen.y;
            var a = Math.atan2(dy, dx);
            var ca = Math.cos(a), sa = Math.sin(a);
            var segLength = this.lineLength(dx, dy);
            if (this.overflow){
                if (this.overflow > segLength){
                    if (this.isLine) this.targetLineTo(x, y);
                    else this.targetMoveTo(x, y);
                    this.overflow -= segLength;
                    return;
                }
                if (this.isLine) this.targetLineTo(this.pen.x + ca*this.overflow, this.pen.y + sa*this.overflow);
                else this.targetMoveTo(this.pen.x + ca*this.overflow, this.pen.y + sa*this.overflow);
                segLength -= this.overflow;
                this.overflow = 0;
                this.isLine = !this.isLine;
                if (!segLength) return;
            }
            var fullDashCount = Math.floor(segLength/this.dashLength);
            if (fullDashCount){
                var onx = ca*this.onLength,	ony = sa*this.onLength;
                var offx = ca*this.offLength,	offy = sa*this.offLength;
                for (var i=0; i<fullDashCount; i++){
                    if (this.isLine){
                        this.targetLineTo(this.pen.x+onx, this.pen.y+ony);
                        this.targetMoveTo(this.pen.x+offx, this.pen.y+offy);
                    }else{
                        this.targetMoveTo(this.pen.x+offx, this.pen.y+offy);
                        this.targetLineTo(this.pen.x+onx, this.pen.y+ony);
                    }
                }
                segLength -= this.dashLength*fullDashCount;
            }
            if (this.isLine){
                if (segLength > this.onLength){
                    this.targetLineTo(this.pen.x+ca*this.onLength, this.pen.y+sa*this.onLength);
                    this.targetMoveTo(x, y);
                    this.overflow = this.offLength-(segLength-this.onLength);
                    this.isLine = false;
                }else{
                    this.targetLineTo(x, y);
                    if (segLength == this.onLength){
                        this.overflow = 0;
                        this.isLine = !this.isLine;
                    }else{
                        this.overflow = this.onLength-segLength;
                        this.targetMoveTo(x, y);
                    }
                }
            }else{
                if (segLength > this.offLength){
                    this.targetMoveTo(this.pen.x+ca*this.offLength, this.pen.y+sa*this.offLength);
                    this.targetLineTo(x, y);
                    this.overflow = this.onLength-(segLength-this.offLength);
                    this.isLine = true;
                }else{
                    this.targetMoveTo(x, y);
                    if (segLength == this.offLength){
                        this.overflow = 0;
                        this.isLine = !this.isLine;
                    }else this.overflow = this.offLength-segLength;
                }
            }
            this.update();
        }
        
        this.curveTo=function(cx, cy, x, y) {
            var sx = this.pen.x;
            var sy = this.pen.y;
            var segLength = this.curveLength(sx, sy, cx, cy, x, y);
            var t = 0;
            var t2 = 0;
            var c;
            if (this.overflow){
                if (this.overflow > segLength){
                    if (this.isLine) this.targetCurveTo(cx, cy, x, y);
                    else this.targetMoveTo(x, y);
                    this.overflow -= segLength;
                    return;
                }
                t = this.overflow/segLength;
                c = this.curveSliceUpTo(sx, sy, cx, cy, x, y, t);
                if (this.isLine) this.targetCurveTo(c[2], c[3], c[4], c[5]);
                else this.targetMoveTo(c[4], c[5]);
                this.overflow = 0;
                this.isLine = !this.isLine;
                if (!segLength) return;
            }
            var remainLength = segLength - segLength*t;
            var fullDashCount = Math.floor(remainLength/this.dashLength);
            var ont = this.onLength/segLength;
            var offt = this.offLength/segLength;
            if (fullDashCount){
                for (var i=0; i<fullDashCount; i++){
                    if (this.isLine){
                        t2 = t + ont;
                        c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
                        this.targetCurveTo(c[2], c[3], c[4], c[5]);
                        t = t2;
                        t2 = t + offt;
                        c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
                        this.targetMoveTo(c[4], c[5]);
                    }else{
                        t2 = t + offt;
                        c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
                        this.targetMoveTo(c[4], c[5]);
                        t = t2;
                        t2 = t + ont;
                        c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
                        this.targetCurveTo(c[2], c[3], c[4], c[5]);
                    }
                    t = t2;
                }
            }
            remainLength = segLength - segLength*t;
            if (this.isLine){
                if (remainLength > this.onLength){
                    t2 = t + ont;
                    c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
                    this.targetCurveTo(c[2], c[3], c[4], c[5]);
                    this.targetMoveTo(x, y);
                    this.overflow = this.offLength-(remainLength-this.onLength);
                    this.isLine = false;
                }else{
                    c = this.curveSliceFrom(sx, sy, cx, cy, x, y, t);
                    this.targetCurveTo(c[2], c[3], c[4], c[5]);
                    if (segLength == this.onLength){
                        this.overflow = 0;
                        this.isLine = !this.isLine;
                    }else{
                        this.overflow = this.onLength-remainLength;
                        this.targetMoveTo(x, y);
                    }
                }
            }else{
                if (remainLength > this.offLength){
                    t2 = t + offt;
                    c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
                    this.targetMoveTo(c[4], c[5]);
                    c = this.curveSliceFrom(sx, sy, cx, cy, x, y, t2);
                    this.targetCurveTo(c[2], c[3], c[4], c[5]);

                    this.overflow = this.onLength-(remainLength-this.offLength);
                    this.isLine = true;
                }else{
                    this.targetMoveTo(x, y);
                    if (remainLength == this.offLength){
                        this.overflow = 0;
                        this.isLine = !this.isLine;
                    }else this.overflow = this.offLength-remainLength;
                }
            }
            this.update();
        }
        
        this.clear=function() {
            this.target.clear();
            this.update();
        }

        
        this.lineStyle=function(thickness,rgb,alpha) {
            this.target.lineStyle(thickness,rgb,alpha);
        }
        
        this.beginFill=function(rgb,alpha) {
            this.target.beginFill(rgb,alpha);
        }
        
        this.beginGradientFill=function(fillType,colors,alphas,ratios,matrix) {
            this.target.beginGradientFill(fillType,colors,alphas,ratios,matrix);
        }
        
        this.endFill=function() {
            this.target.endFill();
            this.update();
        }

        
        this.lineLength=function(sx, sy) {
            if(arguments.length>2){
                return Math.sqrt(sx*sx + sy*sy);
            } else {
                var ex = arguments[2];
                var ey = arguments[3];
            }
            var dx = ex - sx;
            var dy = ey - sy;
            return Math.sqrt(dx*dx + dy*dy);
        }
        this.curveLength=function(sx, sy, cx, cy, ex, ey) {
            var total = 0;
            var tx = sx;
            var ty = sy;
            var px, py, t, it, a, b, c;
            var n = arguments[6] != null ? arguments[6] : this._curveaccuracy;
            for (var i = 1; i<=n; i++){
                t = i/n;
                it = 1-t;
                a = it*it; b = 2*t*it; c = t*t;
                px = a*sx + b*cx + c*ex;
                py = a*sy + b*cy + c*ey;
                total += this.lineLength(tx, ty, px, py);
                tx = px;
                ty = py;
            }
            return total;
        }
        
        this.curveSlice=function(sx, sy, cx, cy, ex, ey, t1, t2) {
            if (t1 == 0) return this.curveSliceUpTo(sx, sy, cx, cy, ex, ey, t2);
            else if (t2 == 1) return this.curveSliceFrom(sx, sy, cx, cy, ex, ey, t1);
            var c = this.curveSliceUpTo(sx, sy, cx, cy, ex, ey, t2);
            c.push(t1/t2);
            return this.curveSliceFrom.apply(this, c);
        }
        
        this.curveSliceUpTo=function(sx, sy, cx, cy, ex, ey, t) {
            t=(t||0);
            
            if (t == 0) t = 1;
            if (t != 1) {
                var midx = cx + (ex-cx)*t;
                var midy = cy + (ey-cy)*t;
                cx = sx + (cx-sx)*t;
                cy = sy + (cy-sy)*t;
                ex = cx + (midx-cx)*t;
                ey = cy + (midy-cy)*t;
            }
            return [sx, sy, cx, cy, ex, ey];
        }
        
        this.curveSliceFrom=function(sx, sy, cx, cy, ex, ey, t) {
            t=(t||0);
            
            if (t == 0) t = 1;
            if (t != 1) {
                var midx = sx + (cx-sx)*t;
                var midy = sy + (cy-sy)*t;
                cx = cx + (ex-cx)*t;
                cy = cy + (ey-cy)*t;
                sx = midx + (cx-midx)*t;
                sy = midy + (cy-midy)*t;
            }
            return [sx, sy, cx, cy, ex, ey];
        }

        this.targetMoveTo=function(x, y) {
            this.pen = {x:x, y:y};
            this.target.moveTo(x, y);
            this.update();
        }
        
        this.targetLineTo=function(x, y) {
            if (x == this.pen.x && y == this.pen.y) return;
            this.pen = {x:x, y:y};
            this.target.lineTo(x, y);
            this.update();
        }
        
        this.targetCurveTo=function(cx, cy, x, y) {
            if (cx == x && cy == y && x == this.pen.x && y == this.pen.y) return;
            this.pen = {x:x, y:y};
            this.target.curveTo(cx, cy, x, y);
            this.update();
        }
        
        this.update=function(){
            this.element.removeAllChildren();
            this.element.addChild(new facilis.Shape(this.target.graphics));
        }
        
        this.setDash(onLength, offLength);
    }
    
    facilis.DashLine=DashLine;
    
}());

(function() {

    function LineUtils() {
        
    }
    
    LineUtils.dashTo=function(mc,startx, starty, endx, endy, len, gap) {
        var seglength, deltax, deltay, segs, cx, cy;
        seglength = len + gap;
        deltax = endx - startx;
        deltay = endy - starty;
        var delta = Math.sqrt((deltax * deltax) + (deltay * deltay));
        segs = Math.floor(Math.abs(delta / seglength));
        var radians = Math.atan2(deltay,deltax);
        cx = startx;
        cy = starty;
        deltax = Math.cos(radians)*seglength;
        deltay = Math.sin(radians)*seglength;
        for (var n = 0; n < segs; n++) {
            LineUtils.initGraphics(mc);
            mc.graphics.moveTo(cx,cy);
            mc.graphics.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
            cx += deltax;
            cy += deltay;
        }
        mc.graphics.moveTo(cx,cy);
        delta = Math.sqrt((endx-cx)*(endx-cx)+(endy-cy)*(endy-cy));
        if(delta>len){
            mc.graphics.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
        } else if(delta>0) {
            mc.graphics.lineTo(cx+Math.cos(radians)*delta,cy+Math.sin(radians)*delta);
        }
        mc.graphics.moveTo(endx,endy);
        mc.addChild(new facilis.Shape(mc.graphics));
    }

    LineUtils.dashDotTo=function(mc,startx, starty, endx, endy, len, gap) {
        var seglength, deltax, deltay, segs, cx, cy;
        seglength = len + gap +1 + gap;
        deltax = endx - startx;
        deltay = endy - starty;
        var delta = Math.sqrt((deltax * deltax) + (deltay * deltay));
        segs = Math.floor(Math.abs(delta / seglength));
        var radians = Math.atan2(deltay,deltax);
        cx = startx;
        cy = starty;
        deltax = Math.cos(radians)*seglength;
        deltay = Math.sin(radians)*seglength;
        for (var n = 0; n < segs; n++) {
            mc.graphics.moveTo(cx,cy);
            mc.graphics.lineTo(cx + Math.cos(radians) * len, cy + Math.sin(radians) * len);
            mc.graphics.moveTo(cx + ((Math.cos(radians) * len) + (Math.cos(radians) * gap)), cy + ((Math.sin(radians) * len) + (Math.sin(radians) * gap)) );
            mc.graphics.lineTo(cx + ((Math.cos(radians) * len) + (Math.cos(radians) * gap))+1, cy + ((Math.sin(radians) * len) + (Math.sin(radians) * gap))+1);
            cx += deltax;
            cy += deltay;
        }
        mc.graphics.moveTo(cx,cy);
        delta = Math.sqrt((endx-cx)*(endx-cx)+(endy-cy)*(endy-cy));
        if(delta>len){
            mc.graphics.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
        } else if(delta>0) {
            mc.graphics.lineTo(cx+Math.cos(radians)*delta,cy+Math.sin(radians)*delta);
        }
        mc.graphics.moveTo(endx,endy);
        mc.addChild(new facilis.Shape(mc.graphics));
    }


    LineUtils.dashCurveTo=function(mc, sx, sy, ex, ey, cx, cy, len, gap) {
        var dashed = new facilis.DashLine(mc, len, gap);
        dashed.moveTo(sx, sy);
        dashed.curveTo(ex, ey, cx, cy);
    }
    
    LineUtils.initGraphics=function(mc){
        if(!mc.graphics)
            mc.graphics=new facilis.Graphics();
    }
    

    facilis.LineUtils = LineUtils;
    
}());

(function() {

    function LineObject(s,e) {
        
        if(!s && !e)
            throw Error("Start and End elements can not be null");
        
        this.BaseElement_constructor();
        
        this.m_endPoint=0;
		this.m_startPoint=0;
		this.m_startElementMc=s;	
		this.m_endElementMc=e;
        
        this._elementId=null;
        
        this.NAME_FONT_FACE = "k0554";
		this.NAME_FONT_COLOR = "#333333";
		this.NAME_FONT_SIZE = "8";
		this.NAME_BG_COLOR = "#DFDFDF";
		this.NAME_BORDER_COLOR = "#CCCCCC";
		
		this.showForth = true;
		this.showBack = false;
		
		this._doubleArrow = false;
		
		
		this.startDragging = false;
		this.endDragging = false;
		
		this.isLooped_back=false;
		this.loop_mc=null;
		
		this.__conditionmc=null;
		this.__namemc=null;
		this.__wizmc=null;
		
		this.lineMC=null;
		this.vertexMC=null;
		this.arrowMC=null;
		this.arrowBackMC=null;
		
		this.lineCornersMC=null;
		
		this.startVertex=null;
		this.endVertex=null;
		
		this.lineVertexs=[];
		this.lineSegments=[];
		
		
		this.lastClick=0;
		this.dblClickSpeed=400;
		
		this.justDblClicked=false;
		
		this.isWizard = false;
		
		this.type = "";
		
		this.middlePoint=null;
		
		this.initIcon=null;
		
        
        this.data=null;
		
		this.txtName=null;
		
		this.FONT_COLOR = "#333333";
		this.FONT_SIZE = "10";
		this.FONT_FACE = "Tahoma";
		
        
        
        
        this.setup();
    }
    
    LineObject.VERTEXES_CHANGED          = "onVertexesChanged";
    LineObject.VERTEXES_TO_CHANGE        = "onVertexesToChange";
    LineObject.lineColor                 = "#A4A4A4";
    LineObject.lineWidth                 = 1.5;
    LineObject.VERTEX_ADD_ENABLE 		 = true;
    
    var element = facilis.extend(LineObject, facilis.AbstractElement);

    element.AbstractElementSetup=element.setup;
    element.setup = function() {
        this.AbstractElementSetup();
        
        
        
        this.startVertex=null;
        this.endVertex = null;
        this.m_endElementMc.addEventListener(facilis.AbstractElement.ELEMENT_MOVED,this.onElementMoved.bind(this));
        this.m_startElementMc.addEventListener(facilis.AbstractElement.ELEMENT_MOVED,this.onElementMoved.bind(this));
        this.m_endElementMc.addEventListener(facilis.AbstractElement.ELEMENT_DELETE,this.onElementDeleted.bind(this));
        this.m_startElementMc.addEventListener(facilis.AbstractElement.ELEMENT_DELETE, this.onElementDeleted.bind(this));

        this.m_endElementMc.addEventListener(facilis.AbstractElement.ELEMENT_DRAGGED,this.onElementMoved.bind(this));
        this.m_startElementMc.addEventListener(facilis.AbstractElement.ELEMENT_DRAGGED, this.onElementMoved.bind(this));

        this.m_endElementMc.addEventListener(facilis.Drag.STOP_EVENT, this.onElementDrop.bind(this));
        this.m_startElementMc.addEventListener(facilis.Drag.STOP_EVENT, this.onElementDrop.bind(this));
        this.m_endElementMc.addEventListener(facilis.Drag.RESET_EVENT, this.onElementDrop.bind(this));
        this.m_startElementMc.addEventListener(facilis.Drag.RESET_EVENT, this.onElementDrop.bind(this));

        this.addEventListener(facilis.AbstractElement.ELEMENT_OVER, this.onLineOver.bind(this));
        this.addEventListener(facilis.AbstractElement.ELEMENT_OUT, this.onLineOut.bind(this));
        
        this.addEventListener(facilis.AbstractElement.ELEMENT_DOUBLE_CLICKED, this.onLineDoubleClick.bind(this));

        this.lineMC = new facilis.BaseElement();
        this.addChild(this.lineMC);
        this.lineCornersMC = new facilis.BaseElement();
        this.addChild(this.lineCornersMC);
        this.vertexMC = new facilis.BaseElement();
        this.addChild(this.vertexMC);
        this.vertexMC.alpha = 0;

        this.setLineEvents();
        this.addSegment(this.m_startElementMc, this.m_endElementMc);

        this.txtName = new facilis.ElementText();
        /*txtName.autoSize = TextFieldAutoSize.CENTER;
        txtName.selectable = false;
        txtName.multiline = true;
        txtName.wordWrap = true;
        txtName.width = 1;*/

        /*var myformat:TextFormat = new TextFormat();
        myformat.color = FONT_COLOR;
        myformat.size = FONT_SIZE;
        myformat.font = FONT_FACE;
        myformat.align = "center";
        txtName.defaultTextFormat=myformat;*/

        //txtName.height = 1;

        /*txtName.addEventListener("mouseover", function(evt) {
            evt.currentTarget.parent.parent.dispatchEvent(evt);
        });*/

        this.addChild(this.txtName);

        this.refreshWholeLine();

        this.initIcon = new facilis.BaseElement();
        this.addChild(this.initIcon);
        var e=new facilis.Event(facilis.AbstractElement.ELEMENT_MOVED);
        e.target=this.m_endElementMc;
        this.m_endElementMc.dispatchEvent(e);

        
    };
    
    
    
    
    element.onLineDoubleClick=function(evt) {
        var seg=null;
        for (var i = 0; i < this.lineMC.numChildren ; i++ ) {
            var child= this.lineMC.getChildAt(i);
            //if(child.hitTestPoint(evt.localX,evt.localY,true)){
            if(child.hitTest(evt.stageX,evt.stageY)){
                seg=this.lineMC.getChildAt(i);
                break;
            }
        }
        if(seg){
            this.addVertex(seg.getStartElement(),seg.getEndElement(),evt.localX,evt.localY);
        }
    }

    element.setLineEvents=function(){
        var tmp = this;
        this.lineMC.addEventListener("mouseup"  , function(evt) {
            var timer = getTimer();
            if (((timer - tmp.lastClick) < tmp.dblClickSpeed) && LineObject.VERTEX_ADD_ENABLE) {
                tmp.justDblClicked=true;
                tmp.onLineDoubleClick(evt);
            }
            tmp.lastClick=timer;
        });
    }

    element.remove=function() {
        callStartEndFunctions("remove");
        try{
            this.getEndElement().getElement().setFirstTask("false");
        }catch(e){
        }
        this.m_startElementMc.removeEventListener(AbstractElement.ELEMENT_DELETE, this.onElementDeleted);
        this.m_endElementMc.removeEventListener(AbstractElement.ELEMENT_DELETE,this.onElementDeleted);
        this.m_endElementMc.removeEventListener(AbstractElement.ELEMENT_MOVED,this.onElementMoved);
        this.m_startElementMc.removeEventListener(AbstractElement.ELEMENT_MOVED, this.onElementMoved);
        this.m_endElementMc.removeEventListener(AbstractElement.ELEMENT_DRAGGED,this.onElementMoved);
        this.m_startElementMc.removeEventListener(AbstractElement.ELEMENT_DRAGGED, this.onElementMoved);

        this.m_endElementMc.removeEventListener(Drag.STOP_EVENT, this.onElementDrop);
        this.m_startElementMc.removeEventListener(Drag.STOP_EVENT, this.onElementDrop);
        this.m_endElementMc.removeEventListener(Drag.RESET_EVENT, this.onElementDrop);
        this.m_startElementMc.removeEventListener(Drag.RESET_EVENT, this.onElementDrop);

        if (middlePoint) {
            middlePoint.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DELETE));
        }
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_DELETE));

        View.getInstance().getLineView().removeElement(this);
    }

    element.addVertex=function(startEl, endEl, x, y) {
        var depth = this.numChildren;
        this.dispatchEvent(new facilis.Event(LineObject.VERTEXES_TO_CHANGE));
        var lineVertex = new facilis.LineVertex();
        this.vertexMC.addChild(lineVertex);
        lineVertex.x = x;
        lineVertex.y = y;
        lineVertex.addEventListener(facilis.LineVertex.CLICK,this.onVertexClick.bind(this));
        lineVertex.addEventListener(facilis.LineVertex.MOVED, this.onVertexMoved.bind(this));
        lineVertex.addEventListener(facilis.LineVertex.DROP, this.onVertexDrop.bind(this));
        lineVertex.addEventListener(facilis.LineVertex.START_MOVE, this.onVertexStartMove.bind(this));
        lineVertex.addEventListener(facilis.LineVertex.CLICKED,this.onVertexClicked.bind(this));
        lineVertex.addEventListener(facilis.LineVertex.DOUBLE_CLICKED,this.onVertexDoubleClicked.bind(this));
        lineVertex.addEventListener(facilis.LineVertex.OVER,this.onVertexRollOver.bind(this));
        lineVertex.addEventListener(facilis.LineVertex.OUT, this.onVertexRollOut.bind(this));

        if(startEl!=this.m_startElementMc){
            startEl.setNextElement(lineVertex);
        }else{
            this.startVertex=lineVertex;
        }

        if(endEl!=this.m_endElementMc){
            endEl.setLastElement(lineVertex);
        }else{
            this.endVertex=lineVertex;
        }

        lineVertex.setLastElement(startEl);
        lineVertex.setNextElement(endEl);
        this.lineVertexs.push(lineVertex);
        
        var seg = this.getSegment(startEl, endEl);

        seg.setEndElement(lineVertex);
        this.addSegment(lineVertex,endEl);
        this.refreshWholeLine();
        this.dispatchEvent(new facilis.Event(facilis.LineObject.VERTEXES_CHANGED));
        return lineVertex;
    }

    element.removeVertex=function(vertex){
        for(var i=0;i<this.lineVertexs.length;i++){
            if (this.lineVertexs[i] == vertex) {
                this.dispatchEvent(new facilis.Event(LineObject.VERTEXES_TO_CHANGE));
                if(this.startVertex==vertex){
                    this.startVertex=(vertex.getNextElement() && vertex.getNextElement()!=this.m_endElementMc)?vertex.getNextElement():null;
                }
                if(this.endVertex==vertex){
                    this.endVertex=(vertex.getLastElement() && vertex.getLastElement()!=this.m_startElementMc)?vertex.getLastElement():null;
                }
                var segment = this.getSegment(vertex, vertex.getNextElement());
                this.removeSegment(segment);
                segment=this.getSegment(vertex.getLastElement(),vertex);
                segment.setEndElement(vertex.getNextElement());
                if(vertex.getLastElement()!=this.m_startElementMc){
                    vertex.getLastElement().setNextElement(vertex.getNextElement());
                }
                if(vertex.getNextElement()!=this.m_endElementMc){
                    vertex.getNextElement().setLastElement(vertex.getLastElement());
                }
                this.lineVertexs.splice(i,1);
                vertex.remove();
                this.refreshWholeLine();
                this.dispatchEvent(new facilis.Event(LineObject.VERTEXES_CHANGED));
            }
        }
    }

    element.removeSegment=function(segment){
        for (var i = 0; i < this.lineMC.numChildren;i++ ) {
            var seg=this.lineMC.getChildAt(i);
            if(seg==segment){
                this.lineSegments.splice(i,1);
                segment.remove();
            }
        }

    }

    element.onVertexClick=function(eventObj) {
        var vertex = eventObj.target;
    }

    element.onVertexMoved=function(eventObj)  {
        startDragging = false;
        endDragging = false;
        var vertex = eventObj.target;
        this.refreshWholeLine(false);
    }

    element.onVertexDrop=function(eventObj)  {
        var vertex = eventObj.target;
        if(vertex.movedX!=0 || vertex.movedY!=0){
            this.dispatchEvent(new facilis.Event(LineObject.VERTEXES_CHANGED));
        }
    }

    element.onVertexStartMove=function(eventObj)  {
        //var vertex:LineVertex = eventObj.target as LineVertex;
        this.dispatchEvent(new facilis.Event(LineObject.VERTEXES_TO_CHANGE));
    }

    element.onVertexClicked=function(eventObj) {
        var vertex = eventObj.target;
    }

    element.onVertexRollOver=function(eventObj) {
        var vertex = eventObj.target;
        vertex.alpha = .9;
    }

    element.onVertexRollOut=function(eventObj) {
        var vertex = eventObj.target;
        vertex.alpha = .3;
    }

    element.onVertexDoubleClicked=function(eventObj) {
        var vertex = eventObj.target;
        this.removeVertex(vertex);
    }

    element.refreshWholeLine=function(_acc) {
        _acc=(_acc===false)?false:true;
        this.moveVertexes();
        for (var i = 0; i < this.lineMC.numChildren;i++ ) {
            var seg = this.lineMC.getChildAt(i);
            seg.setType(this.type);
            seg.updateSegment(_acc);
        }
        this.setArrow();
        this.updateArrowPos();
        //this.updateInitIconPos();
        this.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_MOVED));
        if (this.middlePoint) {
            var p = this.getMiddlePoint();
            this.middlePoint.x = p.x;
            this.middlePoint.y = p.y;
            this.middlePoint.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_MOVED));
        }
        this.alignText();
        /*try {
        if ((this.m_startElementMc).selected && (this.m_endElementMc).selected) {
            i = 0;
            for (i = 0; i < lineVertexs.length;i++ ) {
                (lineVertexs[i] ).moveX((this.m_startElementMc ).movedX);
                (lineVertexs[i] ).moveY((this.m_startElementMc ).movedY);
            }
        }
        }catch(e){}*/
            //(new Solver()).solve(this.m_startElementMc,this.m_endElementMc);
            this.updateLineCorners();
    }

    element.moveVertexes=function() {
        if (this.startDragging && this.endDragging) {
            for (var i = 0; i < this.lineVertexs.length; i++) {
                this.lineVertexs[i].moveX((this.m_startElementMc).movedX);
                this.lineVertexs[i].moveY((this.m_startElementMc).movedY);
            }
        }
    }

    element.addSegment=function(startEl,endEl){
        var depth=this.lineMC.numChildren+10;
        //var segment=this.lineMC.attachMovie("LineSegment",("lineSegment_"+depth),depth,{startPoint:startEl,endPoint:endEl});
        var segment = new facilis.LineSegment(startEl, endEl);
        this.lineMC.addChild(segment);
        //segment.addEventListener("onSegmentDocubleClicked",onSegmentDocubleClicked);
        this.lineSegments.push(segment);
    }

    element.getSegment=function(startEl,endEl){
        var seg = null;
        for (var i = 0; i < this.lineMC.numChildren; i++ ) {
            seg = this.lineMC.getChildAt(i) ;
            if(!(seg.getStartElement()==startEl && seg.getEndElement()==endEl)){
                seg = null;
            }else {
                return seg;
            }
        }
        return seg;
    }

    element.getSegments=function() {
        var segs = [];
        for (var i = 0; i < this.lineMC.numChildren; i++ ) {
            segs.push(this.lineMC.getChildAt(i));
        }
        return segs;
    }

    element._cached=false;
    element.onElementMoved=function(evt) {
        if(this._cached){
            element._cached=false;
            this.uncacheSegments();
        }

        if (evt.target == this.m_startElementMc) {
            this.startDragging = true;
        }
        if (evt.target == this.m_endElementMc) {
            this.endDragging = true;
        }
        this.refreshWholeLine(false);
    }

    element.onElementDrop=function(evt) {
        if (evt.target == this.m_startElementMc) {
            this.startDragging = false;
        }
        if (evt.target == this.m_endElementMc) {
            endDragging = false;
        }
        this.refreshWholeLine();
        
        if (!this.startDragging || !this.endDragging) {
            for (var i = 0; i < this.lineVertexs.length; i++) {
                (this.lineVertexs[i] ).resetStart();
            }
        }
        if(!this._cached){
            element._cached=true;
            this.cacheSegments();
        }
    }
    
    element.uncacheSegments=function(){
        for(var i=0;i<this.lineSegments;i++)
            this.lineSegments[i].uncacheSegment();
    }
    
    element.cacheSegments=function(){
        for(var i=0;i<this.lineSegments;i++)
            this.lineSegments[i].cacheSegment();
    }

    element.onElementDeleted=function(e) {
        this.remove();
    }

    element.setArrow=function() {
        if (this.arrowMC != null) {
            this.removeChild(this.arrowMC);
            this.arrowMC = null;
        }
        if (this.showForth) {
            this.arrowMC = new facilis.BaseElement();
            this.addChild(this.arrowMC);
        }
        if (this.arrowBackMC != null) {
            this.removeChild(this.arrowBackMC);
            this.arrowBackMC = null;
        }
        if (this.showBack) {
            this.arrowBackMC = new facilis.BaseElement();
            this.addChild(this.arrowBackMC);
        }
        this.createArrow(0,0);
        /*if(isWizard){
            createArrow(0,15);
        }*/
        this.vertexMC.parent.setChildIndex(this.vertexMC, this.vertexMC.parent.numChildren - 1);

    }

    element.createArrow=function(x, y) {
        if (this.showForth) {
            this.drawArrow(this.arrowMC, x, y);
            if (this._doubleArrow) {
                this.drawArrow(this.arrowMC, x, y-8);
            }
        }
        if (this.showBack) {
            this.drawArrow(this.arrowBackMC, x, y);
            if (this._doubleArrow) {
                this.drawArrow(this.arrowBackMC, x, y-8);
            }
        }
    }

    element.drawArrow=function(mc,x,y) {
        var size = 10;
        if(!mc.graphics)
            mc.graphics = new facilis.Graphics();
        
        mc.removeAllChildren();
        mc.graphics.lineStyle(0.25,LineObject.lineColor,1);
        mc.graphics.beginFill("#CCCCCC",100);
        mc.graphics.moveTo(x,y);
        mc.graphics.lineTo((size+x),-(size-y));
        mc.graphics.lineTo(0,-(size-y));
        mc.graphics.lineTo(-(size+x),-(size-y));
        mc.graphics.lineTo(x,y);
        mc.graphics.endFill();
        mc.addShape(new facilis.Shape(mc.graphics));
    }

    element.getLastSegment=function(){
        for(var i in this.lineMC){
            var seg=this.lineMC[i];
            if(seg.getEndElement()==this.m_endElementMc){
                return seg;
            }
        }
        return null;
    }

    element.updateArrowPos=function() {
        if(this.showForth){
            this.updateForthArrowPos();
        }
        if(this.showBack){
            this.updateBackArrowPos();
        }
    }

    element.updateForthArrowPos=function() {
        var lastVertex = (this.endVertex)?this.endVertex:this.m_startElementMc;
        var ePoint = new facilis.Point(this.m_endElementMc.x, this.m_endElementMc.y  );
        if (!this.parent) {
            return;
        }
        this.m_endElementMc.parent.localToGlobal( ePoint.x,ePoint.y,ePoint  )
        this.parent.globalToLocal( ePoint.x,ePoint.y,ePoint   );
        var sPoint = new facilis.Point(lastVertex.x, lastVertex.y  );
        lastVertex.parent.localToGlobal( sPoint.x,sPoint.y,sPoint  )
        this.parent.globalToLocal(  sPoint.x,sPoint.y,sPoint  );
        var sin=ePoint.x-sPoint.x;
        var cos=ePoint.y-sPoint.y;

        var angle=-(Math.atan2(sin,cos)*(180/Math.PI));
        this.arrowMC.rotation = angle;
        var s = this.getSegmentEnding(this.m_endElementMc);
        var point = s.getEndPoint();
        s.parent.localToGlobal(point.x,point.y,point);
        this.m_endElementMc.parent.globalToLocal(point.x,point.y,point);
        this.x = 0;
        this.y = 0;
        this.arrowMC.x=point.x;
        this.arrowMC.y=point.y;
    }

    element.updateBackArrowPos=function() {
        var firstVertex = (this.startVertex)?this.startVertex:this.m_endElementMc;
        var sPoint = new facilis.Point(this.m_startElementMc.x, this.m_startElementMc.y  );
        if (!this.parent) {
            return;
        }
        this.m_startElementMc.parent.localToGlobal( sPoint.x,sPoint.y,sPoint  )
        this.parent.globalToLocal(  sPoint.x,sPoint.y,sPoint  );
        var ePoint = new facilis.Point(firstVertex.x, firstVertex.y  );
        
        firstVertex.parent.localToGlobal( ePoint.x,ePoint.y,ePoint  )
        this.parent.globalToLocal(  ePoint.x,ePoint.y,ePoint  );
        var sin=sPoint.x-ePoint.x;
        var cos=sPoint.y-ePoint.y;

        var angle=-(Math.atan2(sin,cos)*(180/Math.PI));
        this.arrowBackMC.rotation = angle;
        var s = this.getSegmentStarting(this.m_startElementMc);
        var point = s.getStartPoint();
        s.parent.localToGlobal(point.x,point.y,point);
        this.m_endElementMc.parent.globalToLocal(point.x,point.y,point);
        this.x = 0;
        this.y = 0;
        this.arrowBackMC.x = point.x;
        this.arrowBackMC.y = point.y;
    }

    element.updateInitIconPos=function(){
        var firstVertex = (this.startVertex)?this.startVertex:this.m_endElementMc;
        var sPoint = new facilis.Point(this.m_startElementMc.x, this.m_startElementMc.y  );
        if (!this.parent) {
            return;
        }
        
        sPoint = this.parent.globalToLocal(  this.m_startElementMc.parent.localToGlobal( sPoint  )  );
        var ePoint = new facilis.Point(firstVertex.x, firstVertex.y  );
        ePoint = this.parent.globalToLocal(  firstVertex.parent.localToGlobal( ePoint  )  );
        
        var point = null;
        if(this.m_startElementMc.getIntersectionWidthSegment){
            point=this.m_startElementMc.getIntersectionWidthSegment(sPoint,ePoint);
        }
        
        if(!point){
            var sin=sPoint.x-ePoint.x;
            var cos=sPoint.y-ePoint.y;

            var angle=-(Math.atan2(sin,cos)*(180/Math.PI));
            this.initIcon.rotation = angle;
            var dist = 0;
            point = new facilis.Point((sPoint.x + ( Math.cos((angle - 90) * (Math.PI / 180)) * dist )), ( sPoint.y + ( Math.sin((angle - 90) * (Math.PI / 180)) * dist ) ));
            point = this.m_startElementMc.parent.localToGlobal(point.x,point.y,point);


            while ( this.m_startElementMc.hitTest( point.x , point.y) ) {
                dist += 3;
                point = new facilis.Point((sPoint.x + ( Math.cos((angle - 90) * (Math.PI / 180)) * dist )), ( sPoint.y + ( Math.sin((angle - 90) * (Math.PI / 180)) * dist ) ));
                this.m_startElementMc.parent.localToGlobal(point.x,point.y,point);
            }
        }
        this.m_endElementMc.parent.globalToLocal(point.x,point.y,point);
        this.initIcon.x=point.x;
        this.initIcon.y=point.y;
    }

    element.getMiddlePoint=function() {
        this.x = 0;
        this.y = 0;
        var distance=0;
        for (var i = 0; i < this.lineMC.numChildren;i++ ) {
            var lineLenght = (this.lineMC.getChildAt(i)  ).getLength();
            if(lineLenght){
                distance+=lineLenght;
            }
        }
        var half=distance/2;
        distance = 0;
        var length=half;
        var seg = null;
        if(this.lineVertexs.length==0){
            seg=this.getSegment(this.m_startElementMc,this.m_endElementMc);
        }else {
            var s=this.m_startElementMc;
            var e=this.startVertex;
            while (e) {
                var aux = this.getSegment(s, e);
                if (aux) {
                    seg = aux;
                    lineLenght = seg.getLength();
                    //var className = ((Object(s).constructor) as Class);
                    if ( (distance < half && distance + lineLenght >= half) 
                    
                    /*|| (className + "" == "[class Element]")*/
                    
                    ) {
                        length=half-distance;
                        e=null;
                        break;
                    }else {
                        distance+=lineLenght;
                        s = e;
                        e = (s.getNextElement)?s.getNextElement():null;
                    }
                }else {
                    e = null;
                }
            }
        }
        return seg.getSegmentPoint(length);

    }

    element.getVertexData=function(){
        var data="";
        var e=this.startVertex;
        while(e){
            data+=e.x+";"+e.y;
            e=e.getNextElement();
            if(e!=this.m_endElementMc){
                data+="-";
            }else{
                e=null;
            }
        }
        return data;
    }

    element.setVertexData=function(data) {
        while (this.vertexMC.numChildren > 0) {
            this.removeVertex(this.vertexMC.getChildAt(0));
        }
        if(data!=""){
            var vertexes=data.split("-");
            var x=vertexes[0].split(";")[0];
            var y=vertexes[0].split(";")[1];
            this.addVertex(this.m_startElementMc,this.m_endElementMc,x,y);
            var vert=this.startVertex;
            for(var i=1;i<vertexes.length;i++){
                x=vertexes[i].split(";")[0];
                y=vertexes[i].split(";")[1];
                this.addVertex(vert,this.m_endElementMc,x,y);
                vert=vert.getNextElement();
            }
        }
    }

    element.overrideVertexData=function(data){
        var vertexes=data.split("-");
        for(var i=0;i<vertexes.length;i++){
            var x = vertexes[i].split(";")[0];
            var y = vertexes[i].split(";")[1];
            if(this.lineVertexs[i]){
                this.lineVertexs[i].x = x;
                this.lineVertexs[i].y = y;
            }
        }
        this.refreshWholeLine();
    }

    element.setType=function(t) {
        this.type = t;
        this.m_endElementMc.dispatchEvent(new facilis.Event(facilis.AbstractElement.ELEMENT_MOVED));
    }

    element.conditionChange=function(type) {
        this.initIcon.graphics.clear();
        if (type=="OTHERWISE") {
            this.initIcon.graphics.lineStyle(2, facilis.LineObject.lineColor);
            this.initIcon.graphics.moveTo( -5, -15);
            this.initIcon.graphics.lineTo(5, -5);
        }else if (type == "CONDITION") {
            var st = (this.m_startElementMc);
            if (st.elementType != "gateway") {
                this.initIcon.graphics.beginFill(0xFFFFFF, .9);
                this.initIcon.graphics.lineStyle(1, facilis.LineObject.lineColor);
                this.initIcon.graphics.moveTo( -7, -10);
                this.initIcon.graphics.lineTo(0, -15);
                this.initIcon.graphics.lineTo(7, -10);
                this.initIcon.graphics.lineTo(0, -5);
                this.initIcon.graphics.lineTo( -7, -10);
                this.initIcon.graphics.endFill();
            }
        }
    }

    element.setCircle=function() {
        this.initIcon.graphics.beginFill(0xFFFFFF, .9);
        this.initIcon.graphics.lineStyle(1, facilis.LineObject.lineColor);
        this.initIcon.graphics.drawCircle(0, -5, -5);
        this.initIcon.graphics.endFill();
    }

    element.setData=function(d) {
        this.data = d;
    }

    element.getData=function() {
        if (!this.data && this.elementType) {
            this.data = (facilis.ElementAttributeController.getInstance().getElementAttributes( this.elementType )).cloneNode(true);
            this.data.attributes.id = this.id;
        }
        this.getExtremeIds();
        this.getVertexs();
        return this.data;
    }

    element.resetId=function()  {
        this.elementId = View.getInstance().getUniqueId();
        this.getData().attributes.id = this.id;
        this.getExtremeIds();
    }

    element.getExtremeIds=function() {
        if ((this.m_startElementMc).elementType=="sflow") {
            this.data.setAttribute("startid", ((this.m_startElementMc).parent).getData().attributes.id);
        }else {
            this.data.setAttribute("startid", (this.m_startElementMc).getData().attributes.id);
        }
        if ((this.m_endElementMc).elementType=="sflow") {
            this.data.setAttribute("endid", ((this.m_endElementMc).parent).getData().attributes.id);
        }else{
            this.data.setAttribute("endid" , (this.m_endElementMc).getData().attributes.id);
        }
    }

    element.getVertexs=function() {
        var vertexs = this.data.ownerDocument.createElement("vertex");
        for (var i = 0; i < this.data.children.length; i++ ) {
            if (this.data.children[i].nodeName=="vertex") {
                (this.data.children[i]).parentNode.removeChild(this.data.children[i]);
            }
        }
        
		this.data.appendChild(vertexs);

        var start = this.data.ownerDocument.createElement("Coordinates");
        start.setAttribute("XCoordinate" , this.m_startElementMc.x);
        start.setAttribute("YCoordinate" , this.m_startElementMc.y);
        vertexs.appendChild(start);

        /*for (i = 0; i < lineVertexs.length;i++ ) {
            var coordinate = new XMLNode(1, "Coordinates");
            coordinate.attributes.XCoordinate = lineVertexs[i].x;
            coordinate.attributes.YCoordinate = lineVertexs[i].y;
            vertexs.appendChild(coordinate);
        }*/
        var el = this.m_startElementMc;
        var seg = this.getSegmentStartingIn(el);
        if (seg) {
            el = seg.getEndElement();
            seg = this.getSegmentStartingIn(el);
            while (el != this.m_endElementMc && seg) {
                var coordinate = this.data.ownerDocument.createElement("Coordinates");
                coordinate.setAttribute("XCoordinate" , el.x);
                coordinate.setAttribute("YCoordinate" , el.y);
                vertexs.appendChild(coordinate);
                el = seg.getEndElement();
                seg = this.getSegmentStartingIn(el);
            }
        }



        var end = this.data.ownerDocument.createElement("Coordinates");
        end.setAttribute("XCoordinate" , this.m_endElementMc.x);
        end.setAttribute("YCoordinate" , this.m_endElementMc.y);
        vertexs.appendChild(end);
    }

    element.getSegmentStartingIn=function(el) {
        for (var i = 0; i < this.lineMC.numChildren; i++ ) {
            try {
                if ((this.lineMC.getChildAt(i) ).getStartElement() == el) {
                    return (this.lineMC.getChildAt(i) );
                }
            }catch (e) {
            }
        }
        return null;
    }

    element.getStartElement=function() {
        return this.m_startElementMc;
    }

    element.getEndElement=function() {
        return this.m_endElementMc;
    }

    element.setName=function(name) {
        this.txtName.text = name;
        this.alignText();
    }

    element.alignText=function() {
		this.txtName.textAlign="center";
        this.txtName.width = 180;
        this.txtName.parent.setChildIndex(this.txtName, this.txtName.parent.numChildren - 1);
        var p = this.getMiddlePoint();
        this.txtName.y = p.y;
        var lineWidth = 180;
        var i = 0;
        while (i < this.txtName.numLines) {
            /*if (lineWidth < ((txtName.getLineMetrics(i) as TextLineMetrics).width + 5)) {
                lineWidth = (txtName.getLineMetrics(i) as TextLineMetrics).width + 5;
            }
            if (lineWidth < 100 && (txtName.getLineMetrics(i) as TextLineMetrics).width < 100) {
                lineWidth += (txtName.getLineMetrics(i) as TextLineMetrics).width + 5;
            }*/
            i++;
        }
        lineWidth = (lineWidth > 180)?180:lineWidth;
        this.txtName.width = lineWidth;
        this.txtName.x = p.x //- (lineWidth / 2);
    }

    element.setBackArrow=function(to) {
        showBack = to;
        setArrow();
    }

    element.setForthArrow=function(to) {
        showForth = to;
        setArrow();
    }


    element.callStartEndFunctions=function(action) {
        
        if(!action)
            action="add";
        
        try {
            if ((this.m_startElementMc).elementType=="gateway") {
                (this.m_startElementMc).getElement().updateExecution(action);
                (this.m_startElementMc).getElement().setReadonlyExpression(action);
            }
        }catch (e) { }
        try {
            if ((this.m_startElementMc).elementType == "startevent") {
                (this.m_startElementMc).getElement().setFirstTaskType("");
            }
        }catch (e) { }
        try {
            if ( (this.m_startElementMc).elementType == "startevent" || (this.m_startElementMc).elementType == "middleevent") {
                (this.m_startElementMc).getElement().setReadonlyNone();
            }
        }catch (e) { }
        /*try {
            if ( ((this.m_startElementMc).elementType == "middleevent") ) {
                (this.m_startElementMc).getElement().disableLineConditions();
            }
        }catch (e) { }*/
        try {
            if ( ((this.m_endElementMc).elementType == "middleevent") ) {
                (this.m_endElementMc).getElement().disableInLineConditions();
            }
        }catch (e) { }
        try {
            if ( /*((this.m_startElementMc).elementType == "middleevent")|| */ ((this.m_endElementMc).elementType == "middleevent") ) {
                var el = (((this.m_startElementMc).elementType == "middleevent")?this.m_startElementMc:this.m_endElementMc);
                if(this.elementType=="sflow" && (el.getContainer().elementType=="task" || el.getContainer().elementType=="csubflow")){
                    el.setContainer(null);
                }
            }
        }catch (e) { }
        try {
            if (this.elementType == "association") {
                var startType = (this.m_startElementMc).elementType;
                var endType = (this.m_endElementMc).elementType;
                if (startType == "textannotation" || endType == "textannotation"){ 
                    this.disableDirection();
                }else if( startType=="dataobject" || endType=="dataobject" ){
                    if (!( startType == "task" || startType == "csubflow" || endType == "task" || endType == "csubflow" ) ) { 
                        this.disableDirection();
                    }
                }
            }
			
			
			if (startType == "datainput" || endType == "dataoutput") {
				var attributes = this.getData().children[0].children;
				for (var i = 0; i < attributes.length; i++ ) {
					if (attributes[i].getAttribute("name") ==  "direction") {
						attributes[i].setAttribute("value", "From");
						attributes[i].setAttribute("type", "text");
						attributes[i].setAttribute("readonly", "true");
						break;
					}
				}
				this.setDirection("from");
			}
			
        }catch (e) { }
    }
    
    element.setDirection=function(to) {
        showForth = false;
        showBack = false;
        to = to.toLowerCase();
        if (to == "both" || to == "to") {
            showBack = true;
        }
        if (to == "both" || to == "from" || to == "one") {
            showForth = true;
        }
        setArrow();
        this.refreshWholeLine();
    }

    element.appear=function() {
        //this.alpha = 1;
        //Tweener.addTween(this, { alpha:1, time:.1, transition:"easeOutInBounce",onComplete:refreshWholeLine} );
    }

    

    element.setApiaType=function(type) {
        this.lineMC.alpha = 1;
        doubleArrow = false;
        this.setType("");
        if(type=="Wizard"){
            doubleArrow = true;
        }else if(type=="Loopback"){
            this.lineMC.alpha = .5;
            this.setType("dashdotted");
        }
        this.refreshWholeLine();
    }

    element.disableDirection=function() {
        var data = this.getData();
        if (data) {
            data = data.firstChild;
            for (var i = 0; i < data.children.length; i++ ) {
                if (data.children[i].attributes.name=="direction") {
                    data.children[i].attributes.type = "text";
                    data.children[i].attributes.readonly = "true";
                    data.children[i].attributes.value = "None";
                }
            }
        }
    }

    element.getLineX=function() {
        var lx = (this.m_startElementMc.x < this.m_endElementMc.x)?this.m_startElementMc.x:this.m_endElementMc.x;
        for (var i = 0; i < this.vertexMC.numChildren;i++ ) {
            if (lx > this.vertexMC.getChildAt(i).x) {
                lx = this.vertexMC.getChildAt(i).x;
            }
        }
        return lx;
    }

    element.getLineY=function() {
        var ly = (this.m_startElementMc.y < this.m_endElementMc.y)?this.m_startElementMc.y:this.m_endElementMc.y;
        for (var i = 0; i < this.vertexMC.numChildren;i++ ) {
            if (ly > this.vertexMC.getChildAt(i).y) {
                ly = this.vertexMC.getChildAt(i).y;
            }
        }
        return ly;
    }

    element.getLineWidth=function() {
        var w = this.lineMC.width+(this.m_startElementMc.width/2)+(this.m_endElementMc.width/2);
        return w;
    }

    element.getLineHeight=function() {
        var h=this.lineMC.height+(this.m_startElementMc.height/2)+(this.m_endElementMc.height/2);
        return h;
    }

    element.updateLineCorners=function() {
        if(!this.lineCornersMC.graphics)
            this.lineCornersMC.graphics=new facilis.Graphics();
        
        if(this.lineCornersMC){
            this.lineCornersMC.graphics.clear();
            this.lineCornersMC.removeAllChildren();
            this.lineCornersMC.graphics.lineStyle(LineObject.lineWidth,LineObject.lineColor);
        }
        //for (var i = 0; i < this.lineMC.numChildren; i++ ) {
        var e=this.startVertex;
        while(e && e!=this.m_endElementMc){
            //e = e.getNextElement();
            var seg1 = this.getSegmentEnding(e);
            var next = e.getNextElement();
            var seg2=this.getSegmentStarting(e);
            var sp = seg1.getEndPoint();
            //lineCornersMC.graphics.moveTo(sp.x, sp.y);
            var ep = seg2.getStartPoint();
            //lineCornersMC.graphics.lineTo(ep.x, ep.y);
            //lineCornersMC.graphics.curveTo(e.x, e.y,ep.x, ep.y);
            this.drawCorner(sp.x, sp.y, ep.x, ep.y, e.x, e.y)
            e = next;
        }
    }

    element.drawCorner=function(startx, starty, controlX, controlY,endx, endy) {
            if(this.type=="dashed"){
                facilis.LineUtils.dashCurveTo(this.lineCornersMC, startx, starty, endx, endy,controlX,controlY,3,4);
            }else if (this.type == "dotted") {
                facilis.LineUtils.dashCurveTo(this.lineCornersMC, startx, starty, endx, endy,controlX,controlY,1,4);
            }else if (this.type == "dashdotted") {
                facilis.LineUtils.dashCurveTo(this.lineCornersMC, startx, starty, endx, endy,controlX,controlY,3,4);
            }else {
                this.lineCornersMC.graphics.moveTo(startx,starty);
                this.lineCornersMC.graphics.curveTo(endx, endy,controlX, controlY);
                this.lineCornersMC.addShape(new facilis.Shape(this.lineCornersMC.graphics));
            }
    }

    element.getSegmentStarting=function(startEl){
        var seg = null;
        for (var i = 0; i < this.lineMC.numChildren; i++ ) {
            seg = this.lineMC.getChildAt(i) ;
            if(seg.getStartElement()==startEl){
                return seg;
            }
        }
        return seg;
    }

    element.getSegmentEnding=function(endEl){
        var seg = null;
        for (var i = 0; i < this.lineMC.numChildren; i++ ) {
            seg = this.lineMC.getChildAt(i) ;
            if(seg.getEndElement()==endEl){
                return seg;
            }
        }
        return seg;
    }

    element.onLineOver=function(e) {
        this.vertexMC.alpha = 1;
    }

    element.onLineOut=function(e) {
        this.vertexMC.alpha = 0;
    }
    
    //////getters setters

    Object.defineProperty(element, 'elementId', {
        get: function() { 
            if (!this._elementId) {
                //this._elementId = View.getInstance().getUniqueId();
            }
            return this._elementId;
        },
        set: function(val){
            this._elementId=val;
        }
    });
    
    Object.defineProperty(element, 'lastElement', {
        get: function() { 
            return this.m_endElementMc;
        }
    });
    
    Object.defineProperty(element, 'startElement', {
        get: function() { 
            return this.m_startElementMc;
        }
    });
    
    Object.defineProperty(element, 'middle', {
        get: function() { 
            if (!this.middlePoint) {
                this.middlePoint = new facilis.AbstractElement();
                this.middlePoint.elementType = this.elementType;
                this.addChild(this.middlePoint);
                /*middlePoint.graphics.beginFill(0x000000, 0);
                middlePoint.graphics.drawCircle(0, 0, 2);
                middlePoint.graphics.endFill();*/
            }
            var p = this.getMiddlePoint();
            this.middlePoint.x = p.x;
            this.middlePoint.y = p.y;
            return this.middlePoint;
        }
    });
    
    Object.defineProperty(element, 'doubleArrow', {
        set: function(val) { 
            this._doubleArrow = val;
        }
    });
    
    
    
    
    facilis.LineObject = facilis.promote(LineObject, "AbstractElement");
    
}());

(function() {

    function LineSegment(s, e) {
        if(!s && !e)
            throw Error("Start and End elements can not be null");
        
        this.BaseElement_constructor();
        
        this.startPoint=s;
		this.endPoint=e;
		
        this.lineStyle="";
		this.lineWidth=facilis.LineObject.lineWidth;
		this.lineColor=facilis.LineObject.lineColor;
		
		this.thinLine=null;
		this.backLine=null;
		
		this.type = "";
		
		this.segmentStartX = 0;
		this.segmentStartY = 0;
		
		this.segmentEndX = 0;
		this.segmentEndY = 0;
        
        this._accThreshold=6;
        
        this.segPoint=null;
		
        this.setup();
    }
    
    var element = facilis.extend(LineSegment, facilis.BaseElement);

    element.setup = function() {
    };
    
    
    
    element.updateSegment=function(_acc) {
            _acc=_acc||true;
			var point1 = new facilis.Point(this.startPoint.x, this.startPoint.y);
			var point2 = new facilis.Point(this.endPoint.x, this.endPoint.y);
			if(this.startPoint.parent && this.endPoint.parent){
                this.startPoint.parent.localToGlobal(point1.x,point1.y,point1)
                this.endPoint.parent.localToGlobal(point2.x,point2.y,point2);
                
                var epoint = null;
				var spoint = null;
                
                if(this.startPoint.getIntersectionWidthSegment){
                    spoint=this.startPoint.getIntersectionWidthSegment(point1,point2);
                }
                
                if(this.endPoint.getIntersectionWidthSegment){
                    epoint=this.endPoint.getIntersectionWidthSegment(point1,point2);
                }
                
                
				this.parent.globalToLocal(point2.x,point2.y,point2);
				this.parent.globalToLocal(point1.x,point1.y,point1);
                
                var x1=point1.x;
				var y1=point1.y;
				var x2=point2.x;
				var y2 = point2.y;
				
				var sin=x1-x2;
				var cos=y1-y2;

				var angle=-(Math.atan2(sin,cos)*(180/Math.PI));
				var dist = 0;
				
				if(!epoint){
                    epoint = new facilis.Point(x2, y2);
                    this.endPoint.parent.localToGlobal(epoint.x,epoint.y,epoint);
                    while (( this.endPoint.x && this.endPoint.y && this.endPoint.LocalhitTest( epoint.x , epoint.y) && _acc )|| (!_acc && dist==0) ) {
                        dist-=this._accThreshold;
                        epoint = new facilis.Point((x2 + ( Math.cos((angle - 90) * (Math.PI / 180)) * dist )), ( y2 + ( Math.sin((angle - 90) * (Math.PI / 180)) * dist ) ));
                        this.endPoint.parent.localToGlobal(epoint.x,epoint.y,epoint);
                    }
                }
				
                if(!spoint){
                    dist = 0;
                    spoint = new facilis.Point(x1, y1);
                    this.startPoint.parent.localToGlobal(spoint.x,spoint.y,spoint);
                    while (( this.startPoint.x && this.startPoint.y && this.startPoint.LocalhitTest( spoint.x , spoint.y) && _acc) || (!_acc && dist==0)) {
                        dist +=this._accThreshold;
                        spoint = new facilis.Point((x1 + ( Math.cos((angle - 90) * (Math.PI / 180)) * dist )), ( y1 + ( Math.sin((angle - 90) * (Math.PI / 180)) * dist ) ));
                        this.startPoint.parent.localToGlobal(spoint.x,spoint.y,spoint);
                    }
                }
                
				this.endPoint.parent.globalToLocal(epoint.x,epoint.y,epoint);
				this.startPoint.parent.globalToLocal(spoint.x,spoint.y,spoint);
				
				this.segmentStartX = spoint.x;
				this.segmentStartY = spoint.y;
				this.segmentEndX = epoint.x;
				this.segmentEndY = epoint.y;
				
				this.drawLineFromTo(this.thinLine,spoint.x,spoint.y,epoint.x,epoint.y);
			}
			
		}
		
		element.getStartElement=function(){
			return this.startPoint;
		}
		element.getEndElement=function(){
			return this.endPoint;
		}
		element.setStartElement=function(point){
			this.startPoint=point;
		}
		element.setEndElement=function(point){
			this.endPoint=point;
		}
		
		element.setType=function(t){
			this.type=t;
		}
		
		element.drawLineFromTo=function(mc, startx, starty , endx, endy) {
			if (this.backLine ==null) {
                this.backLine = new facilis.BaseElement();
                this.addChild(this.backLine);
                this.backLine.graphics = new facilis.Graphics();
			}
            this.backLine.graphics.clear();
            this.backLine.removeAllChildren();
			
			if (this.thinLine ==null) {
                this.thinLine = new facilis.BaseElement();
                this.addChild(this.thinLine);
                this.thinLine.graphics = new facilis.Graphics();
			}
            this.thinLine.graphics.clear();
            this.thinLine.removeAllChildren();

			//thinLine.graphics.lineStyle(lineWidth,lineColor,60,false);
            
            
            this.thinLine.graphics.lineStyle(this.lineWidth,this.lineColor);
            this.thinLine.addShape(new facilis.Shape(this.thinLine.graphics));
            
            this.backLine.graphics.lineStyle(15,"rgba(100,100,100,.01)");
            this.backLine.addShape(new facilis.Shape(this.backLine.graphics));
            
			//graphics.lineStyle(lineWidth, lineColor, 1, false);
			//backLine.graphics.lineStyle(15, lineColor, 0, false);
            
			if(this.type=="dashed"){
				facilis.LineUtils.dashTo(this.thinLine, startx, starty, endx, endy, 5, 7);
				facilis.LineUtils.dashTo(this.backLine, startx, starty, endx, endy, 5, 5);
			}else if (this.type == "dotted") {
				facilis.LineUtils.dashTo(this.thinLine,startx, starty, endx, endy, 1, 4);
				facilis.LineUtils.dashTo(this.backLine, startx, starty, endx, endy, 5, 5);
			}else if (this.type == "dashdotted") {
				facilis.LineUtils.dashDotTo(this.thinLine, startx, starty, endx, endy, 5, 7);
				facilis.LineUtils.dashTo(this.backLine, startx, starty, endx, endy, 5, 5);
			}else {
				this.thinLine.graphics.moveTo(startx,starty);
				this.thinLine.graphics.lineTo(endx,endy);
				this.backLine.graphics.moveTo(startx,starty);
				this.backLine.graphics.lineTo(endx, endy);
				
				//thinLine.graphics.drawRect(50, 50, 100, 500);
				
			}
		}
        
        element.uncacheSegment=function(){
            this.uncache();
        }

        element.cacheSegment=function(){
            var x=Math.min(this.segmentStartX,this.segmentEndX);
            var y=Math.min(this.segmentStartY,this.segmentEndY);
            
            var w=Math.abs(this.segmentStartX - this.segmentEndX);
            var h=Math.abs(this.segmentStartY - this.segmentEndY);
            this.uncache(x,y,w,h);
        }
		
		element.remove=function(){
			this.parent.removeChild(this);
		}
		
		element.getLength=function(){
			return Math.sqrt( Math.pow(this.segmentEndX-this.segmentStartX, 2) + Math.pow(this.segmentEndY-this.segmentStartY, 2) );
		}
		
		
		
		element.getSegmentPoint=function(length) {
			if (this.segPoint) {
				this.segPoint.parent.removeChild(this.segPoint);
				this.segPoint = null;
			}
			var xLength=this.segmentEndX-this.segmentStartX;
			var yLength=this.segmentEndY-this.segmentStartY;
			var cotang=Math.atan2(yLength,xLength);
			
			var minX = this.segmentStartX;
			var minY = this.segmentStartY;
			
			var point = new facilis.Point((Math.cos(cotang) * length) + minX, (Math.sin(cotang) * length) + minY);
			return point;
		}
		
		
		element.getIntersection=function(at,to) {
			var point1 = new facilis.Point(at.x, at.y);
			var point2 = new facilis.Point(to.x, to.y);

			point1 = this.parent.globalToLocal(at.parent.localToGlobal(point1));
			point2 = this.parent.globalToLocal(to.parent.localToGlobal(point2));
			
			var x1 = point1.x;
			var y1 = point1.y;
			var x2 = point2.x;
			var y2 = point2.y;
			
			//var sin = x1 - x2;
			//var cos = y1 - y2;
			var sin = x2 - x1;
			var cos = y2 - y1;

			var angle = -(Math.atan2(sin, cos) * (180 / Math.PI));
			
			var dist = Math.sqrt( Math.pow(sin, 2) + Math.pow(cos, 2) );
			var aprox = dist;
			
			var spoint = new facilis.Point(x1, y1);
			spoint = startPoint.parent.localToGlobal(spoint);
			var count = 0;
			//while (  (spoint.x>(at.x-at.width)) &&  (spoint.x<(at.x+at.width)) && (spoint.y>(at.y-at.height)) &&  (spoint.y<(at.y+at.height)) && count<10) {
			while (  !(spoint.x>(at.x-at.width)) &&  !(spoint.x<(at.x+at.width)) && !(spoint.y>(at.y-at.height)) &&  !(spoint.y<(at.y+at.height)) && count<10) {
				count++;
				aprox = aprox / 2;
				var pointLess = new facilis.Point((x2 + ( Math.cos((angle - 90) * (Math.PI / 180)) * (dist - aprox) )), ( y2 + ( Math.sin((angle - 90) * (Math.PI / 180)) * (dist - aprox) ) ));
				var pointMore = new facilis.Point((x2 + ( Math.cos((angle - 90) * (Math.PI / 180)) * (dist + aprox) )), ( y2 + ( Math.sin((angle - 90) * (Math.PI / 180)) * (dist + aprox) ) ));
				
				pointLess = endPoint.parent.localToGlobal(pointLess);
				pointMore = endPoint.parent.localToGlobal(pointMore);
				//pointLess = this.parent.globalToLocal(at.parent.localToGlobal(pointLess));
				//pointMore = this.parent.globalToLocal(at.parent.localToGlobal(pointMore));
				
				if (  (pointLess.x > (at.x - at.width)) &&  (pointLess.x < (at.x + at.width)) && (pointLess.y > (at.y - at.height)) &&  (pointLess.y < (at.y + at.height)) && aprox > 5 ) {
					dist += aprox;
					spoint = pointMore;
				}else {
					dist -= aprox;
					spoint = pointLess;
				}
				//trace(count+" "+dist+" "+aprox);
			}
			
			/*while (!at.hitTestPoint( spoint.x , spoint.y, true) ) {
				dist-=this._accThreshold;
				spoint = new Point((x2 + ( Math.cos((angle - 90) * (Math.PI / 180)) * dist - aprox )), ( y2 + ( Math.sin((angle - 90) * (Math.PI / 180)) * dist ) ));
			}*/
			
			
			spoint = this.globalToLocal(spoint);
				
			return spoint;
		}

		element.getStartPoint=function() {
			return new facilis.Point(this.segmentStartX, this.segmentStartY);
		}
		
		element.getEndPoint=function() {
			return new facilis.Point(this.segmentEndX, this.segmentEndY);
		}
		
    

    
    facilis.LineSegment = facilis.promote(LineSegment, "BaseElement");
    
}());

(function() {

    function LineVertex() {
        this.BaseElement_constructor();
        
        this.lastElement=new facilis.BaseElement();
		this.nextElement=new facilis.BaseElement();
		
		this.lastClick=0;
		
		this.__allowMoving = false;
		this.__wasMoving = false;
		this.mouseListener={};

        this.cacheThreshold=20;
        
        this.vertex_size=24;
        
        this.vertex;
        
        this.setup();
    }
    
    LineVertex.CLICK					 = "onVertexClick";
    LineVertex.MOVED					 = "onVertexMoved";
    LineVertex.DROP						 = "onVertexDrop";
    LineVertex.START_MOVE				 = "onVertexStartMove";
    LineVertex.CLICKED					 = "onVertexClicked";
    LineVertex.DOUBLE_CLICKED			 = "onVertexDoubleClicked";
    LineVertex.OVER						 = "onVertexRollOver";
    LineVertex.OUT						 = "onVertexRollOut";
    LineVertex.DELETED					 = "onVertexDeleted";
    
    
    var element = facilis.extend(LineVertex, facilis.Drag);
    
    /*
        element.BaseClassSetup=element.setup;
    */
    
    element.DragSetup=element.setup;
    element.setup = function() {
        this.DragSetup();
        
        this.vertex=new facilis.BaseElement();
        this.addChild(this.vertex);
        
        this.vertex.graphics = new facilis.Graphics();
        this.vertex.graphics.beginFill("rgba(230,230,230,0.1)");//beginFill("#EEEEEE",.1);			
        this.vertex.graphics.drawCircle(this.vertex_size,this.vertex_size, this.vertex_size);
        this.vertex.graphics.endFill();
        this.vertex.graphics.lineStyle(1,"#000000");
        this.vertex.graphics.beginFill("#999999");			
        this.vertex.graphics.drawCircle( this.vertex_size, this.vertex_size, this.vertex_size/8);
        this.vertex.graphics.endFill();
        this.vertex.addShape(new facilis.Shape(this.vertex.graphics));
        
        this.addEventListener(facilis.Drag.DRAG_EVENT, this.onVertexMove.bind(this));
        this.addEventListener(facilis.Drag.STOP_EVENT, this.onRelease.bind(this));
        this.addEventListener(facilis.AbstractElement.ELEMENT_OVER, this.onRollOver.bind(this));
        this.addEventListener(facilis.AbstractElement.ELEMENT_OUT, this.onRollOut.bind(this));
        this.addEventListener(facilis.AbstractElement.ELEMENT_CLICKED, this.onClick.bind(this));
        this.addEventListener(facilis.AbstractElement.ELEMENT_DOUBLE_CLICKED, this.onDoubleClick.bind(this));
        //this.setCached(true);
        this.vertex.x=-this.vertex_size;
        this.vertex.y=-this.vertex_size;
        
        //this.vertex.cache(-this.cacheThreshold-this.vertex_size,-this.cacheThreshold-this.vertex_size,this.cacheThreshold+this.vertex_size,this.cacheThreshold+this.vertex_size);
        this.vertex.cache(-this.cacheThreshold,-this.cacheThreshold,this.cacheThreshold+this.vertex_size+50,this.cacheThreshold+this.vertex_size+50);
        this.tickChildren=false;
    };
    
    element.onRelease=function(evt) {
        this.dispatchEvent(new facilis.Event(facilis.LineVertex.MOVED));
        this.removeEventListener(facilis.Drag.DRAG_EVENT, this.onVertexMove);
        if (this.__wasMoving) {
            this.__wasMoving = false;
            this.dispatchEvent(new facilis.Event(facilis.LineVertex.DROP));
        }
        this.__allowMoving = false;
        
    }
    
    element.onDoubleClick=function(evt){
        this.dispatchEvent(new facilis.Event(facilis.LineVertex.DOUBLE_CLICKED));
    }
    
    element.onClick=function(evt){
        this.dispatchEvent(new facilis.Event(facilis.LineVertex.CLICKED));
    }

    element.onVertexMove=function(evt) {
        /*var xmouse = 0; var ymouse = 0;
        var p:Point = new Point(xmouse,ymouse);
        parent.globalToLocal(p);
        this.x =  Math.round(p.x);
        this.y =  Math.round(p.y);*/
        if (!this.__wasMoving) {
            this.dispatchEvent(new facilis.Event(facilis.LineVertex.START_MOVE));
            this.__wasMoving = true;
        }
        this.__allowMoving = true;
        this.dispatchEvent(new facilis.Event(facilis.LineVertex.MOVED));
        //evt.updateAfterEvent();
    }

    element.onRollOver=function(evt){
        var pos =new facilis.Point();
        pos.x=evt.stageX;
        pos.y=evt.stageY;
        //_parent.globalToLocal(pos);
        /*mouseListener=new Object();
        var tmp=this; 
        stage.addEventListener(.onMouseMove=function(evt){
            var pos:Point = new Point( evt.stageX ,evt.stageY );
            tmp.dispatchEvent(new facilis.Event("onVertexRollOver"));
        }

        Mouse.addListener(mouseListener);*/
        /*this.graphics.clear();
        this.graphics.lineStyle(1, 0x000000); 
        this.graphics.beginFill(0x999999, .6);  
        this.graphics.drawCircle(0, 0, 9);
        this.graphics.endFill(); */

        this.dispatchEvent(new facilis.Event(facilis.LineVertex.OVER));
        /*var fGlow:GlowFilter = new GlowFilter(0x7aff43,.5,2,2,5,3,false,false);
        this.filters=[fGlow];*/
    }

    element.onRollOut=function(evt) {
        /*this.graphics.clear();
        this.graphics.lineStyle(0, 0x000000,0); 
        this.graphics.beginFill(0x999999, 0); 
        this.graphics.drawCircle(0, 0, 6);
        this.graphics.endFill(); 
        this.graphics.lineStyle(1, 0x000000); 
        this.graphics.beginFill(0x999999, 1); 
        this.graphics.drawCircle(0, 0, 4);
        this.graphics.endFill(); */
        //this.filters=[];
        //Mouse.removeListener(mouseListener);
        this.dispatchEvent(new facilis.Event(facilis.LineVertex.OUT));
    }

    element.remove=function(){
        this.dispatchEvent(new facilis.Event(facilis.LineVertex.DELETED));
        this.removeAllEventListeners();
        //this.parent.removeChild(this);
        this.removeMe();
    }

    element.setLastElement=function(el){
        this.lastElement=el;
    }

    element.setNextElement=function(el){
        this.nextElement=el;
    }

    element.getLastElement=function(){
        return this.lastElement;
    }

    element.getNextElement=function(){
        return this.nextElement;
    }
    
    element.getIntersectionWidthSegment=function(start,end){
       
        var p=new facilis.Point(this.x,this.y);
        var size=5;
        
        //this.localToGlobal(0,0,p);
        
        var numberOfSides = 5;
        var Xcenter = p.x;
        var Ycenter = p.y;

        var p1=new facilis.Point(Xcenter +  size * Math.cos(0), Ycenter +  size *  Math.sin(0));
        var p2;
        var lines=[];
        for (var i = 1; i <= numberOfSides;i += 1) {
            p2=new facilis.Point(Xcenter + size * Math.cos(i * 2 * Math.PI / numberOfSides), Ycenter + size * Math.sin(i * 2 * Math.PI / numberOfSides));
            if(this.FindPointofIntersection(start,end,p1,p2)) {
             //console.log("not failed linevertex intersection segment");
                return this.FindPointofIntersection(start,end,p1,p2);
            }
            
            p1=p2;
        }
        
        //if(ret){
        //    this.localToGlobal(ret.x,ret.y,ret);
        //}else{
            //console.log("failed linevertex intersection segment");
        //}
        
        return null;
        
        
    }
    


    facilis.LineVertex = facilis.promote(LineVertex, "Drag");
    
}());

(function() {

    function AbstractResourceController() {
        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(AbstractResourceController, {});

    
    element.setup = function() {
        this.resources = {};//new HashMap();
        facilis.View.getInstance().addEventListener(facilis.View.ON_CLEAR, this.toClear.bind(this));
    };
    
    element.resourceId = 0;
		
    element.resources;


    element.addResource=function(res, id) {
        if(id==null){
            id = this.resourceId;
        }else {
            if (id > this.resourceId) {
                this.resourceId = id;
            }
        }
        res.setAttribute("resourceId",id);
        this.resourceId++;
        this.resources[id]=res;
        return res;
    }

    element.removeResource=function(id) {
        return this.resources[id]=null;
    }

    element.getResource=function(id) {
        return this.resources[id];
    }

    element.getResources=function() {
        var res=[];
        for(var i in this.resources)
            res.push(this.resources[i]);
            
        return res;
    }

    element.toClear=function(e) {
        this.resources = {};
    }


    facilis.controller.AbstractResourceController = facilis.promote(AbstractResourceController, "Object");
    
}());

(function() {

    function FormResources() {
        this.AbstractResourceController_constructor();
        
        if (!FormResources.allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }
        
        this.frmIdMap={};
		this.filteredResources=[];
        this.modified = false;

    }
    
    FormResources._instance=null;
    FormResources.allowInstantiation=false;
    FormResources.getInstance=function(){
        if (FormResources._instance == null) {
            FormResources.allowInstantiation = true;
            FormResources._instance = new facilis.controller.FormResources();
            FormResources.allowInstantiation = false;
        }
        return FormResources._instance;
    }
    
    
    var element = facilis.extend(FormResources, facilis.controller.AbstractResourceController);
    
    element.baseAddResource=element.addResource;
    element.addResource=function(res, id) {
        var res = this.baseAddResource(res, id);

        modified = true;

        return res;
    }


    element.checkExists=function(name) {
        var frms = this.getResources();
        for (var i = 0; i < frms.length; i++ ) {
            var form = frms[i];
            if (name==form.children[1].getAttribute("value")) {
                return true;
            }
        }
        return false;
    }

    element.getExistingId=function(name) {
        var frms = this.getResources();
        for (var i = 0; i < frms.length; i++ ) {
            var form = frms[i];
            if (name == form.children[1].getAttribute("value")) {					
                //return form.children[1].getAttribute("resourceId");
                return i;
            }
        }
        return 0;
    }		

    element.getFilteredResources=function() {

        if (this.frmIdMap == null || modified) {

            this.frmIdMap =  {};
            modified = false;

            var toErase = new Array();
            var frms = this.resources.getValues();

            for (var i = 0; i < frms.length; i++ ) {

                var xml_length = frms[i].toString().length;
                var node  = frms[i].children[0];
                var frmId = node.attributes["value"];
                var frmName =  frms[i].children[1].attributes["value"];				

                //Buscar desde i+1 los formularios que tienen el mismo node.frmName
                for (var j = i + 1; j < frms.length; j++) {
                    var nodeAux = frms[j].children[0];					
                    if (frms[j].children[1].attributes["value"] == frmName) {						
                        if(frms[j].toString().length <= frms[i].toString().length) {
                            //Encontre un repetido de menor tamaño
                            toErase.push(j);
                            this.frmIdMap[nodeAux.attributes["value"]] = frmId;
                        } else {
                            //Tengo que borrar el original
                            if (toErase.indexOf(i) < 0) {
                                toErase.push(i);
                                this.frmIdMap[frmId] = nodeAux.attributes["value"];
                            }
                        }
                    }
                }
            }				

            var toErase2 = new Array();
            for (i = 0; i < toErase.length; i++ ) {
                if (toErase2.length == 0) {
                    toErase2.push(toErase[i]);
                } else {
                    var dont_add = false;
                    for (j = 0; j < toErase2.length; j++) {
                        if (toErase[i] < toErase2[j])
                            break;
                        if (toErase[i] == toErase2[j]) {
                            dont_add = true;
                            break;
                        }
                    }
                    if (dont_add)
                        continue;
                    if (j == toErase2.length) {
                        toErase2.push(toErase[i]);
                    } else {
                        //Mover elementos para adelante
                        toErase2.splice(j, 0, toErase[i]);
                    }
                }
            }				
            toErase2.reverse();

            for (i = 0; i < toErase2.length; i++ ) {
                if(frms.length > toErase2[i]) {
                    frms.splice(toErase2[i], 1);
                    //FormResources.getInstance().removeResource(toErase2[i]);
                }
            }

            filteredResources = frms;
        }

        //return resources.getValues();
        return filteredResources;
    }

    element.translateFrmId=function(frmId_origin) {

        //Forzamos la carga de this.frmIdMap
        FormResources.getInstance().getFilteredResources();

        var frmId_aux = frmId_origin;
        while (this.frmIdMap[frmId_aux]  != undefined) {
            frmId_aux = this.frmIdMap[frmId_aux];
        }

        return frmId_aux;
    }

	element.baseRemoveResource=element.removeResource;
	element.removeResource=function(id) {
		this.modified = true;
		return this.baseRemoveResource(id);
	}

    facilis.controller.FormResources = facilis.promote(FormResources, "AbstractResourceController");
    
}());

(function() {

    function LabelManager() {
        
        if (LabelManager.allowInstantiation) {
            facilis.EventDispatcher.initialize(this);
            this._labelsSets={};
            this._defaultSet="default";

        }else{
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }
        
    }
    

    
    LabelManager.allowInstantiation=false;
    LabelManager._instance=null;
    LabelManager.LABELS_LOADED = "onLabelsLoaded";
    

    LabelManager.getInstance=function() {
        if (LabelManager._instance == null) {
            LabelManager.allowInstantiation = true;
            LabelManager._instance = new LabelManager();
            LabelManager.allowInstantiation = false;
        }
        return LabelManager._instance;
    }

    var element = facilis.extend(LabelManager, {});
    
    element.loadLabels=function(url,language) {
        language=(language||"default");
        var labelSet = new facilis.LabelSet(language);
        labelSet.addEventListener(facilis.LabelSet.LABELSET_LOADED, this.setLoaded.bind(this));
        labelSet.loadLabels(url);
    }

    element.getLabel=function(name, labelSet) {
        if (!labelSet) {
            labelSet = this._defaultSet;
        }
        if (this._labelsSets[labelSet]) {
            return (this._labelsSets[labelSet]).getLabel(name);
        }
        return "nor found:"+name;
    }

    element.setLoaded=function(event) {
        var labelSet = event.currentTarget;
        this._labelsSets[labelSet.labelSetName]=labelSet;
        this.dispatchEvent(new facilis.Event(facilis.LabelManager.LABELS_LOADED));
    }

    Object.defineProperty(element, 'defaultLabelSet', {
        set: function(val) {
            this._defaultSet=val;
        }
    });
    

    facilis.LabelManager = facilis.promote(LabelManager, "Object");
    
}());

(function() {

    function LabelSet(setName) {
        facilis.EventDispatcher.initialize(this);
        this._labelSetName=setName;
		this._labels=null;

    }
    
    LabelSet.LABELSET_LOADED = "labelSetLoaded";
    
    
    var element = facilis.extend(LabelSet, {});
    
    element.loadLabels=function(url) {
        
        var queue = new createjs.LoadQueue(true);
        queue.addEventListener("fileload", this.onVarsLoaded.bind(this));
        queue.loadFile(url);//loadFile({src:url, type:createjs.AbstractLoader.JSON});
        
    }

    element.onVarsLoaded=function(event) {
        this._labels = {};
        var retVars = event.result;
        for (var name in retVars) {
            this._labels[name] = unescape(retVars[name]);
            //trace("name: " + name + " value:" + _labels[name]);
        }
        this.dispatchEvent(new facilis.Event(facilis.LabelSet.LABELSET_LOADED));
    }
    
    element.getLabel=function(name) {
        return (this._labels[name]||("undefined label: "+name));
    }

    
    Object.defineProperty(element, 'labelSetName', {
        get: function() {
            return this._labelSetName;
        }
    });



    facilis.LabelSet = facilis.promote(LabelSet, "Object");
    
}());


