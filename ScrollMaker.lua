------------------------------------------------------
-- ScrollMaker.lua
------------------------------------------------------
local addonName, addonTable = ...; 

local ENCHANTING_SPELL_ID = 7411;
local VELLUM_ITEM_ID = 38682;

function FSM_OnEvent(self, event, ...)

	if (event == "ADDON_LOADED" and select(1,...) == "Blizzard_TradeSkillUI") then
		hooksecurefunc(TradeSkillFrame.DetailsFrame, "RefreshDisplay", FSM_TradeSkillDetailsRefreshDisplay);
	end
		
end

------------------------------------------------------
-- Enchanting scroll button
------------------------------------------------------

function FSM_TradeSkillDetailsRefreshDisplay()
	local id = TradeSkillFrame.DetailsFrame.selectedRecipeID;
	local recipeInfo = id and C_TradeSkillUI.GetRecipeInfo(id);
	if (recipeInfo and recipeInfo.alternateVerb == ENSCRIBE) then
		if (not FSM_EnchantScrollButton) then
			FSM_CreateEnchantScrollButton();
		end
		FSM_EnchantScrollButton:Show();	
		
		if (recipeInfo.numAvailable > 0 and GetItemCount(VELLUM_ITEM_ID) > 0) then
			FSM_EnchantScrollButton:Enable();
		else
			FSM_EnchantScrollButton:Disable();
		end
		
	elseif (FSM_EnchantScrollButton) then
		FSM_EnchantScrollButton:Hide();
	end
	
end

function FSM_CreateEnchantScrollButton()
	FSM_EnchantScrollButton = CreateFrame("Button", "FSM_EnchantScrollButton", TradeSkillFrame.DetailsFrame, "MagicButtonTemplate");
	
	FSM_EnchantScrollButton:SetWidth(TradeSkillFrame.DetailsFrame.CreateButton:GetWidth());
	FSM_EnchantScrollButton:SetHeight(TradeSkillFrame.DetailsFrame.CreateButton:GetHeight());
	FSM_EnchantScrollButton:SetPoint("RIGHT", TradeSkillFrame.DetailsFrame.CreateButton, "LEFT",0,0);
	
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
	C_TradeSkillUI.CraftRecipe(TradeSkillFrame.DetailsFrame.selectedRecipeID);
	UseItemByName(VELLUM_ITEM_ID);
end

------------------------------------------------------
-- Run-time loading
------------------------------------------------------
		
FSM_EventFrame = CreateFrame("Frame", nil, nil);
FSM_EventFrame:SetScript("OnEvent", FSM_OnEvent);
FSM_EventFrame:RegisterEvent("ADDON_LOADED");
