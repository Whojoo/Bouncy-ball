package screens 
{
	import whojooEngine.gameScreenManager.PlayScreen;
	import whojooEngine.Vector2;
	
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
		
		protected function addDoor(x:Number, y:Number, width:Number, height:Number):Door
		{
			var door:Door = new Door(new Vector2(x, y), new Vector2(width * 0.5, height * 0.5));
			components.addComponent(door);
			return door;
		}
	}

}