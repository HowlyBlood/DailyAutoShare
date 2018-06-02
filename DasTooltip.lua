local DAS = DailyAutoShare

local function GenerateTooltipText(control)
	
	local key = control:GetName()
	
	if 	    string.match(key, "Invite")	then return GetString((DAS.GetAutoInvite() and DAS_SI_INVITE_TRUE) or DAS_SI_INVITE_FALSE)
	elseif string.match(key, "Accept")	then return GetString((DAS.GetAutoAcceptShared() and DAS_SI_ACCEPT_TRUE) or DAS_SI_ACCEPT_FALSE)
	elseif string.match(key, "Share") 	then return GetString((DAS.GetAutoShare() and DAS_SI_SHARE_TRUE) or DAS_SI_SHARE_FALSE)	
	elseif string.match(key, "Spam") 	then return GetString(DAS_SI_SPAM)
	elseif string.match(key, "Donate") 	then return GetString(DAS_SI_DONATE) 	
	elseif string.match(key, "Refresh") then return GetString(DAS_SI_REFRESH)  
	end	
	
end 


local function SetTooltipText(control)
	DailyAutoShare_Tooltip:ClearLines() 
	local tooltipText = GenerateTooltipText(control)
    if not tooltipText then return end
	DailyAutoShare_Tooltip:AddLine(tooltipText)
	DailyAutoShare_Tooltip:SetHidden(false)
	
	return tooltipText
end
function DAS.SetTooltipText(control)
	SetTooltipText(control)
end


local function setTooltipOffset(control)
	local offsetY = control:GetTop() - control:GetParent():GetTop()
	local isTooltipRight = DAS.GetSettings().tooltipRight
	local myAnchorPos 		= (isTooltipRight and TOPLEFT) or TOPRIGHT
	local parentAnchorPos 	= (isTooltipRight and TOPRIGHT) or TOPLEFT 
	
	DailyAutoShare_Tooltip:ClearAnchors()	
	DailyAutoShare_Tooltip:SetAnchor(myAnchorPos, control:GetParent(), parentAnchorPos, 0, offsetY)
end

function DAS.CreateControlTooltip(control)
	
	SetTooltipText(control)
    setTooltipOffset(DasHeader)
	
end

function DAS.CreateTooltip(control)	
	setTooltipOffset(control)	
	SetTooltipText(control, isButton)	
end

local questStateColors = {
    [DAS_STATUS_ACTIVE]     = ZO_HIGHLIGHT_TEXT:UnpackRGBA(),
    [DAS_STATUS_OPEN]       = ZO_NORMAL_TEXT:UnpackRGBA(),
    [DAS_STATUS_COMPLETE]   = ZO_DISABLED_TEXT:UnpackRGBA(),
}

local dotDotDot = "%.%.%."
function DAS.CreateLabelTooltip(control)
	
   
	setTooltipOffset(control)
	local tooltipText = ""
   
    local questName = control.dataTitle or control.dataQuestName
    
    if nil == questName then return end
    if nil ~= questName:find(dotDotDot) then 
        tooltipText = GetString(DAS_TOGGLE_SUBLIST)
    else             
        local state = DAS.GetCompleted(questName)
        if control.dataQuestState == DAS_STATUS_COMPLETE then 
            tooltipText = (questName .. " completed today with " .. GetUnitName(UNITTAG_PLAYER))
        else
            local bingoString = control["dataBingoString"] or ""
            local bingoTooltip = (bingoString ~= "" and "\n The bingo code is " .. bingoString) or ""
            local status = (( control.dataQuestState == DAS_STATUS_ACTIVE and " is acive") or " still open")
            tooltipText = (questName .. status .. bingoTooltip)
        end
    end
    
    
	DailyAutoShare_Tooltip:AddLine(tooltipText)
	DailyAutoShare_Tooltip:SetHidden(false)
	
 end
 
function DAS.HideTooltip(control)
	DailyAutoShare_Tooltip:ClearLines()
	 DailyAutoShare_Tooltip:SetHidden(true)
	 -- DAS.RefreshLabels()
end