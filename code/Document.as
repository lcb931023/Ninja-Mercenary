﻿package code{	import flash.ui.Mouse;//just to hide the mouse. (Yeah, really.)	import flash.display.MovieClip;	import flash.events.*;	//imports for the scope	import flash.display.BitmapData;	import flash.display.Bitmap;	import flash.geom.Matrix;	public class Document extends MovieClip	{		/////////////////PROPERTY FOR SHOOTING GAME///////////////////////		private var badGuys:Array;		private var deathNumber:Number;//amount of bad guys!		private var ammo:int;//how many bullet u have		//////////***///***///PROPERTIES FOR SNIPING GAME///***///***/////////////		//for the scope		private var zoom:Bitmap;		private var zoomData:BitmapData;		private var zoomMatrix:Matrix;		private var zoomLevel:Number =5;//how much you wanna zoom!		//for the sniping sequences		private var condition:int = 0;//for switching		private var timer:int = 0;//for the timing of shots		//////////***///***///PROPERTIES FOR QTE///***///***/////////////		private var QTEfail:int = 3;						///////////////////////////////////////////////////////////		public function Document()		{			///////////////////////// constructor code			//startBtn.addEventListener(MouseEvent.CLICK, startGame);//this line is not needed because the event listener is added in the timeline. Timeline ftw. Even the one fb has.		}		//////////////////EVENT HANDLER FOR TITLE SCREENS//////////////////////////		private function startGame(e:MouseEvent):void		{			this.gotoAndPlay("start");			Mouse.hide();			//this.initGame();//done in timeline. AGAIN!		}				///////////////METHODS///////////////////////////////////////		private function initFirst()		{			condition = 0;//reset condition everytime game is reinitiated			this.stop();			this.badGuys = new Array();//put all the badGuys into an array, so we can check hit for each of them			badGuys.push(firstGameContainer.SnipingBackdrop.HeadQuarters.top_left_moving,//roof guy						 firstGameContainer.SnipingBackdrop.HeadQuarters.top_right_guy,//roof guy						 firstGameContainer.SnipingBackdrop.tollBuilding.security_guy,//security guy						 firstGameContainer.SnipingBackdrop.HeadQuarters.Doors.front_right_guy,//door guy						 firstGameContainer.SnipingBackdrop.HeadQuarters.Doors.front_left_guy,//door guy						 firstGameContainer.SnipingBackdrop.Car.car_left_guy,//car guy						 firstGameContainer.SnipingBackdrop.Car.car_right_guy//car guy 						 //,firstGameContainer.SnipingBackdrop.HeadQuarters.dumpster_guy_wrap.dumpster_guy//dont get him involved. he's just a drunky!						);			for(var i:int = 0; i < badGuys.length; i++)//add the property death to all them bad guys			{				badGuys[i].death = false;			}			deathNumber = new Number  ;//declare the length to judge when all enemies are down			deathNumber = badGuys.length;			crossHair.addEventListener(MouseEvent.MOUSE_UP, shoot,false,1);			///create the scope image/////////////////////////				///zooming the scope					//create a BitmapData					//zoomLevel=8;					zoomData = new BitmapData(scopeMask.width,scopeMask.height);					//zoom in using matrix										zoomMatrix = new Matrix();					//zoomTranslate(zoomMatrix);					zoomData.draw(firstGameContainer,zoomMatrix,null,null,null,false);					//create the resulting BitMap					zoom = new Bitmap(zoomData);					//trace("zoom X: "+zoom.x+", zoom Y: "+zoom.y+", zoom width: "+zoom.width+", zoom height: "+zoom.height);					//trace("container width:"+(stage.stageWidth-firstGameContainer.width)/2+", container height:"+(stage.stageHeight-firstGameContainer.height)/2);					this.addChild(zoom);					setChildIndex(zoom,(this.numChildren-2));setChildIndex(crossHair,(this.numChildren-1));//keep your face covered by the crosshair, zoom.				///masking the scope				zoom.mask = scopeMask;				///update the scope every frame 				scopeMask.addEventListener(Event.ENTER_FRAME,UpdateScope);		}				//translates the zoomMatrix		private function zoomTranslate(zoomMatrix:Matrix){			zoomMatrix.translate(-scopeMask.x+firstGameContainer.x+scopeMask.width/2,-scopeMask.y+firstGameContainer.y+scopeMask.height/2);//update position			zoomMatrix.scale(zoomLevel,zoomLevel);//update zoom level			zoomMatrix.translate((1-zoomLevel)*scopeMask.width/2,(1-zoomLevel)*scopeMask.height/2);		}				private function UpdateScope(e:Event):void		{			scopeMask.x=crossHair.x;			scopeMask.y=crossHair.y;			///create the scope image/////////////////////////				///zooming the scope					//					//zoom.parent.removeChild(zoom);					//create a BitmapData					zoomData.fillRect(zoomData.rect,0xFFFFFFFF);//clear the bitmap by filling it with NOTHINGNESS(imeanwhite)					//update matrix to locate the zoom						zoomMatrix.identity();//reset matrix						zoomTranslate(zoomMatrix);					//trace(-scopeMask.x+firstGameContainer.x+scopeMask.width/2);					zoomData.draw(firstGameContainer,zoomMatrix,null,null,null,false);									///masking the scope				zoom.mask = scopeMask;				///align the scope image position			//setChildIndex(zoom,1);setChildIndex(crossHair,2);			zoom.x=scopeMask.x-scopeMask.width/2;			zoom.y=scopeMask.y-scopeMask.height/2;			//zoom.alpha=0.5;//debugging code		}		private function shoot(e:MouseEvent):void		{			//Listen to da drunkie!			checkDrunkie();			//switching between situations			for (var i:int = 0; i < badGuys.length; i++)			{				if (badGuys[i].death == false)				{					if (					badGuys[i].hitTestPoint(crossHair.x, crossHair.y, true)//////////////if hit					)					{			switch(condition){				case 0://when no one is shot				if(i<=1){//if rooftop guys are shot (check index number)					//kill them					badGuys[i].getChildAt(0).gotoAndStop(2);//play dying animation; which is da child					guyDie(badGuys[i]);					deathNumber--;//decrease length										condition = 0;									if(deathNumber < 6){//if both are shot (check that by checking death number?)					condition = 1;					}				break;				}else{					sniperFail();					break;				}				case 1://when roof guys are cleared				if(				   (i==2) && 				   (firstGameContainer.SnipingBackdrop.cloud_movement.cloud.x >= 1310) && (firstGameContainer.SnipingBackdrop.cloud_movement.cloud.x <= 1780)				   ){//if security guy is shot and x-value of cloud is between bla,					//kill him					badGuys[i].getChildAt(0).gotoAndStop(2);//play dying animation; which is da child					guyDie(badGuys[i]);					deathNumber--;//decrease length					condition = 2;					break;				}else{					sniperFail();					break;				}								case 2://when security guy is cleared				if(i<=4){//if one of door guys is shot					//kill him					badGuys[i].getChildAt(0).gotoAndStop(2);//play dying animation; which is da child					guyDie(badGuys[i]);					deathNumber--;//decrease length					if(deathNumber < 3){//if both a shot (deathNumber)						removeEventListener(Event.ENTER_FRAME, sniperTimer);//remove listener for sniperTimer						timer = 0;						condition = 3;					}else{//else (meaning only one is shot)						timer = 24;//24 frame=1 sec						this.addEventListener(Event.ENTER_FRAME, sniperTimer);//add sniperTimer for enter frame. in the handler, decrease number of timer every frame					}					break;				}else{//else (meaning you went for the car guys), game over					sniperFail();					break;				}								case 3://when door guys are killed. TOO!				//the only ones left is car guys, so dont need if statement for that				//kill him				badGuys[i].getChildAt(0).gotoAndStop(2);//play dying animation; which is da child				guyDie(badGuys[i]);				deathNumber--;//decrease length				if(deathNumber < 1){//if both a shot (deathNumber)					removeEventListener(Event.ENTER_FRAME, sniperTimer);//remove listener for sniperTimer					timer = 48;//24 frame=1 sec					addEventListener(Event.ENTER_FRAME, sniperFinish);//add a countdown for finishing this game scene					break;				}else{ //(meaning only one is shot)					timer = 20;//24 frame=1 sec					addEventListener(Event.ENTER_FRAME, sniperTimer);//add sniperTimer for enter frame. in the handler, decrease number of timer every frame					break;				}															}			return;					}				}			}			//loop through badGuys to find any overlap			/*for (var i:int = 0; i < badGuys.length; i++)			{				if (badGuys[i].death == false)				{					if (					badGuys[i].hitTestPoint(crossHair.x, crossHair.y, true)//////////////if hit					)					{						badGuys[i].getChildAt(0).gotoAndStop(2);//play dying animation; which is da child						guyDie(badGuys[i]);						deathNumber--;//decrease length												trace("I'm hit! "+deathNumber);						///debugging code						//trace(i);						//trace(badGuysLength);					}				}			}*/					}										private function sniperTimer(e:Event):void{			timer--;			if(timer < 0){//when timer reaches zero, remove this listener and move to failure screen				removeEventListener(Event.ENTER_FRAME, sniperTimer);				sniperFail();			}		}				private function sniperFinish(e:Event):void{			timer--;			if(timer < 0){//when timer reaches zero, remove this listener and move to next part				removeEventListener(Event.ENTER_FRAME, sniperFinish);				sniperGarbage();//clear garbage				Mouse.show();				this.gotoAndPlay("sniper_end");//move to next game;			}		}				private function sniperFail():void{			Mouse.show();			//trace("Be careful who you shoot.");//debugging script			sniperGarbage();			this.gotoAndStop("sniper_Fail");						sniperFailScreen.restart_btn.addEventListener(MouseEvent.CLICK, gotoSniper);			sniperFailScreen.title_btn.addEventListener(MouseEvent.CLICK, gotoTitle);		}								private function sniperGarbage():void{			removeSelf(firstGameContainer);//remove sniper game elements			zoomData.dispose();//remove scope's zoom			removeEventListener(MouseEvent.MOUSE_UP, shoot);//remove listener for shooting			scopeMask.removeEventListener(Event.ENTER_FRAME,UpdateScope);//remove scope updating mechanism			crossHair.win=true;//make the crosshair stop following cursor		}				private function gotoSniper(e:MouseEvent):void{			this.gotoAndPlay("first_game");			Mouse.hide();		}		private function gotoFPS(e:MouseEvent):void{			this.gotoAndPlay("second_game");			Mouse.hide();		}		private function gotoQTE(e:MouseEvent):void{			this.gotoAndPlay("third_game");			Mouse.hide();		}		private function gotoTitle(e:MouseEvent):void{			this.gotoAndPlay("intro");			Mouse.show();		}		private function gotoCredit(e:MouseEvent):void{			this.gotoAndPlay("TitleSequence");		}				private function guyDie(badGuy:MovieClip):void{			badGuy.stop();			badGuy.death = true;		}				private function checkDrunkie():void{			if(firstGameContainer.SnipingBackdrop.HeadQuarters.dumpster_guy_wrap.dumpster_guy.hitTestPoint(crossHair.x, crossHair.y, true))			{				firstGameContainer.SnipingBackdrop.HeadQuarters.dumpster_guy_wrap.dumpster_guy.gotoAndStop(2);			}		}		public function removeSelf(self:MovieClip)		{			self.parent.removeChild(self);		}//utility function for removing movieclip onstage																					//( ͡° ͜ʖ ͡°)/////////////////***///***///SECOND GAME: FPS///***///***/////////////////( ͡° ͜ʖ ͡°)//				private function initSecond():void{			Mouse.hide();			this.stop();			this.badGuys = new Array();			badGuys.length = 0;//reset badGuys array and deathNumber			badGuys.push(secondGame.FPS_background.badGuy1_wrap,//push in enemies						 secondGame.FPS_background.badGuy2_wrap,						 secondGame.FPS_background.badGuy3_wrap,						 secondGame.FPS_background.badGuy4_wrap,						 secondGame.FPS_background.badGuy5_wrap,						 secondGame.FPS_background.badGuy6_wrap						 );			deathNumber = badGuys.length;			for(var i:int = 0; i < badGuys.length; i++)//add the property death to all them bad guys			{				badGuys[i].death = false;			}			crossHair2.addEventListener(MouseEvent.MOUSE_UP, shoot2,false,1);						ammo = 10;						timer = 15*24;//15 seconds. 24 fps			addEventListener(Event.ENTER_FRAME, FPSTimer);		}				private function shoot2(e:MouseEvent):void{			ammo --;//POSSIBLE FAILURE: OUTTA AMMO			//loop through badGuys to find any overlap			for (var i:int = 0; i < badGuys.length; i++)			{				if (badGuys[i].death == false)				{					if (					badGuys[i].hitTestPoint(crossHair2.x, crossHair2.y, true)//////////////if hit					)					{						badGuys[i].getChildAt(0).gotoAndPlay(2);//play dying animation; which is da child						guyDie(badGuys[i]);						deathNumber--;//decrease length												//trace("I'm hit! "+deathNumber);						///debugging code						//trace(i);						//trace(badGuysLength);					}				}			}						if(deathNumber < 1){				timer = 48;//24 frame=1 sec				addEventListener(Event.ENTER_FRAME, FPSFinish);//add a countdown for finishing this game scene			}						if(ammo < 0){//if runs out of ammo				FPSFail();			}								}				private function FPSTimer(e:Event){			timer--;			if(timer < 0){//when timer reaches zero, remove this listener and move to failure screen				FPSFail();			}		}				private function FPSFinish(e:Event){			removeEventListener(Event.ENTER_FRAME, FPSTimer);			timer--;			if(timer < 0){//when timer reaches zero, remove this listener and move to failure screen				removeEventListener(Event.ENTER_FRAME, FPSFinish);				FPSGarbage();//clear garbage				this.gotoAndPlay("FPS_end");//move to next game;			}		}				private function FPSGarbage():void{			removeSelf(secondGame);//remove FPS game elements			removeEventListener(MouseEvent.MOUSE_UP, shoot2);//remove listener for shoot2			crossHair2.win=true;//make the crosshair2 stop following cursor		}				private function FPSFail():void{			Mouse.show();			//trace("Be careful who you shoot.");//debugging script			removeEventListener(Event.ENTER_FRAME, FPSTimer);			FPSGarbage();			this.gotoAndStop("FPS_fail");//move to fail screen and animation			FPSFailScreen.restart_btn.addEventListener(MouseEvent.CLICK, gotoFPS);			FPSFailScreen.title_btn.addEventListener(MouseEvent.CLICK, gotoTitle);		}										//( ͡° ͜ʖ ͡°)/////////////////***///***///THIRD GAME: QTE///***///***/////////////////( ͡° ͜ʖ ͡°)//		private function initThird():void{			QTEfail = 3;		}									};																							};