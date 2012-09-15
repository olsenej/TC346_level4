package
{
	import flash.display.*;
	import flash.events.*;
	
	public class HealthBar extends MovieClip
	{
		var _bar:Sprite;
		var healthBarLevel:Number;
		
		public function HealthBar(xLoc:Number, yLoc:Number, wid:Number = 100, high:Number = 15,
								  bc:uint = 0xFF0000, fc:uint = 0x00FF00)
		{
			this.x = xLoc;
			this.y = yLoc;
			
			var hbol:Sprite = new Sprite();
			addChild(hbol);

			var ol:Graphics = hbol.graphics;
			ol.lineStyle(1, 0x000000);
			ol.beginFill(bc);
			ol.lineTo(wid,0);
			ol.lineTo(wid,high);
			ol.lineTo(0,high);
			ol.lineTo(0,0);
			ol.endFill();
			
			var hb:Sprite = new Sprite();
			hbol.addChild(hb);
			_bar = hb;
			
			var ins:Graphics = hb.graphics;
			ins.lineStyle(0, 0x000000);
			ins.beginFill(fc);
			ins.lineTo(wid,0);
			ins.lineTo(wid,high);
			ins.lineTo(0,high);
			ins.lineTo(0,0);
			ins.endFill();
		}
		
			public function subtractHealth(amount:Number)
			{
				_bar.scaleX -= amount/100;
			}
			public function addHealth(amount:Number)
			{
				_bar.scaleX += amount/100;
			}
			public function resetHealth()
			{
				_bar.scaleX = 1;
			}
			public function getHealth():Number
			{
				return _bar.scaleX*100;
			}
			public function updateHealth()
			{
				if (_bar.scaleX < 0)
					_bar.scaleX = 0;
				if (_bar.scaleX > 1)
					_bar.scaleX = 1;
			}
			public function displayHealth()
			{
				return healthBarLevel;
			}
		}
}

