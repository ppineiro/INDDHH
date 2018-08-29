function isIE(userAgent) {
  userAgent = userAgent || navigator.userAgent;
  return userAgent.indexOf("MSIE ") > -1 || userAgent.indexOf("Trident/") > -1 || userAgent.indexOf("Edge/") > -1 || userAgent.indexOf("Windows NT 10") > -1;
}            
function init(){
    if(isIE()){

        function setExtensions(p){
            Object.defineProperty(p,"children",{
                get:function(){

                    var c=[];
                    for(var i=0;i<this.childNodes.length;i++){
                        if(this.childNodes[i].nodeType==1)
                            c.push(this.childNodes[i]);
                    }
                    return c;
                }
            });

            Object.defineProperty(p,"outerHTML",{

                get:function(){
                    var div=document.createElement("div");
                    div.appendChild(this.cloneNode(true));
                    return div.innerHTML;
                }

            });

            Object.defineProperty(p,"firstElementChild",{

                get:function(){
                    return this.children[0];
                }

            });
        }
        setExtensions(XMLDocument.prototype);
        setExtensions(Element.prototype);
    }
    
    facilis.baseUrl="bin/";
	facilis.Drag.dragDisable=true;
    loadXpdlExamples();
    facilis.game.WindowManager.getInstance().openModal( { closeButton:false, contentUrl:facilis.game.gameAssetsUrl+"screens/languagePicker.html", title:"Language Selection", footer:'<button type="button" class="btn btn-danger" onclick="closeLanguagePickerModal()">Ok</button>' } );
}

function showWhiteBoardWindow(){
    facilis.game.WindowManager.getInstance().openModal( { width:"700px",height:"600px",closeButton:true, contentUrl:facilis.game.gameAssetsUrl+"screens/WhiteboardScoreWindow.html", title:"SCORE" } );
}

var initModal;
function loadLabels(selectedLanguage){
    facilis.LabelManager.getInstance().addEventListener(facilis.LabelManager.LABELS_LOADED, function(e) { 
        initModal=facilis.game.WindowManager.getInstance().openModal( { width:"700px",height:"600px",closeButton:true, contentUrl:facilis.game.gameAssetsUrl+"screens/WhiteboardInitWindow.html", title:"Welcome", onClose:function(){
                                                             initNotepad();
                                                        } } );
        initFacilis();
        
    } );
    facilis.LabelManager.getInstance().loadLabels(facilis.game.gameAssetsUrl+"labels_"+selectedLanguage+".json");
}

function initNotepad(){
    $.get(facilis.game.gameAssetsUrl+"screens/notePad.html", null,
        function(data){
            $('body').append($(data.firstChild.outerHTML));
            $('#notePad')[0].style.position="absolute";    
            $('#notePad')[0].style.top="0px";
            $('#notePad').draggable({
                handle: "#handle"
            });
        },
    'xml');

}


function initFacilis() {
    document.getElementById("facilisCanvas").width = window.innerWidth-30;
    document.getElementById("facilisCanvas").height = window.innerHeight-30; 

    var stage = new createjs.Stage("facilisCanvas");
    stage.enableMouseOver(5);
    stage.mouseMoveOutside = true;
    stage.snapToPixelEnabled=true;
    createjs.Touch.enable(stage);

    facilis.ElementAttributeController.getInstance();
    facilis.IconManager.getInstance();

    stage.addChild(facilis.View.getInstance());

    facilis.View.getInstance().init(stage);

    facilis.ElementAttributeController.getInstance();

    setTimeout(function(){
    stage.update();  

    createjs.Ticker.on("tick", stage);

    },1200);
  return;
}

function loadXpdl(xpdl){
    facilis.View.getInstance().loadModelString(xpdl);
}
var xpdlExamples={};
function loadXpdlExamples(){
	$.get( "xpdlExamples.json" , function( data ) {
		if(!$.isArray(data))
				data=JSON.parse(data);
		
	  xpdlExamples=data;
	});
}

var UrlXpdlLoaded=false;
function loadXpdlUrl(url){
	$.get( url , function( data ) {
		UrlXpdlLoaded=true;
	  facilis.View.getInstance().loadModelString(data);
		if(initModal)
			facilis.game.WindowManager.getInstance().closeModal(initModal.attr("id"));
	});
}

function openSampleProcesses(){
	initModal=facilis.game.WindowManager.getInstance().openModal( { width:"700px",height:"600px",closeButton:true, contentUrl:facilis.game.gameAssetsUrl+"screens/WhiteboardInitWindow.html", title:"Welcome", 						onClose:function(){
    } } );
}