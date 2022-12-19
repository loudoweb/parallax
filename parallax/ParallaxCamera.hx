package parallax;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
@:keepSub
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
	public var minZoom:Float;
	public var preZoom:Float;
	public var zoom:Float;
	public var maxZoom:Float;
	public var deltaZoom:Float;

	/**
	 * 
	 * @param	x starting position of the camera (top left corner of camera)
	 * @param	y starting position of the camera (top left corner of camera)
	 * @param	width
	 * @param	height
	 * @param	zoom
	 */
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