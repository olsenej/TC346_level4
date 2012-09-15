package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.geom.Point;

	public class GameManager extends MovieClip
	{

		var inputObj:InputManager;
		var playerObj:Player;
		var _bar:HealthBar;
		var healthbar:HealthBar;
		var enemySpeed:int;
		var _xd: Number;
		var _myCursor = new Crosshair();
		var _newMissile:Missile = new Missile();
		var enemyHealth: uint = 5;
		var numberBullets = 0;
		var point:Point
		var globalPoint:Point;
		var timePassed:uint;
		var lastTime: uint = 0;
		var _turretTimer:Timer = new Timer(3000, 1); // 3 seconds
		var _newMissile2:TurretMissile = new TurretMissile();
		
		var gravity:Number = 0.02;
		public var gameOverVar:Boolean = false;
		public var nextLevel:Boolean = false;
		var levelNumber:Number = 0;
		var noHealth:Boolean = false;
		
		var blockList:Array;
		var missiles:Array;
		var enemies:Array;
		var genemies:Array;
		var hearts:Array;
		var entrance:Array;
		var exit:Array;
		var turrets:Array;
		var turretmissiles:Array;
		var spikes:Array;
		static const missileSpeed:Number = .35;
		
		public function GameManager()
		{
			// constructor code
			
			inputObj  = new InputManager();
			playerObj = new Player(this, inputObj);
			blockList = new Array();
			missiles = new Array();
			enemies = new Array();
			hearts = new Array();
			genemies = new Array();
			entrance = new Array();
			exit = new Array();
			turrets = new Array();
			turretmissiles = new Array();
			spikes = new Array();
			addChild(inputObj);
			addChild(playerObj);
						
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, gameLoop);
	
		}
		
		private function init(e:Event)
		{
			
			levelNumber += 1;
			
			if(levelNumber == 1){
				playerObj.x = 187;
				playerObj.y = 536;
			}
			if(levelNumber == 2){
				playerObj.x = 49;
				playerObj.y = 115;
			}
			if(levelNumber == 3){
				playerObj.x = 50;
				playerObj.y = 536;
			}
			if(levelNumber == 4){
				playerObj.x = 728;
				playerObj.y = 233;
			}
			if(levelNumber == 5){
				playerObj.x = 727;
				playerObj.y = 232;
			}
			
			healthbar = new HealthBar(20, 20, 200, 20, 0x000000, 0xFF0000);
			addChild(healthbar);
			_turretTimer.start();
			nextLevel = false;
			
			for (var q:int = 0; q < parent.numChildren; q++)
			{
				if(parent.getChildAt(q).name.substr(0, 5) == "enter")
				{
					entrance.push(parent.getChildAt(q));
					trace("enter");
				}
			}
			
			for (var i:int = 0; i < parent.numChildren; i++)
			{
				if(parent.getChildAt(i).name.substr(0, 5) == "block")
				{
					blockList.push(parent.getChildAt(i));
				}
			}
			
			for (var j:int = 0; j < parent.numChildren; j++)
			{
				if(parent.getChildAt(j).name.substr(0, 5) == "enemy")
				{
					enemies.push(parent.getChildAt(j));
				}
			}
			
			for (var p:int = 0; p < parent.numChildren; p++)
			{
				if(parent.getChildAt(p).name.substr(0, 6) == "genemy")
				{
					genemies.push(parent.getChildAt(p));
				}
			}
			
			for (var k:int = 0; k < parent.numChildren; k++)
			{
				if(parent.getChildAt(k).name.substr(0, 5) == "heart")
				{
					hearts.push(parent.getChildAt(k));
				}
			}
			
			for (var l:int = 0; l < parent.numChildren; l++)
			{
				if(parent.getChildAt(l).name.substr(0, 4) == "exit")
				{
					exit.push(parent.getChildAt(l));
				}
			}
			
			for (var n:int = 0; n < parent.numChildren; n++)
			{
				if(parent.getChildAt(n).name.substr(0, 6) == "turret")
				{
					turrets.push(parent.getChildAt(n));
				}
			}
			
			for (var m:int = 0; m < parent.numChildren; m++)
			{
				if(parent.getChildAt(m).name.substr(0, 5) == "spike")
				{
					spikes.push(parent.getChildAt(m));
				}
			}
			
		}
		
		public function gameLoop(event:Event)
		{
			timePassed = getTimer() - lastTime;
			lastTime += timePassed;
			
			playerObj.update(timePassed);
			
			checkBlockCollision();
			checkEnemyCollision();
			checkGroundEnemyCollision();
			checkSpikeCollision();
			checkHeartCollision();
			checkMissileCollision();
			checkHitEnemy();
			checkHitGroundEnemy();
			checkExit();
			faceDirection();
			changeMouse();
			moveArm();
			newMissile();
			moveMissiles(timePassed);
			moveTurrets(timePassed);
			moveTurretMissiles(timePassed);
			checkTurretMissileCollision();
			checkTurretCollision();
			checkHitTurret();
			_turretTimer.addEventListener(TimerEvent.TIMER_COMPLETE, newTurretMissile);
			
			if(gameOverVar)
			{
				_turretTimer.stop();
			
				blockList=[];
				enemies=[];
				genemies=[];
				hearts=[];
				exit=[];
				turrets=[];
				spikes=[];
				
				blockList=null;
				enemies=null;
				genemies=null;
				hearts=null;
				exit=null;
				turrets=null;
				spikes=null;
				
				removeEventListener(Event.ADDED_TO_STAGE, init);				
				removeEventListener(Event.ENTER_FRAME, gameLoop);
				
				removeChild(inputObj);
				removeChild(playerObj);
				
				Main(parent).endGame();
			}
			
			if(nextLevel)
			{
				blockList.splice(0,blockList.length);
				enemies.splice(0,enemies.length);
				genemies.splice(0,genemies.length);
				hearts.splice(0,hearts.length);
				exit.splice(0,exit.length);
				turrets.splice(0,turrets.length);
				spikes.splice(0,spikes.length);
				
				Main(parent).nextLevel();
				nextLevel = false;
				
				removeEventListener(Event.ADDED_TO_STAGE, init);
				addEventListener(Event.ADDED_TO_STAGE, init);
				
				removeEventListener(Event.ENTER_FRAME, gameLoop);
				addEventListener(Event.ENTER_FRAME, gameLoop);
			}
			
			if(noHealth){
				//remove
				//removeChild(playerObj);
				
				/*healthbar.resetHealth();
				if(levelNumber == 1){
					playerObj.x = 220;
					playerObj.y = 565;
					}
				if(levelNumber == 2){
					playerObj.x = 100;
					playerObj.y = 147;
					}
				if(levelNumber == 3){
					playerObj.x = 220;
					playerObj.y = 568;
					}*/
				}
			
			}
			
		public function checkExit()
		{
			exit: for(var k:int=exit.length-1;k>=0;k--) {
				if(playerObj.hitTestObject(exit[k]) ){
					if (inputObj.enterDoor){
						nextLevel = true;
						trace("next");
					}
				}
			}
		}
		
		public function checkBlockCollision()
		{
			for (var i = 0; i < blockList.length; i++)
			
			{
				if( playerObj.hitBox.hitTestObject(blockList[i]) )
					playerObj.collide(blockList[i]);
			}
		}
		
		public function checkEnemyCollision()
		{
			
			for (var j = 0; j < enemies.length; j++){
				if( playerObj.hitTestObject(enemies[j]) ){
					healthbar.subtractHealth(1.5);
					healthbar.updateHealth();
					healthbar.displayHealth();
  						 if(healthbar.getHealth() < .2){
							 //noHealth = true;
							 gameOverVar = true;
      					}
					}
			}
		}
		public function checkGroundEnemyCollision()
		{
			
			for (var j = 0; j < genemies.length; j++){
				if( playerObj.hitTestObject(genemies[j]) ){
					healthbar.subtractHealth(1.5);
					healthbar.updateHealth();
					healthbar.displayHealth();
  						 if(healthbar.getHealth() < .2){
							 //noHealth = true;
							 gameOverVar = true;
      					}
					}
			}
		}
		public function checkTurretCollision()
		{
			
			for (var j = 0; j < turretmissiles.length; j++){
				if(turretmissiles[j].hitTestObject(playerObj) ){
					turretMissileHit(j)
					healthbar.subtractHealth(15);
					healthbar.updateHealth();
					healthbar.displayHealth();
  						 if(healthbar.getHealth() < .2){
							 //noHealth = true;
							 gameOverVar = true;
      					}
					}
			}
		}
		
		public function get gameOver():Boolean
		{
			return gameOverVar;
			trace("return");
		}
		
		public function checkHeartCollision()
		{
			for (var k = 0; k < hearts.length; k++){
				if(playerObj.hitTestObject(hearts[k]) ){
					healthbar.addHealth(30);
					healthbar.updateHealth();
					healthbar.displayHealth();
					hearts[k].gotoAndPlay(2);
					hearts.splice(k,1);
					}
			}
		}
		
		public function checkMissileCollision()
		{
			blockList: for(var j:int=blockList.length-1;j>=0;j--) {
				missiles: for(var i:int=missiles.length-1;i>=0;i--) {
						if (missiles[i].hitTestObject(blockList[j])){
						missileHit(i);
					}
				}
			}
		}
		
		public function checkTurretMissileCollision()
		{
			blockList: for(var j:int=blockList.length-1;j>=0;j--) {
				turretmissiles: for(var i:int=turretmissiles.length-1;i>=0;i--) {
						if (turretmissiles[i].hitTestObject(blockList[j])){
						turretMissileHit(i);
						}
				}
			}
		}
		
		public function checkHitEnemy()
		{
			enemies: for(var k:int=enemies.length-1;k>=0;k--) {
				// loop through missiles
				missiles: for(var i:int=missiles.length-1;i>=0;i--) {
						if (missiles[i].hitTestObject(enemies[k])){
							missileHit(i);
							enemies[k].gotoAndPlay(2);
							enemies.splice(k,1);
						}
				}
			}
		}
		
		public function checkHitGroundEnemy()
		{
			enemies: for(var k:int=genemies.length-1;k>=0;k--) {
				// loop through missiles
				missiles: for(var i:int=missiles.length-1;i>=0;i--) {
						if (missiles[i].hitTestObject(genemies[k])){
							missileHit(i);
							genemies[k].gotoAndPlay("dead");
							genemies.splice(k,1);
						}
				}
			}
		}
		
		public function checkSpikeCollision()
		{
			spikes: for(var k:int=spikes.length-1;k>=0;k--) {
						if (playerObj.hitTestObject(spikes[k])){
							healthbar.subtractHealth(5);
							healthbar.updateHealth();
							healthbar.displayHealth();
  								 if(healthbar.getHealth() < .2){
							 //noHealth = true;
							 gameOverVar = true;
						}
				}
			}
		}
		
		public function moveTurrets(timeDiff:uint)
		{
			turrets: for(var k:int=turrets.length-1;k>=0;k--) {
				var point:Point = new Point(turrets[k].rotateTurret.x, turrets[k].rotateTurret.y);
				point = turrets[k].rotateTurret.parent.localToGlobal(point);
				var opposite:Number = point.y - playerObj.y;
				var adjacent:Number = point.x - playerObj.x;
				var radians:Number = Math.atan2(opposite, adjacent);
				var degrees:Number = radians * (180 / Math.PI ) + 90;
				turrets[k].rotateTurret.rotation = degrees;
			}
		}
		
		public function checkHitTurret()
		{
			turrets: for(var k:int=turrets.length-1;k>=0;k--) {
				// loop through missiles
				missiles: for(var i:int=missiles.length-1;i>=0;i--) {
						if (missiles[i].hitTestObject(turrets[k])){
							missileHit(i);
						}
				}
			}
		}
		
		public function missileHit(missileNum:uint) {
			removeChild(missiles[missileNum]);
			missiles.splice(missileNum,1);
			numberBullets -= 1;
		}
		
		public function turretMissileHit(missileNum2:uint) {
			removeChild(turretmissiles[missileNum2]);
			turretmissiles.splice(missileNum2,1);
		}
		
		public function faceDirection()
		{
			_xd = mouseX - playerObj.x;
			if (_xd > 0) {
				playerObj.gotoAndStop(1);
			}
			if (_xd < 0) {
				playerObj.gotoAndStop(2);
			}
		}
		
		public function changeMouse()
		{
			Mouse.hide();
			
			addChild(_myCursor);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
	
		public function mouseMoveHandler(evt:MouseEvent):void
		{
			_myCursor.x = evt.stageX;
			_myCursor.y = evt.stageY;
		}
		
		public function moveArm()
		{
			var radian:Number = Math.atan2(mouseY-playerObj.y, mouseX-playerObj.x);
			var radianDegree:Number = Math.round((radian * 180 / Math.PI));
			
			if (_xd > 0) {
				playerObj.arm.rotation = radianDegree - 90;
				playerObj.arm.scaleY = -1;
				
			}
			if (_xd < 0) {
				playerObj.arm.rotation = radianDegree + 90;
				playerObj.arm.scaleY = 1; 
			}
		}
		
		public function newMissile() {
			var _newMissile:Missile = new Missile();
			
			var radian:Number = Math.cos(mouseX-playerObj.x);
			var radianDegree:Number = Math.round((radian * 180 / Math.PI));
			
			if (_xd < 0) {
			_newMissile.dx = -(Math.cos(Math.PI*(playerObj.arm.rotation + 90)/180));
			_newMissile.dy = -(Math.sin(Math.PI*(playerObj.arm.rotation + 90)/180));
			}
			
			if (_xd > 0) {
			_newMissile.dx = Math.cos(Math.PI*(playerObj.arm.rotation + 90)/180);
			_newMissile.dy = Math.sin(Math.PI*(playerObj.arm.rotation + 90)/180);
			}
			
			// placement
			var point:Point = new Point(playerObj.arm.guntip.x, playerObj.arm.guntip.y);
			point = playerObj.arm.guntip.parent.localToGlobal(point);
			
			_newMissile.x = point.x;
			_newMissile.y = point.y;

			//if (numberBullets == 0){
				if (inputObj.shootClick==true){
				 
				addChild(_newMissile);
				missiles.push(_newMissile);
				inputObj.updateClick();
				numberBullets += 1;
				
			//}
			}
		}
		
		public function moveMissiles(timeDiff:uint) {
			// for each missile that has been created
			for(var i:int=missiles.length-1;i>=0;i--) {
				// move
				missiles[i].x += missiles[i].dx*missileSpeed*timeDiff;
				missiles[i].y += missiles[i].dy*missileSpeed*timeDiff;
				// moved off screen
				if ((missiles[i].x < 0) || (missiles[i].x > 800) || (missiles[i].y < 0) || (missiles[i].y > 600)) {
					missileHit(i);
				}
			}
		}
		
		public function newTurretMissile(event:TimerEvent) {
			turrets: for(var k:int=turrets.length-1;k>=0;k--) {
				var point:Point = new Point(turrets[k].rotateTurret.x, turrets[k].rotateTurret.y);
				point = turrets[k].rotateTurret.parent.localToGlobal(point);
				var _xd =  playerObj.x - point.x;
				var radian:Number = Math.cos(playerObj.x - point.x);
				var radianDegree:Number = Math.round((radian * 180 / Math.PI));
			
				if (_xd < 0) {
					_newMissile2.dx = -(Math.cos(Math.PI*(turrets[k].rotateTurret.rotation - 90)/180));
					_newMissile2.dy = -(Math.sin(Math.PI*(turrets[k].rotateTurret.rotation - 90)/180));
				}
			
				if (_xd > 0) {
					_newMissile2.dx = Math.cos(Math.PI*(turrets[k].rotateTurret.rotation + 90)/180);
					_newMissile2.dy = Math.sin(Math.PI*(turrets[k].rotateTurret.rotation + 90)/180);
				}
				
				var point2:Point = new Point(turrets[k].rotateTurret.turrettip.x, turrets[k].rotateTurret.turrettip.y);
				point2 = turrets[k].rotateTurret.turrettip.parent.localToGlobal(point2);
			
				_newMissile2.x = point2.x;
				_newMissile2.y = point2.y;
				
				addChild(_newMissile2);
				turretmissiles.push(_newMissile2);
				_turretTimer.stop();
				_turretTimer.start();
			}
		}
		
		public function moveTurretMissiles(timeDiff:uint) {
			for(var i:int=turretmissiles.length-1;i>=0;i--) {
				turretmissiles[i].x += turretmissiles[i].dx*missileSpeed*timeDiff;
				turretmissiles[i].y += turretmissiles[i].dy*missileSpeed*timeDiff;
				if ((turretmissiles[i].x < 0) || (turretmissiles[i].x > 800) || (turretmissiles[i].y < 0) || (turretmissiles[i].y > 600)) {
					turretMissileHit(i);
				}
			}
		}
	}

}