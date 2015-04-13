package browser.dom.log
{
	import browser.utils.Constants;

	import starling.utils.formatString;

	public class DocumentMessage
	{
		//
		// Types
		//
		public static const FILE_READ_ERROR:String =                    "E1:    Can't access to file {0}";
		public static const FILE_LISTING_ERROR:String =                 "E2:    Folder {0} can't be listed";

		public static const FILE_CONTAINS_WRONG_CSS:String =            "E3:    File {0} contains wrong CSS";
		public static const FILE_CONTAINS_WRONG_XML:String =            "E4:    File {0} contains wrong XML";
		public static const FILE_CONTAINS_WRONG_ELEMENT:String =        "W5:    File {0} contains wrong element '{1}'";
		public static const FILE_CONTAINS_WRONG_IMAGE_FORMAT:String =   "E6:    File {0} has unknown texture format (supported only " + Constants.SUPPORTED_IMAGE_EXTENSIONS.join() + " formats)";

		public static const FILE_ATLAS_IMAGE_MISSED:String =            "W7:    Atlas {0} image {1} not found";
		public static const FILE_FONT_IMAGE_MISSED:String =             "W8:    Font {0} image {1} not found";

		public static const TEMPLATE_ERROR:String =                     "E9:    Template in file {0} produce error: {1}";

		//
		// Message
		//
		private var _number:int;
		private var _level:int;
		private var _text:String;

		public function DocumentMessage(type:String, args:Array)
		{
			var pattern:RegExp = /(E|W|I)(\d+):\s*(.+)/;
			var split:Array = pattern.exec(type);
			if (split == null) throw new ArgumentError("Type is invalid");

			_level = (split[1]=="E") ? 2 : (split[1]=="W") ? 1 : 0;
			_number = parseInt(split[2]);
			_text = formatString.apply(split[3], args);
		}

		public function get number():int { return _number }
		public function get level():int { return _level }
		public function get text():String { return _text }
	}
}
