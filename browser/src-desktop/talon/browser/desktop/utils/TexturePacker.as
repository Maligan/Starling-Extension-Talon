package talon.browser.desktop.utils
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;

	public class TexturePacker
	{
		private var _exec:File;
		private var _args:String;
		private var _temp:File;
		private var _data:String;

		public function TexturePacker(exec:File)
		{
			_exec = exec;
		}
		
		public function init(temp:File, data:String, args:String)
		{
			_temp = temp;
			_data = data;
			_args = args;
		}

		/** Return Vector.<Files> into fulfill() or Error into reject(). */
		public function exec(files:Vector.<File>):Promise
		{
			var promise:Promise = new Promise();

			// Errors
			if (files.length == 0)
			{
				promise.fulfill(new <File>[]);
				return promise;
			}
			
			if (!NativeProcess.isSupported)
			{
				promise.reject(new Error("Internal Error: NativeProcess is not supported"));
				return promise;
			}
			
			if (!_exec.exists)
			{
				promise.reject(new Error("File not found: " + _exec.nativePath));
				return promise;
			}
			
			// Prepare
			var processInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			
			try { processInfo.executable = _exec; }
			catch (e:Error) { promise.reject(e); return promise }
			
			processInfo.arguments.push("--data", _temp.nativePath + File.separator + _data);
			processInfo.arguments.push.apply(null, parseArgs(_args));

			for each (var file:File in files)
				processInfo.arguments[processInfo.arguments.length] = file.nativePath;

			// Start
			var processError:String = "";
			var process:NativeProcess = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onProcessError);
			process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
			process.start(processInfo);

			function onProcessError(e:ProgressEvent):void
			{
				processError += process.standardError.readUTFBytes(process.standardError.bytesAvailable);
			}

			function onProcessExit(e:NativeProcessExitEvent):void
			{
				if (e.exitCode != 0)
				{
					promise.reject(new Error(processError, e.exitCode));
				}
				else
				{
					var files:Vector.<File> = null;
					
					try { files = Vector.<File>(_temp.getDirectoryListing()) }
					catch (e:Error) { promise.reject(e); return; }

					promise.fulfill(files);
				}
			}

			return promise;
		}

		private function parseArgs(args:String):Array
		{
			return args ? args.split(" ") : [];
		}
		
		
	}
}