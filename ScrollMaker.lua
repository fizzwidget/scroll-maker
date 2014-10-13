------------------------------------------------------
-- ScrollMaker.lua
------------------------------------------------------
local addonName, addonTable = ...; 

local ENCHANTING_SPELL_ID = 7411;
local VELLUM_ITEM_ID = 38682;

function FSM_OnEvent(self, event, ...)

	if (event == "ADDON_LOADED" and select(1,...) == "Blizzard_TradeSkillUI") then
		hooksecurefunc("TradeSkillFrame_SetSelection", FSM_TradeSkillFrame_SetSelection);
	end
		
end

------------------------------------------------------
-- Enchanting scroll button
------------------------------------------------------

function FSM_TradeSkillFrame_SetSelection(id)
	local skillName, _, _, _, altVerb = GetTradeSkillInfo(id);
	if (altVerb == ENSCRIBE) then
		if (not FSM_EnchantScrollButton) then
			FSM_CreateEnchantScrollButton();
		end
		FSM_EnchantScrollButton:Show();	
		
		if (FSM_CanEnchantScroll(id)) then
			FSM_EnchantScrollButton:Enable();
		else
			FSM_EnchantScrollButton:Disable();
		end
		
	elseif (FSM_EnchantScrollButton) then
		FSM_EnchantScrollButton:Hide();
	end
	
end

function FSM_CanEnchantScroll(id)
	local numReagents = GetTradeSkillNumReagents(id);
	for i=1, numReagents, 1 do
		local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i);
		if ( playerReagentCount < reagentCount ) then
			return false;
		end
	end
	if (GetItemCount(VELLUM_ITEM_ID) == 0) then
		return false;
	end
	return true;
end

function FSM_GetEnchantingSpellName()
	if (not FSM_EnchantingSpellName) then
		FSM_EnchantingSpellName = GetSpellInfo(ENCHANTING_SPELL_ID);
	end
	return FSM_EnchantingSpellName;
end

function FSM_CreateEnchantScrollButton()
	FSM_EnchantScrollButton = CreateFrame("Button", "FSM_EnchantScrollButton", TradeSkillFrame, "MagicButtonTemplate");
	
	FSM_EnchantScrollButton:SetWidth(TradeSkillCreateButton:GetWidth());
	FSM_EnchantScrollButton:SetHeight(TradeSkillCreateButton:GetHeight());
	FSM_EnchantScrollButton:SetPoint("RIGHT", TradeSkillCreateButton, "LEFT",0,0);
	
	FSM_EnchantScrollButton:SetText(CREATE_PROFESSION);
	
	FSM_EnchantScrollButton:SetScript("OnEnter", FSM_EnchantScrollButton_OnEnter);
	FSM_EnchantScrollButton:SetScript("OnLeave", GameTooltip_Hide);
	FSM_EnchantScrollButton:SetScript("OnClick", FSM_EnchantScrollButton_OnClick);
	
end

function FSM_EnchantScrollButton_OnEnter(self)
	
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM");
	GameTooltip:SetText(FSM_CREATE_SCROLL);
	local c = HIGHLIGHT_FONT_COLOR;
	GameTooltip:AddLine(string.format(FSM_VELLUM_REMAINING, GetItemInfo(VELLUM_ITEM_ID), GetItemCount(VELLUM_ITEM_ID)), c.r, c.g, c.b);
	GameTooltip:AddLine(" ");
	
	c = GRAY_FONT_COLOR;
	local title = GetAddOnMetadata(addonName, "Title");
	local version = GetAddOnMetadata(addonName, "Version");
	
	GameTooltip:AddDoubleLine(title, string.format("v%s", version), c.r, c.g, c.b, c.r, c.g, c.b);
	GameTooltip:Show();
	
end

function FSM_EnchantScrollButton_OnClick()
	DoTradeSkill(TradeSkillFrame.selectedSkill);
	UseItemByName(VELLUM_ITEM_ID);
end

------------------------------------------------------
-- Run-time loading
------------------------------------------------------
		
FSM_EventFrame = CreateFrame("Frame", nil, nil);
FSM_EventFrame:SetScript("OnEvent", FSM_OnEvent);
FSM_EventFrame:RegisterEvent("ADDON_LOADED");
