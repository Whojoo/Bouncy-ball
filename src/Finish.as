package  
{
	import whojooEngine.components.PhysicsComponent;
	import whojooEngine.Vector2;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class Finish extends PhysicsComponent 
	{
		
		public function Finish(position:Vector2, halfSize:Vector2) 
		{
			super(position, halfSize);
			
		}
		
		override public function init():void 
		{
			super.init();
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.userData = this;
			bodyDef.position = Vector2.divide(position,
				Settings.getInstance().getPixelPerMeter()).as_b2Vec2();
			bodyDef.type = b2Body.b2_staticBody;
			
			body = Settings.getInstance().getActiveWorld().
				CreateBody(bodyDef);
			var shape:b2CircleShape = new b2CircleShape(
				halfSize.x / Settings.getInstance().getPixelPerMeter());
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.isSensor = true;
			fixture.shape = shape;
			
			body.CreateFixture(fixture);
		}
		
		public function createKeys(positions:Vector.<Vector2>):Vector.<Key>
		{
			//Safe check.
			if (!positions ^ positions.length == 0)
			{
				return positions;
			}
			
			var toReturn:Vector.<Key> = new Vector.<Key>();
			
			if (positions.length == 1)
			{
				toReturn.push(new Key(positions[0], 1));
				return toReturn;
			}
			
			//Order with recursion.
			var positionsInOrder:Vector.<Vector2> = orderPositions(positions);
			
			//Now create some keys.
			for (var i:int = positionsInOrder.length - 1; i >= 0; i--)
			{
				toReturn.push(new Key(positionsInOrder[i], i + 1));
			}
			
			//Return the keys.
			return toReturn;
		}
		
		private function orderPositions(positions:Vector.<Vector2>):Vector.<Vector2>
		{
			//Safe check.
			if (positions.length < 2)
			{
				return positions;
			}
			
			var toReturn:Vector.<Vector2>;
			var farthestAway:Vector2;
			var currentFarthestDistSQ:Number;
			
			//End condition.
			if (positions.length == 2)
			{
				//Calculate the distance squared.
				currentFarthestDistSQ = Vector2.subtract(positions[0], position).lengthSQ();
				otherDistSQ = Vector2.subtract(positions[1], position).lengthSQ();
				
				toReturn = new Vector.<Vector2>();
				
				//Compare and fill toReturn according the results.
				if (currentFarthestDistSQ > otherDistSQ)
				{
					toReturn.push(positions[1], positions[0]);
				}
				else
				{
					toReturn.push(positions[0], positions[1]);
				}
				
				return toReturn;
			}
			
			//Which one is the farthest away?
			farthestAway = positions[0];
			currentFarthestDistSQ = Vector2.subtract(farthestAway, position).lengthSQ();
			
			for (var i:int = 1; i < positions.length; i++)
			{
				var otherDistSQ:Number = Vector2.subtract(positions[i], position).lengthSQ();
				
				if (otherDistSQ > currentFarthestDistSQ)
				{
					currentFarthestDistSQ = otherDistSQ;
					farthestAway = positions[i];
				}
			}
			
			//Remove the farthest away from the list.
			positions.splice(positions.indexOf(farthestAway), 1);
			
			//Recursion.
			toReturn = orderPositions(positions);
			toReturn.push(farthestAway);
			
			return toReturn;
		}
	}

}