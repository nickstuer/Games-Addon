local _, FR = ...

local TTT = FR.TTT or {}
FR.TTT = TTT

local Utils = FR.Utils or {}
FR.Utils = Utils

local board = {}
local turn = "X"
local buttons = {}
local turnText = nil

TTT.PlayersWaitingForGames = {}
local waitingForAGame = false
local yourSymbol = "X" -- Default symbol for the player
local opponentName = nil

function TTT:StyleButton(btn)
    btn:SetNormalFontObject("GameFontNormalLarge")

	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints()
	icon:SetTexture(nil)
	btn.icon = icon
		
    btn:SetBackdrop({
        bgFile = "Interface/Buttons/WHITE8x8",
        edgeFile = "Interface/Buttons/WHITE8x8",
        edgeSize = 1,
    })
    btn:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    btn:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)

    btn:SetHighlightTexture("Interface/Buttons/WHITE8x8")
    btn:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.15)

    btn:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.8, 0.8, 0.1)
    end)
    btn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    end)
end

function TTT:CheckWinner()
	local wins = {
		{1,2,3},{4,5,6},{7,8,9},
		{1,4,7},{2,5,8},{3,6,9},
		{1,5,9},{3,5,7}
	}
	for _, combo in pairs(wins) do
		local a, b, c = combo[1], combo[2], combo[3]
		if board[a] and board[a] == board[b] and board[b] == board[c] then
			print(board[a].." wins!")
            --if (board[a] == "X") then
            --    PlaySound(3154)
            --end

            if (opponentName and board[a] == yourSymbol) then
                print(board[a].." wins! Congrats!")
            else
                print(board[a].." wins! " .. opponentName .. " wins!")
            end
			return true
		end
	end

	for i = 1, 9 do
		if not board[i] then return false end
	end
	print("It's a draw!")
	return true
end

function TTT:ResetBoard()
	for i = 1, 9 do
		buttons[i].icon:SetTexture(nil)
		board[i] = nil
	end
	turn = "X"
end

function TTT:FindWinningMove(symbol)
    local wins = {
        {1,2,3},{4,5,6},{7,8,9},
        {1,4,7},{2,5,8},{3,6,9},
        {1,5,9},{3,5,7}
    }
    for _, combo in ipairs(wins) do
        local a, b, c = combo[1], combo[2], combo[3]
        local vals = {board[a], board[b], board[c]}
        local count = 0
        local empty = nil
        for j = 1, 3 do
            if board[combo[j]] == symbol then
                count = count + 1
            elseif not board[combo[j]] then
                empty = combo[j]
            end
        end
        if count == 2 and empty then
            return empty
        end
    end
    return nil
end

function TTT:SetSymbol(symbol, btn)
	if symbol == "X" then
		btn.icon:SetTexture("Interface/AddOns/Games/Icons/x_icon.tga")
		btn.icon:SetPoint("CENTER")
		btn.icon:SetSize(64, 64)
	else
		btn.icon:SetTexture("Interface/AddOns/Games/Icons/o_icon.tga")
		btn.icon:SetPoint("CENTER")
		btn.icon:SetSize(64, 64)
	end
end

function TTT:AITurn() --'AI' Always "O" for now
    -- Try to win
    local move = self:FindWinningMove("O")
    -- Or block player's win
    if not move then move = self:FindWinningMove("X") end
    -- Otherwise pick center
    if not move and not board[5] then move = 5 end
    -- Otherwise pick a random
    if not move then
        local empty = {}
        for i = 1, 9 do
            if not board[i] then table.insert(empty, i) end
        end
        if #empty == 0 then return end
        move = empty[math.random(#empty)]
    end

    board[move] = "O"
	self:SetSymbol("O", buttons[move])

    if not self:CheckWinner() then
        turn = "X"
        turnText:SetText("Turn: " .. turn)
    else
        C_Timer.After(2, function(x) self:ResetBoard() end)
    end
end


function TTT:BuildWindow()
    opponentName = nil
	local TicTacToe = CreateFrame("Frame", "TicTacToeFrame", UIParent, "BackdropTemplate")
    TicTacToe:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    TicTacToe:SetSize(320, 420)
    TicTacToe:SetPoint("CENTER")
    TicTacToe:SetMovable(true)
    TicTacToe:EnableMouse(true)
    TicTacToe:RegisterForDrag("LeftButton")
    TicTacToe:SetScript("OnDragStart", TicTacToe.StartMoving)
    TicTacToe:SetScript("OnDragStop", TicTacToe.StopMovingOrSizing)
    TicTacToe:SetBackdropColor(0.14, 0.12, 0.2, 0.95)
    TicTacToe:SetBackdropBorderColor(0.35, 0.3, 0.6, 1)
  
    TicTacToe.title = TicTacToe:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    TicTacToe.title:SetPoint("TOP", 0, -5)
    TicTacToe.title:SetText("Tic Tac Toe | Games by Plunger")

    --TicTacToe:Show()

    -- Add X button
	local closeButton = CreateFrame("Button", nil, TicTacToe, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", TicTacToe, "TOPRIGHT", -5, -5)
	closeButton:SetScript("OnClick", function()
		TicTacToe:Hide()
	end)

    turnText = TicTacToe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    turnText:SetPoint("TOP", 0, -40)
    turnText:SetText("Turn: X")

	for i = 1, 9 do
		local btn = CreateFrame("Button", nil, TicTacToe, "BackdropTemplate")
		btn:SetSize(80, 80)
		btn:SetPoint("TOPLEFT", 20 + ((i-1)%3)*100, -70 - math.floor((i-1)/3)*100)
		btn:SetText("")
		self:StyleButton(btn)

		btn:SetScript("OnClick", function(selfBtn)
			if not board[i] and turn == "X" then
				board[i] = turn
				self:SetSymbol(turn, selfBtn)

				if not self:CheckWinner() then
					turn = (turn == "X") and "O" or "X"
					turnText:SetText("Turn: "..turn)
					C_Timer.After(0.5, function() self:AITurn() end)
				else
					C_Timer.After(5, function() self:ResetBoard() end)
				end
			end
		end)
		buttons[i] = btn
	end

    local resetBtn = CreateFrame("Button", nil, TicTacToe, "BackdropTemplate")
    resetBtn:SetBackdrop({
        bgFile = "Interface/Buttons/WHITE8x8",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 10,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    resetBtn:SetSize(120, 30)
    resetBtn:SetPoint("BOTTOM", 0, 10)
    resetBtn:SetText("Reset")
    resetBtn:SetNormalFontObject("GameFontNormal")
    resetBtn:SetHighlightFontObject("GameFontHighlight")
    resetBtn:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
    resetBtn:SetBackdropBorderColor(0.35, 0.3, 0.5, 1)
    resetBtn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.35, 0.3, 0.5, 1)
    end)
    resetBtn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
    end)
    resetBtn:SetScript("OnClick", function(s) self:ResetBoard() end)

end


-- Multiplayer Setup
C_ChatInfo.RegisterAddonMessagePrefix("GamesPing")


function TTT:SendMove(index, symbol)
    if opponentName then
        C_ChatInfo.SendAddonMessage("GamesPing", "MOVE:" .. index .. ":" .. symbol, "PARTY")
    end
end

function TTT:ReceiveMove(index, symbol)
    if not board[index] then
        board[index] = symbol
        local btn = buttons[index]
        btn.icon:SetAlpha(0)
        
        TTT:SetSymbol(symbol, btn)

        btn.icon:SetVertexColor(1, 1, 1, 1)
        btn.icon:SetAlpha(1)

        turn = (turn == "X") and "O" or "X"
        if symbol == "X" then
            turn = "O"
            turnText:SetText("Turn: O (Your Turn)")
        else
            turn = "X"
            turnText:SetText("Turn: X (Your Turn)")
        end
        
        if self:CheckWinner() then
            C_Timer.After(5, function() self:ResetBoard() end)
        end
    end
end

local tttEventFrame = CreateFrame("Frame")
tttEventFrame:RegisterEvent("CHAT_MSG_ADDON")
tttEventFrame:SetScript("OnEvent", function(_, event, prefix, msg, channel, sender)
    if prefix == "GamesPing" and sender ~= Utils.GetFullPlayerName() then
        local index, symbol = msg:match("MOVE:(%d+):([XO])")
        if index and symbol then
            TTT:ReceiveMove(tonumber(index), symbol)
            return
        end

        local gameRequest = msg:match("REQUEST_GAME:(%S+)")
        Utils.Debug("Received game request from:", sender, "Game Type:", gameRequest)
        if gameRequest == "TTT" and waitingForAGame then
            if not opponentName then
                --opponentName = sender
                Utils.Debug("TicTacToe game request received from:", sender)
                C_ChatInfo.SendAddonMessage("GamesPing", "ACCEPT_GAME:TTT:" .. sender, "PARTY")
                TTT:SetOpponent(sender)
                waitingForAGame = false
                turnText:SetText("Turn: X (Opponent's Turn)")
                yourSymbol = "O" -- Player is X
            end
        end

        local acceptGame, person = msg:match("ACCEPT_GAME:(%S+):(%S+)")
        if acceptGame == "TTT" and person == Utils.GetFullPlayerName() then
            Utils.Debug("TicTacToe game accepted by:", sender)
            TTT:SetOpponent(sender)
            waitingForAGame = false
            turnText:SetText("Turn: X (Your Turn)")
            yourSymbol = "X" -- Player is X
        end
    end
end)

function TTT:SetOpponent(name)
    opponentName = name
    print("TicTacToe opponent set to:", name)
end

function TTT:BuildMultiplayerWindow()
	local TicTacToe = CreateFrame("Frame", "TicTacToeFrame", UIParent, "BackdropTemplate")
    TicTacToe:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    TicTacToe:SetSize(320, 420)
    TicTacToe:SetPoint("CENTER")
    TicTacToe:SetMovable(true)
    TicTacToe:EnableMouse(true)
    TicTacToe:RegisterForDrag("LeftButton")
    TicTacToe:SetScript("OnDragStart", TicTacToe.StartMoving)
    TicTacToe:SetScript("OnDragStop", TicTacToe.StopMovingOrSizing)
    TicTacToe:SetBackdropColor(0.14, 0.12, 0.2, 0.95)
    TicTacToe:SetBackdropBorderColor(0.35, 0.3, 0.6, 1)
  
    TicTacToe.title = TicTacToe:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    TicTacToe.title:SetPoint("TOP", 0, -5)
    TicTacToe.title:SetText("Tic Tac Toe | Games by Plunger")

    --TicTacToe:Show()

    -- Add X button
	local closeButton = CreateFrame("Button", nil, TicTacToe, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", TicTacToe, "TOPRIGHT", -5, -5)
	closeButton:SetScript("OnClick", function()
		TicTacToe:Hide()
	end)

    turnText = TicTacToe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    turnText:SetPoint("TOP", 0, -40)
    turnText:SetText("-- Waiting for an Opponent --")
    waitingForAGame = true
    C_ChatInfo.SendAddonMessage("GamesPing", "REQUEST_GAME:TTT", "PARTY")

	for i = 1, 9 do
		local btn = CreateFrame("Button", nil, TicTacToe, "BackdropTemplate")
		btn:SetSize(80, 80)
		btn:SetPoint("TOPLEFT", 20 + ((i-1)%3)*100, -70 - math.floor((i-1)/3)*100)
		btn:SetText("")
		self:StyleButton(btn)

		btn:SetScript("OnClick", function(selfBtn)
            if waitingForAGame then return end
			if not board[i] and turn == yourSymbol then
				board[i] = turn
				self:SetSymbol(turn, selfBtn)
                self:SendMove(i, turn)

				if not self:CheckWinner() then
                    --turn = (turn == "X") and "O" or "X"

                    if turn == "X" then
                        turn = "O"
                        turnText:SetText("Turn: O (Opponent's Turn)")
                    else
                        turn = "X"
                        turnText:SetText("Turn: X (Opponent's Turn)")
                    end
        
                    --C_Timer.After(0.5, function() self:AITurn() end)
                else
                    C_Timer.After(5, function() self:ResetBoard() end)
                end
			end
		end)
		buttons[i] = btn
	end

    local resetBtn = CreateFrame("Button", nil, TicTacToe, "BackdropTemplate")
    resetBtn:SetBackdrop({
        bgFile = "Interface/Buttons/WHITE8x8",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 10,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    resetBtn:SetSize(120, 30)
    resetBtn:SetPoint("BOTTOM", 0, 10)
    resetBtn:SetText("Reset")
    resetBtn:SetNormalFontObject("GameFontNormal")
    resetBtn:SetHighlightFontObject("GameFontHighlight")
    resetBtn:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
    resetBtn:SetBackdropBorderColor(0.35, 0.3, 0.5, 1)
    resetBtn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.35, 0.3, 0.5, 1)
    end)
    resetBtn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
    end)
    resetBtn:SetScript("OnClick", function(s) self:ResetBoard() end)

end


function TTT:BuildSelectionWindow()
	local selectionWindow = CreateFrame("Frame", "SelectionWindowFrame", UIParent, "BackdropTemplate")
	selectionWindow:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	selectionWindow:SetSize(300, 280)
	selectionWindow:SetPoint("CENTER")
	selectionWindow:SetMovable(true)
	selectionWindow:EnableMouse(true)
	selectionWindow:RegisterForDrag("LeftButton")
	selectionWindow:SetScript("OnDragStart", selectionWindow.StartMoving)
	selectionWindow:SetScript("OnDragStop", selectionWindow.StopMovingOrSizing)
	selectionWindow:SetBackdropColor(0.2, 0.1, 0.3, 0.9)
	selectionWindow:SetBackdropBorderColor(0.5, 0.3, 0.8, 1)

	-- Add X button
	local closeButton = CreateFrame("Button", nil, selectionWindow, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", selectionWindow, "TOPRIGHT", -5, -5)
	closeButton:SetScript("OnClick", function()
		selectionWindow:Hide()
	end)
	
	-- Title background frame
	local titleBg = CreateFrame("Frame", nil, selectionWindow)
	titleBg:SetSize(1, 24)
	titleBg:SetPoint("TOPLEFT", selectionWindow, "TOPLEFT", 4, -4)
	titleBg:SetPoint("TOPRIGHT", selectionWindow, "TOPRIGHT", -24, -4)

	selectionWindow.title = titleBg:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	selectionWindow.title:SetPoint("TOP", 0, -10)
	selectionWindow.title:SetText("Games by Plunger | v" .. FR.version)
		
	local function CreateGameButton(parent, label, yOffset, onClick)
		local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
		btn:SetBackdrop({
			bgFile = "Interface/Buttons/WHITE8x8",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			edgeSize = 10,
			insets = { left = 2, right = 2, top = 2, bottom = 2 }
		})
		btn:SetSize(200, 32)
		btn:SetPoint("TOP", parent, "TOP", 0, yOffset)
		btn:SetText(label)
		btn:SetScript("OnClick", onClick)
	
		-- Purple styling
		btn:SetNormalFontObject("GameFontNormal")
		btn:SetHighlightFontObject("GameFontHighlight")
		btn:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
		btn:SetBackdropBorderColor(0.35, 0.3, 0.5, 1)
	
		btn:SetScript("OnEnter", function(self)
			self:SetBackdropColor(0.35, 0.3, 0.5, 1)
		end)
		btn:SetScript("OnLeave", function(self)
			self:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
		end)
	
		return btn
	end

	local y = -60
	local yOffset = 40

	CreateGameButton(selectionWindow, "Play Against AI", y, function()
		selectionWindow:Hide()
		self:BuildWindow()
	end)
	y = y - yOffset
	
	CreateGameButton(selectionWindow, "Play Against Human (Party)", y, function()
		selectionWindow:Hide()
		self:BuildMultiplayerWindow()
	end)
	y = y - yOffset


end


function TTT:Load()
    board = {}
    turn = "X"
    buttons = {}
    turnText = nil
	TTT:BuildSelectionWindow()
end