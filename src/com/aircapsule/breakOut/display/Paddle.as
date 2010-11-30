package com.aircapsule.breakOut.display
{
	import com.aircapsule.breakOut.scenes.GameScene;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Paddle
	{
		public var _box:Box;
		
		protected var _physicObjects:Vector.<PhysicObject> = new Vector.<PhysicObject>();
		
		protected var _gameScene:GameScene;
		
		public var _boxOffset:Point = new Point();
		
		public var _offset:Point = new Point();
		
		public function Paddle($gameScene:GameScene, $width:Number, $height:Number)
		{
			_gameScene = $gameScene;
			
			_box = new Box(0, 0, $width, $height);
			_gameScene.addChild(_box);
			_boxOffset.x = _box.shape._margin;
			_boxOffset.y = _box.shape._margin;
			
			_physicObjects.push(_box);
		}
		
		public function set x($value:Number):void{
			_box.x = _boxOffset.x + $value;
			
			_offset.x = $value;
		}
		
		public function set y($value:Number):void{
			_box.y = _boxOffset.y + $value;
			
			_offset.y = $value;
		}
		
		public function get x():Number{
			return _offset.x;
		}
		
		public function get y():Number{
			return _offset.y;
		}
		
		public function getPhysicObjects():Vector.<PhysicObject>{
			return _physicObjects;
		}
	}
}