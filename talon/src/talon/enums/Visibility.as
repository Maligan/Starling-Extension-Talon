package talon.enums
{
	[Deprecated(message="Replace to Boolean flag")]
	public final class Visibility
	{
		public static const VISIBLE:String = "visible";
		public static const HIDDEN:String = "hidden";
		public static const COLLAPSED:String = "collapsed";

		/** Indicates whether the given orientation string is valid. */
		public static function isValid(visibility:String):Boolean
		{
			return visibility == VISIBLE
				|| visibility == HIDDEN
				|| visibility == COLLAPSED;
		}
	}
}