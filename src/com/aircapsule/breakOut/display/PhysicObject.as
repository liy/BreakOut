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
	public class PhysicObject extends MovieClip
	{
		/**
		 * Collision detection shape 
		 */		
		public var shape:Shape;
		
		/**
		 * 
		 */		
		protected var _dragging:Boolean = false;
		
		/**
		 * Friction: 0-1, 1 means none, 0 means max friction 
		 */		
		public var _friction:Number = 1;
		
		/**
		 * bounce: 0-infinity, 0 means no bounce at all, 1 means rigid surface, >1 means extra bounce
		 */		
		public var _bounce:Number = 1;
		
		/**
		 *  
		 * 
		 */		
		public function PhysicObject()
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
		}
		
		protected function mouseDownHandler($e:MouseEvent):void{
			this.startDrag();
			_dragging = true;
		}
		
		protected function mouseUpHandler($e:MouseEvent):void{
			this.stopDrag();
			_dragging = false;
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
		
		public function get dragging():Boolean{
			return _dragging;
		}
	}
}