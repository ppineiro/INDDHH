(function(){
    facilis.game.gameAssetsUrl="gameAssets/";
    facilis.ActivityElement.prototype.showName=function(){
        this.txtName.visible=true;
        this.refreshCache();
    }
    
    facilis.ActivityElement.prototype.hideName=function(){
        this.txtName.visible=false;
        this.refreshCache();
    }
    
    facilis.ActivityElement.prototype.bonus=function(){
        this.shadow = new facilis.Shadow("#AAAAFF", 0, 0, 30);
        
        var tmp=this;
        try{tmp.updateCache();}catch(e){}
        
        setTimeout(function(){
            /*tmp.filters = [];
            var bounds = tmp.wrongFilter.getBounds();
            tmp.cache(-50+bounds.x, -50+bounds.y, 80+tmp._width, 80+tmp._height);*/
            tmp.shadow=null;
            try{tmp.updateCache();}catch(e){}
        },1000);
    }
    
    facilis.ActivityElement.prototype.greenLight=null;
	facilis.ActivityElement.prototype.showCorrect=function(show) {
        if (this.greenLight) {
            this.removeChild(this.greenLight);
            this.greenLight = null;
        }
        if(show){
            this.greenLight = facilis.IconManager.getInstance().getIcon("icons.drop.Permited");
            this.addChild(this.greenLight);
            this.greenLight.x = 7;
            this.greenLight.y = 7;
        }
        try{this.updateCache();}catch(e){}
    }
		
	facilis.ActivityElement.prototype.wrongFilter=null;
	facilis.ActivityElement.prototype.tiltWrong=function() {
        
        /*this.wrongFilter = new createjs.BlurFilter(5, 5, 1);
        this.filters = [this.wrongFilter];
        var bounds = this.wrongFilter.getBounds();
        this.cache(-50+bounds.x, -50+bounds.y, 80+this._width, 80+this._height);*/
        
        this.shadow = new facilis.Shadow("#FF0000", 0, 0, 15);
        
        var tmp=this;
        try{tmp.updateCache();}catch(e){}
        setTimeout(function(){
            /*tmp.filters = [];
            var bounds = tmp.wrongFilter.getBounds();
            tmp.cache(-50+bounds.x, -50+bounds.y, 80+tmp._width, 80+tmp._height);*/
            tmp.shadow=null;
            try{tmp.updateCache();}catch(e){}
        },1000);
        
        /*wrongFilter = new GlowFilter(0xFF0000, 1, 15, 15, 1);
        this.filters = [wrongFilter];
        var t:Timer = new Timer(700, 1);
        var tmp=this;
        t.addEventListener(TimerEvent.TIMER, function(e:TimerEvent) { 
            tmp.filters = [];
        } );
        t.start();*/
        
    }
}
)();

(function() {

     function GameController() {
        if (!GameController.allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }
        
        facilis.EventDispatcher.initialize(this);
        this.gameState = GameController.GAME_STOPPED;
		this.gameMode = GameController.MODE_DESCRIPTION;
		
		this.allItems=[];
		this.gameItems=[];
		this.answeredGameItems=[];
		
		this.currentElement=null;
		this.currentAnswer=null;
		this.score=0;
		
		this.processDescription="";
		
    }
    
    GameController.GAME_STOPPED = "GAME_STOPPED";
    GameController.GAME_ENDED = "GAME_ENDED";
    GameController.GAME_PLAYING = "GAME_PLAYING";
    GameController.GAME_PAUSED = "GAME_PAUSED";
    GameController.GAME_READY = "GAME_READY";
    GameController.GAME_NEXT = "GAME_NEXT";

    GameController.GAME_CORRECT = "GAME_CORRECT";
    GameController.GAME_BONUS = "GAME_BONUS";
    GameController.GAME_WRONG = "GAME_WRONG";

    GameController.INPECT_ELEMENT = "INPECT_ELEMENT";

    GameController.MODE_NAME = "MODE_NAME";
    GameController.MODE_DESCRIPTION = "MODE_DESCRIPTION";
    GameController.MODE_PERFORMER = "MODE_PERFORMER";


    GameController.allowInstantiation=false;
    GameController._instance;
    
    GameController.getInstance=function() {
        if (GameController._instance == null) {
            GameController.allowInstantiation = true;
            GameController._instance = new GameController();
            GameController.allowInstantiation = false;
        }
        return GameController._instance;
    }

    var element = facilis.extend(GameController, {});
    
    element.init=function() {
        facilis.MultiSelect.MULTISELECT_ENABLED = false;
        facilis.View.getInstance().addEventListener(facilis.View.ON_LOAD, this.viewLoad.bind(this));
        facilis.View.getInstance().addEventListener(facilis.View.ON_SELECT, this.elementSelect.bind(this));
    }
    
    element.play=function() {
        this.score = 0;
        this.answeredGameItems = [];
        this.gameItems = this.setShuffled(this.gameItems);
        this.resetElements();
        this.setNameVisibles((this.gameMode==facilis.game.GameController.MODE_DESCRIPTION || this.gameMode==facilis.game.GameController.MODE_PERFORMER));
        this.gameState = facilis.game.GameController.GAME_PLAYING;
        this.dispatchEvent(new facilis.Event(facilis.game.GameController.GAME_PLAYING));
        this.nextElement();
    }

    Object.defineProperty(element, 'remaining', {
        get: function() {
            return this.gameItems.length;
        }
    });
    
    element.resetElements=function() {
        var items = this.gameItems;
        var items2 = [];
        while (items.length > 0) {
            var item = items.shift();
            item.init();
            if (item.getGameTypeValue() && item.getGameTypeValue() != "") {
                items2.push(item);
            }else {
                this.answeredGameItems.push(item);
            }
        }
        this.gameItems = items2;
    }

    element.setNameVisibles=function(to) {
        for (var i = 0; i < this.allItems.length; i++ ) {
            if (to) {
                ((this.allItems[i]).element.getElement()).showName();
            }else{
                ((this.allItems[i]).element.getElement()).hideName();
            }
        }
    }

    element.end=function() {
        this.gameState = facilis.game.GameController.GAME_ENDED;
        this.score = facilis.game.ScoreCalculator.calculate(this.answeredGameItems);
        while(this.answeredGameItems.length>0) {
            this.gameItems.push(this.answeredGameItems.shift());
        }
        this.dispatchEvent(new facilis.Event(facilis.game.GameController.GAME_ENDED));
    }

    element.stop=function() {
        this.gameState = facilis.game.GameController.GAME_STOPPED;
        this.score = facilis.game.ScoreCalculator.calculate(this.answeredGameItems);
        while(this.answeredGameItems.length>0) {
            this.gameItems.push(this.answeredGameItems.shift());
        }
        this.dispatchEvent(new facilis.Event(facilis.game.GameController.GAME_STOPPED));
    }

    element.pause=function() {
        this.gameState = facilis.game.GameController.GAME_PAUSED;
        this.dispatchEvent(new facilis.Event(facilis.game.GameController.GAME_PAUSED));
    }

    element.checkCorrectAnswers=function(el) {
        for (var i = 0; i < this.gameItems.length; i++){
            if ((this.gameItems[i]).element==el && (this.gameItems[i]).checkCorrect(this.currentElement)) {
                this.setCorrect(this.gameItems[i]);
                this.gameItems.splice(i, 1);
                return true;
            }
        }
        return false;
    }

    element.getQuestion=function() {
        return this.currentElement.getGameTypeValue()
    }

    element.setShuffled=function(arr) {
        var random = [];
        var aux = [];

        for (var i = 0; i < arr.length; i++ )
            aux.push(arr[i]);

        while(aux.length > 0)
            random.push(aux.splice(Math.floor(Math.random()*aux.length), 1)[0]);


        return random;
    }

    element.nextElement=function() {
        facilis.View.getInstance().unselectAll();
        if (this.gameItems.length > 0) {
            this.currentElement = this.gameItems[0];
            if (this.currentElement.getGameTypeValue() && this.currentElement.getGameTypeValue() != "") {
                this.currentAnswer = new facilis.game.Answer();
                this.currentAnswer.start = (new Date()).getTime();
                this.dispatchEvent(new facilis.Event(facilis.game.GameController.GAME_NEXT));
            }else {
                this.answeredGameItems.push(this.gameItems.shift());
                nextElement();
            }

        }else {
            this.end();
        }
    }

    element.setCorrect=function(el) {
        this.currentAnswer.end = (new Date()).getTime();
        if (((this.currentAnswer.end - this.currentAnswer.start) < facilis.game.ScoreCalculator.timeForBonus) && el.answers.length == 0) {
            this.dispatchEvent(new facilis.Event(facilis.game.GameController.GAME_BONUS));
            (el.element.getElement()).bonus();
        }else {
            this.dispatchEvent(new facilis.Event(facilis.game.GameController.GAME_CORRECT));
        }
        this.currentAnswer.correct = true;
        el.addAnswer(this.currentAnswer);
        this.currentAnswer = null;
        this.answeredGameItems.push(el);
        (el.element.getElement()).showName();
        (el.element.getElement()).showCorrect(true);
    }

    element.viewLoad=function(e) {
        var mainProcData=facilis.View.getInstance().getMainProcessData();
        this.processDescription = mainProcData.firstElementChild.firstElementChild.getAttribute("value");
        this.processDescription = this.processDescription?this.processDescription:"";
        facilis.game.ScoreCalculator.processName= mainProcData.firstElementChild.children[1]?mainProcData.firstElementChild.children[1].getAttribute("value"):"";
        this.allItems = [];
        var els = facilis.View.getInstance().getElements();
        for (var i = 0; i < els.length; i++ ) {
            if ((els[i]).elementType=="task" || (els[i]).elementType=="esubflow" || (els[i]).elementType=="csubflow") {
                var gameItem = new facilis.game.GameItem(els[i]);
                this.allItems.push(gameItem);
            }
        }
        this.setNameVisibles((this.gameMode==facilis.game.GameController.MODE_DESCRIPTION || this.gameMode==facilis.game.GameController.MODE_PERFORMER));
        this.gameItems=this.setShuffled(this.allItems);			
        this.dispatchEvent(new facilis.Event(facilis.game.GameController.GAME_READY));
    }

    element.elementSelect=function(e) {
        var el = facilis.View.getInstance().getSelectedElements()[0];
        if(el && el.getElement && (el.getElement() instanceof facilis.ActivityElement)){
            if (this.gameState==facilis.game.GameController.GAME_PLAYING) {
                if (el === this.currentElement.element) {
                    this.setCorrect(this.gameItems.shift());
                    this.nextElement();
                }else if (this.checkCorrectAnswers(el)) {
                    this.nextElement();
                }else {
                    this.currentAnswer.end = (new Date()).getTime();
                    this.currentAnswer.correct = false;
                    this.currentElement.addAnswer(this.currentAnswer);
                    this.currentAnswer = new facilis.game.Answer();
                    this.currentAnswer.start = (new Date()).getTime();
                    facilis.View.getInstance().unselectAll();
                    (el.getElement()).tiltWrong();
                    this.dispatchEvent(new facilis.Event(facilis.game.GameController.GAME_WRONG));
                }
            }else {
                for (var i = 0; i < this.gameItems.length; i++){
                    if ((this.gameItems[i]).element==el) {
                        this.currentElement = (this.gameItems[i]);
                        this.dispatchEvent(new facilis.Event(facilis.game.GameController.INPECT_ELEMENT));
                        return;
                    }
                }
            }
        }else {
            if (this.gameState != facilis.game.GameController.GAME_PLAYING) {
                this.currentElement = null;
                this.dispatchEvent(new facilis.Event(facilis.game.GameController.INPECT_ELEMENT));
            }
        }
    }
    
    element.forceEndGame=function(e) {
        this.end();
    }

    facilis.game.GameController = facilis.promote(GameController, "Object");
    
}());

(function() {
    
    function AudioManager(){}
    
    AudioManager._disabled = false;
		
    AudioManager.correct=function() {
        AudioManager.play("correct");
    }

    AudioManager.error=function() {
        AudioManager.play("error");
    }

    AudioManager.bonus=function() {
        AudioManager.play("bonus");
    }

    AudioManager.music=function() {
        AudioManager.play("music");
    }

    AudioManager.score=function() {
        AudioManager.play("score");
    }

    
    Object.defineProperty(AudioManager, 'enable', {
        set: function(b) {
            createjs.Sound.setMute(!b);
        }
    });

    AudioManager.play=function(s) {
        if (!AudioManager._disabled) {
            createjs.Sound.play(s);
        }
    }
    

    AudioManager.handleSoundLoaded=function(event) {
        console.log("Preloaded:", event.id, event.src);
    }
    
    AudioManager.init=function() {
        createjs.Sound.addEventListener("fileload", this.handleSoundLoaded);
        createjs.Sound.alternateExtensions = ["mp3"];
        createjs.Sound.registerSounds(
            [{id:"correct", src:"correct.mp3"},
            {id:"error", src:"error.mp3"},
            {id:"bonus", src:"bonus.mp3"},
            {id:"score", src:"score.mp3"},
            {id:"music", src:"music.mp3"}]
        , facilis.game.gameAssetsUrl+"audio/");

    }
    setTimeout(function(){
        AudioManager.init();
        }, 500);
    
    
    facilis.game.AudioManager=AudioManager;
    
})();


(function() {

    function GameItem(_element) {
        
        this.name="";
		this.performers=[];
		this.description="";
		
		this._answers=[];
		
		this.element=_element;
        
        this.parseInfo(_element.getData());
    }
    
    //static public//
    
    
    var element = facilis.extend(GameItem, {});
    
    element.init=function() {
        this._answers = [];	
        this.element.getElement().showCorrect(false);
    }

    element.parseInfo=function(data) {
        this.performers = [];
        this.data = data.firstElementChild;
        for (var i = 0; i < this.data.children.length;i++ ) {
            if ((this.data.children[i]).getAttribute("label").toLowerCase()=="name") {
                this.name = (this.data.children[i]).getAttribute("value");
            }
            if ((this.data.children[i]).getAttribute("name")=="documentation") {
                this.description = (this.data.children[i]).getAttribute("value");
            }
            if ((this.data.children[i]).getAttribute("name")=="performers") {
                if ((this.data.children[i]).children.length > 1) {
                    var values = (this.data.children[i]).children[1];
                    for (var v=0;v<values.children.length;v++) {
                        this.performers.push(values.children[v].firstElementChild.getAttribute("value"));
                    }
                    this.performers.sort(Array.CASEINSENSITIVE);
                }
            }
        }
    }

    element.checkCorrect=function(value) {
        return this.getGameTypeValue() == value.getGameTypeValue();
    }

    element.getGameTypeValue=function() {
        if (facilis.game.GameController.getInstance().gameMode==facilis.game.GameController.MODE_NAME) {
            return this.name;
        }
        if (facilis.game.GameController.getInstance().gameMode==facilis.game.GameController.MODE_DESCRIPTION) {
            return this.description;
        }
        if (facilis.game.GameController.getInstance().gameMode==facilis.game.GameController.MODE_PERFORMER) {
            return this.performers.join(", ");
        }
    }

    Object.defineProperty(element, 'answers', {
        get: function() {
            return this._answers;
        }
    });

    element.addAnswer=function(value) 
    {
        this._answers.push(value);
    }


    facilis.game.GameItem = facilis.promote(GameItem, "Object");
    
}());

(function() {

    function Answer() {
        
    }

    var element = facilis.extend(Answer, {});
    
    element.start=null;
    element.end=null;
    element.correct=null;


    facilis.game.Answer = facilis.promote(Answer, "Object");
    
}());

(function() {

    function HighScore() {
        
    }

    var element = facilis.extend(HighScore, {});
    
    element.name=null;
    element.date=null;
    element.score=null;


    facilis.game.HighScore = facilis.promote(HighScore, "Object");
    
}());


(function() {

    function ScoreCalculator() {
    }
    
    ScoreCalculator.timeForBonus = 4000;
		
    ScoreCalculator.bonusTime = -10000;
    ScoreCalculator.penaltyTime = 10000;

    ScoreCalculator.score=0;
    ScoreCalculator.bonus=0;
    ScoreCalculator.incorrect = 0;
    ScoreCalculator.correct = 0;
    ScoreCalculator.avgTime = 0;
    ScoreCalculator.totalTime = 0;

    ScoreCalculator.userName = "";
    ScoreCalculator.processName = "";
    ScoreCalculator.details=[];

    ScoreCalculator.highScores={};
    
    ScoreCalculator.calculate=function(els) {
        ScoreCalculator.score=0;
        ScoreCalculator.bonus=0;
        ScoreCalculator.incorrect=0;
        ScoreCalculator.avgTime= 0;
        ScoreCalculator.totalTime = 0;
        ScoreCalculator.correct = 0;
        ScoreCalculator.details=new Array();
        var totalTime=0;
        for (var i = 0; i < els.length; i++ ) {
            var el = els[i];
            var answers = el.answers;
            var detail = new Object();
            detail[facilis.LabelManager.getInstance().getLabel("lbl_element")] = el.name;
            var correct = 0;
            var incorrect = 0;
            var bonus = 0;
            for (var a = 0; a < answers.length; a++ ) {
                var answer = answers[a];
                var time = answer.end - answer.start;
                facilis.game.ScoreCalculator.totalTime += time;
                if (!answer.correct) {
                    time += facilis.game.ScoreCalculator.penaltyTime;
                    facilis.game.ScoreCalculator.incorrect++;
                    incorrect++;
                }else if (time < facilis.game.ScoreCalculator.timeForBonus && incorrect == 0) {
                    facilis.game.ScoreCalculator.bonus++;
                    bonus++;
                    correct++;
                    time += ScoreCalculator.bonusTime;
                    ScoreCalculator.correct++;
                }else { 
                    correct++;
                    ScoreCalculator.correct++;
                }
                totalTime += time;
            }

            detail[facilis.LabelManager.getInstance().getLabel("lbl_correct")] =  correct;
            detail[facilis.LabelManager.getInstance().getLabel("lbl_errors")] =  incorrect;
            detail[facilis.LabelManager.getInstance().getLabel("lbl_bonus")] =  bonus;
            facilis.game.ScoreCalculator.details.push(detail);
        }

        if (totalTime<0) {
            totalTime = 1;
        }

        facilis.game.ScoreCalculator.totalTime = facilis.game.ScoreCalculator.totalTime / 1000;
        facilis.game.ScoreCalculator.score = (1 / facilis.game.ScoreCalculator.totalTime) * 1000000;
        if (!isFinite(facilis.game.ScoreCalculator.score)) {
            facilis.game.ScoreCalculator.score = 0;
        }
        facilis.game.ScoreCalculator.avgTime = facilis.game.ScoreCalculator.totalTime / els.length;
        facilis.game.ScoreCalculator.addHighScore();
        
        facilis.game.ScoreCalculator.score=Math.round(facilis.game.ScoreCalculator.score);
        
        return facilis.game.ScoreCalculator.score;
    }



    ScoreCalculator.addHighScore=function() {
        var hs={
            score:facilis.game.ScoreCalculator.score,
            name:facilis.game.ScoreCalculator.userName
        }
        
        facilis.game.HighScoreController.getInstance().addHighScore(facilis.game.ScoreCalculator.processName,hs);
    }
    
    ScoreCalculator.isHighScore=function() {
        var hs={
            score:facilis.game.ScoreCalculator.score,
            name:facilis.game.ScoreCalculator.userName
        }
        
        var highScores=facilis.game.HighScoreController.getInstance().highScores;
        if(highScores[highScores.length-1].score>=hs.score){
            return true;
        }
        return false;
    }

    ScoreCalculator.getHighScore=function() {
        if (facilis.game.HighScoreController.getInstance().highScores) {
            return facilis.game.HighScoreController.getInstance().highScores;
        }
        return null;
    }
    
    ScoreCalculator.formatTime =function (input)   {
        input=parseInt(input);
        if(input==0)
            return 0;
        
        var hrs = (input > 3600 ? Math.floor(input / 3600) + ":" : "00:");
        var mins = (hrs && input % 3600 < 600 ? "0" : "") + Math.floor(input % 3600 / 60) + ":";
        var secs = (input % 60 < 10 ? "0" : "") + input % 60;
        return (hrs +"" + mins +"" + secs);
    }
    
    ScoreCalculator.formatScore=function(num){
        var n = num.toString(), p = n.indexOf('.');
        return n.replace(/\d(?=(?:\d{3})+(?:\.|$))/g, function($0, i){
            return p<0 || i<p ? ($0+'.') : $0;
        });
    }

    facilis.game.ScoreCalculator = facilis.promote(ScoreCalculator, "Object");
    
}());

(function() {

    function HighScoreController() {
        if (!HighScoreController.allowInstantiation) {
            
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }
        this._highScoreModel={};
        this._highScores=[];
        this.loadHighScoreModel();
    }
    
    
    HighScoreController.allowInstantiation=false;
    HighScoreController._instance=null;
    
    HighScoreController.getInstance=function() {
        if (HighScoreController._instance == null) {
            HighScoreController.allowInstantiation = true;
            HighScoreController._instance = new HighScoreController();
            HighScoreController.allowInstantiation = false;
        }
        return HighScoreController._instance;
    }
    
    
    var element = facilis.extend(HighScoreController, {});
    
    element.addHighScore=function(game,score) {
        game=(!game||game=="")?"empty":game;
        this.loadHighScores(game);
        this._highScores.push(score);
        this._highScores.sort(function(a, b){return b.score-a.score});
        if (this._highScores.length > 10) {
            this._highScores.pop();
        }
        this.saveHighScores(game);
    }

    Object.defineProperty(element, 'highScores', {
        get: function() {
            return this._highScores;
        }
    });

    element.loadHighScores=function(game) {
        this._highScores =[];
        if(this._highScoreModel[game]){
            this._highScores = this._highScoreModel[game];
        }

    }
    
    element.loadHighScoreModel=function() {
        this._highScoreModel ={};
        if(localStorage["facilis.game.HighScore"]){
            this._highScoreModel = JSON.parse(localStorage["facilis.game.HighScore"]);
        }

    }

    element.saveHighScores=function(game) {
        this._highScoreModel[game]=this._highScores;
        localStorage["facilis.game.HighScore"] = JSON.stringify(this._highScoreModel);

    }


    facilis.game.HighScoreController = facilis.promote(HighScoreController, "Object");
    
}());


function WindowManager(){
        if (!WindowManager.allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
        }
    
        this.onCloseFunctions={};
        
        this.openModal=function(config){
            var modalId=this.getModalId();
            var modalHTML='<div class="modal" id="'+modalId+'" data-backdrop="static" data-keyboard="false"><div class="modal-dialog"><div class="modal-content"><div class="modal-header">';
            if(!config.closeButton==false)
                modalHTML+='<button type="button" class="close" onclick="facilis.game.WindowManager.getInstance().closeModal(\''+modalId+'\')" data-dismiss="modal" aria-hidden="true">x</button>';
            
            modalHTML+='<h4 class="modal-title">'+(config.title||"")+'</h4></div><div class="modal-body"></div>';
            if(config.footer && config.footer!="")
                modalHTML+='<div class="modal-footer">'+config.footer+'</div>';
                
            /*<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button><button type="button" class="btn btn-primary">Save changes</button></div>
            */
            modalHTML+='</div></div></div>';
            
            if(config.onClose) 
                this.onCloseFunctions["closeFunction_"+modalId]=config.onClose;
            
            if(config.contentHTML){
                
            }else if(config.contentUrl){
                var tmp=this;
                $.get(config.contentUrl, null,
                    function(data){
                        $(data.firstChild.outerHTML).appendTo($('#'+modalId).find(".modal-body"));
                        tmp.startModal(modalId);
                    },
                    'xml');
            }
            $(modalHTML).appendTo("body");
            var cssOverride={};
            if(config.width)
                cssOverride.width=config.width;
            
            if(config.height)
                cssOverride.height=config.height;
            
            
            $("#"+modalId).find(".modal-dialog").css(cssOverride);
            return $("#"+modalId);
            //( { width:700, height:520, centered:true, content:modal, title:"" } )
        }
        
        this.startModal=function(modalId){
            $('#'+modalId).modal({
                show: true,
                truebackdrop: 'static', 
                keyboard: false
            });
        }
        
        this.closeModal=function(id){
            if(this.onCloseFunctions["closeFunction_"+id]){
                this.onCloseFunctions["closeFunction_"+id]();
                this.onCloseFunctions["closeFunction_"+id]=null;
            }
                
            $("#"+id).modal('hide');
            setTimeout(function(){$("#"+id).remove();},800);
        }
        
        this.modalCount=0;
        this.getModalId=function(){
            this.modalCount++;
            return "_modal_"+this.modalCount;
        }
        
    }
    
    WindowManager.allowInstantiation=false;
    WindowManager._instance;
    
    WindowManager.getInstance=function() {
        if (WindowManager._instance == null) {
            WindowManager.allowInstantiation = true;
            WindowManager._instance = new WindowManager();
            WindowManager.allowInstantiation = false;
        }
        return WindowManager._instance;
    }

    facilis.game.WindowManager=WindowManager;

(function() {

    function GamePanel(config) {
        this.actions=config.actions;
        
        this.loadBtn=config.loadButton;
        this.playStopButton=config.startStopButton;

        this.questionLabel=config.questionLabel;

        //this.radioGroup;
        this.taskName=config.taskName;
        this.taskDescription=config.taskDescription;
        this.taskPerformer=config.taskPerformer;
        
        this.nameInput=config.nameInput;

        this.countdownEl=config.countdown;
        
        this.printerButton=config.printerButton;
        
        this.counter=config.counter;

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(GamePanel, {});
    
    /*
        element.BaseClassSetup=element.setup;
    */
    element.setup = function() {
        //this.BaseClassSetup();
        
        
        facilis.game.GameController.getInstance().init();
			
        facilis.game.GameController.getInstance().addEventListener(facilis.game.GameController.GAME_PAUSED, this.onGamePause.bind(this));
        facilis.game.GameController.getInstance().addEventListener(facilis.game.GameController.GAME_PLAYING, this.onGamePlaying.bind(this));
        facilis.game.GameController.getInstance().addEventListener(facilis.game.GameController.GAME_READY, this.onGameReady.bind(this));
        facilis.game.GameController.getInstance().addEventListener(facilis.game.GameController.GAME_STOPPED, this.onGameStop.bind(this));
        facilis.game.GameController.getInstance().addEventListener(facilis.game.GameController.GAME_ENDED, this.onGameEnd.bind(this));
        facilis.game.GameController.getInstance().addEventListener(facilis.game.GameController.GAME_NEXT, this.onGameNext.bind(this));
        facilis.game.GameController.getInstance().addEventListener(facilis.game.GameController.GAME_CORRECT, this.onGameCorrect.bind(this));
        facilis.game.GameController.getInstance().addEventListener(facilis.game.GameController.GAME_WRONG, this.onGameWrong.bind(this));
        facilis.game.GameController.getInstance().addEventListener(facilis.game.GameController.GAME_BONUS, this.onGameBonus.bind(this));

        facilis.game.GameController.getInstance().addEventListener(facilis.game.GameController.INPECT_ELEMENT, this.onInspectElement.bind(this));
        
        
        
        this.loadBtn.addEventListener("change", this.loadGameFile.bind(this));

        this.playStopButton.addEventListener("click", this.startStopClick.bind(this));
        this.playStopButton.disabled = true;

        this.taskDescription.addEventListener("click", this.radioChecked.bind(this));
        this.taskDescription.checked=true;
        
        this.taskPerformer.addEventListener("click", this.radioChecked.bind(this));
        this.taskPerformer.checked=false;
        
        this.taskName.addEventListener("click", this.radioChecked.bind(this));
        this.taskName.checked=false;
        
        this.countdown = new facilis.game.CountdownTimer(this.countdownEl);
        this.countdown.displayRemaining = false;
        this.countdown.x = 5;
        this.countdown.y = 5;
        this.countdown.scaleX = 2;
        this.countdown.scaleY = 2;
        
        this.countdown.addEventListener(facilis.game.CountdownTimer.TIMER_ENDED,function(){
            facilis.game.GameController.getInstance().end();
        });

        this.questionLabel.disabled = true;
        this.questionLabel.visible = false;
        
        this.nameInput.addEventListener("change", this.nameInputChanged.bind(this));
        
        this.printerButton.addEventListener("click", this.printDocumentation.bind(this));

        this.checkPlayButton();
    };
    
    element.onGamePlaying=function(e) {
        this.loadBtn.disabled = true;
        this.playStopButton.disabled = true;
        //this.endButton.disabled = false;
        this.countdown.startTimer(3600,  null);
        this.checkPlayButton();
        
        this.playStopButton.playing=true;
        this.nameInput.disabled  = true;
        
        this.taskName.disabled = true;
        this.taskDescription.disabled = true;
        this.taskPerformer.disabled = true;
        
        this.questionLabel.visible = true;
        this.countdown.visible = true;
    }

    element.onGameReady=function(e) {
        this.loaded=true;
        this.loadBtn.disabled = false;
        this.playStopButton.disabled = false;
        //this.endButton.disabled = true;

        this.taskName.disabled = false;
        this.taskDescription.disabled = false;
        this.taskPerformer.disabled = false;
        
        this.playStopButton.playing=false;

        this.setQuestionText(this.getProcessName()+"\n"+ facilis.game.GameController.getInstance().processDescription);
        this.countdown.visible = false;
        this.checkPlayButton();
    }

    element.onGameEnd=function(e) {
        this.loadBtn.disabled = false;
        this.playStopButton.disabled = false;
        //this.endButton.disabled = true;
        this.checkPlayButton();
        
        this.taskName.disabled = false;
        this.taskDescription.disabled = false;
        this.taskPerformer.disabled = false;
        
        this.playStopButton.playing=false;
        this.nameInput.disabled  = false;
        
        this.countdown.stopTimer();
        this.countdown.visible = false;
        this.questionLabel.visible = true;
        this.setQuestionText(facilis.game.GameController.getInstance().processDescription);
        //AbstractMain.message(facilis.game.GameController.getInstance().score);
        
        /*var modal = new WhiteboardScoreWindow();
        var win = facilis.game.WindowManager.getInstance().openModal( { width:700, height:520, centered:true, content:modal, title:"" } );
        win.setDragbarHeight(0);
        win.removeClose();
        win.removeMinimize();*/
        showWhiteBoardWindow();
    }


    element.onGameStop=function(e) {
        this.loadBtn.disabled = false;
        this.playStopButton.disabled = false;
        this.playStopButton.playing=false;
        //this.endButton.disabled = true;
        this.checkPlayButton();
        
        this.taskName.visible = true;
        this.taskDescription.visible = true;
        this.taskPerformer.visible = true;
        
        this.nameInput.disabled  = false;
        
        this.countdown.stopTimer();
        this.countdown.visible = false;
        this.questionLabel.visible = true;
        this.setQuestionText(facilis.game.GameController.getInstance().processDescription);

    }

    element.onGameNext=function(e) {
        var str = facilis.game.GameController.getInstance().getQuestion();
        this.setQuestionText(str);
        this.counter.innerText=facilis.LabelManager.getInstance().getLabel("lbl_remaining") +" "+ facilis.game.GameController.getInstance().remaining;
    }

    element.onGameCorrect=function(e) {
        facilis.game.AudioManager.correct();
        //AbstractMain.message("Correct!!!");
    }

    element.onGameWrong=function(e) {
        facilis.game.AudioManager.error();
        //AbstractMain.message("Wrong!!!");
    }

    element.onGameBonus=function(e) {
        facilis.game.AudioManager.bonus();
        //AbstractMain.message("Wrong!!!");
    }

    element.startStopClick=function(e) {
        if(this.playStopButton.playing){
            facilis.game.GameController.getInstance().play();
        }else{
            facilis.game.GameController.getInstance().stop();
        }
    }

    element.endClick=function(e) {
        facilis.game.GameController.getInstance().stop();
    }
    
    element.loadClick=function(e) {
        //this.actions.loadXPDL();
    }


    element.radioChecked=function(el) {
        if(el.target.disabled)
            return;
        
        if (this.taskDescription==el.target) {
            facilis.game.GameController.getInstance().gameMode = facilis.game.GameController.MODE_DESCRIPTION;
            this.taskPerformer.checked=false;
            this.taskName.checked=false;
        }else if (this.taskPerformer==el.target) {
            facilis.game.GameController.getInstance().gameMode = facilis.game.GameController.MODE_PERFORMER;
            this.taskDescription.checked=false;
            this.taskName.checked=false;
        }else if (this.taskName==el.target) {
            facilis.game.GameController.getInstance().gameMode = facilis.game.GameController.MODE_NAME;
            this.taskPerformer.checked=false;
            this.taskDescription.checked=false;
        }

    }

    element.onGamePause=function(e) {

    }



    element.onInspectElement=function(e) {
        var txt;
        if(facilis.game.GameController.getInstance().processDescription){
            txt =this.getProcessName()+"\n"+ facilis.game.GameController.getInstance().processDescription;
        }
        if(facilis.game.GameController.getInstance().currentElement){
            var gameItem = facilis.game.GameController.getInstance().currentElement;
            if(gameItem.name)
                txt = facilis.LabelManager.getInstance().getLabel("lbl_taskName") + ":  " + gameItem.name;
            
            if(gameItem.description)
                txt += "\n" +facilis.LabelManager.getInstance().getLabel("lbl_taskDesc") + ":  " + gameItem.description;
            
            if(gameItem.performers && gameItem.performers.length>0)
                txt += "\n" +facilis.LabelManager.getInstance().getLabel("lbl_taskPerf") + ":  " + gameItem.performers.join(", ");
        }
        this.setQuestionText(txt);
    }

    element.setQuestionText=function(str) {
        this.questionLabel.value = str;
        //this.questionLabel.updateScrolls();
    }


    element.getProcessName=function() {
        var d = facilis.View.getInstance().getMainProcessData();
        if (d) {
            d = d.firstElementChild;
            for (var i = 0; i < d.children.length; i++ ) {
                if (d.children[i].getAttribute("name") == "name" || d.children[i].getAttribute("name") == "nameChooser") {
                    return d.children[i].getAttribute("value");
                }
            }
        }
        return "UnNamed";

    }

    element.nameInputChanged=function(e) {
        facilis.game.ScoreCalculator.userName=this.nameInput.value;
        this.checkPlayButton();
    }
    
    element.checkPlayButton=function() {
        this.playStopButton.disabled = !((this.nameInput.value != "\r" && this.nameInput.value != "") && (this.loaded || UrlXpdlLoaded));
        this.playStopButton.title="";
        if (this.playStopButton.disabled) {
            var tt =  facilis.LabelManager.getInstance().getLabel("lbl_mustprovide");
            var provide = "";
            if (!this.loaded) {
                provide = facilis.LabelManager.getInstance().getLabel("lbl_agamefile");
            }
            if ((this.nameInput.value == "\r" || this.nameInput.value == "") && !this.loaded) {
                provide += ", ";
            }
            if (this.nameInput.value == "\r" || this.nameInput.value == "") {
                provide += facilis.LabelManager.getInstance().getLabel("lbl_aplayername");
            }
            tt=tt.replace("*", provide);
            this.playStopButton.title=tt;
        }
    }
    
    element.printDocumentation=function(){
        (new facilis.documentation.PdfDocumentGenerator()).getDocumentation();
    }

    element.loadGameFile=function(e){

        var fr = new FileReader();
        var files=e.target.files;
        var total=files.length;
        if(files.length!=0){
            var f=files[0];
            var fr = new FileReader();
            fr.onload = function(){
                loadXpdl(this.result);
            };
            fr.readAsText(f,"utf-8");
        }
    
    }
    
    facilis.game.GamePanel = facilis.promote(GamePanel, "Object");
    
}());


		
		

(function() {
    
    function Timer(){
        facilis.EventDispatcher.initialize(this);
        var scope=this;
        this.interval=null;
        this.lastTick=0;
        this.start=function(){
            this.interval=setInterval(
                function(){
                    scope.lastTick++;
                    scope.dispatchEvent(new facilis.Event(Timer.TIMER));
                }
                ,300);
        }
        
        this.stop=function(){
            clearInterval(this.interval);
        }
        
        this.getLastTick=function(){
            return this.lastTick;
        }
    }
    Timer.TIMER="timer_timer"

    function CountdownTimer(container) {
        this.container=container;
        
        this.isFinished =false;
		this.paused  = true;
		this._currentTime;
		this._lastTime=0;
		//this._myTimerClip : MovieClip
		this._recentTimePassed=0;
		this._startTime=0;
		this._totalTimeInMilliseconds=0;
		this._totalTimeInSeconds=0;
		this._totalTimePassed=0;
		this._whenFinishedCallBack = null;
		this.minutesLeft=0;
		this.secondsLeft=0;
		this.tensOfSecondsLeft=0;
		this.timeSecondsLeft=1000;
		
        this.countTo=-1;
        
		this.minutes;
		this.seconds;
		
		this.timer;
		
		this.displayRemaining = true;
        
        
        facilis.EventDispatcher.initialize(this);
    
        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(CountdownTimer, {});
    
    
    
    element.TIMER_ENDED="TIMER_ENDED";
    
    element.setup = function() {
        this.container.innerHTML="";
        this.container.style.display="table";
        this.minutes = document.createElement("div");
        this.minutes.style.display="table-cell";
        this.minutes.style.width="40%";
        this.minutes.style.textAlign="right";
        this.container.appendChild(this.minutes);
        //this.minutes.width = 12;
        this.dots = document.createElement("div");
        this.dots.style.display="table-cell";
        this.dots.style.width="20%";
        this.dots.style.textAlign="center";
        this.container.appendChild(this.dots);
        this.dots.innerText=" : ";
        this.seconds = document.createElement("div");
        this.seconds.style.display="table-cell";
        this.seconds.style.width="40%";
        this.seconds.style.textAlign="left";
        //this.seconds.width = 12;
        this.container.appendChild(this.seconds);
        this.timer = new Timer(300);
        this.timer.addEventListener(Timer.TIMER, this.loop.bind(this));
    }


    element.continueTimer=function() {
        this._lastTime = this.getTimer();
        this.paused = false;
    }

    element.dispose=function() {
        stopTimer()
        removeChild(_myTimerClip)
        _myTimerClip = null
        this._whenFinishedCallBack = null
    }

    element.initialise=function(_timerClip) {
        _myTimerClip = _timerClip

    }
    element.pauseTimer=function() {
        console.log("pausing timer")
        this.paused = true;
    }

    element.startTimer=function(_seconds,_callBack) {
        console.log("starting timer for " + _seconds + " seconds")
        this._totalTimeInSeconds = _seconds;
        this._whenFinishedCallBack = _callBack;
        this._totalTimeInMilliseconds = _seconds * 1000;
        this.timer.start();
        this._startTime = this.getTimer();
        this._lastTime = this._startTime;
        this._totalTimePassed = 0;
        this.paused = false;
        this.isFinished = false;
    }

    element.stopTimer=function() {
        this.timer.stop()
    }

    element.updateTimeDisplay=function() {
        this._currentTime = this.getTimer();
        this._recentTimePassed = this._currentTime - this._lastTime;
        this._lastTime = this._currentTime;
        this._totalTimePassed += this._recentTimePassed;
        // work out how much time to display
        this.timeSecondsLeft = Math.ceil((this._totalTimeInMilliseconds - this._totalTimePassed) / 1000);
        if (this.timeSecondsLeft < 1) {
            // this.timer has finished
            this.isFinished = true
        }
        var displayTime = this.timeSecondsLeft;
        if (!this.displayRemaining) {
            displayTime = this._totalTimeInSeconds - displayTime;
        }
        this.minutesLeft = parseInt(displayTime / (60));
        displayTime -= this.minutesLeft * 60;
        this.tensOfSecondsLeft = parseInt(displayTime / (10));
        displayTime -= this.tensOfSecondsLeft * 10;
        this.secondsLeft = displayTime;
        if (this.minutes.innerText != this.minutesLeft) {
            this.minutes.innerText = this.minutesLeft;
        }
        //if (tensof.text != String(this.tensOfSecondsLeft)) {
            //tensof.text = String(this.tensOfSecondsLeft);
        /*}
        if (seconds.text != String(this.secondsLeft)) {*/
            this.seconds.innerText = this.tensOfSecondsLeft+""+this.secondsLeft;
        //}
    }


    element.timerFinished=function() {
        console.log("timer has finished countdown");
        this.dispatchEvent(new facilis.Event(facilis.game.CountdownTimer.TIMER_ENDED));

        this.stopTimer();
        if (this._whenFinishedCallBack != null) {
            this._whenFinishedCallBack.call()
        }
    }

    element.loop=function(event) {
        if (!this.paused) {
            this.updateTimeDisplay();
            if (this.isFinished) {
                this.timerFinished()
            }
        }
    }
    
    element.getTimer=function(){
        //return this.timer.getLastTick();
        return (new Date()).getTime();
    }


    facilis.game.CountdownTimer = facilis.promote(CountdownTimer, "Object");
    
}());

        
		
		

