package  
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class Textures 
	{
		[Embed(source = "../lib/Small_Key_Icon_TP.png")]
		private var keyTextureClass:Class;
		
		[Embed(source = "../lib/RaceFlag.png")]
		private var finishTextureClass:Class;
		
		private static var instance:Textures;
		
		public function Textures() 
		{
		}
		
		public static function getInstance():Textures
		{
			if (instance)
			{
				return instance;
			}
			
			return (instance = new Textures());
		}
		
		public function getKeyTexture():Bitmap
		{
			return new keyTextureClass() as Bitmap;
		}
		
		public function getFinishTexture():Bitmap
		{
			return new finishTextureClass() as Bitmap;
		}
	}

}