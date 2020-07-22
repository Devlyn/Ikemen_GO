-- Handles all the go functions called by the lua scripts
-- This script should be used rather than calling the Go function directly
-- todo Dev: Differentiate between setters, getters and void functions


-- Set selected column and row in the go engine
-- @param column the selected column
-- @param rows the selected row
function setGoSelColRow(column, row)
    return setSelColRow(column, row)
end

-- Set the cell size based on width and height in the go engine
-- @param width the width of the cell
-- @param height the height of the cell
function setGoSelCellSize(width, height)
    return setSelCellSize(width, height)
end

-- Set the cell scale based on x and y in the go engine
-- @param x the x-axis of the cell scale
-- @param y the y-axis of the cell scale
function setGoSelCellScale(x, y)
    return setSelCellScale(x, y)
end

-- Refresh the engine
function callGoRefresh()
    return refresh()
end

-- Set the input command in the go engine
-- @param command the given command
-- @param player the player that gave the command
function setGoCommandInput(command, player)
    return commandInput(command, player)
end

-- Set a new input commandd in the go engine
function setGoCommandNew()
    return commandNew()
end

-- Add a new command in the go engine
-- @param commandname name of the command
-- @param command the command that was input
-- @param commandkeyremap the remap key
function setGoCommandAdd(commandname, command, commandkeyremap)
    return commandAdd(commandname, command, commandkeyremap)
end

-- Get the state of a command by name in the go engine
-- @param command the command that was input
-- @param commandstring string name of the command
function getGoGetCommandState(command, commandstring)
    return commandGetState(command, commandstring)
end

-- Get the command line arguments passed to the go engine
function getGoCommandLineFlags()
    return getCommandLineFlags()
end

-- Set the Game speed of the go engine
-- @param value the value to set the game speed to
function setGoGameSpeed(value)
    return setGameSpeed(value)
end

-- Call the game command buff reset to reset the command buffer in the go engine
-- @param command the command to reset
function callGoCommandBufReset(command)
    return commandBufReset(command)
end

-- Set the Game volume of the go engine
-- @param value the value to set the volume to
function setGoVolumeBGM(value)
    return setVolumeBgm(value)
end

-- Set the Game volume of the go engine
-- @param value the value to set the volume to
function setGoVolumeMaster(value)
    return setVolumeMaster(value)
end

-- Toggle the game status draw of the go engine
function toggleGoStatusDraw()
    return toggleStatusDraw()
end

-- Toggle the game max power mode of the go engine
function toggleGoMaxPowerMode()
    return toggleMaxPowerMode()
end

-- Set the game mode in the go engine
function setGoGameMode(name)
    return setGameMode(name)
end

-- Call Synchronize function of the go engine
function callGoSynchronize()
    return synchronize()
end

-- Call the fill Rect go function to fill background in the go engine
-- @param boxcoordinateX the x-axis coordinate
-- @param boxcoordinateY the y-axis coordiante
-- @param width the screen width
-- @param height the screen height
-- @param rColor the R color range max 255
-- @param gColor the G color range max 255
-- @param bColor the B color range max 255
-- @param alpha1 alpha1 value
-- @param alpha2 alpha2 value
-- @param autoScale set boolean for auto scaling
-- @param useSPLocalCoord set boolean to use Screenpack localcoord
function callGoFillRectangle(boxcoordinateX, boxcoordinateY, width, height, rColor, gColor, bColor, alpha1, alpha2, autoScale, useSPLocalCoord)
    return fillRect(
            boxcoordinateX,
            boxcoordinateY,
            width,
            height,
            rColor,
            gColor,
            bColor,
            alpha1,
            alpha2,
            autoScale,
            useSPLocalCoord
    )
end

-- call the game background draw function to draw the background of the go engine
-- @param backgroundName definition of the background
-- @oaran useDraw boolean
function callGoBGDraw(backgroundName, useDraw)
    return bgDraw(backgroundName, useDraw)
end

-- call the game BG reset function to reset the BG in the go engine
-- @param data the input data to reset
function callGoBGReset(data)
    return bgReset(data)
end

-- call the game clear color function to clear a color in the go engine
-- @param rColor
-- @param gColor
-- @param bColor
function callGoClearColor(rColor, gColor, bColor)
    return clearColor(rColor, gColor, bColor)
end

-- call the game play sound function in the go engine
-- @param sndData
-- @param soundQueueOne
-- @param soundQueueTwo
function callGoSoundPlay(sndData, soundQueueOne, soundQueueTwo)
    return sndPlay(sndData, soundQueueOne, soundQueueTwo)
end

-- call the game play bgm function in the go engine
-- @param bgmName name of the background music
-- @param isDefault boolean value to determine if this is default
-- @param bgmLoop indicator if the background music is looped
-- @param bgmVolume volume value for the background music
-- @param bgmLoopstart indicator where the loop starts
-- @param bgmLoopend indicator where the loop ends
function callGoBGMPlay(bgmName, isDefault, bgmLoop, bgmVolume, bgmLoopstart, bgmLoopend)
    return playBGM(bgmName, isDefault, bgmLoop, bgmVolume, bgmLoopstart, bgmLoopend)
end

-- call the game enter netplay function to start a netplay session in the go engine
-- @param serverAddress
function callGoEnterNetPlay(serverAddress)
    return enterNetPlay(serverAddress)
end

-- call the game connected function to check if an connection has been established in the go engine
function callGoConnected()
    return connected()
end

-- call the game esc function to simulatie pressing the escape key in the go engine
function callGoEsc()
    return esc()
end

-- call the game SzzRandom function in the go engine
function callGoSszRandom()
    return sszRandom()
end

-- get the game framecount in the go engine
function getGoFrameCount()
    return getFrameCount()
end

-- call the game fadescreen function to fadein/out to the specfified frame in the go engine
-- @param fadeType
-- @param frame
-- @param length
-- @param rColor
-- @param gColor
-- @param bColor
function callGoFadeScreen(fadeType, frame, length, rColor, gColor, bColor)
    return fadeScreen(
            fadeType,
            frame,
            length,
            rColor,
            gColor,
            bColor
    )
end

-- call the game new text image function to create a new text image in the go engine
function callGoNewTextImage()
    return textImgNew()
end

-- call the game loadLifebar function to load a lifebar definition file in the go engine
-- @param definitionFile the file to be loaded
function callGoLoadLifeBar(definitionFile)
    return loadLifebar(definitionFile)
end

-- call the game set text image font to set the image font in the go engine
-- @param textImage the provided textImage
function setGoTextImageFont(textImage, fontTable) 
    return textImgSetFont(textImage, fontTable)    
end

-- call the game set text image bank to set image bank in the go engine
-- @param textImage the provided textImage
-- @param bank
function setGoTextImgBank(textImage, bank)
    return textImgSetBank(textImage, bank)
end

-- call the game set text image align to set alignment in the go engine
-- @param textImage the provided textImage
function setGoTextImageAlign(textImage, alignMent)
    return textImgSetAlign(textImage, alignMent)
end

-- call the game set text image text to set image text in the go engine
-- @param textImage the provided textImage
function setGoTextImageText(textImage, text)
    return textImgSetText(textImage, text)
end

-- call the game set text image color to set image color in the go engine
-- @param textImage the provided textImage
function setGoTextImageColor(textImage, rColor, gColor, bColor, source, destination)
    return textImgSetColor(textImage, rColor, gColor, bColor, source, destination)
end

-- call the game set text image position to set image position in the go engine
-- @param textImage the provided textImage
function setGoTextImagePosition(textImage, xAxis, yAxis)
    return textImgSetPos(textImage, xAxis, yAxis)
end

-- call the game set text image scale to set image scale in the go engine
-- @param textImage the provided textImage
function setGoTextImageScale(textImage, xScale, yScale)
    return textImgSetScale(textImage, xScale, yScale)
end

-- call the game set text image bank to set image bank in the go engine
-- @param textImage the provided textImage
function setGoTextImageWindow(textImage, xAxis, yAxis, width, height)
    return textImgSetWindow(textImage, xAxis, yAxis, width, height)
end

-- call the game new font function to load a new font in the go engine
function callGoNewFont(font, height)
    return fontNew(font, height)
end

-- get the game font definition based on the provided font table in the go engine
function getGoFontDef(fontTable)
    return fontGetDef(fontTable)
end

-- set the game computer/input to provided value in the go engine
-- @param player
-- @param aiLevel the provided AI level, if set to 0 player is manually controlled
function setGoCom(player, aiLevel)
    return setCom(player, aiLevel)
end

-- set the game team mode to the provided value in the go engine
-- @param team the side this change is applicable to, we only have 2 sides so the options are 1 or 2
-- @param gameType the provided gameType which consists of: Single, Simul, Ratio and Tag
-- @param playerAmount the amount of players, cannot exceed the max of the gameType
function setGoTeamMode(team, gameType, playerAmount)
    return setTeamMode(team, gameType, playerAmount)
end

-- set the game character to the provied values in the go engine
-- @param player
-- @param character
-- @param palette
function setGoSelectCharacter(player, character, palette)
    selectChar(player, character, palette)
end

-- call the game loadstart function to load ?? in the go engine
function callGoLoadStart()
    return loadStart()
end

-- call the game ??? function to ??? in the go engine
function callGoGame()
    return game()
end

-- set the game allow BGM value to allow BGM in the go engine
function setGoAllowBGM(allowBGM)
    return setAllowBGM(allowBGM)
end

-- set the game allow debug keys value to allow debugkeys in the go engine
function setGoAllowDebugKeys(allowDebugKeys)
    return setAllowDebugKeys(allowDebugKeys)
end

-- set the game ???
function setGoGCPercent(value)
    return setGCPercent(value)
end







