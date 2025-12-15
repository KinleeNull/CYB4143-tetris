-- Setup for live board
local boardWidth  = 10
local boardHeight = 20
local tileSize    = 20
local tileMargin  = 1

local colors = {
    [0x08] = 0x202020,  -- empty
    [0x01] = 0x0000FF,  -- red
    [0x02] = 0x00FF00,  -- green
    [0x03] = 0xFF0000,  -- blue
    [0x04] = 0xFFFF00,  -- cyan
    [0x05] = 0xFF00FF,  -- pink
    [0x06] = 0x00FFFF,  -- yellow
    [0x07] = 0xFFFFFF,  -- white
}

tiles = {}

function createBoardGrid()
    local panel = Trainer.boardPanel

    -- Destroy old tiles
    if tiles then
        for r = 1, #tiles do
            for c = 1, #tiles[r] do
                if tiles[r][c] then
                    tiles[r][c].destroy()
                end
            end
        end
    end

    tiles = {}

    panel.Width  = boardWidth  * (tileSize + tileMargin)
    panel.Height = boardHeight * (tileSize + tileMargin)

    -- build grid
    for r = 1, boardHeight do
        tiles[r] = {}
        for c = 1, boardWidth do
            local t = createPanel(panel)
            t.Parent = panel
            t.Left = (c - 1) * (tileSize + tileMargin)
            t.Top  = (r - 1) * (tileSize + tileMargin)
            t.Width = tileSize
            t.Height = tileSize
            t.BevelOuter = bvNone
            t.Color = 0x202020
            tiles[r][c] = t
        end
    end
end

function updateBoardPreview()
    local base = getAddressSafe("board_table1")
    if base == nil then return end

    for r = 1, boardHeight do
        for c = 1, boardWidth do
            local addr = base + (r-1) * 20 + (c-1) * 2
            local val = readBytes(addr, 1, false) or 0x08
            local newColor = colors[val] or 0x000000
            if tiles[r][c].Color ~= newColor then
                tiles[r][c].Color = newColor
            end
        end
    end
end

-- Create timer for updating board
local boardTimer = createTimer()
boardTimer.Interval = 100
boardTimer.OnTimer = updateBoardPreview
boardTimer.Enabled = false   -- turn off until grid is created

function Trainer_LiveGridClick(sender)
    createBoardGrid()
    updateBoardPreview()
    boardTimer.Enabled = true
end

function Trainer_btnSetPieceClick(sender)
    -- Read dropdown
    local choice = Trainer.ComboPiece.Text

    if choice == nil or choice == "" then
        showMessage("Please choose a piece color.")
        return
    end

    local pieceIDs = {
        Red = 1,
        Green = 2,
        Blue = 3,
        Cyan = 4,
        Pink = 5,
        Yellow = 6,
        White = 7
    }

    local id = pieceIDs[choice]

    -- Get address for next piece
    local addr = getAddress("next_piece")
    if addr == nil then
        showMessage("Error: next_piece not found.")
        return
    end

    -- Write to next piece address
    writeBytes(addr, id)

    showMessage("Next piece set to: " .. choice .. " (ID " .. id .. ")")
end

function btnAddScoreClick(sender)
    local addr = getAddress("score")
    if addr == nil then
        showMessage("Error: score not found")
        return
    end

    local current = readSmallInteger(addr)

    local newScore = current + 100
    writeSmallInteger(addr, newScore)
    writeInteger(addr, newScore)

    showMessage("Added 100 points! (" .. current .. " → " .. newScore .. ")")
end

function Trainer_Add500Click(sender)
    local addr = getAddress("score")
    if addr == nil then
        showMessage("Error: score not found")
        return
    end

    local current = readSmallInteger(addr)

    local newScore = current + 500
    writeSmallInteger(addr, newScore)
    writeInteger(addr, newScore)

    showMessage("Added 500 points! (" .. current .. " → " .. newScore .. ")")
end

-- Setup for freezing next piece
local freezeNextPiece = false
local frozenID = nil
local nextPieceAddr = getAddress("next_piece")

-- Create timer to continuously update piece
local pieceTimer = createTimer(nil, false)
pieceTimer.Interval = 1
pieceTimer.OnTimer = function(sender)
    if freezeNextPiece and frozenID ~= nil and nextPieceAddr ~= nil then
        writeBytes(nextPieceAddr, frozenID)
    end
end

function Trainer_SetFreezeNextPieceClick(sender)
    local choice = Trainer.ComboPiece.Text
    if choice == nil or choice == "" then
        showMessage("Choose a piece first!")
        return
    end

    local pieceIDs = {
        Red=1,
        Green=2,
        Blue=3,
        Cyan=4,
        Pink=5,
        Yellow=6,
        White=7
    }

    frozenID = pieceIDs[choice]

    freezeNextPiece = true
    pieceTimer.Enabled = true
    showMessage("Next piece frozen as: " .. choice)
end

-- Setup for Null Mode
NullModeEnabled = false

-- Store the normal next piece for later restoration
local normalNextPiece = nil
local scoreAddr = getAddress("score")
local linesAddr = getAddress("lines_cleared")
local nextPieceAddr = getAddress("next_piece")

-- Create timer to continously update values
local nullTimer = createTimer(nil, false)
nullTimer.Interval = 50
nullTimer.OnTimer = function()

    if not NullModeEnabled
       then return
    end

    writeSmallInteger(scoreAddr, 0)
    writeSmallInteger(linesAddr, 0)
    writeBytes(nextPieceAddr, 2)
end

function Trainer_EnableNullModeClick(sender)
    if NullModeEnabled then
        showMessage("NULL MODE already active.")
        return
    end

    -- Save current next piece
    normalNextPiece = readBytes(nextPieceAddr, 1, false)

    NullModeEnabled = true
    nullTimer.Enabled = true

    showMessage("NULL MODE ENABLED")
end

function Trainer_DisableNullModeClick(sender)
    if not NullModeEnabled then
        showMessage("NULL MODE is not active.")
        return
    end

    NullModeEnabled = false
    nullTimer.Enabled = false

    -- Restore next piece
    if normalNextPiece ~= nil then
        writeBytes(nextPieceAddr, normalNextPiece)
    end

    showMessage("NULL MODE disabled")
end

