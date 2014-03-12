package screens 
{
	import whojooEngine.gameScreenManager.GameScreen;
	import whojooEngine.input.InputAction;
	import whojooEngine.WText;
	import whojooEngine.input.Keys;
	import whojooEngine.Settings;
	/**
	 * ...
	 * @author Robin de Gier
	 */
	public class MenuScreen extends GameScreen
	{
		private var _entries:Vector.<WText>;
		private var _hitEsc:InputAction;
		
		public function MenuScreen() 
		{
			_hitEsc = new InputAction([Keys.ESC],
				true);
		}
		
		override public function activate():void 
		{
			for each (var text:WText in _entries)
			{
				text.addText();
			}
			
			super.activate();
		}
		
		override public function deactivate():void 
		{
			for each (var text:WText in _entries)
			{
				text.removeText();
			}
			
			super.deactivate();
		}
		
		override public function update(elapsedTime:Number):void 
		{
			if (_hitEsc.check(Settings.getInstance().getGame().input))
			{
				onCancel();
			}
			
			super.update(elapsedTime);
		}
		
		public function onCancel():void
		{
			screenManager.removeScreen(this);
		}
	}

}