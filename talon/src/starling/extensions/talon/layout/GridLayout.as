package starling.extensions.talon.layout
{
	import starling.errors.AbstractMethodError;
	import starling.extensions.talon.core.Node;

	public class GridLayout extends Layout
	{
		public override function measureAutoWidth(node:Node, width:Number, height:Number):Number
		{
			throw new AbstractMethodError("Not implemented");
		}

		public override function measureAutoHeight(node:Node, width:Number, height:Number):Number
		{
			throw new AbstractMethodError("Not implemented");
		}

		public override function arrange(node:Node, width:Number, height:Number):void
		{
			throw new AbstractMethodError("Not implemented");
		}
	}
}
