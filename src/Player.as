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
	import whojooEngine.physics.Wall;
	import whojooEngine.Vector2;
	import whojooEngine.Settings;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class Player extends Box 
	{
		//Constant movement variables.
		private const moveVec:Vector2 = new Vector2(1, 0);
		private const jumpVec:Vector2 = new Vector2(0, -20);
		
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
		private var jumpFromFloor:Boolean;
		private var orbs:Vector.<Player>;
		
		//Movement.
		private var movementMultiplier:Number;
		
		public function Player(position:Vector2, halfSize:Vector2) 
		{
			super(position, halfSize);
			
			doJump = new InputAction([ Keys.UP, Keys.SPACE, Keys.W ], true);
			moveLeft = new InputAction([ Keys.LEFT, Keys.A ]);
			moveRight = new InputAction([ Keys.RIGHT, Keys.D ]);
			
			jumpFromFloor = true;
			jumpsFromOrbLeft = 0;
			jumpsLeft = 5;
			orbs = new Vector.<Player>();
			
			movementMultiplier = OnFloorMultiplier;
		}
		
		private function jump():Boolean
		{
			//Jumping from floor is a free jump.
			if (jumpFromFloor)
			{
				//Jumping can't always happen so the actual jump has to be after these if elses.
				//However we must skip the following if elses if we're on the floor.
				//That's the reason of this empty if statement.
			}
			//Do we still have starting jumps left?
			else if (jumpsLeft > 
				(orbs.length > 0 ? orbs.length - 1 : 0) * SettingsJumper.getInstance().getJumpCountPerOrb() + jumpsFromOrbLeft)
			{
				jumpsLeft--;
			}
			//Are we able to air jump?
			else if (jumpsFromOrbLeft > 0)
			{
				//Is the current orb out of jumps?
				if (--jumpsFromOrbLeft <= 0)
				{
					jumpsFromOrbLeft = SettingsJumper.getInstance().getJumpCountPerOrb();
					
					var temp:Vector.<Player> = orbs;
					orbs = new Vector.<Player>();
					
					//Skip the old orb and copy the others in a new array.
					for (var i:int = 1; i < temp.length; i++)
					{
						orbs.push(temp[i]);
					}
				}
			}
			else 
			{
				return false;
			}
			
			//movementMultiplier = InAirMultiplier;
			
			return true;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			
			//Mechanics.
			//Set jumpFromFloor on false in case we're on on the floor anymore.
			jumpFromFloor = false;
			for (var contact:b2ContactEdge = body.GetContactList(); contact; contact = contact.next)
			{
				if (contact.other.GetUserData() is Wall && 
					(contact.other.GetUserData() as Wall).position.y > position.y)
				{
					jumpFromFloor = true;
					
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
			
			graphics.beginFill(0x000000);
			graphics.drawRect(transformedPosition.x - halfSize.x, transformedPosition.y - halfSize.y,
				halfSize.x * 2, halfSize.y * 2);
			graphics.endFill();
		}
	}

}