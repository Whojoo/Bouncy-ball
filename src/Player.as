package  
{
	import adobe.utils.CustomActions;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Graphics;
	import whojooEngine.Camera;
	import whojooEngine.components.PhysicsComponent;
	import whojooEngine.input.Input;
	import whojooEngine.input.InputAction;
	import whojooEngine.input.Keys;
	import whojooEngine.physics.Box;
	import whojooEngine.physics.Circle;
	import whojooEngine.physics.Wall;
	import whojooEngine.Vector2;
	import whojooEngine.Settings;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class Player extends Circle 
	{
		//Constant movement variables.
		private const moveVec:Vector2 = new Vector2(1, 0);
		private const jumpVec:Vector2 = new Vector2(0, -20);
		
		//Jump constants.
		private const AmountOfFreeJumps:Number = 2;
		
		//Constant player states.
		private const InAirMultiplier:Number = 0.65;
		private const OnFloorMultiplier:Number = 1;
		
		//Input.
		private var doJump:InputAction;
		private var moveLeft:InputAction;
		private var moveRight:InputAction;
		
		//Jumps.
		private var jumpsFromOrbLeft:Number;
		private var jumpsLeft:Number;
		private var orbs:Vector.<Orb>;
		
		//Movement.
		private var movementMultiplier:Number;
		
		public function Player(position:Vector2, halfSize:Vector2) 
		{
			super(position, halfSize);
			
			doJump = new InputAction([ Keys.UP, Keys.SPACE, Keys.W ], true);
			moveLeft = new InputAction([ Keys.LEFT, Keys.A ]);
			moveRight = new InputAction([ Keys.RIGHT, Keys.D ]);
			
			jumpsFromOrbLeft = 0;
			jumpsLeft = 5;
			orbs = new Vector.<Orb>();
			
			movementMultiplier = OnFloorMultiplier;
		}
		
		private function jump():Boolean
		{
			//Do we still have free jumps left?
			if (jumpsLeft > amountOfOrbJumpsLeft())
			{
				jumpsLeft--;
			}
			//Do we have orb empowered jumps left?
			else if (orbs.length > 0)
			{
				//Adjust the jumping numbers.
				jumpsLeft--;
				jumpsFromOrbLeft--;
				orbs[0].orbEmpowerUsed();
				
				if (jumpsFromOrbLeft <= 0)
				{
					//Just used last orb.
					if (orbs.length == 1)
					{
						orbs = new Vector.<Orb>();
					}
					//Still got some orbs left.
					else
					{
						var temp:Vector.<Orb> = orbs;
						
						for (var i:int = 1; i < orbs.length; i++)
						{
							temp.push(orbs[i]);
						}
						
						orbs = temp;
						jumpsFromOrbLeft = SettingsJumper.getInstance().getJumpCountPerOrb();
					}
				}
			}
			else 
			{
				return false;
			}
			
			return true;
		}
		
		private function amountOfOrbJumpsLeft():Number
		{
			//Do we have any reserve orbs?
			return (orbs.length > 1 ? orbs.length - 1 : 0) * 
				SettingsJumper.getInstance().getJumpCountPerOrb() + jumpsFromOrbLeft;
		}
		
		public function gainOrbEmpower(orb:Orb, alreadyEmpowered:Boolean):void
		{
			//jumpsFromOrbLeft might get adjusted so we prepair jumpsLeft for the adjustment.
			jumpsLeft -= jumpsFromOrbLeft;
			
			//Orb only calls this function if it is currently in use or not stored at all.
			if (alreadyEmpowered && orb == orbs[0])
			{
				jumpsFromOrbLeft = SettingsJumper.getInstance().getJumpCountPerOrb();
			}
			else
			{
				orbs.push(orb);
				
				if (orbs.length == 1)
				{
					jumpsFromOrbLeft = SettingsJumper.getInstance().getJumpCountPerOrb();
				}
			}
			
			//jumpsFromOrbLeft might have been adjusted, adjust jumpsLeft.
			jumpsLeft += jumpsFromOrbLeft;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			
			movementMultiplier = InAirMultiplier;
			
			//Mechanics.
			for (var contact:b2ContactEdge = body.GetContactList(); contact; contact = contact.next)
			{
				var floor:Wall = contact.other.GetUserData() as Wall;
				if (floor && floor.position.y - floor.halfSize.y > 
					position.y + halfSize.y)
				{
					//Get free jumps.
					jumpsLeft = amountOfOrbJumpsLeft() + AmountOfFreeJumps;
					
					//We're on the floor so reset the movementMultiplier.
					movementMultiplier = OnFloorMultiplier;
					
					//We're on the floor so get out of the loop.
					break;
				}
			}
			
			//Input check.
			var movementVector:Vector2 = new Vector2();
			if (doJump.check(Settings.getInstance().getGame().input))
			{
				//Jump mechanics + check if we can jump.
				if (jump())
					movementVector.incrementBy(Vector2.multiply(
						jumpVec, Settings.getInstance().getPixelPerMeter()));
			}
			
			if (moveRight.check(Settings.getInstance().getGame().input))
			{
				movementVector.incrementBy(Vector2.multiply(moveVec, 
					movementMultiplier * Settings.getInstance().getPixelPerMeter()));
			}
			else if (moveLeft.check(Settings.getInstance().getGame().input))
			{
				movementVector.incrementBy(Vector2.multiply(moveVec, 
					-movementMultiplier * Settings.getInstance().getPixelPerMeter()));
			}
			
			//Now add in the move.
			move(movementVector);
			
			//Allign the camera.
			Camera.getInstance().position = position.clone();
		}
		
		override public function render(graphics:Graphics):void 
		{
			super.render(graphics);
			
			var transformedPosition:Vector2 = Vector2.transform(position,
				Camera.getInstance().view);
			
			var scaledradius:Number = Camera.getInstance().scale * radius;
			
			graphics.beginFill(0x000000);
			graphics.drawCircle(transformedPosition.x, 
				transformedPosition.y,
				scaledradius);
			graphics.endFill();
		}
	}

}