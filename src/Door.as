package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Graphics;
	import whojooEngine.Camera;
	import whojooEngine.physics.Wall;
	import whojooEngine.Settings;
	import whojooEngine.Vector2;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class Door extends Wall 
	{
		private const Vertices:int = 4;
		
		public var active:Boolean;
		
		public function Door(topLeft:Vector2, halfSize:Vector2) 
		{
			super(topLeft, halfSize);
			active = true;
		}
		
		public function switchDoor():void
		{
			//Switch the values to their opposite.
			active = !active;
			supressDraw = !supressDraw;
			body.GetFixtureList().SetSensor(!body.GetFixtureList().IsSensor());
		}
		
		override public function update(deltaTime:Number):void 
		{
			super.update(deltaTime);
		}
		
		override public function render(graphics:Graphics):void 
		{
			super.render(graphics);
			
			if (!supressDraw) 
			{
				graphics.beginFill(0x000000);
				graphics.moveTo(drawList[0].x, drawList[0].y);
				for (var i:int = 1; i < 4; i++) {
					graphics.lineTo(drawList[i].x, drawList[i].y);
				}
				graphics.lineTo(drawList[0].x, drawList[0].y);
				graphics.endFill();
				
				graphics.beginFill(0xffffff);
				var temp:Vector2 = Vector2.transform(position, 
					Camera.getInstance().view);
				graphics.drawCircle(temp.x, temp.y, 10);
				graphics.endFill();
			}
		}
	}

}