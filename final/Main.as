package 
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.ui.Mouse;

	public class Main extends MovieClip
	{

		var gameObj:GameManager;
		var gameOverScreen:GameOverScreen;
		var introScreen:IntroScreen;
		var healthBar:HealthBar;
		var _levelNumber:Number = 1;

		public function Main()
		{
			// constructor code
			gameOverScreen = new GameOverScreen();
			introScreen = new IntroScreen();
			addChild(introScreen);
			introScreen.playBtn.addEventListener(MouseEvent.CLICK,onPlayButtonClick);
			stage.stageFocusRect = false;

		}

		function onPlayButtonClick(event:MouseEvent):void
		{
			removeChild(introScreen);
			startGame();
			var gameSfx = new GameSfx();
			var bg_music : SoundChannel = gameSfx.play(0, int.MAX_VALUE);
			bg_music.soundTransform = new SoundTransform(.5,0);
		}

		public function startGame()
		{
			gameObj = undefined;
			gameObj = new GameManager();
			
			addChild(gameObj);
			stage.focus = gameObj;

		}
		
		public function restartGame()
		{	
			addChild(gameObj);
			stage.focus = gameObj;
		}

		public function nextLevel()
		{
			nextScene();
			_levelNumber += 1;
			removeChild(gameObj);
			addChild(gameObj);
			stage.focus = gameObj;
		}

		public function endGame()
		{
			Mouse.show();
			SoundMixer.stopAll();
			removeChild(gameObj);
			gameObj = null;
			addChild(gameOverScreen);
			gameOverScreen.replayBtn.addEventListener(MouseEvent.CLICK,onReplayButtonClick);
		}
		
		function onReplayButtonClick(event:MouseEvent):void
		{
			removeChild(gameOverScreen);
			gameObj = null;
			startGame();
			var gameSfx = new GameSfx();
			var bg_music : SoundChannel = gameSfx.play(0, int.MAX_VALUE);
			bg_music.soundTransform = new SoundTransform(.5,0);
		}
	}
}