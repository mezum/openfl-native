package flash.display;


import openfl.utils.WeakRef;


using Lambda;

class MovieClip extends Sprite {
	
	
	public var currentFrame (default, null):Int = 0;
	public var enabled:Bool;
	public var framesLoaded (default, null):Int;
	public var totalFrames (default, null):Int = 1;
	
	@:noCompletion private static var __frameClips:Array<WeakRef<MovieClip>> = new Array<WeakRef<MovieClip>>();
	@:noCompletion private static var __numMC:Int = 0;
	@:noCompletion private var __frameScripts:Array<Void -> Void>;
	@:noCompletion private var __numFrameScripts:Int = 0;
	@:noCompletion private var __beforeFrame:Int = -1;
	@:noCompletion private var __clipNo:Int;
	
	
	public function new () {
		
		super ();
		
		__clipNo = __numMC++;
		__frameScripts = [];
		
	}
	
	
	public function addFrameScript (frame:Int, script:Void->Void):Void {
		
		if (frame >= totalFrames) {
			return;
		}
		
		if (script != null) {
			
			if (__frameScripts[frame + 1] == null) {
				
				if (++__numFrameScripts == 1) {
					
					var l = 0;
					var r = __frameClips.length - 1;
					while (l <= r) {
						
						var m = (l + r) >> 1;
						var targetClipId = __frameClips[m].get ().__clipNo;
						if (targetClipId > __clipNo) {
							
							l = m;
							
						} else if (targetClipId < __clipNo) {
							
							r = m - 1;
							
						}
						
					}
					
					__frameClips.insert (l, new WeakRef(this));
					
				}
				
			}
			
		} else {
			
			if (__frameScripts[frame + 1] != null) {
				
				if (--__numFrameScripts == 0) {
					
					var l = 0;
					var r = __frameClips.length - 1;
					while (l <= r) {
						
						var m = (l + r) >> 1;
						var targetClipId = __frameClips[m].get().__clipNo;
						if (targetClipId > __clipNo) {
							
							l = m;
							
						} else if (targetClipId < __clipNo) {
							
							r = m - 1;
							
						} else  {
							
							l = m;
							break;
							
						}
						
					}
					__frameClips.splice (l, 1);
					
				}
				
			}
			
		}
		
		__frameScripts[frame + 1] = script;
		
	}
	
	@:noCompletion public static function __runAllFrameScript ():Void {
		
		var i = 0;
		while (i < __frameClips.length) {
			
			var clip = __frameClips[i].get ();
			if (clip != null) {
				
				clip.__runFrameScript ();
				i++;
				
			} else {
				
				__frameClips.splice(i, 1);
				
			}
			
		}
		
	}
	
	
	@:noCompletion public function __runFrameScript ():Void {
		
		if (__beforeFrame != currentFrame) {
			
			var script = __frameScripts[currentFrame];
			if (script != null) {
				
				script();
				
			}
			__beforeFrame = currentFrame;
			
		}
		
	}
	
	
	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void {
		
		
		
	}
	
	
	public function gotoAndStop (frame:Dynamic, scene:String = null):Void {
		
		
		
	}
	
	
	public function nextFrame ():Void {
		
		
		
	}
	
	
	@:noCompletion override private function __getType ():String {
		
		return "MovieClip";
		
	}
	
	
	public function play ():Void {
		
		
		
	}
	
	
	public function prevFrame ():Void {
		
		
		
	}
	
	
	public function stop ():Void {
		
		
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function set_totalFrames (v:Int):Int {
		
		
		if (__frameScripts.length < v + 1) {
			
			for (i in __frameScripts.length ... v + 1) {
				
				__frameScripts.push(null);
				
			}
			
		} else if (__frameScripts.length > v + 1) {
			
			for (i in v + 1 ... __frameScripts.length) {
				
				__frameScripts.pop();
				
			}
			
		}
		
		return totalFrames = v;
		
	}
	
	
}