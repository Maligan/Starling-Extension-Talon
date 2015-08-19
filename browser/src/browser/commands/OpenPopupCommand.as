package browser.commands
{
	import browser.AppController;
	import browser.popups.Popup;

	public class OpenPopupCommand extends Command
	{
		private var _popupClass:Class;
		private var _modal:Boolean;

		public function OpenPopupCommand(controller:AppController, modal:Boolean, popupClass:Class)
		{
			super(controller);
			_popupClass = popupClass;
			_modal = modal;
		}

		public override function execute():void
		{
			var popup:Popup = new _popupClass();
			popup.open(_modal);
		}
	}
}