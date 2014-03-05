package  
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import whojooEngine.Camera;
	import whojooEngine.components.PhysicsComponent;
	import whojooEngine.gameScreenManager.PlayScreen;
	import whojooEngine.messageBoard.Message;
	import whojooEngine.messageBoard.MessageBoard;
	import whojooEngine.Settings;
	import whojooEngine.Vector2;
	import whojooEngine.WMatrix;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class Finish extends PhysicsComponent 
	{
		private const DistancePunishmentMargeInPercentage:Number = 110;
		private const Radius:Number = 50;
		
		//Variable for UserExperience.
		private var noDistancePunishment:Boolean;
		
		private var keys:Vector.<Key>;
		private var distanceLimit:Number;
		private var currentKey:Number;
		private var player:Player;
		private var texture:BitmapData;
		
		public function Finish(position:Vector2, player:Player, userExperience:Boolean = false) 
		{
			super(position, new Vector2(Radius, Radius));
			
			distanceLimit = Number.MAX_VALUE;
			this.player = player;
			
			//Variable only used for UserExperience.
			noDistancePunishment = userExperience;
		}
		
		override public function init():void 
		{
			super.init();
			
			var bitmap:Bitmap = Textures.getInstance().getFinishTexture();
			texture = new BitmapData(bitmap.width, bitmap.height, true);
			scale = Radius / bitmap.width;
			texture.draw(bitmap, WMatrix.toMatrix(WMatrix.createScale(scale)));
			halfSize = new Vector2(bitmap.width * scale * 0.5, bitmap.height * scale * 0.5);
			
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
			
			MessageBoard.getInstance().registerToBoard(this);
		}
		
		public function createKeys(positions:Vector.<Vector2>):Vector.<Key>
		{
			//Safe check.
			//XOR operation
			var firstCheck:Boolean = !positions && positions.length == 0;
			var secondCheck:Boolean = !positions || positions.length == 0;
			if (firstCheck && secondCheck)
			{
				return null;
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
			
			//Set local variables.
			keys = toReturn;
			currentKey = keys.length;
			
			//Return the keys.
			return toReturn;
		}
		
		override public function recieveMessage(message:Message):void 
		{
			super.recieveMessage(message);
			
			if (message.message == Key.Key_Reached)
			{
				currentKey--;
			}
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
		
		override public function update(deltaTime:Number):void 
		{
			super.update(deltaTime);
			
			if (currentKey == keys.length)
			{
				return;
			}
			
			//Can we punish the player and do we have to punish the player?
			if (!noDistancePunishment && 
				checkIfPlayerPassedDistanceLimit() && currentKey != keys.length - 1)
			{
				if (currentKey > -1)
				{
					keys[currentKey].keyLost();
				}
				
				currentKey++;
			}
			
			//Skip the last part if the player doesn't have all keys yet.
			if (currentKey != 0)
			{
				return;
			}
			
			//Has the player reached the finish?
			var deltaX:Number = position.x - player.position.x;
			var deltaY:Number = position.y - player.position.y;
			var radiiSQ:Number = halfSize.x * halfSize.x + player.radius * player.radius;
			
			if (deltaX * deltaX + deltaY * deltaY < radiiSQ)
			{
				//Add a win screen.
				throw new Error("We won, now add that in the code!");
			}
		}
		
		override public function render(graphics:Graphics):void 
		{
			super.render(graphics);
			
			var viewMatrix:WMatrix = Camera.getInstance().view;
			
			var personalMatrix:WMatrix = (new WMatrix()).
				translate(halfSize.inverse()).translate(position);
			
			var textureMatrix:WMatrix = new WMatrix();
			textureMatrix = WMatrix.multiplyTwoMatrices(viewMatrix, personalMatrix);
			
			var transformedPos:Vector2 = Vector2.transform(
				Vector2.subtract(position, halfSize), viewMatrix);
			var transformedHS:Vector2 = Vector2.multiply(halfSize, 2);
			
			graphics.beginBitmapFill(texture, WMatrix.toMatrix(textureMatrix), false, true);
			graphics.drawRect(transformedPos.x, transformedPos.y,
				transformedHS.x, transformedHS.y);
			graphics.endFill();
		}
		
		private function checkIfPlayerPassedDistanceLimit():Boolean
		{
			const fromPercentageToDecimalFactor:Number = 0.1;
			
			//We want the marge squared since it's quicker to use lengthSQ on vector2.
			//That means that our converter factor has to squared as well.
			var punishmentMargeSQ:Number = DistancePunishmentMargeInPercentage * DistancePunishmentMargeInPercentage *
				fromPercentageToDecimalFactor * fromPercentageToDecimalFactor;
			
			var distanceToKeySQ:Number = Vector2.subtract(position, keys[currentKey].position).lengthSQ();
			
			//Now check if the player has passed the limit.
			return distanceToKeySQ * punishmentMargeSQ < Vector2.subtract(player.position, position).lengthSQ();
		}
		
		public function getDistanceTillEndInMeters():Number
		{
			var rawDistanceInPixels:Number = Vector2.subtract(position, player.position).length();
			var actualDistnaceInPixels:Number = rawDistanceInPixels - (halfSize.x + player.radius);
			
			return actualDistnaceInPixels / Settings.getInstance().getPixelPerMeter();
		}
	}

}