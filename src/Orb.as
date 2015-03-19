package  
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Graphics;
	import ui.OrbGainedHuD;
	import whojooEngine.Camera;
	import whojooEngine.components.GameComponent;
	import whojooEngine.components.PhysicsComponent;
	import whojooEngine.Settings;
	import whojooEngine.Vector2;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class Orb extends PhysicsComponent 
	{
		private var orbPowerLeftAtPlayer:Number;
		
		public function Orb(position:Vector2) 
		{
			super(position, new Vector2(10, 10));
			
			orbPowerLeftAtPlayer = 0;
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
		
		public function orbEmpowerUsed():void
		{
			orbPowerLeftAtPlayer = orbPowerLeftAtPlayer > 0 ? 
				--orbPowerLeftAtPlayer : 0;
		}
		
		private function orbEmpowerGained(player:Player):void
		{
			//Only call the player if we can do something.
			if (orbPowerLeftAtPlayer < SettingsJumper.getInstance().getJumpCountPerOrb())
			{
				player.gainOrbEmpower(this, orbPowerLeftAtPlayer != 0);
				orbPowerLeftAtPlayer = SettingsJumper.getInstance().getJumpCountPerOrb();
				
				var transformedPos:Vector2 = Vector2.transform(position,
					Camera.getInstance().view);
				
				Settings.getInstance().getActiveScreen().hudComponents.addComponent(
					new OrbGainedHuD(transformedPos, new Vector2(250, 525)));
			}
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			
			for (var contact:b2ContactEdge = body.GetContactList(); contact; contact = contact.next)
			{
				//Empower the player.
				var player:Player = contact.other.GetUserData() as Player;
				if (player)
				{
					orbEmpowerGained(player);
				}
			}
		}
		
		override public function render(graphics:Graphics):void 
		{
			super.render(graphics);
			
			var transformedPosition:Vector2 = Vector2.transform(position,
				Camera.getInstance().view);
			var scaledRadius:Number = halfSize.x * Camera.getInstance().scale;
			
			graphics.beginFill(0x0000FF);
			graphics.drawCircle(transformedPosition.x, transformedPosition.y, scaledRadius);
			graphics.endFill();
		}
	}

}