package com.aircapsule.air.collision
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Shape;
	import com.aircapsule.geom.Vector2D;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class GJK
	{
		protected var _simplex:Simplex;
		
		public var _tolerence2:Number = 0.001;	
		
		public function GJK()
		{
			_simplex = new Simplex();
		}
		
		public function start($shape1:Shape, $shape2:Shape):ContactInfo{
			var r1:Vector2D = $shape1.affineTransform.transformVector($shape1._vertices[0].clone());
			var r2:Vector2D = $shape2.affineTransform.transformVector($shape2._vertices[0].clone());
			
			// initialize search direction and simplex vertex A
			_simplex._sd = r2.subNew(r1);
			_simplex._vA = new SimplexVertex(r1, r2, 1);
			_simplex.size = 1;
			
			// origin
			var O:Vector2D = new Vector2D();
			
			// init support point
			var supportPoint:Vector2D = null;
			
			var i:uint=0;
			while(true){
				var oldVertices:Vector.<Vector2D> = _simplex.getVertices();
				
				switch(_simplex.size){
					case 2:
						_simplex.solveLine(O);
						break;
					case 3:
						_simplex.solveTriangle(O);
						break;
					default:
						break;
				}
				
				if(_simplex.size == 3){
					break;
				}
				
				var P:Vector2D = _simplex.getClosestPoint();
				
				// Get the support point
				var support1:Vector2D = $shape1.getSupport(_simplex._sd);
				var support2:Vector2D = $shape2.getSupport(_simplex._sd.clone().reverse());
				supportPoint = support1.subNew(support2);
				
				if(P.length2 <= _tolerence2){
					break;
				}
				
				//check if the support point has already been added into the simplex
				var duplicated:Boolean = false;
				for each(var ov:Vector2D in oldVertices){
					if(ov.equalTo(supportPoint)){
						duplicated = true;
						break;
					}
				}
				if(duplicated){
					break;
				}
				
				++i;
				if(i >= 5){
					break;
				}
				
				var S:SimplexVertex = new SimplexVertex(support1, support2, 1);
				_simplex.addSimplexVertex(S);
			}
			
			var n:Vector2D = _simplex._sd.getUnit().reverse();
			var dis:Number = n.dot(supportPoint);
			if(dis < $shape1._margin+$shape2._margin && dis > _tolerence2){
				var peneLength:Number = $shape1._margin+$shape2._margin - dis;
				var witnesses:Vector.<Vector2D> = _simplex.getWitnessPoints();
				var scInfo:ContactInfo = new ContactInfo(peneLength, witnesses, n.scaleNew(peneLength), n);
				
				return scInfo;
			}
			
			return null;
		}
	}
}