package screens 
{
	import flash.ui.KeyboardType;
	import whojooEngine.Camera;
	import whojooEngine.gameScreenManager.PlayScreen;
	import whojooEngine.interfaces.IComponent;
	import whojooEngine.physics.Wall;
	import whojooEngine.Settings;
	import whojooEngine.Vector2;
	import whojooEngine.WMatrix;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class TestScreen extends GameplayScreen 
	{
		
		public function TestScreen() 
		{
			super(new Vector2(0, 1 * Settings.getInstance().getPixelPerMeter()));
		}
		
		override public function init():void 
		{
			super.init();
			var player:Player;
			player = new Player(new Vector2(100, 4900));
			
			var doors:Vector.<Door> = new Vector.<Door>();
			var keyDoorComb:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			for (var i:int = 0; i < 4; i++)
			{
				keyDoorComb.push(new Vector.<int>());
			}
			
			var finish:Finish = new Finish(new Vector2(1850, 200), player, false);
			components.addComponent(finish);
			var keyPositions:Vector.<Vector2> = new Vector.<Vector2>();
			
			Camera.getInstance().worldSize = new Vector2(2000, 5000);
			components.addComponent(new JumperWall(new Vector2(0, 0), new Vector2(50, 4950)));
			components.addComponent(new JumperWall(new Vector2(0, 4950), new Vector2(1950, 5000)));
			components.addComponent(new JumperWall(new Vector2(1950, 50), new Vector2(2000, 5000)));
			components.addComponent(new JumperWall(new Vector2(50, 0), new Vector2(2000, 50)));
			
			var doorIndex:int = 0;
			
			addWall(50, 4750, 300, 50);
			addWall(450, 4550, 200, 50);
			addWall(650, 4350, 50, 250);
			addWall(700, 4350, 300, 50);
			keyPositions.push(newKeyPos(800, 4250), newKeyPos(1000, 3950), newKeyPos(1000, 2000), newKeyPos(3000, 30000));
			doors.push(addDoor(950, 4100, 50, 250));
			keyDoorComb[3].push(doorIndex++);
			addWall(950, 4400, 50, 200);
			addWall(1400, 4600, 300, 50);
			addWall(1650, 4650, 50, 200);
			addWall(1700, 4800, 250, 50);
			addWall(50, 4250, 450, 50);
			addWall(500, 4100, 50, 200);
			addWall(500, 4050, 1000, 50);
			doors.push(addDoor(1500, 4050, 450, 50));
			keyDoorComb[0].push(doorIndex);
			keyDoorComb[2].push(doorIndex);
			keyDoorComb[3].push(doorIndex++);
			
			//components.addComponents(wallVec);
			var keyVec:Vector.<Key> = finish.createKeys(keyPositions);
			
			var door:Door = new Door(new Vector2(500, 9850), new Vector2(25, 50));
			var vec:Vector.<Door> = new Vector.<Door>();
			vec.push(door);
			components.addComponent(door);
			
			for (var j:int = 0; j < keyVec.length; j++)
			{
				for (var u:int = 0; u < keyDoorComb[j].length; u++)
				{
					keyVec[j].addDoor(doors[keyDoorComb[j][u]]);
				}
			}
			
			for each (var key:Key in keyVec)
			{
				components.addComponent(key);
			}
			
			components.addComponent(player);
		}
	}

}