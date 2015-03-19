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
	import ui.KeyCounter;
	import ui.KeyPointer;
	import ui.JumpsLeftCounter;
	
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

			var finish:Finish = addFinishAndKeyUI(new Vector2(1925, 1875), player, false);
			addJumpsLeftUI(player);

			var keyPositions:Vector.<Vector2> = new Vector.<Vector2>();
			keyPositions.push(newKeyPos(1800, 4900), newKeyPos(800, 4300), newKeyPos(1000, 3950), newKeyPos(100, 2400), newKeyPos(1925, 3350));
			var keyVec:Vector.<Key> = finish.createKeys(keyPositions);
			
			Camera.getInstance().worldSize = new Vector2(2000, 5000);
			components.addComponent(new JumperWall(new Vector2(0, 0), new Vector2(50, 4950)));
			components.addComponent(new JumperWall(new Vector2(0, 4950), new Vector2(1950, 5000)));
			components.addComponent(new JumperWall(new Vector2(1950, 50), new Vector2(2000, 5000)));
			components.addComponent(new JumperWall(new Vector2(50, 0), new Vector2(2000, 50)));
			
			var doorIndex:int = 0;
			
			addWall(1750, 4300, 250, 50);
			addWall(50, 4750, 300, 50);
			addWall(450, 4550, 200, 50);
			addWall(650, 4350, 50, 250);
			addWall(700, 4350, 300, 50);
			addDoor(700, 4100, 50, 250, [0], keyVec);
			addOrb(900, 4275);
			addOrb(300, 4075);
			addDoor(1000, 4575, 400, 50, [1], keyVec);
			addWall(950, 4400, 50, 200);
			addWall(1400, 4600, 300, 50);
			addWall(1650, 4650, 50, 200);
			addWall(1700, 4800, 250, 50);
			addWall(50, 4250, 450, 50);
			addWall(500, 4100, 50, 200);
			addWall(500, 4050, 1000, 50);
			addDoor(1500, 4050, 450, 50, [1, 2, 4], keyVec);
			//Doors counting as floors, start them as open.
			addDoor(400, 3850, 300, 50, [2, 3], keyVec).switchDoor();
			addDoor(50, 3650, 300, 50, [2, 3], keyVec).switchDoor();
			addDoor(200, 3400, 200, 50, [2, 3], keyVec).switchDoor();
			addDoor(50, 3150, 300, 50, [2, 3], keyVec).switchDoor();
			addDoor(50, 2850, 300, 50, [2, 3], keyVec).switchDoor();
			addDoor(50, 2550, 300, 50, [2], keyVec).switchDoor();
			//Horizontal until finish.
			addWall(500, 2250, 1000, 50);
			addOrb(800, 2100);
			//Walls towards key 4.
			addDoor(450, 2850, 150, 50, [3], keyVec).switchDoor();
			addDoor(1000, 3100, 300, 50, [3], keyVec).switchDoor();
			addDoor(1600, 3500, 150, 50, [4], keyVec);
			addDoor(1750, 3250, 50, 300, [3], keyVec);
			addDoor(1800, 3500, 150, 50, [3, 4], keyVec);
			addDoor(1800, 3250, 150, 50, [3, 4], keyVec);
			addDoor(1800, 2850, 150, 50, [4], keyVec).switchDoor();
			addDoor(1800, 2550, 150, 50, [4], keyVec).switchDoor();
			addDoor(1800, 2250, 150, 50, [4], keyVec).switchDoor();
			addDoor(1850, 1900, 100, 50, [4], keyVec);
			addDoor(1850, 1800, 100, 50, [4], keyVec);
			addDoor(1850, 1850, 50, 50, [4], keyVec);
			
			//components.addComponents(wallVec);
			
			
			var door:Door = new Door(new Vector2(500, 9850), new Vector2(25, 50));
			var vec:Vector.<Door> = new Vector.<Door>();
			vec.push(door);
			components.addComponent(door);
			
			for each (var key:Key in keyVec)
			{
				components.addComponent(key);
			}
			
			components.addComponent(player);
		}
	}

}