package talon.browser.desktop.popups
{
	import flash.ui.Keyboard;
	import flash.ui.MouseCursor;

	import starling.core.Starling;

	import starling.display.DisplayObject;
	import starling.events.Event;

	import starling.utils.StringUtil;

	import talon.Attribute;
	import talon.browser.desktop.utils.Updater;
	import talon.browser.platform.popups.Popup;

	public class UpdatePopup extends Popup
	{
		private var _updater:Updater;
		private var _details:Boolean;

		protected override function initialize():void
		{
			addChild(manager.factory.createElement("UpdatePopup") as DisplayObject);
			node.commit();

			query("#cancel").onTap(onCancelClick);
			query("#update").onTap(onUpdateClick);
			query("#details").onTap(onDetailsClick);

			_updater = Updater(data);
			_updater.addEventListener(Event.CHANGE, onUpdaterChange);
			_updater.execute(true);

			addKeyboardListener(Keyboard.ENTER, onUpdateClick);
			addKeyboardListener(Keyboard.ESCAPE, onCancelClick);
		}

		public override function dispose():void
		{
			_updater.removeEventListener(Event.CHANGE, onUpdaterChange);
			super.dispose();
		}

		private function onUpdateClick(e:*):void
		{
			_updater.execute();
		}

		private function onCancelClick():void
		{
			_updater.stop();
			close();
		}

		private function onDetailsClick(e:Event):void
		{
			_details = !_details;
			query("#details").setAttribute(Attribute.TRANSFORM, _details ? "rotate(-90deg)" : "none");
			query("#detailsInfo").setAttribute(Attribute.VISIBLE, _details);
		}

		//
		// Updater Events
		//
		private function onUpdaterChange(e:*):void
		{
			// [Begin load descriptor]
			if (_updater.step == 1)
			{
				query("#info").setAttribute(Attribute.TEXT, "$dialog.updater.statusLoadingDescriptor");
				query("#details").setAttribute(Attribute.VISIBLE, false);
				query("#detailsInfo").setAttribute(Attribute.VISIBLE, false);
				query("#update").setAttribute(Attribute.VISIBLE, false);

				query("#spinner").tween(1, { repeatCount: 0, onUpdate: function ():void
				{
					query("#spinner").setAttribute(Attribute.TRANSFORM, "rotate(" + (Starling.juggler.elapsedTime * 180) + "deg)");
				}}, juggler);
			}
			// [Begin load application]
			else if (_updater.step == 2)
			{
				query("#info").setAttribute(Attribute.TEXT, "$dialog.updater.statusLoadingApplication");
			}
			// [Success descriptor load]
			else if (_updater.lastStatus == "UPDATE_DESCRIPTOR_LOADED")
			{
				query("#info")
					.setAttribute(Attribute.TEXT, StringUtil.format(node.getResource("dialog.updater.statusHasUpdate"), _updater.lastUpdaterVersion));

				query("#detailsInfo")
					.setAttribute(Attribute.TEXT, _updater.lastUpdaterDescription);

				query("#spinner")
					.setAttribute(Attribute.VISIBLE, false)
					.tweenKill(juggler);

				query("#details")
					.setAttribute(Attribute.VISIBLE, true);

				query("#update")
					.setAttribute(Attribute.VISIBLE, true);

			}
			// [Success application load & start update]
			else if (_updater.lastStatus != "UPDATER_STARTED")
			{
				var hasLastVersion:Boolean = _updater.lastStatus == "UPDATE_DESCRIPTOR_VERSION_IS_LESS_OR_EQUALS";

				if (hasLastVersion)
				{
					query("#info")
						.setAttribute(Attribute.TEXT, "$dialog.updater.statusLatest");
				}
				else
				{
					query("#info")
						.setAttribute(Attribute.TEXT, "$dialog.updater.statusError")
						.setAttribute(Attribute.FONT_COLOR, "#FFAAAA");
				}

				query("#spinner")
					.setAttribute(Attribute.VISIBLE, false)
					.tweenKill(juggler);

				query("#details")
					.setAttribute(Attribute.VISIBLE, !hasLastVersion);

				query("#detailsInfo").setAttribute(Attribute.TEXT, _updater.lastStatus);
			}

			node.invalidate();
			node.parent.parent.commit();
		}
	}
}