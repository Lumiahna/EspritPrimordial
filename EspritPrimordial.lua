-- ----------------------------------------------------------------------------
-- Loot automatique Esprit Primordial
-- 		by Lumiahna
-- ----------------------------------------------------------------------------

NeedPrimalSpirits = {};
NeedPrimalSpiritsDB = NeedPrimalSpiritsDB or { ["need"] = true,["greed"] = false,["pass"] = false,["disable"] = false,};

function NeedPrimalSpirits.OnEvent(self,event,...)
	if NeedPrimalSpiritsDB and NeedPrimalSpiritsDB.disable then
		return;
	end
	if event == "START_LOOT_ROLL" then
		local id = ...;
		local _, name, _, quality, bindOnPickUp, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(id);
		local primalSpiritName = select(1,GetItemInfo(120945));
		if name == primalSpiritName then
			-- Blizzard uses 0 to pass, 1 to Need an item, 2 to Greed an item, and 3 to Disenchant an item.
			-- Need > Greed > Pass
			if canNeed and NeedPrimalSpiritsDB.need then
				RollOnLoot(id, 1);
				StaticPopup_Hide("CONFIRM_LOOT_ROLL");
				C_Timer.After(.1,function()
						ConfirmLootRoll(id, 1);
						end);
			-- If loot is set to Need before Greed, needing primal spirits is disabled.
			elseif canGreed and (NeedPrimalSpiritsDB.greed or NeedPrimalSpiritsDB.need) then
				RollOnLoot(id, 2);
				StaticPopup_Hide("CONFIRM_LOOT_ROLL");
				C_Timer.After(.1,function()
						ConfirmLootRoll(id, 2);
						end);
			else
				RollOnLoot(id, 0);
				StaticPopup_Hide("CONFIRM_LOOT_ROLL");
				C_Timer.After(.1,function()
						ConfirmLootRoll(id, 0);
						end);
			end
		end
	end
end

------------------------------------------------
-- Slash Commands
------------------------------------------------
local function slashHandler(msg)
	msg = msg:lower() or "";
	if (msg == "off") then
		NeedPrimalSpiritsDB.disable = true;
		NeedPrimalSpiritsDB.need = false;
		NeedPrimalSpiritsDB.greed = false;
		NeedPrimalSpiritsDB.pass = false;
		print("|cff33ff99EP|r: Esprit Primordial Desactive");
	elseif (msg == "besoin") then
		NeedPrimalSpiritsDB.disable = false;
		NeedPrimalSpiritsDB.need = true;
		NeedPrimalSpiritsDB.greed = false;
		NeedPrimalSpiritsDB.pass = false;
		print("|cff33ff99EP|r: Besoin sur tous les esprits primordiaux");
	elseif (msg == "cupi") then
		NeedPrimalSpiritsDB.disable = false;
		NeedPrimalSpiritsDB.need = false;
		NeedPrimalSpiritsDB.greed = true;
		NeedPrimalSpiritsDB.pass = false;
		print("|cff33ff99EP|r: Cupi sur tous les esprits primordiaux");
	elseif (msg == "passer") then
		NeedPrimalSpiritsDB.disable = false;
		NeedPrimalSpiritsDB.need = false;
		NeedPrimalSpiritsDB.greed = false;
		NeedPrimalSpiritsDB.pass = true;
		print("|cff33ff99EP|r: Passer sur tous les exprits primordiaux");
	else
		print("|cff33ff99Esprit Primordial|r: Commande |cffffff78/ep|r :");
		if NeedPrimalSpiritsDB.disable then
			print("  |cff00ff00Addon desactive");
		elseif NeedPrimalSpiritsDB.need then
			print("  |cff00ff00Actuellement sur besoin");
		elseif NeedPrimalSpiritsDB.greed then
			print("  |cff00ff00Actuellement sur cupi");
		elseif NeedPrimalSpiritsDB.pass then
			print("  |cff00ff00Actuellement sur passer");
		end
		print("  |cffffff78 off|r - Desactive addon");
		print("  |cffffff78 besoin|r - fait besoin sur esprits primordiaux");
		print("  |cffffff78 cupi|r - fait cupi sur esprits primordiaux");
		print("  |cffffff78 passer|r - fait passer sur esprits primordiaux");
		print("  |cffffff78 Auteur|r - Lumiahna et Asmoro-Suramar");
		print("  |cffffff78 Une idee de la guilde Les Ames Egregores - Suramar");
	end
end

SlashCmdList.NeedPrimalSpirits = function(msg) slashHandler(msg) end;
SLASH_NeedPrimalSpirits1 = "/ep";
SLASH_NeedPrimalSpirits2 = "/espritprimordial";

NeedPrimalSpirits.frame = CreateFrame("Frame");
NeedPrimalSpirits.frame:RegisterEvent("START_LOOT_ROLL");
NeedPrimalSpirits.frame:SetScript("OnEvent", NeedPrimalSpirits.OnEvent);
