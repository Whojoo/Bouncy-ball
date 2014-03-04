package  
{
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.WeakFunctionClosure;
	import whojooEngine.Camera;
	import whojooEngine.components.PhysicsComponent;
	import whojooEngine.Vector2;
	import whojooEngine.WMatrix;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class Key extends PhysicsComponent 
	{
		//Doors linked to this key.
		private var doors:Vector.<Door>;
		private var texture:BitmapData;
		
		public function Key(position:Vector2, doors:Vector.<Door>) 
		{
			super(position, new Vector2(30, 10));
			
			this.doors = doors;
		}
		
		override public function init():void 
		{
			super.init();
			
			var bitmap:Bitmap = Textures.getInstance().getKeyTexture();
			texture = new BitmapData(bitmap.width, bitmap.height, true);
			texture.draw(bitmap, WMatrix.toMatrix(WMatrix.identity()));
			
			halfSize = new Vector2(bitmap.width * 0.5, bitmap.height * 0.5);
		}
		
		override public function update(deltaTime:Number):void 
		{
			super.update(deltaTime);
			
			if (!body)
			{
				return;
			}
			
			for (var contact:b2ContactEdge = body.GetContactList();
				contact; contact = contact.next)
			{
				var player:Player = contact.other.GetUserData() as Player;
				if (player)
				{
					//Message the screen that the player reached this key!
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