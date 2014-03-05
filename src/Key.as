package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.WeakFunctionClosure;
	import screens.GameplayScreen;
	import whojooEngine.Camera;
	import whojooEngine.components.PhysicsComponent;
	import whojooEngine.messageBoard.Message;
	import whojooEngine.messageBoard.MessageBoard;
	import whojooEngine.Settings;
	import whojooEngine.Vector2;
	import whojooEngine.WMatrix;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class Key extends PhysicsComponent 
	{
		public static const Key_Reached:String = "Key Reached";
		
		//Doors linked to this key.
		private var doors:Vector.<Door>;
		
		private var texture:BitmapData;
		private var keyNumber:Number;
		private var keyActive:Boolean;
		
		public function Key(position:Vector2, keyNumber:Number, doors:Vector.<Door> = null) 
		{
			super(position, new Vector2(30, 10));
			
			if (doors)
			{
				this.doors = doors;
			}
			else
			{
				this.doors = new Vector.<Door>();
			}
		}
		
		override public function init():void 
		{
			super.init();
			
			keyActive = false;
			
			var bitmap:Bitmap = Textures.getInstance().getKeyTexture();
			texture = new BitmapData(bitmap.width, bitmap.height, true);
			texture.draw(bitmap, WMatrix.toMatrix(WMatrix.identity()));
			
			halfSize = new Vector2(bitmap.width * 0.5, bitmap.height * 0.5);
			
			var settings:Settings = Settings.getInstance();
			
			//Initialize the body.
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.userData = this;
			bodyDef.position = Vector2.divide(position,
				settings.getPixelPerMeter()).as_b2Vec2();
			bodyDef.type = b2Body.b2_staticBody;
			
			body = settings.getActiveWorld().CreateBody(bodyDef);
			
			var vertices:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			vertices.push(Vector2.divide(halfSize.inverse(), settings.getPixelPerMeter()).as_b2Vec2());
			vertices.push(Vector2.divide(new Vector2(halfSize.x, -halfSize.y), settings.getPixelPerMeter()).as_b2Vec2());
			vertices.push(Vector2.divide(halfSize.clone(), settings.getPixelPerMeter()).as_b2Vec2());
			vertices.push(Vector2.divide(new Vector2( -halfSize.x, halfSize.y), settings.getPixelPerMeter()).as_b2Vec2());
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsVector(vertices, vertices.length);
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.isSensor = true;
			fixture.shape = shape;
			
			body.CreateFixture(fixture);
		}
		
		public function addDoor(door:Door):void
		{
			doors.push(door);
		}
		
		public function addDoors(doors:Vector.<Door>):void
		{
			for each (var door:Door in doors)
			{
				this.doors.push(door);
			}
		}
		
		public function keyLost():void
		{
			if (!keyActive)
			{
				//No need to do something if we weren't active to begin with.
				return;
			}
			
			keyActive = false;
			
			//Safe check.
			if (!doors)
			{
				return;
			}
			
			//Close all doors.
			for (var i:int = doors.length - 1; i >= 0; i--)
			{
				doors[i].switchDoor();
			}
		}
		
		override public function update(deltaTime:Number):void 
		{
			super.update(deltaTime);
			
			if (!body)
			{
				return;
			}
			
			//Check for player collision.
			for (var contact:b2ContactEdge = body.GetContactList();
				contact; contact = contact.next)
			{
				var player:Player = contact.other.GetUserData() as Player;
				if (player)
				{
					//Safe check.
					if (!doors)
					{
						break;
					}
					
					if (keyActive)
					{
						//No need to switch doors if we are already active.
						break;
					}
					
					var screen:GameplayScreen = Settings.getInstance().getActiveScreen() as GameplayScreen;
					
					if (screen)
					{
						screen.keyReached(keyNumber);
					}
					
					MessageBoard.getInstance().sendMessage(
						new Message(Key_Reached, this));
					
					keyActive = true;
					
					//Open all doors.
					for (var i:int = doors.length - 1; i >= 0; i--)
					{
						doors[i].switchDoor();
					}
					
					//No need to stay in this loop.
					break;
				}
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
	}

}