package 
{

	import flash.display.MovieClip;
	import flashx.textLayout.formats.Float;
	import flash.events.*;
	import flash.utils.Timer;

	public class Player extends MovieClip
	{
		private var _inputObj:InputManager;
		private var _gameObj:GameManager;
		private var playerObj:Player;
		
		private var missiles:Array;
		static const missileSpeed:Number = .2;

		private var _vx:Number = 0;
		private var _vy:Number = 0;
		private var _speed:Number = 0.025;

		private var _ax:Number = 0;
		private var _ay:Number = 0;
		private var _speedMax = 8;

		private var _friction:Number = 0.1;
		private var _bounce:Number = -0.1; //-0.15
		private var _bounceX:Boolean = false;
		private var _bounceY:Boolean = false;

		private var _halfHeight:Number;
		private var _halfWidth:Number;
		private var _xd:Number;

		private var _isGrounded:Boolean = false;
		private var _jumpForce:Number = -9.5;
		private var _airControl:Number = 0.5;
		
		var _walkTimer:Timer = new Timer(100, 1);


		public function Player(game: GameManager, input : InputManager)
		{
			_walkTimer.start();
			
			_gameObj = game;
			_inputObj = input;

			_halfHeight = this.hitBox.height / 2;
			_halfWidth = this.hitBox.width / 2;
			
			addEventListener(Event.ENTER_FRAME, updateMC);
		}
		
		public function updateMC(event:Event)
		{
			_walkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, updateWalk);
		}
		
		public function updateWalk(event:TimerEvent)
		{
			_walkTimer.stop();
			_walkTimer.start();
			if(_vx == 0){
				this.legs.gotoAndStop("stand");
			}
			if(_vx !=0 && _isGrounded){
				this.legs.gotoAndStop("walk");
			}
			//if(_vx > .1 && _isGrounded){
				//this.legs.gotoAndStop("walk");
			//}
		}

		public function update(timePassed:uint)
		{
			//collect horizontal input and apply it to the accelartion;
			_ax = _inputObj.horizontalInput * _speed * timePassed;
			
			//apply aircontrol
		
			_vx +=  _ax;
			
			//apply friction if there is no horizontal input
			if (_inputObj.horizontalInput == 0)
			{
				_vx *=  _friction;
			}


			//cap the speed
			if (_vx > _speedMax)
			{
				_vx = _speedMax;
			}
			if (_vx < -_speedMax)
			{
				_vx =  -  _speedMax;
			}

			//gravity
			_ay = _gameObj.gravity * timePassed;
			_vy +=  _ay;

			//jump
			if (_inputObj.jumpButton && _isGrounded)
			{
				_vy = _jumpForce;
				
			}
			
			//trim low speeds
			if (Math.abs(_vx) < 0.1)
			{
				_vx = 0;
			}
			if (Math.abs(_vy) < 0.1)
			{
				_vy = 0;
			}
			
			//apply speeds
			this.x +=  _vx;
			this.y +=  _vy;
			
			if (( this.x + this.hitBox.x ) + _halfWidth > stage.stageWidth)
			{
				this.x = stage.stageWidth - _halfWidth - this.hitBox.x;
				_vx *= _bounce;
			}
			if ( (this.x + this.hitBox.x ) < _halfWidth)
			{
				this.x = _halfWidth - this.hitBox.x;
				_vx *= _bounce;
			}

			if (this.hitBox.y + this.y + _halfHeight > stage.stageHeight)
			{
				this.y = stage.stageHeight - _halfHeight - this.hitBox.y;
				_vy *= _bounce;
				_isGrounded = true;
			}
			else 
				_isGrounded = false;
			
			if ( (this.y + this.hitBox.y) + _halfHeight < 0)
			{
				this.y = _halfHeight - this.hitBox.y;
				_vy *= _bounce;
			}
		
		}
		
		function collide(obj:Block)
		{
			var dx:Number = (this.x + this.hitBox.x) - obj.x;
			var dy:Number = (this.y + this.hitBox.y) - obj.y;
			
			var ox:Number = (_halfWidth + obj.width/2) - Math.abs(dx);
			var oy:Number = (_halfHeight + obj.height/2) -  Math.abs(dy);
			
			var tx = _vx;
			var ty = _vy;
			
			if (ox < oy)
			{
				ty  = 0;
				if (dx < 0 )
				{
					//left
					ox *= -1;
					oy = 0;
					
					if (_vx > 0)
						_vx *= _bounce;
					
				}	
				else
				{	//right
				
					oy = 0;
					if (_vx < 0)
						_vx *= _bounce;
					
				}
			}
			else
			{
				tx  = 0;
				if (dy < 0 )
				{
					//up
					oy *= -1;
					ox = 0;
					if(_vy > 0)
						_vy *= _bounce;
					//_isGrounded = true;
					
				}
				else
				{	//down
					
					ox = 0;
					if(_vy < 0)
						_vy *= _bounce;
				}
			}
			
			this.x += ox;
			this.y += oy;
			
			if (obj.hitTestPoint(this.x, this.y + _halfHeight + 0.1, false))
				_isGrounded = true;
		}
	}
}