package flash.display;


import flash.display.MovieClip.MovieClipList;
import flash.display.MovieClip.MovieClipListIterator;
import openfl.utils.WeakRef;


using Lambda;

class MovieClip extends Sprite {
	
	
	public var currentFrame (get, null):Int = 0;
	public var enabled:Bool;
	public var framesLoaded (default, null):Int;
	public var totalFrames (get, null):Int = 1;
	
	@:noCompletion private var __currentFrame:Int = 0;
	@:noCompletion private var __totalFrames(default, set):Int = 1;
	
	@:noCompletion private static var animationClips:MovieClipList = new MovieClipList();
	@:noCompletion private static var frameClips:MovieClipList = new MovieClipList();
	@:noCompletion private static var numAllClips:Int = 0;
	@:noCompletion private var frameScripts:Array<Void -> Void>;
	@:noCompletion private var numFrameScripts:Int = 0;
	@:noCompletion private var lastFrameScript:Int = -1;
	@:noCompletion public var clipNo(default, null):Int;
	
	
	public function new () {
		
		super ();
		
		clipNo = numAllClips++;
		frameScripts = [];
		
	}
	
	
	public function addFrameScript (frame:Int, script:Void->Void):Void {
		
		if (frame >= totalFrames) {
			return;
		}
		
		if (script != null) {
			
			if (frameScripts[frame + 1] == null) {
				
				if (++numFrameScripts == 1) {
					
					frameClips.register (this);
					
				}
				
			}
			
		} else {
			
			if (frameScripts[frame + 1] != null) {
				
				if (--numFrameScripts == 0) {
					
					frameClips.unregister (this);
					
				}
				
			}
			
		}
		
		frameScripts[frame + 1] = script;
		
	}
	
	@:noCompletion public static function runAllFrameScript ():Void {
		
		for (clip in frameClips) {
			
			clip.runFrameScript ();
			
		}
		
	}
	
	
	@:noCompletion public function runFrameScript ():Void {
		
		if (lastFrameScript != currentFrame) {
			
			var script = frameScripts[currentFrame];
			if (script != null) {
				
				script();
				
			}
			lastFrameScript = currentFrame;
			
		}
		
	}
	
	@:noCompletion public static function updateAnimations ():Void {
		
		for (clip in animationClips) {
			
			clip.enterFrame();
			
		}
		
	}
	
	@:noCompletion private function enterFrame ():Void
	{
		
		
		
	}
	
	@:noCompletion private function turnOnAutoUpdate ():Void
	{
		
		animationClips.register (this);
		
	}
	
	
	@:noCompletion private function turnOffAutoUpdate ():Void
	{
		
		animationClips.unregister (this);
		
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
	
	private function get_currentFrame ():Int {
		
		return __currentFrame;
		
	}
	
	
	private function get_totalFrames ():Int {
		
		return __totalFrames;
		
	}
	
	
	private function set___totalFrames (v:Int):Int {
		
		
		if (frameScripts.length < v + 1) {
			
			for (i in frameScripts.length ... v + 1) {
				
				frameScripts.push(null);
				
			}
			
		} else if (frameScripts.length > v + 1) {
			
			for (i in v + 1 ... frameScripts.length) {
				
				frameScripts.pop();
				
			}
			
		}
		
		return __totalFrames = v;
		
	}
	
	
}




class MovieClipList {
	
	private var list:Array<WeakRef<MovieClip>>;
	
	public var length(get, null):Int;
	
	public function new ()
	{
		list = [];
	}
	
	public function register (mc:MovieClip):Void
	{
		
		var clipNo = mc.clipNo;
		var l = 0;
		var r = list.length - 1;
		while (l <= r) {
			
			var m = (l + r) >> 1;
			var targetClipId = list[m].get ().clipNo;
			if (targetClipId > clipNo) {
				
				l = m;
				
			} else if (targetClipId < clipNo) {
				
				r = m - 1;
				
			} else {
				return;
			}
			
		}
		
		list.insert (l, new WeakRef (mc));
		
	}
	
	
	public function unregister (mc:MovieClip):Void {
		
		var clipNo = mc.clipNo;
		var l = 0;
		var r = length - 1;
		while (l <= r) {
			
			var m = (l + r) >> 1;
			var targetClipId = list[m].get().clipNo;
			if (targetClipId > clipNo) {
				
				l = m;
				
			} else if (targetClipId < clipNo) {
				
				r = m - 1;
				
			} else {
				
				l = m;
				break;
				
			}
			
		}
		
		if (list[l].get() == mc) list.splice (l, 1);
		
	}
	
	
	public function get(pos:Int):MovieClip
	{
		
		return list[pos].get();
		
	}
	
	
	public function splice(pos:Int, len:Int):Void
	{
		
		list.splice(pos, len);
		
	}
	
	
	public function iterator ():Iterator<MovieClip> 
	{
		return new MovieClipListIterator(this);
	}
	
	
	
	
	// Getters & Setters
	
	private function get_length():Int { return list.length; }
	
	
}




class MovieClipListIterator
{
	
	private var list:MovieClipList;
	private var i:Int = 0;
	
	public function new (movieClipList:MovieClipList) {
		
		list = movieClipList;
		
	}
	
	public function hasNext () {
		
		while (true) {
			
			if (i >= list.length) {
				
				return false;
				
			} else if (list.get (i) == null) {
				
				list.splice(i, 1);
				
			} else {
				break;
			}
			
		}
		
		
		return true;
	}
	
	
	public function next () {
		
		return list.get (i++);
		
	}
	
}
