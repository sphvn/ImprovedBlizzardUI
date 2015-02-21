local impChat = CreateFrame( "Frame", nil, UIParent );

local CHAT_FONT_SIZE = 15;

-- Not Localized due to simple output structure
local function ModifyBlizzStrings()
	-- Local Player Loot
	CURRENCY_GAINED = "|cffFFFF00+ %s";
	CURRENCY_GAINED_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	CURRENCY_GAINED_MULTIPLE_BONUS = "|cffFFFF00+ %s |cffFFFF00(%d)";
	
	LOOT_ITEM_SELF = "|cffFFFF00+ %s";
	LOOT_ITEM_SELF_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_CREATED_SELF = "|cffFFFF00+ %s";
	LOOT_ITEM_CREATED_SELF_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_BONUS_ROLL_SELF = "|cffFFFF00+ %s";
	LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_REFUND = "|cffFFFF00+ %s";
	LOOT_ITEM_REFUND_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_PUSHED_SELF = "|cffFFFF00+ %s";
	LOOT_ITEM_PUSHED_SELF_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";

	-- Remote Players Loot
	LOOT_ITEM = "%s |cffFFFF00+ %s";
	LOOT_ITEM_BONUS_ROLL = "%s |cffFFFF00+ %s";
	LOOT_ITEM_BONUS_ROLL_MULTIPLE = "%s |cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_MULTIPLE = "%s |cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_PUSHED = "%s |cffFFFF00+ %s";
	LOOT_ITEM_PUSHED_MULTIPLE = "%s |cffFFFF00+ %s |cffFFFF00(%d)";

	-- Chat Channels
	CHAT_SAY_GET = "%s "
	CHAT_YELL_GET = "%s "
	CHAT_WHISPER_INFORM_GET = "w to %s "
	CHAT_WHISPER_GET = "w from %s "
	CHAT_BN_WHISPER_INFORM_GET = "w to %s "
	CHAT_BN_WHISPER_GET = "w from %s "
	CHAT_PARTY_GET = "|Hchannel:PARTY|hp|h %s "
	CHAT_PARTY_LEADER_GET =  "|Hchannel:PARTY|hpl|h %s "
	CHAT_PARTY_GUIDE_GET =  "|Hchannel:PARTY|hpg|h %s "
	CHAT_INSTANCE_CHAT_GET = "|Hchannel:Battleground|hi.|h %s: "
	CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hil.|h %s: "
	CHAT_GUILD_GET = "|Hchannel:GUILD|hg|h %s "
	CHAT_OFFICER_GET = "|Hchannel:OFFICER|ho|h %s "
	CHAT_FLAG_AFK = "[AFK] "
	CHAT_FLAG_DND = "[DND] "
	CHAT_FLAG_GM = "[GM] "
end

local function TweakChat()

	-- Hide Buttons
	ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
	ChatFrameMenuButton:Hide()
	FriendsMicroButton:HookScript("OnShow", FriendsMicroButton.Hide)
	FriendsMicroButton:Hide()
	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetClampRectInsets(-15,15,15,-15)

	  --Edit Box Font
	ChatFontNormal:SetFont(STANDARD_TEXT_FONT, CHAT_FONT_SIZE, "THINOUTLINE")
	ChatFontNormal:SetShadowOffset(1,-1)
	ChatFontNormal:SetShadowColor(0,0,0,0.6)

	-- Loop Through Chat Windows
	for i = 1, NUM_CHAT_WINDOWS do
		local chatWindowName = _G["ChatFrame"..i]:GetName();

		-- Allow Moving Anywhere
		_G["ChatFrame"..i]:SetClampRectInsets( 0, 0, 0, 0 );
		_G["ChatFrame"..i]:SetMinResize( 100, 50 );
		_G["ChatFrame"..i]:SetMaxResize( UIParent:GetWidth(), UIParent:GetHeight() );

		-- Change Chat Text
		_G["ChatFrame"..i]:SetFont(STANDARD_TEXT_FONT, CHAT_FONT_SIZE, "THINOUTLINE");
		_G["ChatFrame"..i]:SetShadowOffset( 1, -1 );
		_G["ChatFrame"..i]:SetShadowColor( 0, 0, 0, 0.6 );
	
		-- Change Chat Tabs
		local chatTab = _G[chatWindowName.."Tab"];
		local tabFont = chatTab:GetFontString();
		tabFont:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE");
		tabFont:SetShadowOffset( 1, -1 );
		tabFont:SetShadowColor( 0, 0, 0, 0.6 );

		--Hide Tab Backgrounds
		_G[chatWindowName.."TabLeft"]:SetTexture( nil );
		_G[chatWindowName.."TabMiddle"]:SetTexture( nil );
		_G[chatWindowName.."TabRight"]:SetTexture( nil );
		_G[chatWindowName.."TabSelectedLeft"]:SetTexture(nil)
      	_G[chatWindowName.."TabSelectedMiddle"]:SetTexture(nil)
      	_G[chatWindowName.."TabSelectedRight"]:SetTexture(nil)
		chatTab:SetAlpha( 1.0 );

		-- Stop Chat Arrows Coming Back
		_G[chatWindowName.."ButtonFrame"]:Hide();
    	_G[chatWindowName.."ButtonFrame"]:HookScript("OnShow", _G[chatWindowName.."ButtonFrame"].Hide)
	
    	-- Skin Edit Text Box
	    _G[chatWindowName.."EditBoxLeft"]:Hide()
	    _G[chatWindowName.."EditBoxMid"]:Hide()
	    _G[chatWindowName.."EditBoxRight"]:Hide()

	    _G[chatWindowName.."EditBox"]:SetAltArrowKeyMode(false)
	    _G[chatWindowName.."EditBox"]:ClearAllPoints()
	    _G[chatWindowName.."EditBox"]:SetPoint("BOTTOM",_G["ChatFrame"..i],"TOP",0,22)
	    _G[chatWindowName.."EditBox"]:SetPoint("LEFT",_G["ChatFrame"..i],-5,0)
	    _G[chatWindowName.."EditBox"]:SetPoint("RIGHT",_G["ChatFrame"..i],10,0)
	end
end

local function Chat_HandleEvents( self, event, ... )
	if( event == "PLAYER_ENTERING_WORLD" )then
		if( bModifyChat == true )then
			ModifyBlizzStrings();
			TweakChat();
		end
	end
end

local function Chat_Init()
	impChat:SetScript( "OnEvent", Chat_HandleEvents );
	impChat:RegisterEvent( "PLAYER_ENTERING_WORLD" );
end

-- Call Initialisation
Chat_Init();