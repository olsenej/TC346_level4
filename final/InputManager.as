package 
{
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.utils.Timer;

	public class InputManager extends MovieClip
	{

		// arrow keys
		private var _rightArrow:Boolean = false;
		private var _leftArrow:Boolean = false;
		private var _downArrow:Boolean = false;
		private var _upArrow: Boolean = false;
		private var _click: Boolean = false;
		
		public function InputManager()
		{
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event)
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownEvent);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpEvent);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownEvent);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpEvent);
			
		}

		private function onKeyDownEvent(event:KeyboardEvent)
		{
			if(event.keyCode == 65)
				_leftArrow = true;
			if(event.keyCode == 68)
				_rightArrow = true;
			if(event.keyCode == 83)
				_downArrow = true;
			if(event.keyCode == 87)
				_upArrow = true;
		}

		private function onKeyUpEvent(event:KeyboardEvent)
		{
			if(event.keyCode == 65)
				_leftArrow = false;
			if(event.keyCode == 68)
				_rightArrow = false;
			if(event.keyCode == 83)
				_downArrow = false;
			if(event.keyCode == 87)
				_upArrow = false;
		}
		
		private function onMouseDownEvent(event:MouseEvent)
		{
			if(MouseEvent.MOUSE_DOWN)
				_click = true;
		}
		
		private function onMouseUpEvent(event:MouseEvent)
		{
			if(MouseEvent.MOUSE_UP)
				_click = false;
		}
		
		public function get horizontalInput():Number
		{
			var val:Number = 0;
			
			if(_leftArrow)
				val--; 
			
			if(_rightArrow)
				val++;
			
			return val;
		}
		
		public function get jumpButton():Boolean
		{	
			return _upArrow;
		}
		
		public function get enterDoor():Boolean
		{
			return _downArrow;
		}
		
		public function get shootClick():Boolean
		{
			return _click;
		}
		
		public function updateClick()
		{
			_click=false;
		}
		
	}

}