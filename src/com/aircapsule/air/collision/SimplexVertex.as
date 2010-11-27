package com.aircapsule.air.collision
{
	import com.aircapsule.geom.Vector2D;

	public class SimplexVertex
	{
		/**
		 * The position vector from one of shape 1's vertex.
		 */		
		public var vertex1:Vector2D = new Vector2D();
		
		/**
		 * The position vector from one of shape 2's vertex. 
		 */		
		public var vertex2:Vector2D = new Vector2D();
		
		/**
		 * lambda, barycentric coordinate of the vertex on the simplex 
		 */		
		public var lbd:Number = 1;
		
		/**
		 * A vertex in a simplex. Contains extra information to calculate witness points and closest point. Such as,
		 * point1 substract point2 which result this simplex's vertex position, and the barycentric coordinate of the vertex on simplex. 
		 * @param $v1 Vertex from shape 1
		 * @param $v2 vertex from shape 2
		 * @param $lambda The barycentric coordinate of the vertex on the simplex
		 * 
		 */		
		public function SimplexVertex($v1:Vector2D, $v2:Vector2D, $lambda:Number=1){
			vertex1 = $v1;
			vertex2 = $v2;
			lbd = $lambda;
		}
		
		/**
		 * Calculate the simplex vertex's actual position vector.
		 * @return Simplex vertex's position vector.
		 * 
		 */		
		public function get vertex():Vector2D{
			return vertex1.subNew(vertex2);
		}
		
		/**
		 * clone me!
		 * @return A clone.
		 * 
		 */		
		public function clone():SimplexVertex{
			var v:SimplexVertex = new SimplexVertex(vertex1.clone(), vertex2.clone(), lbd);
			return v;
		}
	}
}