package com.aircapsule.air.collision
{
	import com.aircapsule.geom.Vector2D;

	public class Simplex
	{
		/**
		 * The latest vertex added to the simplex 
		 */		
		public var _vA:SimplexVertex;
		
		/**
		 * The previous vertex added to the simplex 
		 */		
		public var _vB:SimplexVertex;
		
		/**
		 * The oldest vertex added to the simplex
		 */		
		public var _vC:SimplexVertex;
		
		/**
		 * Number of vertices in the simplex 
		 */		
		public var size:uint = 0;
		
		/**
		 * 
		 */		
		public var _sd:Vector2D
		
		protected var _denominator:Number = 1;
		
		/**
		 * 
		 * 
		 */		
		public function Simplex()
		{
			
		}
		
		public function solveLine(O:Vector2D):void{
			// TODO:  the actual position Vector2D of the simplex calculation can be optimized.
			// no need to calculate them every time.
			var A:Vector2D = _vA.vertex;
			var B:Vector2D = _vB.vertex;
			
			var AB:Vector2D = B.subNew(A);
			var BA:Vector2D = A.subNew(B);
			
			var AO:Vector2D = O.subNew(A);
			var BO:Vector2D = O.subNew(B);
			
			var v:Number = AO.dot(AB);
			var u:Number = BO.dot(BA);
			
			// A region
			if(v <= 0){
				size = 1;
				_denominator = 1;
				
				// no need to update the simplex vertices
				
				_vA.lbd = 1;
				
				_sd = AO;
				return;
			}
			
			// B region. If we do not use cached simplex, we can simply ignore this condition.
			if(u <= 0){
				size = 1;
				_denominator = 1;
				
				// update latest simplex vertex A to simplex vertex B
				_vA = _vB;
				_vA.lbd = 1;
				
				_sd = BO;
				return;
			}
			
			// AB region
			size = 2;
			_denominator = 1/AB.dot(AB);
			
			// no need to update the simplex vertices
			
			_vA.lbd = u;
			_vB.lbd = v;
			
			_sd = AB.getPerp(AO);
		}
		
		public function solveTriangle(O:Vector2D):void{
			// TODO:  the actual position Vector2D of the simplex calculation can be optimized.
			// no need to calculate them every time.
			var A:Vector2D = _vA.vertex;
			var B:Vector2D = _vB.vertex;
			var C:Vector2D = _vC.vertex;
			
			// note that, in order to prevent divide by 0, and using latest cached simplex vertices.
			// we have to check all the conditions
			
			// start checking A, B and C regions
			
			// A region
			var AO:Vector2D = O.subNew(A);
			var AB:Vector2D = B.subNew(A);
			var AC:Vector2D = C.subNew(A);
			var vAB:Number = AO.dot(AB);
			var vAC:Number = AO.dot(AC);
			if(vAB <= 0 && vAC <= 0){
				size = 1;
				_denominator = 1;
				
				_vA.lbd = 1;
				
				_sd = AO;
				return;
			}
			
			// B region
			var BA:Vector2D = A.subNew(B);
			var BC:Vector2D = C.subNew(B);
			var BO:Vector2D = O.subNew(B);
			var uAB:Number = BO.dot(BA);
			var vBC:Number = BO.dot(BC);
			if(uAB <= 0 && vBC <= 0){
				size = 1;
				_denominator = 1;
				
				_vA = _vB;
				_vA.lbd = 1;
				
				_sd = BO;
				return;
			}
			
			// C region
			var CA:Vector2D = A.subNew(C);
			var CB:Vector2D = B.subNew(C);
			var CO:Vector2D = O.subNew(C);
			var uAC:Number = CO.dot(CA);
			var uBC:Number = CO.dot(CB);
			if(uAC <= 0 && uBC <= 0){
				size = 1;
				_denominator = 1;
				
				_vA = _vC;
				_vA.lbd = 1;
				
				_sd = CO;
				return;
			}
			
			// start checking AB, AC, and BC region
			
			// u*Ax + v*Bx + w*Cx = Px = 0
			// u*Ay + v*By + w*Cy = Py = 0
			// u    + v    + w 	  = 1  = 1
			//
			// [Ax Bx Cx]  *  [u]  = [Px] = 0
			// [Ay By Cy]     [v]  = [Py] = 0
			// [1  1  1 ]     [w]  = [1]  = 1
			var divider:Number = A.x*B.y + B.x*C.y + C.x*A.y - C.x*B.y - B.x*A.y - A.x*C.y;
			var uABC:Number = B.x*C.y - C.x*B.y;
			var vABC:Number = C.x*A.y - A.x*C.y;
			var wABC:Number = A.x*B.y - B.x*A.y;
			
			// AB region
			if(uAB>0 && vAB>0 && wABC*divider<=0){
				size = 2;
				_denominator = 1/AB.dot(AB);
				
				// update barycentric coordinate for minimum vertices(which is a line)
				//      vAB        uAB
				//       |          |
				// A _________P___________ B
				// 
				// note that uAB is a coefficient for A, but it actually express PB's magnitude
				// That's why a.bc should be uAB not vAB.
				_vA.lbd = uAB;
				_vB.lbd = vAB;
				
				_sd = AB.getPerp(AO);
				return;
			}
			
			// AC region
			if(uAC>0 && vAC>0 && vABC*divider<=0){
				size = 2;
				_denominator = 1/AC.dot(AC);
				
				// update simplex vertices
				_vB = _vC;
				
				_vA.lbd = uAC;
				_vB.lbd = vAC;
				
				_sd = AC.getPerp(AO);
				return;
			}
			
			// if A,B,C are collinear, we have to check BC region
			// BC region
			if(uBC>0 && vBC>0 && uABC*divider<=0){
				size = 2;
				_denominator = 1/BC.dot(BC);
				
				// update simplex vertices
				_vA = _vB;
				_vB = _vC;
				
				_vA.lbd = uBC;
				_vB.lbd = vBC;
					
				_sd = BC.getPerp(BO);
				return;
			}
			
			// in ABC region
			size = 3;
			_denominator = 1/divider;
			
			_vA.lbd = uABC;
			_vB.lbd = vABC;
			_vC.lbd = wABC;
			
			_sd = new Vector2D();
		}
		
		public function getWitnessPoints():Vector.<Vector2D>{
			var G:Vector2D = new Vector2D();
			var H:Vector2D = new Vector2D();
			
			switch(size){
				case 1:
					G = _vA.vertex1.scaleNew(_vA.lbd*_denominator);
					H = _vA.vertex2.scaleNew(_vA.lbd*_denominator);
					break;
				case 2:
					// G = u*A1 + v*B1
					// vertex1 = A.r*A.vertex1 + B.r*B.vertex1
					G = _vA.vertex1.scaleNew(_vA.lbd*_denominator).addNew(_vB.vertex1.scaleNew(_vB.lbd*_denominator));
					// H = u*A2 + v*B2
					// vertex2 = A.r*A.vertex2 + B.r*B.vertex2
					H = _vA.vertex2.scaleNew(_vA.lbd*_denominator).addNew(_vB.vertex2.scaleNew(_vB.lbd*_denominator));
					break;
				case 3:
					G = _vA.vertex1.scaleNew(_vA.lbd*_denominator).addNew(_vB.vertex1.scaleNew(_vB.lbd*_denominator)).addNew(_vC.vertex1.scaleNew(_vC.lbd*_denominator));
					H = G.clone();
					break;
				default:
					throw new Error("simplex size error, witness point");
					break;
			}
			
			var points:Vector.<Vector2D> = new Vector.<Vector2D>();
			points[0] = G;
			points[1] = H;
			return points;
		}
		
		public function getClosestPoint():Vector2D{
			switch(size){
				case 1:
					return _vA.vertex;
					break;
				case 2:
					var A:Vector2D = _vA.vertex;
					var B:Vector2D = _vB.vertex;
					
					//uA + vB = P
					return A.scaleNew(_vA.lbd*_denominator).addNew(B.scaleNew(_vB.lbd*_denominator))
					break;
				case 3:
					return new Vector2D();
					break;
				default:
					throw new Error("getClosetPoint, simplex size error: "+size);
					break;
			}
		}
		
		public function getVertices():Vector.<Vector2D>{
			var vertices:Vector.<Vector2D> = new Vector.<Vector2D>();
			switch(size){
				case 1:
					vertices[0] = _vA.vertex;
					break;
				case 2:
					vertices[0] = _vA.vertex;
					vertices[1] = _vB.vertex;
					break;
				case 3:
					vertices[0] = _vA.vertex;
					vertices[1] = _vB.vertex;
					vertices[2] = _vC.vertex;
					break;
				default:
					throw new Error("simplex size error: "+size);
					break;
			}
			
			return vertices;
		}
		
		/**
		 * 
		 * @param $S
		 * 
		 */		
		public function addSimplexVertex($S:SimplexVertex):void{
			switch(size){
				case 1:
					_vB = _vA;
					_vA = $S;
					size = 2;
					break;
				case 2:
					_vC = _vB; 
					_vB = _vA;
					_vA = $S;
					size = 3;
					break;
				default:
					throw new Error("Add minimum error");
					break
			}
		}
	}
}