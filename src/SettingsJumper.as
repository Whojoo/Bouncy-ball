package  
{
	import whojooEngine.Settings;
	
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class SettingsJumper 
	{
		private static var instance:SettingsJumper;
		
		public function SettingsJumper() 
		{
		}
		
		public static function getInstance():SettingsJumper
		{
			if (instance == null)
			{
				return (instance = new SettingsJumper());
			}
			
			return instance;
		}
		
		public function getJumpCountPerOrb():Number
		{
			return 2;
		}
	}

}