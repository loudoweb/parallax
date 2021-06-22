package parallax;
import haxe.xml.Access;
using parallax.ParallaxHelper;

#if openfl
typedef Point = openfl.geom.Point;
#else
typedef Point = { x:Float, y:Float};
#end
/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class Parallax 
{
	/**
	 * Name
	 */
	public var id:String;
	/**
	 * Main layer that allows to retrieve the bounds (width and height) of the parallax world
	 */
	public var world:String;
	/**
	 * Set manually the width of the parallax world or use variable `world`
	 */
	public var width:Float;
	/**
	 * Set manually the height of the parallax world or use variable `world`
	 */
	public var height:Float;
	/**
	 * All layers that move at different speed
	 */
	public var layers:Array<ParallaxLayer>;
	
	public var camera:ParallaxCamera;
	
	public var speed:Int;

	public function new(id:String, world:String, cameraX:Float, cameraY:Float, speed:Int = 1 ) 
	{
		this.id = id;
		this.world = world;
		this.speed = speed;
		
		camera = new ParallaxCamera(cameraX, cameraY );
	}
	
	public function moveCamera(x:Float, y:Float):Void
	{
		camera.x += x;
		camera.y += y;
		//checkBounds();
		updateLayers();
	}
	
	public function updateLayers():Void
	{
		for (layer in layers)
		{
			layer.x = layer.originX - camera.x + (camera.originX - camera.x) * speed * layer.depth;
			layer.y = layer.originY - camera.y + (camera.originY - camera.y) * speed * layer.depth;
		}	
	}
	
	
	
	inline public function setZoomBounds(screenY:Int):Void
	{
		camera.setZoomBounds(screenY);
	}
	
	public function checkBounds():Void{
		if (camera.x < 0){
			trace('bound reach x <0');
			camera.x = 0;
		}else if (camera.x > width - camera.width){
			trace('bound reach camera.width - width', camera.width, width);
			camera.x = width - camera.width;
		}
			
		if (camera.y < 0){
			camera.y = 0;
			trace('bound reach y <0');
		}else if (camera.y > height - camera.height){
			trace('bound reach camera.height - height');
			camera.y = height - camera.height;
		
		}
	}
	
	public function onZoom(delta:Float):Void {
		
		camera.onZoom(delta);
		
		//imagePivot = image.globalToLocal(new Point(e.stageX, e.stageY));
			
		applyZoom();
		
	}
	
	function applyZoom():Void
	{
		if (!camera.canApplyZoom())
			return;
			
		//var offsetX = image.x + imagePivot.x * preZoom - imagePivot.x * zoom;
		//var offsetY = image.y + imagePivot.y * preZoom - imagePivot.y * zoom;

		//bgPos.setTo(offsetX, offsetY);
		/*for (container in containers)
		{
			
			container.scaleX = container.scaleY = parallax.zoom;
		}*/
		//checkBounds(bgPos, stage.stageWidth, stage.stageHeight);
		//image.x = bgPos.x;
		//image.y = bgPos.y;
	}
	
	public static function parse(xml:Xml):Parallax
	{
		var _xml = new Access(xml.firstElement());
		var world = new Parallax(_xml.has.id ? _xml.att.id : "world", _xml.has.world ? _xml.att.world : "", _xml.getFloat("camX"), _xml.getFloat("camY"));
		if (_xml.has.width)
			world.width = Std.parseFloat(_xml.att.width);
		if (_xml.has.height)
			world.height = Std.parseFloat(_xml.att.height);
		
		if (world.layers == null)
			world.layers = [];
		
		for (item in _xml.node.layers.nodes.layer)
		{
			world.layers.push(ParallaxLayer.parse(item));
		}
		
		world.updateLayers();
		
		return world;
	}
	
}