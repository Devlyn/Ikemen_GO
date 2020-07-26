local main = main
local start4p = require('external.script.start4p')

main.t_itemname ['4pversus'] = function(cursorPosY, moveTxt, item, t)
    setHomeTeam(1) --P1 side considered the home team
    main.t_pIn[2] = 2 --P2 controls P2 side of the select screen
    main.t_pIn[3] = 3
    main.t_pIn[4] = 4
    main.stageMenu = true --stage selection enabled
    --main.p2Faces = true --additional window with P2 select screen small portraits (faces) enabled
    main.p2SelectMenu = true
    main.p3SelectMenu = true
    main.p4SelectMenu = true
    main.versusScreen = true
    main.victoryScreen = true
    --uses default main.t_charparam assignment
    main.t_lifebar.p1score = true
    main.t_lifebar.p2score = true
    main.p1TeamMenu.single = false
    main.p1TeamMenu.simul = true
    main.p1TeamMenu.turns = false
    main.p1TeamMenu.tag = false
    main.p1TeamMenu.ratio = false
    main.p2TeamMenu.single = false
    main.p2TeamMenu.simul = true
    main.p2TeamMenu.turns = false
    main.p2TeamMenu.tag = false
    main.p2TeamMenu.ratio = false
    main.txt_mainSelect:update({text = motif.select_info.title_teamversus_text})
    sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
    main.f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
    setGameMode('4pversus')
    start4p.f_select4pSimple()
end

main.t_itemname ['4pcoop'] = function(cursorPosY, moveTxt, item, t)
    setHomeTeam(1) --P1 side considered the home team
    main.t_pIn[2] = 2
    main.t_pIn[3] = 3
    main.t_pIn[4] = 4
    main.coop = true --P2 fighting on P1 side enabled
    --main.p2Faces = true
    main.p2SelectMenu = true
    main.p3SelectMenu = true;
    main.p4SelectMenu = true;
    main.resetScore = true
    main.versusScreen = true
    main.victoryScreen = true
    main.continueScreen = true
    main.t_charparam.stage = true
    main.t_charparam.music = true
    main.t_charparam.ai = true
    main.t_charparam.rounds = true
    --main.t_charparam.time = true
    --main.t_charparam.single = true
    --main.t_charparam.rivals = true
    main.t_lifebar.p1score = true
    main.t_lifebar.p2ai = true
    main.resultsTable = motif.win_screen
    main.credits = config.Credits - 1
    main.p1TeamMenu.simul = true
    main.p1TeamMenu.tag = false
    main.p2TeamMenu.single = false
    main.p2TeamMenu.simul = true
    main.p2TeamMenu.turns = false
    main.p2TeamMenu.tag = false
    main.p2TeamMenu.ratio = false
    main.txt_mainSelect:update({text = motif.select_info.title_teamcoop_text})
    sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
    main.f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
    setGameMode('4pcoop')
    start4p.f_select4pSimple()
end
