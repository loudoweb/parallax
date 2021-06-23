package parallax;
import haxe.xml.Access;
using parallax.ParallaxHelper;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class ParallaxSprite 
{
	/**
	 * Name of the sprite
	 */
	public var id:String;
	/**
	 * PNG
	 */
	public var img:String;
	
	public var originX:Float;
	public var originY:Float;
	
	public var scaleX:Float;
	public var scaleY:Float;
	
	public var isAnim:Bool;

	public function new(id:String, img:String, x:Float, y:Float, scaleX:Float = 1, scaleY:Float = 1, isAnim:Bool = false) 
	{
		this.id = id;
		this.img = img;
		this.originX = x;
		this.originY = y;
		this.scaleX = scaleX;
		this.scaleY = scaleY;
		this.isAnim = isAnim;
	}
	
	public static function parse(xml:Access):ParallaxSprite
	{
		return new ParallaxSprite(xml.has.id ? xml.att.id : xml.att.img, xml.att.img + ".png", xml.getFloat("x"), xml.getFloat("y"), xml.getFloat("scaleX", 1), xml.getFloat("scaleY", 1), xml.getBool("isAnim", false));
	}
	
}