package parallax;
import haxe.ds.WeakMap;
import haxe.xml.Access;
using parallax.ParallaxHelper;

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
	 * optional
	 */
	public var world:String;
	/**
	 * Set manually the width of the parallax world or use variable `world`
	 * optional
	 */
	public var width:Float;
	/**
	 * Set manually the height of the parallax world or use variable `world`
	 * optional
	 */
	public var height:Float;
	/**
	 * All layers that move at different speed
	 */
	public var layers:Array<ParallaxLayer>;
	
	public var camera:ParallaxCamera;
	
	public var speed:Int;
	
	public var zoomOffsetX:Null<Float>;
	public var zoomOffsetY:Null<Float>;
	
	public function new(id:String, world:String, cameraX:Float, cameraY:Float, speed:Int = 1 ) 
	{
		this.id = id;
		this.world = world;
		this.speed = speed;
		
		camera = new ParallaxCamera(cameraX, cameraY );
	}
	
	public function moveCamera(x:Float, y:Float):Void
	{
		camera.x += x * speed;
		camera.y += y * speed;
		checkBounds();
		updateLayers();
	}
	
	public function updateLayers():Void
	{
		for (layer in layers)
		{
			layer.x = Math.round(layer.originX - camera.x + (camera.originX - camera.x) * (layer.depth - 1));
			layer.y = Math.round(layer.originY - camera.y + (camera.originY - camera.y) * (layer.depth - 1));
		}	
	}
	
	
	public function setZoomBounds(screenY:Int):Void
	{
		//zoom bounds
		//to have fluid zoom
		camera.minZoom = screenY / (height / camera.zoom);
		//trace("image height", height / camera.zoom, "stage", screenY);
		camera.deltaZoom = (1 - camera.minZoom) / 2;
		camera.maxZoom = 1 + camera.deltaZoom *2;
		trace(camera.minZoom, camera.zoom, camera.maxZoom, camera.deltaZoom);
		
		
		var values = [for (i in 0...5) i * camera.deltaZoom + camera.minZoom];
		//find closest zoom to current
		var closest = 42.;
		for (item in values)
		{
			if ( Math.abs(item - camera.zoom) < Math.abs(camera.zoom - closest))
				closest = item;
		}
		
		if (closest != camera.zoom)
		{
			trace("resize", camera.minZoom, "old", camera.zoom, "closest", closest, camera.maxZoom);
			camera.zoom = closest;
			//this.zoomOffsetX = zoomOffsetX;
			//this.zoomOffsetY = zoomOffsetY;
					
			applyZoom();
		}
	
	}
	
	public function checkBounds():Void{

		if (camera.x < 0){
			camera.x = 0;
		}else if (camera.x > (width * camera.zoom - camera.width)){
			camera.x = (width * camera.zoom - camera.width) ;
		}
			
		if (camera.y < 0){
			camera.y = 0;
		}else if (camera.y > (height * camera.zoom - camera.height)){
			camera.y = (height * camera.zoom - camera.height);
		
		}
	}
	
	public function onZoom(delta:Float, zoomOffsetX:Null<Float> = null, zoomOffsetY:Null<Float> = null):Void {
		
		camera.onZoom(delta);
		
		this.zoomOffsetX = zoomOffsetX;
		this.zoomOffsetY = zoomOffsetY;
					
		applyZoom();
		
	}
	
	public function applyZoom():Void
	{
		if (!camera.canApplyZoom())
			return;
			
		if (zoomOffsetX != null)
		{

			var offsetX = zoomOffsetX * camera.preZoom - zoomOffsetX * camera.zoom;
			var offsetY = zoomOffsetY * camera.preZoom - zoomOffsetY * camera.zoom;
			
			camera.x -= offsetX;
			camera.y -= offsetY;
		}

		checkBounds();
		updateLayers();
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