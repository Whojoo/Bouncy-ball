package  
{
	import flash.display.Graphics;
	import whojooEngine.Camera;
	import whojooEngine.physics.Wall;
	import whojooEngine.Vector2;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class JumperWall extends Wall 
	{
		
		public function JumperWall(topLeft:Vector2, bottomRight:Vector2) 
		{
			super(topLeft, Vector2.multiply(Vector2.subtract(bottomRight, topLeft), 0.5));
			
		}
		
		override public function render(graphics:Graphics):void 
		{
			super.render(graphics);
			
			var transformedPosition:Vector2 = Vector2.transform(position,
				Camera.getInstance().view);
			
			graphics.beginFill(0x804000);
			graphics.drawRect(transformedPosition.x - halfSize.x,
				transformedPosition.y - halfSize.y,
				halfSize.x * 2, halfSize.y * 2);
			graphics.endFill();
		}
	}

}