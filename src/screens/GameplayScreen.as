package screens 
{
	import ui.DistanceLeftHuD;
	import ui.KeyCounter;
	import ui.KeyPointer;
	import whojooEngine.Camera;
	import whojooEngine.gameScreenManager.PlayScreen;
	import whojooEngine.Vector2;
	import ui.JumpsLeftCounter;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class GameplayScreen extends PlayScreen 
	{
		public function GameplayScreen(gravity:Vector2) 
		{
			super(gravity);
			transitionOnTime = 2;
			transitionOffTime = 2;
		}
		
		protected function addWall(x1:Number, y1:Number, width:Number, height:Number):void
		{
			components.addComponent(new JumperWall(new Vector2(x1, y1), new Vector2(x1+width, y1+height)));
		}
		
		protected function newKeyPos(x:Number, y:Number):Vector2
		{
			return new Vector2(x, y);
		}
		
		protected function addOrb(x:Number, y:Number):void
		{
			components.addComponent(new Orb(new Vector2(x, y)));
		}
		
		protected function addFinishAndKeyUI(position:Vector2, player:Player, isUserExp:Boolean):Finish
		{
			var finish:Finish = new Finish(position, player, isUserExp);
			components.addComponent(finish);
			hudComponents.addComponent(new KeyCounter(finish, new Vector2(550, 500))); 
			hudComponents.addComponent(new KeyPointer(finish, Camera.getInstance()));
			hudComponents.addComponent(new DistanceLeftHuD(new Vector2(400, 550), finish));
			return finish;
		}

		protected function addJumpsLeftUI(player:Player):void
		{
			hudComponents.addComponent(new JumpsLeftCounter(player, new Vector2(250, 500)));
		}
		
		protected function addDoor(x:Number, y:Number, width:Number, height:Number, keyNumbers:Array, keys:Vector.<Key>):Door
		{
			var door:Door = new Door(new Vector2(x, y), new Vector2(width * 0.5, height * 0.5));
			components.addComponent(door);

			var keyMaxIndex:int = keys.length - 1;
			for(var i:int = keyNumbers.length - 1; i >= 0; i--)
			{
				var temp:int = keyMaxIndex - keyNumbers[i];
				keys[keyMaxIndex - keyNumbers[i]].addDoor(door);
			};

			return door;
		}
		
		override public function unload():void 
		{
			super.unload();
			
			components.clearList();
			hudComponents.clearList();
		}
	}

}