package talon.types
{
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/** Dispatched when gauge change its amount/unit. */
	[Event(name="change", type="starling.events.Event")]
	/** Measured size. Defined by 'units' and 'amount'. */
	public final class Gauge extends EventDispatcher
	{
		/** Value is not set, and must be ignored. This is <code>null</code> analog. */
		public static const NONE:String = "none";
		/** Indicates that final value must be defined by measure context. */
		public static const AUTO:String = "auto";
		/** Regular pixel. */
		public static const PX:String = "px";
		/** Density-independent pixel (e.g. retina display set point per pixel as 1:2). */
		public static const DP:String = "dp";
		/** Millimeter. NB! Device independent (absolute) unit. (Undesirable to use absolute units. If possible then replace it with em/px). */
		public static const MM:String = "mm";
		/** Ems has dynamic value, 1em equals 'fontSize' of current node. */
		public static const EM:String = "em";
		/** Relative unit. Percentages target defined by parent node. */
		public static const PERCENT:String = "%";
		/** Relative unit (weight based). Unlike percent stars target defined by parent node and siblings. */
		public static const STAR:String = "*";

		private static const PATTERN:RegExp = /^(-?\d*\.?\d+)(px|dp|mm|em|%|\*|)$/;
		private static const HELPER:Gauge = new Gauge();

		/** @private */
		public static function toPixels(string:String, ppmm:Number, ppem:Number, ppdt:Number, pp100p:Number, aw:Number, ah:Number, ppts:Number, ts:int):Number
		{
			HELPER.parse(string);
			return HELPER.toPixels(ppmm, ppem, ppdt, pp100p, aw, ah, ppts, ts);
		}

		private var _unit:String = NONE;
		private var _amount:Number = 0;
		private var _auto:Function = null;

		/** Read string and parse it value, throw ArgumentError if string has not valid format. */
		public function parse(string:String):void
		{
			const prevUnit:String = _unit;
			const prevAmount:Number = _amount;

			if (string == NONE)
			{
				_unit = NONE;
				_amount = 0;
			}
			else if (string == AUTO)
			{
				if (!auto) throw new ArgumentError("Auto value is not allowed");
				_unit = AUTO;
				_amount = 0;
			}
			else if (string == STAR)
			{
				_unit = STAR;
				_amount = 1;
			}
			else
			{
				var match:Array = PATTERN.exec(string);
				if (match == null) throw ArgumentError("Input string is not valid gauge: " + string);
				_amount = parseFloat(match[1]);
				_unit = match[2] || PX;
			}

			if (prevUnit != _unit || prevAmount != _amount)
			{
				dispatchEventWith(Event.CHANGE);
			}
		}

		/** Strong typed values setup. */
		public function setTo(amount:Number, unit:String):void
		{
			if (_amount != amount || _unit != unit)
			{
				_amount = amount;
				_unit = unit;

				dispatchEventWith(Event.CHANGE);
			}
		}

		/**
		 * @private
		 * Transform gauge to pixels.
		 * Core & Hardcore function.
		 *
		 * @param ppmm pixels per millimeter
		 * @param ppem pixels per em
		 * @param ppdp pixels per density-independent point
		 * @param pp100p pixels per 100%
		 * @param aw available width (for 'auto' measure)
		 * @param ah available height (for 'auto' measure)
		 * @param ppts pixels per total stars
		 * @param s stars amount
		 */
		public function toPixels(ppmm:Number, ppem:Number, ppdp:Number, pp100p:Number, aw:Number = Infinity, ah:Number = Infinity, ppts:Number = 0, s:int = 0):Number
		{
			switch (unit)
			{
				case NONE:		return 0;
				case AUTO:		return auto(aw, ah);
				case PX:		return amount;
				case MM:		return amount * ppmm;
				case EM:        return amount * ppem;
				case DP:        return amount * ppdp;
				case PERCENT:   return amount * pp100p/100;
				case STAR:		return amount * (s?(ppts/s):0);
				default:		throw new Error("Unknown gauge unit: " + unit);
			}
		}

		/** Unit of measurement. */
		public function get unit():String { return _unit }
		public function set unit(value:String):void
		{
			if (_unit != value)
			{
				if (!auto && value == AUTO) throw new ArgumentError("Auto value is not allowed");

				_unit = unit;
				dispatchEventWith(Event.CHANGE);
			}
		}

		/** Amount of measurement. */
		public function get amount():Number { return _amount }
		public function set amount(value:Number):void
		{
			if (_amount != value)
			{
				_amount = value;
				dispatchEventWith(Event.CHANGE);
			}
		}

		/** Callback used for transform gauge to pixels (instead using <code>amount</code> property). */
		public function get auto():Function { return _auto }
		public function set auto(value:Function):void
		{
			if (isAuto && value == null) throw new ArgumentError("Auto callback can't be null, when gauge unit == AUTO");

			if (_auto != value)
			{
				_auto = value;
				// Do not dispatch Event.CHANGE
				// Event change cause change in binded Attribute. (@see TalonImage)
			}
		}

		/** Compares with another gauge and return <code>true</code> if they are equal. */
		public function equals(gauge:Gauge):Boolean
		{
			if (gauge == null) throw new ArgumentError("Parameter gauge must be non-null");

			return gauge.unit == unit
				&& gauge.amount == amount;
		}

		/** Gauge unit == AUTO. */
		public function get isAuto():Boolean
		{
			return _unit == AUTO;
		}

		/** Gauge unit == NONE. */
		public function get isNone():Boolean
		{
			return _unit == NONE;
		}

		/** @private */
		public function toString():String
		{
			if (isAuto) return AUTO;
			if (isNone) return NONE;
			if (_unit==STAR && _amount==1) return STAR;

			return _amount + _unit;
		}
	}
}
