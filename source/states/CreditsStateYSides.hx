package states;

import flixel.FlxObject;
import objects.AttachedSprite;
import flixel.addons.display.FlxBackdrop;

class CreditsStateYSides extends MusicBeatState
{
	public static var watchingCredits:Bool = false;
	public static var backFromCredits:Bool = false;
	var wentBack:Bool = false;

    var developers:Array<Dynamic> = [
        ['gBv2209',         'gbv',      ['Concept Artist', 'Artist', 'Animator', 'Musician', 'Charter', 'Coder'], 		[['yt', 'https://www.youtube.com/@gBv2209'], ['x', 'https://x.com/gbv2209']]],
        ['Mr. Madera',      'madera',   ['Main Coder', 'Charter'], 						                                [['yt', 'https://www.youtube.com/@mrmadera1235'], ['x', 'https://x.com/MrMadera625']]],
        ['SFoxyDAC',        'foxy',     ['Artist', 'Animator'], 					                                    [['yt', 'https://www.youtube.com/@SFoxyDAC'], ['x', 'https://x.com/SFoxyDAC']]],
        ['Bunny',           'bunny',    ['Charter'], 					                                                [['x', ['https://x.com/ArchDolphin_']]]],
        ['Zhadnii',         'ema',  ['Musician'], 					                                                [['yt', 'https://youtube.com/@zhadnii_']]],
        ['FlashMan07',      'flash',    ['Musician', 'Concept Artist', 'Artist'],                                       [['yt', 'https://www.youtube.com/@FlashMan07']]],
        ['Heromax',         'hero',     ['Concept Artist', 'Artist', 'Charter'], 			                            [['x', 'https://x.com/heromax_2498']]],
        ['ItsTapiiii',      'tapi',     ['Musician'], 					                                                [['yt', 'https://www.youtube.com/@ItsTapiiii']]],
        ['E1000',           'emil',    ['Artist', 'Charter'], 					                                        [['yt', 'https://www.youtube.com/@E1000YT/videos'], ['x', 'https://x.com/E1000TWOF ']]]
    ];

	var bg:FlxSprite;

    var currentCharacter:FlxSprite;
    var devInfo:InfoAboutPerson;

	var psych:FlxSprite;
	var icons:FlxBackdrop;

	var topY:Float;
	var bottomY:Float = 850;

	var tweenDuration:Float = 0.1;
    static var curSelected:Int = 0;

	override function create() 
	{
		bg = new FlxSprite(-80).makeGraphic(1280, 720, 0xFFBFB4F1);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);

		icons = new FlxBackdrop(Paths.image('mainmenu/icons'), XY);
		icons.velocity.set(10, 10);
		icons.alpha = 0.45;
		icons.antialiasing = ClientPrefs.data.antialiasing;
		icons.scrollFactor.set();
		add(icons);

		icons.setPosition(MainMenuState.iconsPos[0], MainMenuState.iconsPos[1]);

        currentCharacter = new FlxSprite(60, 200);
		currentCharacter.loadGraphic(Paths.image('credits2/people/gbv'));
        currentCharacter.screenCenter(Y);
		currentCharacter.antialiasing = ClientPrefs.data.antialiasing;
		add(currentCharacter);

        devInfo = new InfoAboutPerson('gbv2209', 		['Concept Artist', 'Artist', 'Animator', 'Musician', 'Charter', 'Coder'], 		[['yt', 'https://www.youtube.com/@gBv2209'], ['x', 'https://x.com/gbv2209']]);
        devInfo.x += 200;
        add(devInfo);

		psych = new FlxSprite(500, 1010);
		psych.loadGraphic(Paths.image('credits2/psychTeam'));
		psych.screenCenter(X);
		psych.updateHitbox();
		psych.scrollFactor.set(0, 1);
		psych.antialiasing = ClientPrefs.data.antialiasing;
		add(psych);

		psych.alpha = 0;
		FlxTween.tween(psych, {alpha: 1}, tweenDuration, {startDelay: 0.6});

        changeSelection();
	}

	var psychScale:Float = 1;
	override function update(elapsed:Float) {
		if (controls.BACK && !watchingCredits) {
			wentBack = true;
		
			backFromCredits = true;
			watchingCredits = false;
            
			MainMenuState.iconsPos.insert(0, icons.x);
			MainMenuState.iconsPos.insert(1, icons.y);

			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new MainMenuState());
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        if(controls.UI_LEFT_P)
        {
            changeSelection(-1);
        }

        if(controls.UI_RIGHT_P)
        {
            changeSelection(1);
        }

		var mult = FlxMath.lerp(psych.scale.x, psychScale, elapsed * 7);
		psych.scale.set(mult, mult);

		if(FlxG.mouse.overlaps(psych) && !watchingCredits)
		{
			psychScale = 1.1;
			if(FlxG.mouse.justPressed)
			{
				watchingCredits = false;
				MusicBeatState.switchState(new CreditsState());	
			}
		}
		else psychScale = 1;

		super.update(elapsed);

		FlxG.mouse.visible = true;
	}

    function changeSelection(change:Int = 0)
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, developers.length - 1);

        // reload char
		currentCharacter.loadGraphic(Paths.image('credits2/people/${developers[curSelected][1]}'));
        currentCharacter.screenCenter(Y);
		currentCharacter.antialiasing = ClientPrefs.data.antialiasing;
		add(currentCharacter);

        // reload info
        devInfo.refresh(developers[curSelected][0], developers[curSelected][2], developers[curSelected][3]);
    }
}

class InfoAboutPerson extends FlxSpriteGroup
{
	var squareBg:FlxSprite;
	var personName:Alphabet;
	var rolsGrp:FlxSpriteGroup;
	var socialMediasGrp:FlxSpriteGroup;
	var socialMedias:Array<Dynamic> = [];

	public function new(name:String, rols:Array<String>, avaibleSocialMedias:Array<Dynamic>)
	{
		super();

		socialMedias = avaibleSocialMedias;

		squareBg = new FlxSprite();
		//squareBg.makeGraphic(600, 550, 0xFF000000);
		squareBg.loadGraphic(Paths.image('credits2/background'));
		squareBg.alpha = 0.7;
		squareBg.scrollFactor.set();
		squareBg.screenCenter();
		add(squareBg);

		personName = new Alphabet(0, squareBg.y + 10, name, true);
		personName.setScale(0.85);
		personName.x = squareBg.x + squareBg.width / 2 - personName.width / 2;
		personName.scrollFactor.set();
		add(personName);

		rolsGrp = new FlxSpriteGroup();
		add(rolsGrp);

		socialMediasGrp = new FlxSpriteGroup();
		add(socialMediasGrp);

		for(i in 0...rols.length)
		{
			var rolTxt = new Alphabet(0, 0, rols[i], true);
			rolTxt.setScale(0.7);
			rolTxt.y = personName.y + personName.height + 30 + ((rolTxt.height + 10) * i);
			rolTxt.scrollFactor.set();
			rolTxt.screenCenter(X);
			rolsGrp.add(rolTxt);
		}

		for(i in 0...avaibleSocialMedias.length)
		{
			if(socialMediasGrp.members[i-1] != null) socialMediasGrp.members[i-1].x -= socialMediasGrp.members[i-1].width;

			var socialMediaIcon = new FlxSprite();
			trace('Loading the following social media: ${avaibleSocialMedias[i][0]}');
			switch(avaibleSocialMedias[i][0])
			{
				case 'yt':
					socialMediaIcon.loadGraphic(Paths.image('credits2/icons/yt'));
				case 'disc':
					socialMediaIcon.loadGraphic(Paths.image('credits2/icons/disc'));
				case 'x':
					socialMediaIcon.loadGraphic(Paths.image('credits2/icons/X'));
			}
			socialMediaIcon.scrollFactor.set();
			socialMediaIcon.y = squareBg.y + squareBg.height - socialMediaIcon.height - 10;
			socialMediaIcon.x = squareBg.x + squareBg.width - socialMediaIcon.width - 10;
			socialMediaIcon.ID = i;
			socialMediasGrp.add(socialMediaIcon);
		}
	}

    public function refresh(name:String, rols:Array<String>, avaibleSocialMedias:Array<Dynamic>)
    {
        personName.text = name;
		personName.x = squareBg.x + squareBg.width / 2 - personName.width / 2;
        
        // reset groups
        rolsGrp.forEach(function(obj:FlxSprite) { rolsGrp.remove(obj); });
        socialMediasGrp.forEach(function(obj:FlxSprite) { socialMediasGrp.remove(obj); });

		for(i in 0...rols.length)
		{
			var rolTxt = new Alphabet(0, 0, rols[i], true);
			rolTxt.setScale(0.7);
			rolTxt.y = personName.y + personName.height + 30 + ((rolTxt.height + 10) * i);
			rolTxt.scrollFactor.set();
			rolTxt.screenCenter(X);
			rolsGrp.add(rolTxt);
		}

		for(i in 0...avaibleSocialMedias.length)
		{
			if(socialMediasGrp.members[i-1] != null) socialMediasGrp.members[i-1].x -= socialMediasGrp.members[i-1].width;

			var socialMediaIcon = new FlxSprite();
			trace('Loading the following social media: ${avaibleSocialMedias[i][0]}');
			switch(avaibleSocialMedias[i][0])
			{
				case 'yt':
					socialMediaIcon.loadGraphic(Paths.image('credits2/icons/yt'));
				case 'disc':
					socialMediaIcon.loadGraphic(Paths.image('credits2/icons/disc'));
				case 'x':
					socialMediaIcon.loadGraphic(Paths.image('credits2/icons/X'));
			}
			socialMediaIcon.scrollFactor.set();
			socialMediaIcon.y = squareBg.y + squareBg.height - socialMediaIcon.height - 10;
			socialMediaIcon.x = squareBg.x + squareBg.width - socialMediaIcon.width - 210;
			socialMediaIcon.ID = i;
			socialMediasGrp.add(socialMediaIcon);
		}
    }

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		socialMediasGrp.forEach(function(spr:FlxSprite)
		{
			if(FlxG.mouse.overlaps(spr))
			{
				spr.alpha = 1;
				if(FlxG.mouse.justPressed)
				{
					CoolUtil.browserLoad(socialMedias[spr.ID][1]);
				}
			}
			else spr.alpha = 0.7;
		});
	}
}