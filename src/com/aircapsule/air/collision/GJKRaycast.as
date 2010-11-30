package com.aircapsule.air.collision
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Shape;
	import com.aircapsule.geom.Vector2D;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class GJKRaycast
	{
		protected var _simplex:Simplex
		
		/**
		 * Ray 
		 */		
		public var r:Vector2D = new Vector2D();
		
		/**
		 * 
		 */		
		private var _elipson2:Number = 0.00001;
		
		private var _index:uint = 0;
		
		public function GJKRaycast()
		{
			_simplex = new Simplex();
			
		}
		
		/**
		 * 
		 * @param $shape1
		 * @param $shape2
		 * @return 
		 * 
		 */
		public function start($shape1:Shape, $shape2:Shape):RayContactInfo{
			_index = 0;
			
			var lambda:Number = 0;
			
			// The source vector point
			var s:Vector2D = new Vector2D();
			
			// the position vector on ray r
			var x:Vector2D = s.clone();
			
			// normal of the contact point
			var n:Vector2D = null;
			
			// arbitary vector
			var r1:Vector2D = $shape1.getTransformedVertices()[0];
			var r2:Vector2D = $shape2.getTransformedVertices()[0];
			var R:Vector2D = r1.subNew(r2);
			// the search direction
			var v:Vector2D = x.subNew(R);
			
			World.getVisual().graphics.lineStyle(1, 0xCC99CC, 1);
			World.getVisual().graphics.beginFill(0x8833FF, 1);
			World.getVisual().graphics.drawCircle(r1.x, r1.y, 1);
			World.getVisual().graphics.drawCircle(r2.x, r2.y, 2);
			World.getVisual().graphics.drawCircle(R.x, R.y, 3);
			
			// initialize simplex
			_simplex.size = 0;
			
			var S:SimplexVertex = new SimplexVertex(r1, r2);
			_simplex._vA = S;
			_simplex.size = 1;
			_simplex._sd = v.clone();
			
//			MonsterDebugger.trace(this, "v.length2: "+v.length2);
			
			// cloeset point to Origin.
			var c:Vector2D;
			
			while(v.length2 > _elipson2){
				if(++_index > 10){
					MonsterDebugger.trace(this, "out loop");
					return null;
				}
				
				var support1:Vector2D = $shape1.getSupport(v.clone());
				var support2:Vector2D = $shape2.getSupport(v.clone().reverse());
				var p:Vector2D = support1.subNew(support2);
				
				var w:Vector2D = x.subNew(p);
				
				
				if(v.dot(w) > 0){
					if(v.dot(r) >= 0){
//						MonsterDebugger.trace(this, "no intersection");
						return null;
					}
					else{
						lambda = lambda - v.dot(w)/v.dot(r);
						x = s.addNew(r.scaleNew(lambda));
						n = v.clone();
					}
				}
				
				
				var S:SimplexVertex = new SimplexVertex(support1, support2);
				_simplex.addSimplexVertex(S);
				
				// solve simplex
				switch(_simplex.size){
					case 2:
						_simplex.solveLine(x);
						break;
					case 3:
						_simplex.solveTriangle(x);
						break;
					case 1:
						break;
				}
				
				c = _simplex.getClosestPoint();
				
				// get closet point having problem!??!?!?!?!?!??!?!
				v = x.subNew(c);
			}
			
			MonsterDebugger.trace(this, "hit");
			
			var normal:Vector2D = c.addNew(n.normalize().scaleNew(20));
			World.getVisual().graphics.beginFill(0xFF00FF, 1);
			World.getVisual().graphics.moveTo(c.x, c.y);
			World.getVisual().graphics.lineTo(normal.x, normal.y);
			
			var pair:Vector.<Vector2D> = _simplex.getWitnessPoints();
			for(var i:uint=0; i<pair.length; ++i){
				World.getVisual().graphics.beginFill(0xFF00FF, 1);
				World.getVisual().graphics.drawCircle(pair[i].x, pair[i].y, 5);
			}
			
			
			return  new RayContactInfo(s, r.getUnit(), n.normalize(), lambda, _simplex.getWitnessPoints());
		}
		
		public function get simplex():Simplex{
			return _simplex;
		}
	}
}