package backend;

import flixel.util.FlxGradient;
import shaders.DiamondTransShader;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;

    var shader:DiamondTransShader;
    var rect:FlxSprite;
    var tween:FlxTween;

	var duration:Float;
	public function new(duration:Float, isTransIn:Bool)
	{
		this.duration = duration;
		this.isTransIn = isTransIn;
		super();
	}

	override function create()
	{
        camera = new FlxCamera();
        camera.bgColor = FlxColor.TRANSPARENT;

        FlxG.cameras.add(camera, false);

        shader = new DiamondTransShader();

        shader.progress.value = [0.0];
        shader.reverse.value = [false];

        rect = new FlxSprite(0, 0);
        rect.makeGraphic(1, 1, 0xFF000000);
        rect.scale.set(1280, 720);
        rect.origin.set();
        rect.shader = shader;
        rect.visible = false;
        add(rect);

        if (isTransIn)
            fadeIn();
        else
            fadeOut();

		super.create();
	}

    function __fade(from:Float, to:Float, reverse:Bool)
    {
        trace("fade initiated");
        
        rect.visible = true;
        shader.progress.value = [from];
        shader.reverse.value = [reverse];

        tween = FlxTween.num(from, to, duration, {ease: FlxEase.linear, onComplete: function(_)
        {
            trace("finished");
            if (finishCallback != null)
            {
                trace("with callback");
				if(finishCallback != null)
				{
					finishCallback();
					finishCallback = null;
				}
            }
        }}, function(num:Float)
        {
            shader.progress.value = [num];
        });
    }

    function fadeIn()
    {
        __fade(0.0, 1.0, true);
    }

    function fadeOut()
    {
        __fade(0.0, 1.0, false);
    }

	// Don't delete this
	override function close():Void
	{
		super.close();

		if(finishCallback != null)
		{
			finishCallback();
			finishCallback = null;
		}
	}
}
