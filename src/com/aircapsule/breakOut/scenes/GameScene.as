package com.aircapsule.breakOut.scenes
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.ContactInfo;
	import com.aircapsule.air.collision.GJK;
	import com.aircapsule.air.collision.GJKRaycast;
	import com.aircapsule.air.collision.RayContactInfo;
	import com.aircapsule.breakOut.display.Ball;
	import com.aircapsule.breakOut.display.Box;
	import com.aircapsule.breakOut.display.Paddle;
	import com.aircapsule.breakOut.display.PhysicObject;
	import com.aircapsule.breakOut.display.TriangleObject;
	import com.aircapsule.geom.Vector2D;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class GameScene extends Sprite
	{
		protected var _ball:Ball;
		
		protected var _physicObjects:Vector.<PhysicObject> = new Vector.<PhysicObject>();
		
		public var _bounds:Rectangle;
		
		protected var _gjk:GJK;
		
		public var _startY:Number=0;
		
		protected var _paddle:Paddle;
		
		protected var _paddleObjects:Vector.<PhysicObject> = new Vector.<PhysicObject>();
		
		
		
		// ray casting vars
		
		protected var _gjkRaycast:GJKRaycast;
		
		protected var _rayhitInfos:Vector.<RayContactInfo> = new Vector.<RayContactInfo>();
		
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
			
			// create continuous gjk collision detector
			_gjkRaycast = new GJKRaycast();
			
			// initialize background physical world
			var world:World = World.getVisual();
			
			_ball = new Ball(4);
			_ball.x = 200;
			_ball.y = 300;
			_ball._velocity = new Vector2D(-3,-4.5);
			this.addChild(_ball);
			
			// physical world should be on the top most level. Easier for showing debug draw.
			this.addChild(world);
			
			// default bounds is the stage bounds
			_bounds = new Rectangle(_ball._radius, _ball._radius, this.stage.stageWidth-_ball._radius*2, stage.stageHeight-_ball._radius*2);
			
			// create boxes
			createBoxes();
			
			// create paddle
			_paddle = new Paddle(this, 60, 8);
			_paddle.x = this.stage.stageWidth/2;
			_paddle.y = 600 - _paddle._box.height;
			
			_paddleObjects = _paddle.getPhysicObjects();
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, movePaddleHandler, false, 0, true);
			
			// set timer, no delta elapsed time at the moment. Simple onEnterFrame event.
			this.addEventListener(Event.ENTER_FRAME, mainLoop);
		}
		
		private function createBoxes():void{
			var space:Number = 2;
			
			var ty:Number = _startY;
			var tx:Number = space/2;
			
			var brickWidth:Number = 40 - space;
			var brickHeight:Number = 10 - space;
			
			for(var i:uint=0; i<60; ++i){
				var box:Box = new Box(0, 0, brickWidth, brickHeight);
				box.x = tx + box.margin;
				box.y = ty + box.margin;
				
				tx += box.margin*2+brickWidth + space;
				
				if(tx>= this.stage.stageWidth){
					tx = space/2;
					ty += box.margin*2+brickHeight + space;
				}
				this.addChild(box);
				_physicObjects.push(box);
			}
		}
		
		protected function movePaddleHandler($e:KeyboardEvent):void{
			if($e.keyCode == Keyboard.LEFT){
//				_paddle.x -= 30;
//				if()
				_ball._velocity.rotate(-0.1);
			}
			else if($e.keyCode == Keyboard.RIGHT){
//				_paddle.x += 30;
				_ball._velocity.rotate(0.1);
			}
		}
		
		protected function mainLoop($e:Event):void{
			// update ball's position if it is not being dragged.
			if(!_ball.dragging){
				var edgeContact:Vector2D = raycast(new Vector2D(_ball.x, _ball.y), _ball._velocity);
				
				if(edgeContact != null){
					World.getVisual().clearDraw();
					World.getVisual().drawCircle(edgeContact, 3, 0x00FF00);
					
					_paddle.x += (edgeContact.x - _paddle._box.width/2 - _paddle.x)/20;
					_paddle.y += (edgeContact.y - _paddle.y)/20;
					
					if(_paddle.x < 0){
						_paddle.x = 0;
					}
					if(_paddle.x + _paddle._box.width >= 480){
						_paddle.x = 480 - _paddle._box.width;
					}
				}
				
				if(!outBounds() && !checkCollision()){
					// move ball
					_ball.move();
				}
			}
		}
		
		protected function checkCollision():Boolean{
			for(var i:uint=0; i<_physicObjects.length; ++i){
				var contactInfo:ContactInfo = _gjk.start(_ball.shape, _physicObjects[i].shape);
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
					vp.scale(_physicObjects[i]._friction);
					
					// bounce
					vn.scale(_physicObjects[i]._bounce);
					
					// reverse the vector along contact normal
					_ball._velocity = vn.reverse().addNew(vp);
					
					// remove the box
					removeBrick(_physicObjects[i], i);
				}
			}
			
			for(var i:uint=0; i<_paddleObjects.length; ++i){
				var contactInfo:ContactInfo = _gjk.start(_ball.shape, _paddleObjects[i].shape);
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
					vp.scale(_paddleObjects[i]._friction);
					
					// bounce
					vn.scale(_paddleObjects[i]._bounce);
					
					// reverse the vector along contact normal
					_ball._velocity = vn.reverse().addNew(vp);
				}
			}
			
			return false;
		}
		
		/**
		 * 
		 * @param R Source vector
		 * @param r direction vector
		 * @return 
		 * 
		 */		
		protected function raycast(R:Vector2D, r:Vector2D):Vector2D{
			// segment AB
			var A:Vector2D = new Vector2D(0, 600-_paddle._box.height);
			var B:Vector2D = new Vector2D(480, 600-_paddle._box.height);
				
			var RA:Vector2D = A.subNew(R);
			var BA:Vector2D = A.subNew(B);
				
			// P = R + lambda * r
			// P = A + beta   * (B - A)
			// If segment and ray intersect
			// using cramer's rule to solve beta and lambda
			var denominator:Number = r.x*BA.y - r.y*BA.x;
				
			// impossible
			if(denominator == 0){
				// two lines parallel
				return null;
			}
				
			var lambda:Number = (RA.x*BA.y - RA.y*BA.x)/denominator;
			var beta:Number = (r.x*RA.y - r.y*RA.x)/denominator;
			
			if(lambda < 0){
				// no intersection, two line intersect at opposite ray direction
				// ball is going upward.
				// probably we can use Continuous GJK to detect box collision in the future here.
				return null;
			}
			
			// going downward
				
			// intersect on the left boundary
			if(beta < 0){
				
				A = new Vector2D();
				B = new Vector2D(0, 600);
				
				var RA:Vector2D = A.subNew(R);
				var BA:Vector2D = A.subNew(B);
				
				var denominator:Number = r.x*BA.y - r.y*BA.x;
				var lambda:Number = (RA.x*BA.y - RA.y*BA.x)/denominator;
				
				var newSource:Vector2D = R.addNew(r.scaleNew(lambda))
				
				var n:Vector2D = new Vector2D(1, 0);
				
				// vector along normal
				var vn:Vector2D = n.scaleNew(r.dot(n));
				// vector perpendicular to normal
				var vp:Vector2D = r.subNew(vn);
					
				var newDir:Vector2D = vn.reverse().addNew(vp);
					
				return raycast(newSource, newDir);
			}
			// intersect on the left boundary
			else if(beta > 1){
//				MonsterDebugger.trace(this, "right");
					
				A = new Vector2D(480, 0);
				B = new Vector2D(480, 600);
					
				var RA:Vector2D = A.subNew(R);
				var BA:Vector2D = A.subNew(B);
				
				var denominator:Number = r.x*BA.y - r.y*BA.x;
				var lambda:Number = (RA.x*BA.y - RA.y*BA.x)/denominator;
				
				var newSource:Vector2D = R.addNew(r.scaleNew(lambda))
					
				var n:Vector2D = new Vector2D(-1, 0);
				
				// vector along normal
				var vn:Vector2D = n.scaleNew(r.dot(n));
				// vector perpendicular to normal
				var vp:Vector2D = r.subNew(vn);
					
				var newDir:Vector2D = vn.reverse().addNew(vp);
					
				// recursivly detect downward collision on bottom edge or ball is going upward or two line parallel(imossible)
				return raycast(newSource, newDir);
			}
				
			// contact on the top boundary
			return R.addNew(r.scaleNew(lambda));	
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
		
		protected function removeBrick($brick:PhysicObject, $index:uint):void{
			_physicObjects.splice($index, 1);
			this.removeChild($brick);
		}
	}
}