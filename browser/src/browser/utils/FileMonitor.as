package browser.utils
{
	import flash.filesystem.File;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	* Dispatched when the modified date of the file being modified changes.
	*
	[Event(name="change", type="starling.events.Event")]
	
	/**
	* Class that monitors files for changes.
	*
	* Based on as3corelib FileMonitor.
	*/
	public class FileMonitor extends EventDispatcher
	{
		public static const DEFAULT_MONITOR_TIMER:Timer = new Timer(1000);

		private var _timer:Timer;
		private var _watching:Boolean;
		private var _file:File;
		private var _lastExists:Boolean = false;
		private var _lastModifiedTime:Number;
		
		/**
		 * 	@parameter file The File that will be monitored for changes.
		 * 
		 * 	@param interval How often in milliseconds the file is polled for
		 * 	change events. Default value is 1000, minimum value is 1000
		 */ 
		public function FileMonitor(file:File = null, interval:Number = -1)
		{
			if (interval != -1)
			{
				_timer = new Timer(Math.min(interval, 1000));
			}
			else
			{
				_timer = DEFAULT_MONITOR_TIMER;
			}

			this.file = file;
		}
	
		/** File being monitored for changes. */
		public function get file():File
		{
			return _file;
		}
		
		public function set file(file:File):void
		{
			var prevWatching:Boolean = _watching;

			if (_watching)
				unwatch();

			_file = file;
			_lastExists = _file.exists;
			_lastModifiedTime = _lastExists ? _file.modificationDate.getTime() : -1;

			if (prevWatching)
				watch();
		}
		
		/** How often the system is polled for Volume change events. */
		public function get interval():Number
		{
			return _timer.delay;
		}		
		
		/**
		 * Begins monitoring the specified file for changes.
		 * 
		 * Broadcasts Event.CHANGE event when the file's modification date has changed.
		 */
		public function watch():void
		{
			if (_watching == false)
			{
				_watching = true;

				if (_timer.hasEventListener(TimerEvent.TIMER) == false)
					_timer.start();

				_timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
			}
		}

		/** Stops watching the specified file for changes. */
		public function unwatch():void
		{
			if (_watching)
			{
				_watching = false;

				_timer.removeEventListener(TimerEvent.TIMER, onTimerEvent);

				if (_timer.hasEventListener(TimerEvent.TIMER) == false)
					_timer.stop();
			}
		}
		
		private function onTimerEvent(e:TimerEvent):void
		{
			var exist:Boolean = _file.exists;

			if (_lastExists != exist)
			{
				_lastExists = _file.exists;
				if (exist) _lastModifiedTime = _file.modificationDate.getTime();
				dispatchEventWith(Event.CHANGE);
			}
			else if (exist)
			{
				var modifiedTime:Number = _file.modificationDate.getTime();
				if (modifiedTime != _lastModifiedTime)
				{
					_lastModifiedTime = modifiedTime;
					dispatchEventWith(Event.CHANGE);
				}
			}
		}
	}
}