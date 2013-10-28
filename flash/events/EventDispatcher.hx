package flash.events;


import flash.events.Event;
import flash.events.IEventDispatcher;
import openfl.utils.WeakRef;


class EventDispatcher implements IEventDispatcher {
	
	
	@:noCompletion private var __eventMap:EventMap;
	@:noCompletion private var __target:IEventDispatcher;
	
	
	public function new (target:IEventDispatcher = null):Void {
		
		__target = (target == null ? this : target);
		__eventMap = null;
		
	}
	
	
	public function addEventListener (type:String, listener:Function, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		if (__eventMap == null) {
			
			__eventMap = new EventMap ();
			
		}
		
		var list = __eventMap.get (type);
		
		if (list == null) {
			
			list = new ListenerList ();
			__eventMap.set (type, list);
			
		}
		
		list.push (new Listener (new WeakRef<Function> (listener, useWeakReference), useCapture, priority));
		list.sort (__sortEvents);
		__updateListenerCount(type, 1);
		
	}
	

	public function dispatchEvent (event:Event):Bool {
		
		if (__eventMap == null) {
			
			return false;
			
		}
		
		if (event.target == null) {
			
			event.target = __target;
			
		}
		
		if (event.currentTarget == null) {
			
			event.currentTarget = __target;
			
		}
		
		var list = __eventMap.get (event.type);
		var capture = (event.eventPhase == EventPhase.CAPTURING_PHASE);
		
		if (list != null) {
			
			var index = 0;
			
			var listItem, listener;
			var deleteCount = 0;
			
			while (index < list.length) {
				
				listener = list[index];
				if (listener.listener.get() == null) {
					
					list.splice (index, 1);
					deleteCount--;
					
				} else {
					
					if (listener.useCapture == capture) {
						
						listener.dispatchEvent (event);
						
						if (event.__getIsCancelledNow ()) {
							
							break;
							
						}
						
					}
					
					index++;
					
				}
				
			}
			
			__updateListenerCount(event.type, deleteCount);
			return true;
			
		}
		
		return false;
		
	}
	
	
	public function hasEventListener (type:String):Bool {
		
		if (__eventMap == null) {
			
			return false;
			
		}
		
		var list = __eventMap.get (type);
		var deleteCount = 0;
		
		if (list != null) {
			
			while (list.length > 0) {
				
				var item = list[0];
				if (item.listener.get() != null) {
					
					if (deleteCount < 0) __updateListenerCount(type, deleteCount);
					return true;
					
				} else {
					
					list.shift();
					deleteCount--;
					
				}
				
			}
			
		}
		
		if (deleteCount < 0) __updateListenerCount(type, deleteCount);
		return false;
		
	}
	
	
	public function removeEventListener (type:String, listener:Function, capture:Bool = false):Void {
		
		if (__eventMap == null || !__eventMap.exists (type)) {
			
			return;
			
		}
		
		var list = __eventMap.get (type);
		var item;
		
		for (i in 0...list.length) {
			
			item = list[i];
			if (item != null && item.is (listener, capture)) {
				
				list.splice(i, 1);
				__updateListenerCount(type, -1);
				return;
				
			}
			
		}
		
	}
	
	
	public function toString ():String {
		
		return "[object " + Type.getClassName (Type.getClass (this)) + "]";
		
	}
	
	
	public function willTrigger (type:String):Bool {
		
		return hasEventListener (type);
		
	}
	
	
	@:keep @:noCompletion private function __updateListenerCount (type:String, diff:Int):Void { }
	
	
	@:noCompletion public function __dispatchCompleteEvent ():Void {
		
		dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
	@:noCompletion public function __dispatchIOErrorEvent ():Void {
		
		dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
		
	}
	
	
	@:noCompletion private static inline function __sortEvents (a:Listener, b:Listener):Int {
		
		return a.priority == b.priority ? a.id - b.id : b.priority - a.priority;
		
	}
	
	
}


class Listener {
	
	
	public var id:Int;
	public var listener:WeakRef <Function>;
	public var priority:Int;
	public var useCapture:Bool;

	private static var __id = 1;
	
	
	public function new (listener:WeakRef <Function>, useCapture:Bool, priority:Int) {
		
		this.listener = listener;
		this.useCapture = useCapture;
		this.priority = priority;
		id = __id++;
		
	}
	
	
	public function dispatchEvent (event:Event):Void {
		
		listener.get () (event);
		
	}
	
	
	public function is (listener:Function, useCapture:Bool) {
		
		return (Reflect.compareMethods (this.listener.get(), listener) && this.useCapture == useCapture);
		
	}
	
	
}


typedef ListenerList = Array<Listener>;
typedef EventMap = haxe.ds.StringMap<ListenerList>;