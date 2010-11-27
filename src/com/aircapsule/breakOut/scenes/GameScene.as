package com.aircapsule.breakOut.scenes
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.ContactInfo;
	import com.aircapsule.air.collision.GJK;
	import com.aircapsule.breakOut.display.Ball;
	import com.aircapsule.breakOut.display.Box;
	import com.aircapsule.geom.Vector2D;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class GameScene extends Sprite
	{
		protected var _ball:Ball;
		
		protected var _boxes:Vector.<Box> = new Vector.<Box>();
		
		public var _bounds:Rectangle;
		
		protected var _gjk:GJK
		
		public function GameScene()
		{
			
		}
		
		/**
		 * Initialize must be called AFTER added onto the stage 
		 * 
		 */		
		public function init():void{
			// create GJK collision detector
			_gjk = new GJK();
			
			// initialize background physical world
			var world:World = World.getVisual();
			
			_ball = new Ball(4);
			_ball._a = new Vector2D(0, 0.1);
			_ball._velocity = new Vector2D(0,0);
			this.addChild(_ball);
			
			// physical world should be on the top most level. Easier for showing debug draw.
			this.addChild(world);
			
			// default bounds is the stage bounds
			_bounds = new Rectangle(_ball._radius, _ball._radius, this.stage.stageWidth-_ball._radius*2, stage.stageHeight-_ball._radius*2);
			_ball.x = _bounds.x;
			_ball.y = _bounds.y;
			
			// create boxes
			createBoxes();
			
			// set timer, no delta elapsed time at the moment. Simple onEnterFrame event.
			this.addEventListener(Event.ENTER_FRAME, mainLoop);
		}
		
		private function createBoxes():void{
			for(var i:uint=0; i<20; ++i){
				var ranSize:Number = Math.random()*15;
				var box:Box = new Box(0, 0, 10+ranSize, 10+ranSize);
				box.x = Math.random()*(this.stage.stageWidth - 25);
				box.y = Math.random()*(100 - 25)+this.stage.stageHeight-100;
//				box._friction = Math.random()*0.5+0.5;
				box._bounce = 0;
				box.rotation = Math.random()*360;
				this.addChild(box);
				_boxes.push(box);
			}
		}
		
		protected function mainLoop($e:Event):void{
			// update ball's position if it is not being dragged.
			if(!_ball.dragging){
				if(!outBounds() && !checkCollision()){
					// move ball
					_ball.move();
				}
			}
		}
		
		protected function checkCollision():Boolean{
			for(var i:uint=0; i<_boxes.length; ++i){
				var contactInfo:ContactInfo = _gjk.start(_ball.shape, _boxes[i].shape);
				// contact
				if(contactInfo != null){
					// resolve penetration
					_ball.x += contactInfo._pentrV.x;
					_ball.y += contactInfo._pentrV.y;
					
					// reverse sub velocity vector direction on the contact normal direction
					// vector along contact normal
					var vn:Vector2D = contactInfo._n.scaleNew(_ball._velocity.dot(contactInfo._n));
					// vector perpendicular to normal
					var vp:Vector2D = _ball._velocity.subNew(vn);
					
					// friction
					vp.scale(_boxes[i]._friction);
					
					// bounce
					vn.scale(_boxes[i]._bounce);
					
					// reverse the vector along contact normal
					_ball._velocity = vn.reverse().addNew(vp);
				}
			}
			return false;
		}
		
		protected function outBounds():Boolean{
			var out:Boolean = false;
			
			if(_ball.x < _bounds.x){
				_ball.x = _bounds.x;
				_ball._velocity.x = -_ball._velocity.x;
				
				out = true;
			}
			else if(_ball.x > _bounds.x + _bounds.width){
				_ball.x = _bounds.x + _bounds.width;
				_ball._velocity.x = -_ball._velocity.x;
				
				out = true;
			}
			
			if(_ball.y < _bounds.y){
				_ball.y = _bounds.y;
				_ball._velocity.y = -_ball._velocity.y;
				
				out = true;
			}
			else if(_ball.y > _bounds.y + _bounds.height){
				_ball.y = _bounds.y + _bounds.height;
				_ball._velocity.y = -_ball._velocity.y;
				
				out = true;
			}
			return out;
		}
	}
}