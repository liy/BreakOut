package com.aircapsule.breakOut.display
{
	import com.aircapsule.air.collision.shape.Shape;
	import com.aircapsule.geom.Common;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import nl.demonsters.debugger.MonsterDebugger;

	/**
	 * Abstract class 
	 * @author Liy
	 * 
	 */	
	public class PhysicDO extends MovieClip
	{
		/**
		 * Collision detection shape 
		 */		
		public var shape:Shape;
		
		/**
		 *  
		 * 
		 */		
		public function PhysicDO()
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
		}
		
		protected function mouseDownHandler($e:MouseEvent):void{
			this.startDrag();
		}
		
		protected function mouseUpHandler($e:MouseEvent):void{
			this.stopDrag();
		}
		
		protected function mouseMoveHandler($e:MouseEvent):void{
			// Not sure why when dragging the sprite the x and y do not update
			// So we have to manual update position
			this.x = this.x;
			this.y = this.y;
		}
		
		public override function set x($value:Number):void{
			shape.affineTransform.tx = $value;
			super.x = $value;
		}
		
		public override function set y($value:Number):void{
			shape.affineTransform.ty = $value;
			super.y = $value;
		}
		
		public override function set rotation($value:Number):void{
			shape.affineTransform.identity();
			shape.affineTransform.rotate($value*Common.DEGREE_TO_RADIAN);
			shape.affineTransform.translate(this.x, this.y);
			super.rotation = $value;
		}
	}
}