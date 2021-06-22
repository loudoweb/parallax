package parallax;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class ParallaxCamera 
{
	//boundaries
	public var originX:Float;
	public var originY:Float;
	public var width:Float;
	public var height:Float;
	
	//current state
	public var x:Float;
	public var y:Float;
	
	//zoom
	//zoom
	var minZoom:Float;
	var preZoom:Float;
	public var zoom:Float;
	var maxZoom:Float;
	var deltaZoom:Float;

	public function new(x:Float, y:Float, width:Float = 1920, height:Float = 1080, zoom:Float = 1) 
	{
		this.originX = x;
		this.originY = y;
		this.width = width;
		this.height = height;
		this.zoom = zoom;
		this.x = x;
		this.y = y;
	}
	
	public function setZoomBounds(screenY:Float):Void
	{
		//zoom bounds
		//to have fluid zoom
		minZoom = screenY / (height / zoom);
		//trace("image height", height / zoom, "stage", screenY);
		deltaZoom = (1 - minZoom) / 2;
		maxZoom = 1 + deltaZoom *2;
		//trace(minZoom, zoom, maxZoom, deltaZoom);
	}
	
	public function onZoom(delta:Float):Void
	{
		preZoom = zoom;
		zoom += delta * deltaZoom;
		if (zoom > maxZoom)
			zoom = maxZoom;
		if (zoom < minZoom)
			zoom = minZoom;
	}
	
	inline public function canApplyZoom():Bool
	{
		return preZoom != zoom;
	}
	
}