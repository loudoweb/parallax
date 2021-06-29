package parallax;
import haxe.xml.Access;
using parallax.ParallaxHelper;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class ParallaxSprite 
{
	//internal
	
	/**
	 * Name of the sprite
	 */
	public var id:String;
	/**
	 * PNG
	 */
	public var img:String;
	
	public var originX:Int;
	public var originY:Int;
	
	public var x:Int;
	public var y:Int;
	
	//external: not used by parallax engine
	
	public var width:Int;
	public var height:Int;
	
	public var offsetX:Float;
	public var offsetY:Float;
	
	public var scaleX:Float;
	public var scaleY:Float;
	
	public var rotation:Int;
	
	/**
	 * An anim should use a prefix in image attribute.
	 */
	public var isAnim:Bool;
	

	public function new(id:String, img:String, x:Int, y:Int, scaleX:Float = 1, scaleY:Float = 1, width:Int = 0, height:Int = 0, offsetX:Int = 0, offsetY:Int = 0, isAnim:Bool = false) 
	{
		this.id = id;
		this.img = img;
		this.originX = x;
		this.originY = y;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.scaleX = scaleX;
		this.scaleY = scaleY;
		this.isAnim = isAnim;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.rotation = 0;
	}
	
	public static function parse(xml:Access):ParallaxSprite
	{
		return new ParallaxSprite(xml.has.id ? xml.att.id : xml.att.img, xml.att.img + ".png", xml.getInt("x"), xml.getInt("y"), xml.getFloat("scaleX", 1), xml.getFloat("scaleY", 1), xml.getInt("width"), xml.getInt("height"), xml.getInt("offsetX"), xml.getInt("offsetY"), xml.getBool("isAnim", false));
	}
	
}