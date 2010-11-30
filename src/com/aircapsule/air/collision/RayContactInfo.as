package com.aircapsule.air.collision
{
	import com.aircapsule.geom.Vector2D;

	public class RayContactInfo
	{
		/**
		 * source point 
		 */		
		public var source:Vector2D;
		
		/**
		 * ray direction
		 */		
		public var dir:Vector2D;
		
		/**
		 * Lambda value when ray hits the minkowski difference 
		 */		
		public var lambda:Number;
		
		/**
		 * Contact points on two shapes 
		 */		
		public var witnesses:Vector.<Vector2D>;
		
		/**
		 * unit normal vector of the contact position 
		 */		
		public var normal:Vector2D;
		
		public function RayContactInfo($source:Vector2D, $dir:Vector2D, $n:Vector2D=null, $lambda:Number=Number.POSITIVE_INFINITY, $witnesses:Vector.<Vector2D>=null)
		{
			source = $source;
			dir = $dir;
			lambda = $lambda;
			normal = $n;
			witnesses = $witnesses;
		}
	}
}