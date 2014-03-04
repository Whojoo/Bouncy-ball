package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import screens.TestScreen;
	import whojooEngine.Game;
	import whojooEngine.Settings;
	import whojooEngine.Vector2;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class Main extends Game 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			Settings.getInstance().setPixelPerMeter(30);
			run(30, new TestScreen());
		}
		
	}
	
}