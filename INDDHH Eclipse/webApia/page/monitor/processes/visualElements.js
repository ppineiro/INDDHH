var arrayColors = [];

function initVisualElements() {
	
	//*************** FIGURES *************
	
	//Creates an empty figure
	go.Shape.defineFigureGenerator("Empty", function(shape, w, h) {
	    return new go.Geometry();
	});

	// Represents the cross on a task indicating the element is a subprocess
	go.Shape.defineFigureGenerator("SubpIndicator", function(shape, w, h) {
		var geo = new go.Geometry();
		var fig = new go.PathFigure(w,0,false);
		geo.add(fig);

		fig.add(new go.PathSegment(go.PathSegment.Line, 0, 0));
		fig.add(new go.PathSegment(go.PathSegment.Line, 0, h));
		fig.add(new go.PathSegment(go.PathSegment.Line, w, h));
		fig.add(new go.PathSegment(go.PathSegment.Line, w, 0));
		
		fig.add(new go.PathSegment(go.PathSegment.Move, 0.5*w, 0.2*h));
		fig.add(new go.PathSegment(go.PathSegment.Line, 0.5*w, 0.8*h));

		fig.add(new go.PathSegment(go.PathSegment.Move, 0.2*w, 0.5*h));
		fig.add(new go.PathSegment(go.PathSegment.Line, 0.8*w, 0.5*h));

		return geo;
	});

	//Draw an operator of tyoe event
	go.Shape.defineFigureGenerator("EventOp", function(shape, w, h) {
		var geo = new go.Geometry();
		var fig = new go.PathFigure(w, 0.5*w, false);
		geo.add(fig);

		var rad1 = 0.5*w;
		var rad2 = rad1 + 3;

		//Ring
		fig.add(new go.PathSegment(go.PathSegment.Arc, 0, 360, rad1, rad1, rad1, rad1).close());
		fig.add(new go.PathSegment(go.PathSegment.Move, 0.5*w + rad2, 0.5*w));
		fig.add(new go.PathSegment(go.PathSegment.Arc, 0, 360, rad1, rad1, rad2, rad2).close());

		//Pentagon
		fig.add(new go.PathSegment(go.PathSegment.Move, 0.5*w, 0.1*w));
		fig.add(new go.PathSegment(go.PathSegment.Line, 0.1*w, 0.4*w));
		fig.add(new go.PathSegment(go.PathSegment.Line, 0.3*w, 0.8*w));
		fig.add(new go.PathSegment(go.PathSegment.Line, 0.7*w, 0.8*w));
		fig.add(new go.PathSegment(go.PathSegment.Line, 0.9*w, 0.4*w).close());

		return geo;

	});

	go.Shape.defineFigureGenerator("DoubleTriangle", function(shape, w, h) {
		var geo = new go.Geometry();
		var fig = new go.PathFigure(w, h, false);
		geo.add(fig);

		fig.add(new go.PathSegment(go.PathSegment.Line, 0.5*w, 0.5*h));
		fig.add(new go.PathSegment(go.PathSegment.Line, 0, h).close());

		fig.add(new go.PathSegment(go.PathSegment.Move, w, 0.5*h));
		fig.add(new go.PathSegment(go.PathSegment.Line, 0.5*w, 0));
		fig.add(new go.PathSegment(go.PathSegment.Line, 0, 0.5*h).close());

		return geo;
	});	
	

	
	
	//************************* MODEL START ****************************
	var gom = go.GraphObject.make;
	
	// Tooltip showing node information
	var elemInfo = 
		gom(go.HTMLInfo,
			{show: showElemInfo, hide: hideElemInfo}
		);
	// var diagram = new go.Diagram("myDiv");
	
	var diagram = 
		gom(go.Diagram, "jsonTable",
			{
				allowDelete: false,
				initialContentAlignment: go.Spot.Center,
//				autoScale: go.Diagram.Uniform,
//				mouseOver: showTooltip,
				"toolManager.hoverDelay": 10,
				"toolManager.toolTipDuration": 10000,
				"toolManager.mouseWheelBehavior": go.ToolManager.WheelZoom,
				doubleClick: fitIntoScreen,
				layout: gom(go.ForceDirectedLayout,  // automatically spread nodes apart
		              { maxIterations: 100, defaultSpringLength: 10, defaultElectricalCharge: 50 })
				// al dar doble click sobre campo vacio, se puede ajustar el diagrama a la vista
//				isReadOnly: true
				
			}
		);

	// DEFINE COLORS
	var lightGreen = gom(go.Brush, "Linear", { 0: "white", 0.5: "lightgreen" });
	var lightRed = gom(go.Brush, "Linear", { 0: "white", 0.5: "#d77676" });
	var lightYellow = gom(go.Brush, "Linear", { 0: "white", 0.8: "#ffffb3" });
	var lightGrey = gom(go.Brush, "Linear", { 0: "white", 0.8: "#bdbdbd" });
	var lightOrange = gom(go.Brush, "Linear", { 0: "white", 0.8: "#ffb74d" });
	var lightWhite = gom(go.Brush, "Linear", { 0: "white", 1: "white" });
	var lightSkyGrey = gom(go.Brush, "Linear", { 0:"white", 0.3:"#cfd8dc" });
	
	var darkGrey = "#37474f";
	var lighBlue = "#a7ffeb";
	
	arrayColors.push(lightGreen);
	arrayColors.push(lightRed);
	arrayColors.push(lightYellow);
	arrayColors.push(lightGrey);
	arrayColors.push(lightOrange);
	arrayColors.push(lightSkyGrey);
	
	//Selection templates
	
	var templateAdornmentRectangle = 
		gom(go.Adornment, "Auto",
			{layerName: "Grid"},
			gom(go.Shape, "RoundedRectangle", {fill: lighBlue, stroke: null, parameter1: 15, desiredSize: new go.Size(100,60)}),
			gom(go.Placeholder)

		);

	var templateAdornmentCircle = 
		gom(go.Adornment, "Auto",
			{layerName: "Grid"},
			gom(go.Shape, "Circle", {fill: lighBlue, stroke: null, desiredSize: new go.Size(38,38)}),
			gom(go.Placeholder)
		);

	var templateAdornmentDiamond = 
		gom(go.Adornment, "Auto",
			{layerName: "Grid"},
			gom(go.Shape, "Diamond", {fill: lighBlue, stroke: null, desiredSize: new go.Size(50,50)}),
			gom(go.Placeholder)
		);

	var templateAdornmentLink =
		gom(go.Adornment, "Link");
	
	
	//************************ NODE TEMPLATES *********************
	
	// Creates a task user node
	diagram.nodeTemplateMap.add("task",
		gom(go.Node, "Auto", {zOrder: 0, toolTip: elemInfo, selectionAdornmentTemplate: templateAdornmentRectangle},
			new go.Binding("location", "location", go.Point.parse).makeTwoWay(go.Point.stringify),
			gom(go.Panel, "Spot", 
				{ desiredSize: new go.Size(110, 70) },
			gom(go.Shape, "RoundedRectangle",
				{fill: lightSkyGrey, stroke: darkGrey, strokeWidth: 1, parameter1: 10, isPanelMain: true, maxSize: new go.Size(100,60)},
				new go.Binding("strokeWidth", "subprocess", function(e) {return e ? 1.5 : 1})
			),
			// For user tasks
			gom(go.Shape, "BpmnTaskUser",
				{alignment: new go.Spot(0,0,5,5), 
				alignmentFocus: go.Spot.TopLeft,
				desiredSize: new go.Size(15,15),
				fill: "white", 
				stroke: darkGrey},
				new go.Binding("figure", "subprocess", function(sb) {return !sb ? "BpmnTaskUser" : "Empty"})
			),
			// For subprocess
			gom(go.Shape, "Empty", // Subprocess figure
				{
					alignment: new go.Spot(0.5, 1),
					alignmentFocus: go.Spot.Bottom,
					fill: lightSkyGrey,
					stroke: darkGrey,
					strokeWidth: 1.5,
					desiredSize: new go.Size(15,15)
				},
				new go.Binding("figure", "subprocess", function(sb) {return sb ? "SubpIndicator" : "Empty"})
			),
			// Default text
			gom(go.TextBlock, "Default task", 
				{alignment: go.Spot.Center, textAlign: "center", font:"10px sans-serif", margin: 2},
				new go.Binding("text", "name")
			)),
			gom(go.Shape, "Empty",
				{fill: lightYellow, stroke: "yellow", strokeWidth: 1, desiredSize: new go.Size(25, 25), alignment: new go.Spot(1, 1, -5, -5)},
				new go.Binding("figure", "timer", function(t) {return t ? "Circle" : "Empty"})
			),
			gom(go.Shape, "Empty",
					{fill: lightYellow, stroke: "black", strokeWidth: 1, desiredSize: new go.Size(15, 15), alignment: new go.Spot(1, 1, -9, -9)},
					new go.Binding("figure", "timer", function(t) {return t ? "BpmnEventTimer" : "Empty"})
			)
		)
	);
	
	
	//Creates circle events: Begining, ending and intermediate events
	diagram.nodeTemplateMap.add("event",
		gom(go.Node, "Auto", {zOrder: 1, selectionAdornmentTemplate: templateAdornmentCircle},
			new go.Binding("location", "location", go.Point.parse).makeTwoWay(go.Point.stringify),
			gom(go.Panel, "Spot",
				gom(go.Shape, "Circle",
					{fill: lightYellow, stroke: "yellow", strokeWidth: 1, desiredSize: new go.Size(30,30)},
					new go.Binding ("fill", "event_type", lightColor),	//color
					new go.Binding("stroke", "event_type", evtColorWidth),	//border
					new go.Binding("strokeWidth", "event_type", function(e) { return (e == 1) ? 3 : 1 })	//border-width
				),
				gom(go.Shape, "Empty", 
					{fill: lightYellow, stroke: "yellow", desiredSize: new go.Size(30,30)},
					new go.Binding("figure", "event_type", function(inter){ return (inter == 3) ? "Ring" : "Empty" }),
					new go.Binding ("fill", "event_type", lightColor)	//color
				),
				gom(go.Shape, "Empty", 
					{alignment: go.Spot.Center, fill: lightYellow, desiredSize: new go.Size(13,13)},
					new go.Binding("figure", "element", selectElement),
					new go.Binding("fill", "event_type", lightColor)
				)
			)
		)
	);

	//Create operator figures
	diagram.nodeTemplateMap.add("operator",
		gom(go.Node, "Auto", {selectionAdornmentTemplate: templateAdornmentDiamond},
			new go.Binding("location", "location", go.Point.parse).makeTwoWay(go.Point.stringify),
			gom(go.Panel, "Spot",
				gom(go.Shape, "Diamond",
					{fill: lightOrange, stroke: "#ef6c00", desiredSize: new go.Size(40,40)}
				),
				gom(go.Shape, "Empty",
					{fill: lightOrange, stroke: "black", strokeWidth: 1, desiredSize: new go.Size(18,18)},
					new go.Binding("figure", "op_type", opType)
				)
			)
		)
	);	

	//************************ LINKS TEMPLATES ************************
	
	diagram.linkTemplate = 
		gom(go.Link, {selectionAdornmentTemplate: templateAdornmentLink},
			gom(go.Shape,
				{stroke:"#bdbdbd", strokeWidth: 2}
			),
			gom(go.Shape,
				{toArrow: "Triangle", fill: "#bdbdbd", stroke: "#bdbdbd", scale: 1.7},
				new go.Binding("toArrow", "wizzard", function(w) { return w ? "DoubleTriangle" : "Triangle" }),
				new go.Binding("scale", "wizzard", function(w) { return w ? 2.0 : 1.7 })
			),
			gom(go.TextBlock, 
				{
					textAlign: "center",
					editable: false,
					margin: 2
				},
				new go.Binding("text", "name")
			)
			
		);

	// Set diagram's model
	diagram.model = go.Model.fromJson(document.getElementById("myJson").textContent);
	
	function showTooltip(obj, div) {
		
		//use coordinates to place the information div
		
		var coordX = diagram.transformDocToView(obj.part.location).x; //gives location of element. Same as coordX of location
		var coordY = diagram.transformDocToView(obj.part.location).y;
		
		var str = '';
		str += '<b>' + TASK_STATE + '</b>' + ': ' + (obj.data.tsk_state != null ? obj.data.tsk_state : '')  + '<br>';
		if (!obj.data.subprocess && obj.data.subprocess != 1) {
			str += '<b>' + POOLS_USR + '</b>' + ': ' + (obj.data.users_pool != null ? obj.data.users_pool : '') + '<br>';
			str += '<b>' + USR + '</b>' + ': ' + (obj.data.user != null ? obj.data.user : '') + '<br>';
		}
		str += '<br>';
		str += '<b>' + QUAL_DTE + '</b>' + ': ' + (obj.data.qual_date != null ? obj.data.qual_date : '') + '<br>';
		str += '<b>' + END_DTE + '</b>' + ': ' + (obj.data.end_date != null ? obj.data.end_date : '') + '<br>';
		
		div.innerHTML= '';
		div.style.display = '';
		div.style.position = 'absolute';
		div.style.left = coordX + 100 + 'px';
		div.style.top = coordY + 20 + 'px';
		
		var titleDiv = document.createElement('div');
		titleDiv.id = 'titleDiv';
		titleDiv.className = 'titleDiv'
		var infoDiv = document.createElement('div');
		infoDiv.id = 'infoDiv';
		infoDiv.className = 'infoDiv';
		var sepDiv = document.createElement('div');
		sepDiv.id = 'sepDiv';
		sepDiv.className = 'sepDiv';
		
		div.appendChild(titleDiv);
		div.appendChild(sepDiv);
		div.appendChild(infoDiv);
		
		titleDiv.innerHTML = obj.data.name;
		infoDiv.innerHTML = str;
	}

	function showElemInfo(obj) {
		var div = document.getElementById('htmlInfo');
		showTooltip(obj, div);
	}

	function hideElemInfo() {
		$('htmlInfo').style.display = 'none';
	}
	
	function fitIntoScreen () {
		go.Diagram.Uniform;
	}
	
	$('htmlInfo').onmouseover = function() {
		$('htmlInfo').style.display = 'none';
	}
}

function selectElement(e) {
	var els = [
		"BpmnTaskMessage",
		"BpmnEventTimer",
		"BpmnEventError",
		"TriangleUp",
		"Pentagon"
	];
	if (e < els.length)
		return els[e];
	return "Empty";
}

// el orden debe corresponder con los elementos de la tabla operators
function opType(op) {
	var operators = [
		"ThinCross",
		"ThinCross",
		"ThinCross",
		"ThinX",
		"Circle"
		
	];
	if (op - 1 < operators.length)
		return operators[op - 1];
	return "Empty";
}

function lightColor(c) {
	if (c < arrayColors.length)
		return arrayColors[c];
	return lightWhite;
}

function evtColorWidth (ev) {
	//0: Start, 2: Intermediate, 1: End
	var colors = [
		"green",
		"red", 
		"yellow"
	];
	if (ev < colors.length)
		return colors[ev];
	return "black";
}
