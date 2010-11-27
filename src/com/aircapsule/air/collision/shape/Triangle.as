package com.aircapsule.air.collision.shape
{
	import com.aircapsule.geom.Vector2D;

	public class Triangle extends Shape
	{
		public function Triangle($A:Vector2D=null, $B:Vector2D=null, $C:Vector2D=null)
		{
			var v:Vector2D = new Vector2D(100, 0);
			if($A == null){
				$A = new Vector2D();
			}
			
			if($B == null){
				$B = $A.addNew(v);
			}
			
			
			if($C == null){
				v.rotate(Math.PI/3);
				$C = $A.addNew(v);
			}
			
			_vertices[0] = $A;
			_vertices[1] = $B;
			_vertices[2] = $C;
		}
	}
}