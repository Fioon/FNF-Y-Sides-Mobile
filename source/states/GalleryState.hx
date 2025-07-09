package states;

import flixel.addons.display.FlxBackdrop;
import shaders.WiggleEffect;

class GalleryState extends MusicBeatState
{
    var bg:FlxSprite;
    var bars:FlxSprite;
    var lines:FlxBackdrop = new FlxBackdrop(Paths.image('gallery/lines'), #if (flixel <= "5.0.0") 0.2, 0.2, true, true #else XY #end);
	var bfIconsTop:FlxBackdrop = new FlxBackdrop(Paths.image('gallery/bfIcon'), #if (flixel <= "5.0.0") 0.2, 0.2, true, true #else X #end);
	var bfIconsBottom:FlxBackdrop = new FlxBackdrop(Paths.image('gallery/bfIcon'), #if (flixel <= "5.0.0") 0.2, 0.2, true, true #else X #end);

    var leftArrow:FlxSprite;
    var rightArrow:FlxSprite;

    var optGrp:FlxTypedGroup<GalleryObject>;
    var optArray:Array<String> = [
        'outdated_concepts',
        'outdated_concepts'
    ];

	var wiggle:WiggleEffect = null;

    private static var curSelected:Int = 0;

    override function create() 
    {
        super.create();

        FlxG.mouse.visible = true;

		wiggle = new WiggleEffect(2, 4, 0.002, WiggleEffectType.DREAMY);
        
        bg = new FlxSprite();
        bg.loadGraphic(Paths.image('gallery/bg'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        add(bg);

        lines.velocity.set(75, 75);
        lines.alpha = 0.45;
        lines.antialiasing = ClientPrefs.data.antialiasing;
        add(lines);

        bars = new FlxSprite();
        bars.loadGraphic(Paths.image('gallery/bars'));
        bars.antialiasing = ClientPrefs.data.antialiasing;
        add(bars);

        bfIconsTop.velocity.set(-50, 0);
        bfIconsTop.antialiasing = ClientPrefs.data.antialiasing;
		add(bfIconsTop);

        bfIconsBottom.flipX = true;
        bfIconsBottom.velocity.set(50, 0);
        bfIconsBottom.y = FlxG.height - bfIconsBottom.height;
        bfIconsBottom.antialiasing = ClientPrefs.data.antialiasing;
        add(bfIconsBottom);

        optGrp = new FlxTypedGroup<GalleryObject>();
        add(optGrp);

        leftArrow = new FlxSprite(45, 0);
        leftArrow.loadGraphic(Paths.image('gallery/arrow'));
        leftArrow.screenCenter(Y);
        leftArrow.antialiasing = ClientPrefs.data.antialiasing;
        add(leftArrow);

        leftArrow.y -= 10;
        FlxTween.tween(leftArrow, {y: leftArrow.y + 20}, 7, {ease: FlxEase.quartInOut, type: PINGPONG});

        rightArrow = new FlxSprite(45, 0);
        rightArrow.loadGraphic(Paths.image('gallery/arrow'));
        rightArrow.screenCenter(Y);
        rightArrow.antialiasing = ClientPrefs.data.antialiasing;
        rightArrow.x = FlxG.width - rightArrow.width - 45;
        rightArrow.flipX = true;
        add(rightArrow);

        rightArrow.y -= 10;
        FlxTween.tween(rightArrow, {y: rightArrow.y + 20}, 7, {ease: FlxEase.quartInOut, type: PINGPONG});

        for(i in 0...optArray.length)
        {
            var spr = new GalleryObject();
            spr.loadGraphic(Paths.image('gallery/' + optArray[i]));
            spr.antialiasing = ClientPrefs.data.antialiasing;
            spr.screenCenter();
            spr.targetX = i;
            spr.x += FlxG.width * i;
            spr.shader = wiggle;
            optGrp.add(spr);

            spr.y -= 10;
            FlxTween.tween(spr, {y: spr.y + 20}, 7, {ease: FlxEase.quartInOut, type: PINGPONG});
        }

        changeSelect();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

		if (wiggle != null) {
			wiggle.update(elapsed);
		}

        if(controls.BACK)
        {
            MusicBeatState.switchState(new MainMenuState());
        }

        var leftMult:Float = FlxMath.lerp(leftArrow.scale.x, 1, elapsed * 9);
        leftArrow.scale.set(leftMult, leftMult);

        var rightMult:Float = FlxMath.lerp(rightArrow.scale.x, 1, elapsed * 9);
        rightArrow.scale.set(rightMult, rightMult);

        if(controls.UI_RIGHT_P)
        {
            changeSelect(1);
            rightArrow.scale.set(1.25, 1.075);
        }
        else if(controls.UI_LEFT_P)
        {
            changeSelect(-1);
            leftArrow.scale.set(1.25, 1.075);
        }
    }

    function changeSelect(change:Int = 0)
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, optArray.length - 1);

		for (num => item in optGrp.members)
		{
			item.targetX = num - curSelected;
			item.alpha = 0.6;
			if (item.targetX == 0) item.alpha = 1;
		}
    }
}

class GalleryObject extends FlxSprite
{
    public var targetX:Float = 0;
    public var distancePerItem:FlxPoint = new FlxPoint(1280, 0);
    public var startPosition:FlxPoint = new FlxPoint(0, 0);
    
    public function new(x:Float = 0, y:Float = 0, ?graphic:Dynamic = null)
    {
        super(x, y, graphic);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

		var lerpVal:Float = Math.exp(-elapsed * 9.6);
		x = FlxMath.lerp((targetX * distancePerItem.x) + startPosition.x, x, lerpVal);
    }
}