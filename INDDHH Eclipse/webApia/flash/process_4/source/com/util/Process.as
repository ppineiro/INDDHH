//----------------------------------------------------------------------------------
// ProcessClass
//----------------------------------------------------------------------------------
// Created and copyright held by:
// Jesse R. Warden (jesterxl@jessewarden.com)
// April 23, 2003
//----------------------------------------------------------------------------------
// Simulate a for loop using a more processor friendly solution
//----------------------------------------------------------------------------------

/*
// Example (put on main timeline):
onProcess = function(current, goal, increment){
	trace("current: " + current);
	trace("goal: " + goal);
	trace("increment: " + increment);
};

onDone = function(current, goal, increment){
	trace("current: " + current);
	trace("goal: " + goal);
	trace("increment: " + increment);
};
process1 = new ProcessClass(0, 10, 1, "onProcess", this, "onDone", this);
// You can now start via:
// process1.startProcess();
// and prematurely abort via:
// process1.abortProcess();
// 
*/

//----------------------------------------------------------------------------------
// License For Use
//----------------------------------------------------------------------------------
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
// 
// 3. The name of the author may not be used to endorse or promote products derived
// from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
// EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
// OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
// IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
// OF SUCH DAMAGE.
//----------------------------------------------------------------------------------

_global.ProcessClass = function(start,
								end,
								increment,
								callbackHandler,
								callbackObject,
								doneHandler,
								doneObject){
	
	this.init.apply(this, arguments);
};

ProcessClass.prototype.init = function(start,
									   end,
									   increment,
									   callbackHandler,
									   callbackObject,
									   doneHandler,
									   doneObject){
	
	this.start = start;
	this.end = end;
	this.increment = increment;
	this.callbackHandler = callbackHandler;
	this.callbackObject = callbackObject;
	this.doneHandler = doneHandler;
	this.doneObject = doneObject;
	
	clearInterval(this.processID);
	this.processID = null;
	
	if(this.start == this.end){
		this.endProcess();
	}else if(this.increment == 0){
		this.endProcess();
	}else if(this.increment > 0 && this.start >= this.end){
		this.endProcess();
	}else if(this.increment < 0 && this.start <= this.end){
		this.endProcess();
	}else{
		this.startProcess();
	}
};

// ##################################################
// The only public method
ProcessClass.prototype.startProcess = function(){
	clearInterval(this.processID);
	this.processID = setInterval(this, "process", 0);
};

ProcessClass.prototype.abortProcess = function(){
	clearInterval(this.processID);
	this.processID = null;
};
// ##################################################

ProcessClass.prototype.process = function(){
	this.callbackObject[this.callbackHandler](this.start, this.end, this.increment);
	this.start += this.increment;
	if(this.increment > 0){
		if(this.start >= this.end){
			this.endProcess();
		}
	}else if(this.increment < 0){
		if(this.start <= this.end){
			this.endProcess();
		}
	}
};

ProcessClass.prototype.endProcess = function(){
	clearInterval(this.processID);
	this.processID = null;
	this.doneObject[this.doneHandler](this.start, this.end, this.increment);
};