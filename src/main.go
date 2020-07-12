package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"regexp"
	"runtime"
	"strconv"
	"strings"

	"github.com/go-gl/glfw/v3.3/glfw"
	"github.com/sqweek/dialog"
	lua "github.com/yuin/gopher-lua"
)

const (
	// Define system constants
	PSeperator               string = string(os.PathSeparator)
	ConfigDirName            string = "save"
	ConfigPath               string = ConfigDirName + PSeperator
	ReplayDirPath            string = ConfigPath + "replays"
	ConfigFilePath           string = ConfigPath + "config.json"
	LogFileName              string = "Ikemen.log"
	StatsFilePath            string = ConfigPath + "stats.json"
	HJStatsFilePath          string = ConfigPath + "hjstats.json"
	GameControllerDBFilePath string = ConfigPath + "gamecontrollerdb.txt"
)

func init() {
	runtime.LockOSThread()
}

func chk(err error) {
	if err != nil {
		panic(err)
	}
}

func createLog(p string) *os.File {
	//fmt.Println("Creating log")
	if !fileExists(p) {
		f, err := os.Create(p)
		if err != nil {
			panic(err)
		}
		return f
	} else {
		f, err := os.Open(p)
		if err != nil {
			panic(err)
		}
		return f
	}
}

func fileExists(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}

func closeLog(f *os.File) {
	//fmt.Println("Closing log")
	chk(f.Close())
}
func main() {
	os.Mkdir(ConfigDirName, os.ModeSticky|0755)
	os.Mkdir(ReplayDirPath, os.ModeSticky|0755)
	if len(os.Args[1:]) > 0 {
		sys.cmdFlags = make(map[string]string)
		key := ""
		player := 1
		for _, a := range os.Args[1:] {
			match, _ := regexp.MatchString("^-", a)
			if match {
				help, _ := regexp.MatchString("^-[h%?]", a)
				if help {
					text := `Options (case sensitive):
-h -?                   Help
-log <logfile>          Records match data to <logfile>
-r <path>               Loads motif <path>. eg. -r motifdir or -r motifdir/system.def
-lifebar <path>         Loads lifebar <path>. eg. -lifebar data/fight.def
-storyboard <path>      Loads storyboard <path>. eg. -storyboard chars/kfm/intro.def

Quick VS Options:
-p<n> <playername>      Loads player n, eg. -p3 kfm
-p<n>.ai <level>        Sets player n's AI to <level>, eg. -p1.ai 8
-p<n>.color <col>       Sets player n's color to <col>
-p<n>.power <power>     Sets player n's power to <power>
-p<n>.life <life>       Sets player n's life to <life>
-tmode1 <tmode>         Sets p1 team mode to <tmode>
-tmode2 <tmode>         Sets p2 team mode to <tmode>
-time <num>             Round time (-1 to disable)
-rounds <num>           Plays for <num> rounds, and then quits
-s <stagename>          Loads stage <stagename>

Debug Options:
-nojoy                  Disables joysticks
-nomusic                Disables music
-nosound                Disables all sound effects and music
-togglelifebars         Disables display of the Life and Power bars
-maxpowermode           Enables auto-refill of Power bars
-ailevel <level>        Changes game difficulty setting to <level> (1-8)
-speed <speed>          Changes game speed setting to <speed> (10%%-200%%)
-stresstest <frameskip> Stability test (AI matches at speed increased by <frameskip>)
-speedtest              Speed test (match speed x100)`
					//dialog.Message(text).Title("I.K.E.M.E.N Command line options").Info()
					fmt.Printf("I.K.E.M.E.N Command line options\n\n" + text + "\nPress ENTER to exit")
					var s string
					fmt.Scanln(&s)
					os.Exit(0)
				}
				sys.cmdFlags[a] = ""
				key = a
			} else if key == "" {
				sys.cmdFlags[fmt.Sprintf("-p%v", player)] = a
				player += 1
			} else {
				sys.cmdFlags[key] = a
				key = ""
			}
		}
	}
	// Initialize GLFW library
	chk(glfw.Init())
	defer glfw.Terminate()

	// Create log file to print errors to
	log := createLog(LogFileName)
	defer closeLog(log)
	if _, err := ioutil.ReadFile(StatsFilePath); err != nil {
		f, err := os.Create(HJStatsFilePath)
		chk(err)
		f.Write([]byte("{}"))
		chk(f.Close())
	}
	defcfg := []byte(strings.Join(strings.Split(
		`{
	"AIRamping": true,
	"AIRandomColor": true,
	"AudioDucking": false,
	"AutoGuard": false,
	"BarGuard": false,
	"BarRedLife": true,
	"BarStun": false,
	"Borderless": false,
	"ComboExtraFrameWindow": 1,
	"CommonAir": "data/common.air",
	"CommonCmd": "data/common.cmd",
	"CommonConst": "data/common.const",
	"CommonStates": [
		"data/dizzy.zss",
		"data/guardbreak.zss",
		"data/score.zss",
		"data/tag.zss"
    ],
	"ControllerStickSensitivity": 0.4,
	"Credits": 10,
	"DebugFont": "font/f-4x6.def",
	"DebugKeys": true,
	"DebugMode": false,
	"DebugScript": "external/script/debug.lua",
	"Difficulty": 8,
	"ExternalShaders": [],
	"Fullscreen": false,
	"GameWidth": 1280,
	"GameHeight": 720,
	"GameSpeed": 100,
	"IP": {},
	"LifebarFontScale": 1,
	"LifeMul": 100,
	"ListenPort": "7500",
	"LocalcoordScalingType": 1,
	"MaxAfterImage": 128,
	"MaxDrawGames": -2,
	"MaxExplod": 512,
	"MaxHelper": 56,
	"MaxPlayerProjectile": 256,
	"Motif": "data/system.def",
	"MSAA": false,
	"NumSimul": [
		2,
		4
	],
	"NumTag": [
		2,
		4
	],
	"NumTurns": [
		2,
		4
	],
	"PostProcessingShader": 0,
	"PreloadingSmall": true,
	"PreloadingBig": true,
	"PreloadingVersus": true,
	"PreloadingStage": true,
	"QuickContinue": false,
	"RatioAttack": [
		0.82,
		1,
		1.17,
		1.3
	],
	"RatioLife": [
		0.8,
		1,
		1.17,
		1.4
	],
	"RoundsNumSingle": 2,
	"RoundsNumTeam": 2,
	"RoundTime": 99,
	"ScreenshotFolder": "",
	"SimulLoseKO": true,
	"SingleVsTeamLife": 100,
	"System": "external/script/main.lua",
	"TagLoseKO": false,
	"TeamLifeAdjustment": false,
	"TeamPowerShare": true,
	"TrainingChar": "chars/training/training.def",
	"TurnsRecoveryBase": 0,
	"TurnsRecoveryBonus": 20,
	"VolumeBgm": 80,
	"VolumeMaster": 80,
	"VolumeSfx": 80,
	"VRetrace": 1, 
	"WindowIcon": "external/icons/IkemenCylia.png",
	"WindowTitle": "Ikemen GO",
	"XinputTriggerSensitivity": 0,
	"ZoomActive": true,
	"ZoomDelay": false,
	"ZoomMax": 1,
	"ZoomMin": 1,
	"ZoomSpeed": 1,
	"KeyConfig": [
		{
			"Joystick": -1,
			"Buttons": [
				"UP",
				"DOWN",
				"LEFT",
				"RIGHT",
				"q",
				"w",
				"e",
				"a",
				"s",
				"d",
				"RETURN",
				"MINUS",
				"EQUALS"
			]
		},
		{
			"Joystick": -1,
			"Buttons": [
				"KP_8",
				"KP_2",
				"KP_4",
				"KP_6",
				"i",
				"o",
				"p",
				"j",
				"k",
				"l",
				"KP_ENTER",
				"LEFTBRACKET",
				"RIGHTBRACKET"
			]
		},
		{
			"Joystick": -1,
			"Buttons": [
				"r",
				"t",
				"y",
				"u",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"LCTRL",
				"7",
				"8"
			]
		},
		{
			"Joystick": -1,
			"Buttons": [
				"z",
				"x",
				"c",
				"v",
				"f",
				"g",
				"h",
				"b",
				"n",
				"m",
				"RCTRL",
				"COMMA",
				"PERIOD"
			]
		}
	],
	"JoystickConfig": [
		{
			"Joystick": 0,
			"Buttons": [
				"14",
				"16",
				"17",
				"15",
				"2",
				"1",
				"0",
				"3",
				"5",
				"4",
				"9",
				"7",
				"6"
			]
		},
		{
			"Joystick": 1,
			"Buttons": [
				"14",
				"16",
				"17",
				"15",
				"2",
				"1",
				"0",
				"3",
				"5",
				"4",
				"9",
				"7",
				"6"
			]
		},
		{
			"Joystick": 2,
			"Buttons": [
				"14",
				"16",
				"17",
				"15",
				"2",
				"1",
				"0",
				"3",
				"5",
				"4",
				"9",
				"7",
				"6"
			]
		},
		{
			"Joystick": 3,
			"Buttons": [
				"14",
				"16",
				"17",
				"15",
				"2",
				"1",
				"0",
				"3",
				"5",
				"4",
				"9",
				"7",
				"6"
			]
		}
	]
}
`, "\n"), "\r\n"))
	tmp := struct {
		AIRamping                  bool
		AIRandomColor              bool
		AudioDucking               bool
		AutoGuard                  bool
		BarGuard                   bool
		BarRedLife                 bool
		BarStun                    bool
		Borderless                 bool
		ComboExtraFrameWindow      int32
		CommonAir                  string
		CommonCmd                  string
		CommonConst                string
		CommonStates               []string
		ControllerStickSensitivity float32
		Credits                    int
		DebugFont                  string
		DebugKeys                  bool
		DebugMode                  bool
		DebugScript                string
		Difficulty                 int
		ExternalShaders            []string
		Fullscreen                 bool
		GameWidth                  int32
		GameHeight                 int32
		GameSpeed                  float32
		IP                         map[string]string
		LifebarFontScale           float32
		LifeMul                    float32
		ListenPort                 string
		LocalcoordScalingType      int32
		MaxAfterImage              int32
		MaxDrawGames               int32
		MaxExplod                  int
		MaxHelper                  int32
		MaxPlayerProjectile        int
		Motif                      string
		MSAA                       bool
		NumSimul                   [2]int
		NumTag                     [2]int
		NumTurns                   [2]int
		PostProcessingShader       int32
		PreloadingSmall            bool
		PreloadingBig              bool
		PreloadingVersus           bool
		PreloadingStage            bool
		QuickContinue              bool
		RatioAttack                [4]float32
		RatioLife                  [4]float32
		RoundsNumSingle            int32
		RoundsNumTeam              int32
		RoundTime                  int32
		ScreenshotFolder           string
		SimulLoseKO                bool
		SingleVsTeamLife           float32
		System                     string
		TagLoseKO                  bool
		TeamLifeAdjustment         bool
		TeamPowerShare             bool
		TrainingChar               string
		TurnsRecoveryBase          float32
		TurnsRecoveryBonus         float32
		VolumeBgm                  int
		VolumeMaster               int
		VolumeSfx                  int
		VRetrace                   int
		WindowIcon                 string
		WindowTitle                string
		XinputTriggerSensitivity   float32
		ZoomActive                 bool
		ZoomDelay                  bool
		ZoomMax                    float32
		ZoomMin                    float32
		ZoomSpeed                  float32
		KeyConfig                  []struct {
			Joystick int
			Buttons  []interface{}
		}
		JoystickConfig []struct {
			Joystick int
			Buttons  []interface{}
		}
	}{}
	// Read the config JSON file and unmarshal it to the tmp variable
	chk(json.Unmarshal(defcfg, &tmp))
	if bytes, err := ioutil.ReadFile(ConfigFilePath); err == nil {
		if len(bytes) >= 3 &&
			bytes[0] == 0xef && bytes[1] == 0xbb && bytes[2] == 0xbf {
			bytes = bytes[3:]
		}
		chk(json.Unmarshal(bytes, &tmp))
	}
	cfg, _ := json.MarshalIndent(tmp, "", "	")
	// Write to the config JSON file (and also set permissions to CHMOD 644
	chk(ioutil.WriteFile(ConfigFilePath, cfg, 0644))

	// Bind the values from the config JSON to the system
	sys.afterImageMax = tmp.MaxAfterImage
	sys.allowDebugKeys = tmp.DebugKeys
	sys.audioDucking = tmp.AudioDucking
	sys.bgmVolume = tmp.VolumeBgm
	sys.borderless = tmp.Borderless
	sys.zoomDelay = tmp.ZoomDelay
	sys.cam.ZoomEnable = tmp.ZoomActive
	sys.cam.ZoomMax = tmp.ZoomMax
	sys.cam.ZoomMin = tmp.ZoomMin
	sys.cam.ZoomSpeed = 12 - tmp.ZoomSpeed
	sys.comboExtraFrameWindow = tmp.ComboExtraFrameWindow
	if air, err := ioutil.ReadFile(tmp.CommonAir); err == nil {
		sys.commonAir = "\n" + string(air)
	}
	if cmd, err := ioutil.ReadFile(tmp.CommonCmd); err == nil {
		sys.commonCmd = "\n" + string(cmd)
	}
	sys.commonConst = tmp.CommonConst
	sys.commonStates = tmp.CommonStates
	sys.controllerStickSensitivity = tmp.ControllerStickSensitivity
	sys.debugDraw = tmp.DebugMode
	sys.debugScript = tmp.DebugScript
	sys.explodMax = tmp.MaxExplod
	sys.externalShaderList = tmp.ExternalShaders
	sys.fullscreen = tmp.Fullscreen
	sys.helperMax = tmp.MaxHelper
	sys.lifeAdjustment = tmp.TeamLifeAdjustment
	sys.lifebarFontScale = tmp.LifebarFontScale
	sys.listenPort = tmp.ListenPort
	sys.localcoordScalingType = tmp.LocalcoordScalingType
	sys.masterVolume = tmp.VolumeMaster
	sys.multisampleAntialiasing = tmp.MSAA
	sys.playerProjectileMax = tmp.MaxPlayerProjectile
	sys.postProcessingShader = tmp.PostProcessingShader
	sys.preloading.big = tmp.PreloadingBig
	sys.preloading.small = tmp.PreloadingSmall
	sys.preloading.stage = tmp.PreloadingStage
	sys.preloading.versus = tmp.PreloadingVersus
	tmp.ScreenshotFolder = strings.TrimSpace(tmp.ScreenshotFolder)
	if tmp.ScreenshotFolder != "" {
		tmp.ScreenshotFolder = strings.Replace(tmp.ScreenshotFolder, "\\", "/", -1)
		tmp.ScreenshotFolder = strings.TrimRight(tmp.ScreenshotFolder, "/")
		sys.screenshotFolder = tmp.ScreenshotFolder + "/"
	} else {
		sys.screenshotFolder = tmp.ScreenshotFolder
	}
	sys.vRetrace = tmp.VRetrace
	sys.wavVolume = tmp.VolumeSfx
	sys.windowMainIconLocation = append(sys.windowMainIconLocation, tmp.WindowIcon)
	sys.windowTitle = tmp.WindowTitle
	sys.xinputTriggerSensitivity = tmp.XinputTriggerSensitivity
	stoki := func(key string) int {
		return int(StringToKey(key))
	}
	Atoi := func(key string) int {
		var i int
		i, _ = strconv.Atoi(key)
		return i
	}
	for i := 0; i < MaxSimul; i++ {
		for _, kc := range tmp.KeyConfig {
			b := kc.Buttons
			if kc.Joystick < 0 {
				sys.keyConfig = append(sys.keyConfig, KeyConfig{kc.Joystick,
					stoki(b[0].(string)), stoki(b[1].(string)),
					stoki(b[2].(string)), stoki(b[3].(string)),
					stoki(b[4].(string)), stoki(b[5].(string)), stoki(b[6].(string)),
					stoki(b[7].(string)), stoki(b[8].(string)), stoki(b[9].(string)),
					stoki(b[10].(string)), stoki(b[11].(string)), stoki(b[12].(string))})
			}
		}
		if _, ok := sys.cmdFlags["-nojoy"]; !ok {
			for _, jc := range tmp.JoystickConfig {
				b := jc.Buttons
				if jc.Joystick >= 0 {
					sys.joystickConfig = append(sys.joystickConfig, KeyConfig{jc.Joystick,
						Atoi(b[0].(string)), Atoi(b[1].(string)),
						Atoi(b[2].(string)), Atoi(b[3].(string)),
						Atoi(b[4].(string)), Atoi(b[5].(string)), Atoi(b[6].(string)),
						Atoi(b[7].(string)), Atoi(b[8].(string)), Atoi(b[9].(string)),
						Atoi(b[10].(string)), Atoi(b[11].(string)), Atoi(b[12].(string))})
				}
			}
		}
	}
	// Append keyconfig to keyconfig? based on the MaxAttachtedChar value
	for i := 0; i < MaxAttachedChar; i++ {
		sys.keyConfig = append(sys.keyConfig, KeyConfig{-1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1})
	}
	//os.Mkdir("debug", os.ModeSticky|0755)

	// Add optional SDL gamecontroller db for optimized controller support
	bytes, err := ioutil.ReadFile(GameControllerDBFilePath)
	if bytes != nil && err == nil {
		fmt.Println("Gamepad mappings found!")
		updated := glfw.UpdateGamepadMappings(string(bytes))
		if updated {
			fmt.Println("Gamepad mappings have been updated")
		}
	} else {
		fmt.Println("No gamepad mappings found")
	}

	// Check how many gamepads are present
	// TODO: Check what happens when there are more then 4 controllers?
	fmt.Println("Gamepad Checks: ")
	fmt.Println("Controller 1 present: ", glfw.Joystick1.Present())
	fmt.Println("Controller 2 present: ", glfw.Joystick2.Present())
	fmt.Println("Controller 3 present: ", glfw.Joystick3.Present())
	fmt.Println("Controller 4 present: ", glfw.Joystick4.Present())
	l := sys.init(tmp.GameWidth, tmp.GameHeight)
	if err := l.DoFile(tmp.System); err != nil {
		fmt.Fprintln(log, err)
		switch err.(type) {
		case *lua.ApiError:
			errstr := strings.Split(err.Error(), "\n")[0]
			if len(errstr) < 10 || errstr[len(errstr)-10:] != "<game end>" {
				dialog.Message("%s\n\nError saved to Ikemen.log", err).Title("I.K.E.M.E.N Error").Error()
				panic(err)
			}
		default:
			dialog.Message("%s\n\nError saved to Ikemen.log", err).Title("I.K.E.M.E.N Error").Error()
			panic(err)
		}
	}

	// Keep running until sys.gameEnd = false?
	if !sys.gameEnd {
		sys.gameEnd = true
	}
	<-sys.audioClose
}
