package com.aircapsule.air
{
	import com.aircapsule.air.collision.shape.Shape;
	import com.aircapsule.geom.Vector2D;
	
	import flash.display.Sprite;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class World extends Sprite
	{
		private static var VISUAL:World = null;
		
		protected var _shapes:Vector.<Shape> = new Vector.<Shape>();
		
		public var _drawSupport:Boolean = true;
		
		public function World()
		{
			// I allow you to create multiple worlds.
		}
		
		/**
		 * Only one visual world is allowed.
		 * @return 
		 * 
		 */		
		public static function getVisual():World{
			if(VISUAL == null){
				VISUAL = new World();
			}
			return VISUAL;
		}
		
		public function addShape($shape:Shape):void{
			_shapes.push($shape);
		}
		
		public function removeShape($shape:Shape):Shape{
			var index:int = _shapes.indexOf($shape);
			var shape:Shape = null;
			if(index != -1){
				shape = _shapes.splice(index, 1)[0];
			}
			return shape;
		}
		
		public function debugDraw():void{
			this.graphics.clear();
			this.graphics.beginFill(0x00000, 1);
			this.graphics.drawCircle(0,0,2);
			for each(var shape:Shape in _shapes){
				// draw shapes
				shape.draw();
			}
			this.graphics.endFill();
		}
		
		public function drawCircle($pos:Vector2D, $radius:Number=5, $colour:uint=0xFF0000, $alpha:Number=0.8){
			this.graphics.beginFill($colour, $alpha);
			this.graphics.drawCircle($pos.x, $pos.y, $radius);
			this.graphics.endFill();
		}
		
		public function clearDraw():void{
			this.graphics.clear();
		}
	}
}