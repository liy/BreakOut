package com.aircapsule.air.collision
{
	import com.aircapsule.geom.Vector2D;

	public class ContactInfo
	{
		public var _dis:Number = 0;
		
		public var _witnesses:Vector.<Vector2D>;
		
		public var _pentrV:Vector2D;
		
		public var _n:Vector2D;
		
		/**
		 *  
		 * @param $dis
		 * @param $witnessPoints
		 * @param $pentrV
		 * @param $normal Direction is as the same as $pentrV, but a unit vector
		 * 
		 */		
		public function ContactInfo($dis:Number, $witnessPoints:Vector.<Vector2D>=null, $pentrV:Vector2D=null, $normal:Vector2D=null)
		{
			_dis = $dis;
			_witnesses = $witnessPoints;
			_pentrV = $pentrV;
			_n = $normal;
		}
	}
}