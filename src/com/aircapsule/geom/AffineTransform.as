package com.aircapsule.geom
{
	import flash.geom.Matrix;

	/**
	 * 
	 * @author Liy
	 * 
	 */	
	public class AffineTransform extends Matrix
	{	
		public function AffineTransform($a:Number=1, $b:Number=0, $c:Number=0, $d:Number=1, $tx:Number=0, $ty:Number=0){
			super($a, $b, $c, $d, $tx, $ty);
		}
		
		/**
		 * Convert a matrix to AffineTransform instance. 
		 * @param $m
		 * @return 
		 * 
		 */		
		public function toAffineTransform($m:Matrix):AffineTransform{
			this.a = $m.a;
			this.b = $m.b;
			this.c = $m.c;
			this.d = $m.d;
			this.tx = $m.tx;
			this.ty = $m.ty;
			
			return this;
		}
		
		/**
		 * Directly apply to the parameter Vector2D instance. This does not clone the vector. 
		 * @param $v The Vector2D you want to transform.
		 * @return The transformed same Vector2D instance.
		 * 
		 */		
		public function transformVector($v:Vector2D):Vector2D{
			var x = $v.x*a + $v.y*c + tx;
			var y = $v.x*b + $v.y*d + ty;
			
			$v.x = x;
			$v.y = y;
			
			return $v;
		}
		
		/**
		 * Transform support search direction. 
		 * Support mapping only apply the rotation and skew transformations, so translation tx and ty are ignored. 
		 * Also note that the transformation is reversed.
		 * @param $d Search direction.
		 * @return The transformed same search direction Vector2D instance.
		 * 
		 */		
		public function transformSupportSearchDir($d:Vector2D):Vector2D{
			// var x:Number = x*cos - y*sin;
			// var y:Number = x*sin + y*cos;
			//
			// only rotation will be applied, and the rotation is the reverse of the original rotation
			// Because: sin(-theta) = -sin(theta) and cos(-theta) = cos(theta) 
			var x = $d.x*a - $d.y*c;
			var y = -$d.x*b + $d.y*d;
			
			$d.x = x;
			$d.y = y;
			
			return $d; 
		}
	}
}