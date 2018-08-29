// JavaScript Document
var postitsState="";
var postitsInitState="";

function addPostit(text){
	var postIt=createPostit(text);
	postIt.className="trashable";
	showPostits();
	postiItArea.appendChild(postIt);
	postIts.push(postIt);
	postIt.x=30;
	postIt.y=30;
	new Draggable(postIt, {revert:false,handle:postIt.drag,
		change:function(e){
			e.element.y=e.element.offsetTop;
			e.element.x=e.element.offsetLeft;
			
		}
	});
	postIt.text.focus();
	return postIt;
}

function createPostit(text){
	if(text==undefined){
		text="";
	}
	var postIt=document.createElement("DIV");
	postIt.style.position="absolute";
	postIt.style.zIndex="1";
	postIt.style.height="167px";
	postIt.style.width="151px";
	postIt.type="postit";
	postIt.id=postIts.length;
	postIt.style.backgroundImage="url(styles/"+currStyle+"/images/postIt.png)";
	postIt.innerHTML="<div style='position:relative;height:20px;cursor:pointer;cursor:move;'></div><textarea wrap='virtual' style='position:relative;background-color:transparent;left:10px;width:125px;height:130px;border:0px' name='' cols='' rows=''>"+text+"</textarea>";
	postIt.text=postIt.getElementsByTagName("TEXTAREA")[0];
	makeSelectable(postIt.text);
	postIt.drag=postIt.getElementsByTagName("DIV")[0];
	postIt.remove=function(){
		removePostit(this);
	};
	postIt.getObject=function(){
		var obj=getPostitObject({name:("Postit "+this.id),
		atts:{text:this.text.value},
		postit:true,
		text:this.text.value,
		icon:"styles/"+currStyle+"/images/postit_icon_50x50.png",
		dblClickDo:function(icon){
			addPostit(icon.getObject().atts.text);
			icon.remove();
		} });
		return obj;
	}
	setPostitMenu(postIt);
	return postIt;
}

function removePostit(postit){
	for(var i=0;i<postIts.length;i++){
		if(postIts[i]==postit){
			postIts.splice(i,1);
			postit.parentNode.removeChild(postit);
		}
	}
}

function hidePostits(){
	postitsState="hidden";
	try{
		postiItArea.style.zIndex=3;
		//Effect.Fade(postiItArea,{duration:.5});
		for(var i=0;i<postIts.length;i++){
			Effect.Fade(postIts[i],{duration:.5});
		}
	}catch(e){}
}

function showPostits(){
	postitsState="shown";
	try{
		for(var i=0;i<postIts.length;i++){
			Effect.Appear(postIts[i],{duration:.5});
		}
		//Effect.Appear(postiItArea,{duration:.5});
		postiItArea.style.zIndex=20;
	}
	catch(e){}
}

function postitsToBack(){
	postitsState="back";
	try{
		for(var i=0;i<postIts.length;i++){
			new Effect.Opacity(postIts[i], {duration:.5, from:1.0, to:0.5});
		}
		//new Effect.Opacity(postiItArea, {duration:.5, from:1.0, to:0.5});
		postiItArea.style.zIndex=3;
	}
	catch(e){}
}

function sortPostits(sortMethod){
	switch(sortMethod){
		case 'cascade':
			sortPostitsCascade();
		break;
		case 'hotizontally':
			sortPostitsHorizontal();
		break;
	}
}

function sortPostitsCascade(){
	var x=10;
	var y=10;
	for(var i=0;i<postIts.length;i++){
		postIts[i].style.left=x+"px";
		postIts[i].style.top=y+"px";
		x+=20;
		y+=20;
	}
}

function sortPostitsHorizontal(){
	var postitWidth=postIts[0].clientWidth+10;
	var postitHeight=postIts[0].clientHeight+10;
	var stageWidth=getStageWidth();
	cantPerLine=Math.floor(stageWidth/postitWidth);
	for(var i=0;i<postIts.length;i++){
		var position=i;
		var y=0;
		while(position>=cantPerLine){
			position-=cantPerLine;
			y++;
		}
		postIts[i].style.left=((position*postitWidth)+10)+"px";
		postIts[i].style.top=((y*postitHeight)+10)+"px";
	}
}

function getPostitObject(atts){
	var obj=new element({name:("Postit "+atts.text),
	atts:{text:atts.text,postit:true},
	text:atts.text,
	icon:"styles/"+currStyle+"/images/postit_icon_50x50.png",
	dblClickDo:function(icon){
		addPostit(icon.getObject().atts.text);
		icon.remove();
	} });
	return obj;
}

function setPostitsVisibility(vis){
	postitsState=vis;
	if(vis=="hidden"){
		hidePostits();
	}else if(vis=="shown"){
		showPostits();
	}else if(vis=="back"){
		postitsToBack();
	}
}