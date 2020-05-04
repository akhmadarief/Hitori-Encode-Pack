#include <GUIConstants.au3>

#include <WindowsConstants.au3>    ; No incluidas ahora (v3.3) en GUIConstants.au3
#include <StaticConstants.au3>     ; No incluidas ahora (v3.3) en GUIConstants.au3
#include <EditConstants.au3>       ; No incluidas ahora (v3.3) en GUIConstants.au3

;Modo Eventos
Opt("GUIOnEventMode", 1)

;Variables
Dim $ruta_file
Dim $ruta_filo
Dim $ruta_fold
Dim $ruta_enco
Dim $ruta_log
Dim $ruta_ini
Dim $ruta_eac
Dim $ruta_out
Dim $filename
Dim $eac3to
Dim $MkvMerge
Dim $TsMuxer
Dim $Pcm2Tsmu
Dim $Lame
Dim $TwoLame
Dim $OggEnc2
Dim $NeroAacEnc
Dim $extension
Dim $encoder
Dim $editor
Dim $tw
Dim $tf
Dim $t9
Dim $first
Dim $mkv_1
Dim $mkv_2
Dim $mkv_3
Dim $mkv_4
Dim $mkv_5
Dim $mkv_6
Dim $srt_0
Dim $srt_1
Dim $srt_2
Dim $srt_3
Dim $srt_4
Dim $srt_5
Dim $srt_6
Dim $srt_7
Dim $srt_8
Dim $t11
Dim $t12
Dim $t21
Dim $t22
Dim $stretch
Dim $delay
Dim $offset
Dim $dec_1
Dim $dec_2
Dim $dec_3
Dim $dec_4
Dim $dec_5
Dim $dec_6
Dim $dec_7
Dim $dec_8
Dim $dec_9
Dim $dec10
Dim $bit_1
Dim $bit_2
Dim $qua_3
Dim $bit_4
Dim $qua_5
Dim $bit_6
Dim $qua_7
Dim $bit_8
Dim $bit_9
Dim $bit10
Dim $track_mkv
Dim $map
Dim $clp
$aux = 0
$PID = 0
$feat = ""
$mode = ""
$param = ""
$par0 = ""
$par1 = ""
$sources = ""
$video = ""
$lg1 = ""
$lg2 = ""
$audio1 = ""
$audio2 = ""
$track_max = ""
$track = ""
$tcod = 7
$MiPC = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
$shutd = 0
$shutm = 0
$decorar = ""
$bits = 24
$ext_def = ""
$par_def = ""

;Ventana Principal
$ppal = GUICreate("UsEac3To v1.2.9", 680, 550, -1, -1, -1, $WS_EX_ACCEPTFILES)
GUISetOnEvent($GUI_EVENT_CLOSE, "cerrar_ppal")
GUISetOnEvent ( $GUI_EVENT_DROPPED, "funcion_drag_drop" )

;Barra de menus
$menu_archivo = GUICtrlCreateMenu ("&File")
$submenu_abrir = GUICtrlCreateMenuitem ("&Open...",$menu_archivo)
GUICtrlSetOnEvent ($submenu_abrir, "explorer" )
GUICtrlCreateMenuitem ("",$menu_archivo)
$submenu_salir = GUICtrlCreateMenuitem ("&Exit",$menu_archivo)
GUICtrlSetOnEvent ($submenu_salir, "cerrar_ppal" )

$menu_config = GUICtrlCreateMenu ("&Settings")
$path_eac3to = GUICtrlCreateMenuitem ("Path to eac3to",$menu_config)
GUICtrlSetOnEvent ($path_eac3to, "explorer_eac" )
GUICtrlCreateMenuitem ("",$menu_config)
$path_MkvMerge = GUICtrlCreateMenuitem ("Path to MkvMerge",$menu_config)
GUICtrlSetOnEvent ($path_MkvMerge, "explorer_mkv" )
GUICtrlCreateMenuitem ("",$menu_config)
$path_TsMuxer = GUICtrlCreateMenuitem ("Path to TsMuxer",$menu_config)
GUICtrlSetOnEvent ($path_TsMuxer, "explorer_tsm" )
GUICtrlCreateMenuitem ("",$menu_config)
$path_enco = GUICtrlCreateMenuitem ("Encoders Folder",$menu_config)
GUICtrlSetOnEvent ($path_enco, "explorer_enc" )
GUICtrlCreateMenuitem ("",$menu_config)
$path_out = GUICtrlCreateMenuitem ("Output Folder",$menu_config)
GUICtrlSetOnEvent ($path_out, "explorer_out" )
GUICtrlCreateMenuitem ("",$menu_config)
$submenu_shu = GUICtrlCreateMenu ("Shutdown at finish",$menu_config)
$subsubmenu_shu_1 = GUICtrlCreateMenuItem ( "Disabled", $submenu_shu )
GUICtrlSetOnEvent ($subsubmenu_shu_1, "funcion_shu_1" )
$subsubmenu_shu_2 = GUICtrlCreateMenuItem ( "Enabled", $submenu_shu )
GUICtrlSetOnEvent ($subsubmenu_shu_2, "funcion_shu_2" )
GUICtrlSetState($subsubmenu_shu_1, $GUI_CHECKED)


$menu_ayuda = GUICtrlCreateMenu ("&?")
$submenu_help = GUICtrlCreateMenuitem ("&Help",$menu_ayuda)
GUICtrlSetOnEvent ($submenu_help, "help" )
$submenu_acerca = GUICtrlCreateMenuitem ("&About",$menu_ayuda)
GUICtrlSetOnEvent ($submenu_acerca, "acerca" )

;Botones y cuadros
$cuadro_abrir = GUICtrlCreateLabel ( "No file selected...", 10, 10, 520, 20, BitOr($GUI_SS_DEFAULT_LABEL, $SS_SUNKEN, $SS_LEFT))
GUICtrlSetBkColor($cuadro_abrir, 0x99ffff)
$boton_abrir = GUICtrlCreateButton ("&Input File", 543, 10, 60, 20)
GUICtrlSetOnEvent ($boton_abrir, "explorer")
$cuadro_add = GUICtrlCreateEdit ( "", 10, 40, 520, 20, $WS_VSCROLL + $ES_WANTRETURN)
GUICtrlSetBkColor($cuadro_add, 0x99ffff)
$boton_add = GUICtrlCreateButton ("+ Sources", 543, 40, 60, 20)
GUICtrlSetOnEvent ($boton_add, "add_sources")
$boton_savelog = GUICtrlCreateButton ("&Save Log", 610, 40, 60, 20)
GUICtrlSetOnEvent ($boton_savelog, "save_log")
$boton_cancelar = GUICtrlCreateButton ("Show Log", 610, 10, 60, 20)
GUICtrlSetOnEvent ($boton_cancelar, "funcion_cancel") ; cancel dont work then change the function

;control info log
$cuadro_bsi = GUICtrlCreateLabel ( "* * E A C 3 T O   I N F O * *", 10, 70, 660, 15, $SS_SUNKEN+$SS_CENTER)
GUICtrlSetBkColor($cuadro_bsi, 0xd5e1e9)
GUICtrlSetFont ($cuadro_bsi, 9, 1600, 2)
$cuadro_info = GUICtrlCreateEdit ( "", 10, 85, 660, 225, $WS_VSCROLL + $ES_WANTRETURN)
GUICtrlSetBkColor($cuadro_info, 0xd5e1e9)
GUICtrlSetState ( $cuadro_info, $GUI_DROPACCEPTED )
GUICtrlSetFont ( $cuadro_info, 9, 400, 0, "Fixedsys")
; intento de fuente no proporcional para preservar columnas
GUICtrlSetData ( $cuadro_info, "No File Selected... Drag&Drop is allowed.")

GUICtrlCreateGroup("Global Parameters", 10, 315, 130, 50)
$c1 = GUICtrlCreateCombo("demux", 15, 335, 70, 20) ; create first item
GUICtrlSetData($c1, "check|test","demux") ; add other item snd set a new default
$add_c1 = GUICtrlCreateButton ("RUN", 95, 335, 40, 20)
GUICtrlSetOnEvent ($add_c1, "c1_run")

GUICtrlCreateGroup("Track Input and Output format", 150, 315, 190, 50)
$t1 = GUICtrlCreateCombo("", 155, 335, 70, 20) ; create first item
GUICtrlSetOnEvent ($t1, "t1_add")
$t2 = GUICtrlCreateCombo("ac3", 230, 335, 70, 20) ; create first item
;GUICtrlSetData($t2, "flac|wav|wavs|pcm|w64|mp2|mp3|m4a|dts|dtshd|thd|thd+ac3|mkv|h264|vc1|m2v|srt|ssa|ass|sup|txt|mp3-ext|mp2-ext|ogg-ext|ac3-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3") ; add other item snd set a new default
GUICtrlSetData($t2, "flac|wav|wavs|pcm|w64|mp2|mp3|m4a|dts|dtshd|thd|thd+ac3|mkv|h264|vc1|m2v|srt|ssa|ass|sup|txt|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3-ffm") ; add other item snd set a new default
$add_t2 = GUICtrlCreateButton ("Add", 305, 335, 30, 20)
GUICtrlSetOnEvent ($add_t2, "t2_add")

GUICtrlCreateGroup("Frequent parameters", 350, 315, 160, 50)
$t3 = GUICtrlCreateCombo("448", 355, 335, 110, 20) ; create first item
GUICtrlSetData($t3, "quality=0.35|core|downStereo|downDpl|mixlfe|phaseShift|0,1,2,3,5,6,4|down6|double7|down16|resampleTo48000|slowdown|speedup|23.976|changeTo23.976|normalize|3.5dB|100ms|edit=0:00:00.000,0ms|silence|loop|logdts", "448")
$add_t3 = GUICtrlCreateButton ("Add", 475, 335, 30, 20)
GUICtrlSetOnEvent ($add_t3, "t3_add")

GUICtrlCreateGroup("More parameters", 520, 315, 150, 50)
$t4 = GUICtrlCreateCombo("no2ndpass", 525, 335, 100, 20) ; create first item
GUICtrlSetData($t4, "keepPulldown|stripPulldown|seekToIFrames|keepFullRange|ignoreEncrypt|skip2|keepDialnorm|2pass|mono|9mb|simple|full|dontDither|override -big|lowPriority|r8brain|dcadec|arcsoft|libav|nero|sonic|decodeHdcd", "no2ndpass") ; add other item snd set a new default
$add_t4 = GUICtrlCreateButton ("Add", 635, 335, 30, 20)
GUICtrlSetOnEvent ($add_t4, "t4_add")

;param info log
$param_bsi = GUICtrlCreateLabel ( "* * COMMAND LINE PARAMETERS ('%' char replaced by input name) * *", 10, 375, 660, 15, $SS_SUNKEN+$SS_CENTER)
GUICtrlSetBkColor($param_bsi, 0xd5e1e9)
GUICtrlSetFont ($param_bsi, 9, 1600, 2)
$param_info = GUICtrlCreateEdit ( "", 10, 390, 660, 55, $WS_VSCROLL + $ES_WANTRETURN)
GUICtrlSetBkColor($param_info, 0xd5e1e9)
GUICtrlSetFont ( $param_info, 9, 400, 0, "Fixedsys")
GUICtrlSetData ( $param_info, "")

GUICtrlCreateGroup("Output Folder", 10, 450, 100, 75)
$same_asi = GUICtrlCreateRadio("Same as input", 20, 465, 85, 25)
$user_def = GUICtrlCreateRadio("User defined", 20, 495, 85, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
GUICtrlSetState($same_asi, $GUI_CHECKED)

$boton_clear = GUICtrlCreateButton ("&Clear CL", 120, 455, 55, 30)
GUICtrlSetOnEvent ($boton_clear, "Clear_Param")
$run_global = GUICtrlCreateButton ("&RUN CL", 120, 495, 55, 30)
GUICtrlSetOnEvent ($run_global, "Global_run")
$boton_queue = GUICtrlCreateButton ("&EnQueue", 185, 455, 55, 30)
GUICtrlSetOnEvent ($boton_queue, "Enqueue")
$run_queue = GUICtrlCreateButton ("RUN &Que.", 185, 495, 55, 30)
GUICtrlSetOnEvent ($run_queue, "Queue_run")

GUICtrlCreateGroup("Auxiliary Tools", 250, 450, 420, 75)
$boton_mkvmux = GUICtrlCreateButton ("Run and MkvMux", 255, 465, 95, 25)
GUICtrlSetOnEvent ($boton_mkvmux, "run_MkvMux")
$boton_tsmux = GUICtrlCreateButton ("Run and TsMux", 255, 495, 95, 25)
GUICtrlSetOnEvent ($boton_tsmux, "run_TsMux")
$boton_ext = GUICtrlCreateButton ("MkvExtract/INF", 360, 465, 95, 25)
GUICtrlSetOnEvent ($boton_ext, "mkv_gui")
$boton_srt = GUICtrlCreateButton ("SRT/.../TRIM", 360, 495, 95, 25)
GUICtrlSetOnEvent ($boton_srt, "srt_sel")
$boton_dec = GUICtrlCreateButton ("A/V Recode", 465, 465, 95, 25)
GUICtrlSetOnEvent ($boton_dec, "dec_gui")
$boton_nos = GUICtrlCreateButton ("DelayCut", 465, 495, 95, 25)
GUICtrlSetOnEvent ($boton_nos, "DelayCut_run")
$boton_empezar = GUICtrlCreateButton ("&MkvToolNix", 570, 465, 95, 25)
GUICtrlSetOnEvent ($boton_empezar, "MkvMerge_run")
$boton_showlog = GUICtrlCreateButton ("&TsMuxerGUI", 570, 495, 95, 25)
GUICtrlSetOnEvent ($boton_showlog, "TsMuxer_run")

;Hace visible la GUI
GUISetState(@SW_SHOW)

;GUI script
$ruta_ini = @ScriptDir & "\UsEac3To.ini"
$ruta_log = @ScriptDir & "\UsEac3To.log"
If FileExists($ruta_ini) Then
    $ini_handle = FileOpen ( $ruta_ini, 512 )
    $eac3to    = FileReadLine($ini_handle)
    $ruta_fold = FileReadLine($ini_handle)
    $MkvMerge  = FileReadLine($ini_handle)
    $TsMuxer   = FileReadLine($ini_handle)
    $ruta_enco = FileReadLine($ini_handle)
    $ruta_out  = FileReadLine($ini_handle)
    FileClose($ini_handle)
EndIf

If not FileExists($eac3to)    Then $eac3to    = @ScriptDir & "\eac3to.exe"
If not FileExists($MkvMerge)  Then $MkvMerge  = @ProgramFilesDir & "\MKVtoolnix\mkvmerge.exe"
If not FileExists($TsMuxer)   Then $TsMuxer   = @ProgramFilesDir & "\tsMuxeR\tsMuxer.exe"
If not FileExists($ruta_enco) Then $ruta_enco = @ScriptDir
If not FileExists($ruta_out)  Then $ruta_out  = @ScriptDir
If not FileExists($eac3to)    Then $eac3to    = StringTrimRight(@ScriptDir, 8) & "eac3to.exe"
If not FileExists($eac3to)    Then explorer_eac()
$ruta_eac = StringTrimRight($eac3to, 10)
If not FileExists($TsMuxer)   Then $TsMuxer   = $ruta_eac & "tsMuxeR\tsMuxer.exe"
If not FileExists($MkvMerge)  Then $MkvMerge  = $ruta_eac & "MKVtoolnix\mkvmerge.exe"
;If $ruta_out <> @ScriptDir Then GUICtrlSetState($user_def, $GUI_CHECKED)

; Create Vid_enc file if not exist
$Vid_enc = @ScriptDir & "\Vid_enc.par"
If not FileExists($Vid_enc) Then
    $log_handle = FileOpen ($Vid_enc, 514)
    FileWriteLine($log_handle, "[Encoders]")
    FileWriteLine($log_handle, "x264.exe")
    FileWriteLine($log_handle, "avs4x26x.exe")
    FileWriteLine($log_handle, "xvid_encraw.exe")
    FileWriteLine($log_handle, "")
    FileWriteLine($log_handle, "[Extensions]")
    FileWriteLine($log_handle, "mkv")
    FileWriteLine($log_handle, "h265")
    FileWriteLine($log_handle, "h264")
    FileWriteLine($log_handle, "mp4")
    FileWriteLine($log_handle, "avi")
    FileWriteLine($log_handle, "")
    FileWriteLine($log_handle, "[Text Editor]")
    FileWriteLine($log_handle, "Notepad.exe")
    FileWriteLine($log_handle, "")
    FileWriteLine($log_handle, "[Presets]")
    FileWriteLine($log_handle, "Default|--crf 18.0 --bframes 4 --ref 5 --trellis 2 --subme 8")
    FileWriteLine($log_handle, "720_pass_1|--preset slow --pass 1 --bitrate 4000 --stats " & chr(34) & ".stats" & chr(34))
    FileWriteLine($log_handle, "720_pass_2|--preset slow --pass 2 --bitrate 4000 --stats " & chr(34) & ".stats" & chr(34))
    FileWriteLine($log_handle, "avi_pass_1|-pass1 -bitrate 2000 -max_bframes 1 -nopacked -turbo -notrellis")
    FileWriteLine($log_handle, "avi_pass_2|-pass2 -bitrate 1770 -max_bframes 1 -nopacked -turbo -notrellis")
    FileWriteLine($log_handle, "x265_def|--crf 20")
    FileClose($log_handle)
Endif

; Create Help.log
$ruta_help = @ScriptDir & "\Help.log"
$param = chr(34) & $eac3to & chr(34) & " >" & chr(34) & $ruta_log & chr(34)
Param_page()

$ruta_cmd = @ScriptDir & "\UsEac3To2.cmd"
$cmd_handle = FileOpen ($ruta_cmd , 514 )
FileWriteLine($cmd_handle, $param)
FileClose($cmd_handle)
ShellExecuteWait($ruta_cmd,"","","",@SW_HIDE )

$log_in = FileOpen ($ruta_log, 512)
$log_out = FileOpen ($ruta_help, 514)
While 1
    $line = FileReadLine($log_in)
    If @error = -1 Then ExitLoop
    If StringLen($line) > 79 Then $line = StringMid($line, 81)
    FileWriteLine($log_out, $line)
Wend
FileClose($log_in)
FileClose($log_out)
; Drag & Drop over EXE
If $CmdLine[0] Then
    $ruta_file = $CmdLineRaw
    If StringLeft($ruta_file, 1) == chr(34) Then $ruta_file = StringTrimRight(StringTrimLeft($ruta_file, 1), 1)
    If FileExists($ruta_file) Then
        If StringInStr(FileGetAttrib($ruta_file), "D") Then $ruta_file = $ruta_file & "\0"
        new_file()
    EndIf
EndIf

While 1
    Sleep(1000)
    If $shutd == 9 Then
        Sleep(1000)
        If $shutm == 1 Then
            Shutdown(9, "Shutdown and Power off")
        Else
            $shutd = 0
        EndIf
    EndIf
WEnd

;UDF'S
; File Open, Input file, Drag & Drop
;================================================================================================================================================
Func explorer()
    If $aux == 0 Then
        If not FileExists($ruta_fold) Then $ruta_fold = $MiPC
        $ruta_file_aux = FileOpenDialog("Select File", $ruta_fold, "type 0 for folder (*.*)", 2)
        If $ruta_file_aux <> "" Then
            $ruta_file = $ruta_file_aux
            new_file()
        EndIf
    Else
        MsgBox(4096, "Not allowed", "Wait until the job end or Cancel it.", 10)
    EndIf
EndFunc

Func funcion_drag_drop()
    If $aux == 0 Then
        $ruta_file = @GUI_DragFile
;        $ruta_file = StringTrimRight($ruta_file, 2)   ; Bug corregido en version 3.3.10
        If StringInStr(FileGetAttrib($ruta_file), "D") Then $ruta_file = $ruta_file & "\0"
        new_file()
    Else
        MsgBox(4096, "Not allowed", "Wait until the job end or Cancel it.", 10)
    EndIf
EndFunc

Func new_file()
    $bits = 24
    $pa = StringSplit($ruta_file, "\")
    $filename = $pa[$pa[0]]
    $ruta_fold = StringTrimRight($ruta_file, StringLen($filename) + 1)
    If StringRight($ruta_file, 2) == "\0" Then $ruta_file = $ruta_fold & "\"
    $pa = StringSplit($filename, ".")
    $extension = StringLower($pa[$pa[0]])
    $sources = ""
    GUICtrlSetData($cuadro_add, $sources)
    ;
    save_ini()
    GUICtrlSetData($cuadro_abrir, $ruta_file)
    $feat = ""
    $mode = "file"
    funcion_run("","")
EndFunc

; Other Menu functions
;================================================================================================================================================
Func cerrar_ppal()
    Exit
EndFunc

Func explorer_eac() ;
    $tcod = 6
    If FileExists($eac3to) Then $tcod = MsgBox(260, "Path to eac3to", "The file already exist:" & @CRLF & $eac3to & @CRLF & "Do you want change?")
    If $tcod == 6 Then
        $ruta_file_aux = FileOpenDialog("Select File", $MiPC, "soft needed (eac3to.exe)", 1+2, "eac3to.exe")
        If $ruta_file_aux <> "" Then
            $eac3to = $ruta_file_aux
            save_ini()
        EndIf
    Endif
EndFunc

Func explorer_mkv()
    $tcod = 6
    If FileExists($MkvMerge) Then $tcod = MsgBox(260, "Path to MkvMerge", "The file already exist:" & @CRLF & $MkvMerge & @CRLF & "Do you want change?")
    If $tcod == 6 Then
        $ruta_file_aux = FileOpenDialog("Select File", $MiPC, "soft optional (mkvmerge.exe)", 1+2, "mkvmerge.exe")
        If $ruta_file_aux <> "" Then
            $MkvMerge = $ruta_file_aux
            save_ini()
        EndIf
    Endif
EndFunc

Func explorer_tsm()
    $tcod = 6
    If FileExists($TsMuxer) Then $tcod = MsgBox(260, "Path to TsMuxer", "The file already exist:" & @CRLF & $TsMuxer & @CRLF & "Do you want change?")
    If $tcod == 6 Then
        $ruta_file_aux = FileOpenDialog("Select File", $MiPC, "soft optional (tsMuxer.exe)", 1+2, "tsMuxer.exe")
        If $ruta_file_aux <> "" Then
            $TsMuxer = $ruta_file_aux
            save_ini()
        EndIf
    Endif
EndFunc

Func explorer_enc()
    $tcod = 6
    If FileExists($ruta_enco) Then $tcod = MsgBox(260, "Encoders Folder", "The folder is now:" & @CRLF & $ruta_enco & @CRLF & "Do you want change?")
    If $tcod == 6 Then
        $ruta_log_aux = FileSelectFolder ("Select Folder", $MiPC, 1)
        If $ruta_log_aux <> "" Then
            $ruta_enco = $ruta_log_aux
            save_ini()
        EndIf
    Endif
EndFunc

Func explorer_out()
    $tcod = 6
    If FileExists($ruta_out) Then $tcod = MsgBox(260, "Output Folder", "The folder is now:" & @CRLF & $ruta_out & @CRLF & "Do you want change?")
    If $tcod == 6 Then
        $ruta_log_aux = FileSelectFolder ("Select Folder", $MiPC, 1)
        If $ruta_log_aux == "" Then $ruta_log_aux = @ScriptDir
        $ruta_out = $ruta_log_aux
        save_ini()
        If $ruta_out <> @ScriptDir Then GUICtrlSetState($user_def, $GUI_CHECKED)
    EndIf
EndFunc

Func funcion_shu_1()
    GUICtrlSetState($subsubmenu_shu_1, $GUI_CHECKED)
    GUICtrlSetState($subsubmenu_shu_2, $GUI_UNCHECKED)
    $shutm = 0
EndFunc

Func funcion_shu_2()
    GUICtrlSetState($subsubmenu_shu_1, $GUI_UNCHECKED)
    GUICtrlSetState($subsubmenu_shu_2, $GUI_CHECKED)
    $shutm = 1
EndFunc

Func save_ini()
    $ini_handle = FileOpen ( $ruta_ini, 514 )
    FileWriteLine($ini_handle, $eac3to)
    FileWriteLine($ini_handle, $ruta_fold)
    FileWriteLine($ini_handle, $MkvMerge)
    FileWriteLine($ini_handle, $TsMuxer)
    FileWriteLine($ini_handle, $ruta_enco)
    FileWriteLine($ini_handle, $ruta_out)
    FileClose($ini_handle)
EndFunc

Func help()
    $log_handle = FileOpen ( $ruta_help, 512 )
    $tx = FileRead($log_handle)
    FileClose($log_handle)

    $gui_help = GUICreate("Eac3To Help", 680, 350, -1, -1, $WS_CAPTION+$WS_POPUP+$WS_SYSMENU, -1, $ppal)
    GUISetState(@SW_SHOW, $gui_help)
    GUISetOnEvent($GUI_EVENT_CLOSE, "cerrar_acerca")

    $cuadro_inf = GUICtrlCreateEdit ( "", 10, 10, 660, 330, $WS_VSCROLL + $ES_WANTRETURN)
    GUICtrlSetBkColor($cuadro_inf, 0xd5e1e9)
    GUICtrlSetFont ( $cuadro_inf, 9, 400, 0, "Fixedsys")
    GUICtrlSetData ( $cuadro_inf, $tx)
EndFunc

Func acerca()
    $gui_acerca = GUICreate("About UsEac3To", 200, 120, -1, -1, $WS_CAPTION+$WS_POPUP+$WS_SYSMENU, -1, $ppal)
    GUISetState (@SW_DISABLE, $ppal)
    GUISetState(@SW_SHOW, $gui_acerca)
    GUISetOnEvent($GUI_EVENT_CLOSE, "cerrar_acerca")
    GUICtrlCreateLabel ("UsEac3To by tebasuna51,", 40, 10)
    GUICtrlCreateLabel ("Another GUI for Eac3To, now building", 10, 25)
    GUICtrlCreateLabel ("the Command Line Parameters, and", 10, 40)
    GUICtrlCreateLabel ("samples to use with muxers (readme).", 10, 55)
    GUICtrlCreateLabel ("GUI thanks to susanalic.", 80, 105)
    $boton_ok = GUICtrlCreateButton ("&OK", 70, 76, 60, 20)
    GUICtrlSetOnEvent ($boton_ok, "cerrar_acerca")
EndFunc

Func cerrar_acerca()
    GUIDelete()
    GUISetState(@SW_ENABLE, $ppal)
    GUISetState(@SW_RESTORE, $ppal)
EndFunc

; Upper buttons functions
;================================================================================================================================================
Func funcion_cancel() ; new function Show Log
    If $extension <> "" Then
        $log_handle = FileOpen ( $ruta_log, 512 )
        $tw = FileRead($log_handle)
        FileClose($log_handle)
        GUICtrlSetState ( $cuadro_info, $GUI_ENABLE)
        GUICtrlSetData ( $cuadro_info, $tw)
    EndIf
EndFunc

Func add_sources()
    If $extension <> "" Then
        $sources = ""
        $pa = StringSplit($filename, ".")
        $xex = StringLen($pa[$pa[0]])
        $par0 = StringTrimRight($ruta_file, $xex + 1)

        $xex = 1
        $par1 = $pa[$pa[0] - 1]
        For $i = 1 to StringLen($par1)
            If StringIsDigit(StringRight($par1, $i)) Then
                $xex = StringRight($par1, $i) + 1
            Else
                $i = StringLen($par1)
            EndIf
        next

        $par1 = StringTrimRight($par0, StringLen($xex)) & $xex & "." & $pa[$pa[0]]
        while FileExists($par1)
            $sources = $sources & "+" & chr(34) & $par1 & chr(34)
            $xex = $xex + 1
            $par1 = StringTrimRight($par0, StringLen($xex)) & $xex & "." & $pa[$pa[0]]
        wend
        GUICtrlSetData($cuadro_add, $sources)
        If $sources == "" then
            MsgBox(4096, "Not found", "Don't exist a file:" & @CRLF & $par1 , 10)
        Else
            $feat = ""
            $mode = "file"
            funcion_run("","")
        EndIf
    EndIf
EndFunc

Func save_log()
    If $tw <> "" Then
        $tw = GUICtrlRead ( $cuadro_info )
        $ruta_log_completa = $ruta_file & "_.log"
        If GUICtrlRead($user_def) == $GUI_CHECKED Then $ruta_log_completa = $ruta_out & "\" & $filename & "_.log"
        $log_handle = FileOpen ( $ruta_log_completa, 514 )
        FileWrite($log_handle, $tw)
        FileClose($log_handle)
        MsgBox(4096, "Save log", "File " & $ruta_log_completa & " saved.", 10)
    EndIf
EndFunc

; Middle buttons functions
;================================================================================================================================================
Func c1_run()
    If $aux == 0 Then
        $par0 = " -" & GUICtrlRead($c1)
        If $par0 == " -demux" Then
            If GUICtrlRead($user_def) == $GUI_CHECKED Then
                $par0 = " " & chr(34) & $ruta_out & "\" & $filename & "_.*" & chr(34)
            Else
                $par0 = " " & chr(34) & $ruta_file & "_.*" & chr(34)
            EndIf
        EndIf
        $mode = "glob"
        funcion_run($par0, "")
    Else
        MsgBox(4096, "Not allowed", "Wait until the job end or Cancel it.", 10)
    EndIf
EndFunc

Func t1_add() ; Select valid Output format for Track Input
    $in_track = GUICtrlRead($t1)
    If $in_track = "" Then
        GUICtrlSetData($t2, "|A.Tools", "A.Tools")
    Else
        $pos = StringInStr($in_track, ":")
        If $pos > 0 and $pos < 6 Then
            $in_track = StringMid($in_track, $pos + 2, 3)
        Else
            $in_track = StringLeft($in_track, 3)
        Endif
        Switch $in_track
            Case "M2V"
                GUICtrlSetData($t2, "|mkv|m2v", "mkv")
            Case "h26"
                GUICtrlSetData($t2, "|mkv|h264", "mkv")
            Case "VC-"
                GUICtrlSetData($t2, "|mkv|vc1", "mkv")
            Case "AVI"
                GUICtrlSetData($t2, "|A.Tools", "A.Tools")
            Case "HEV"  ; new with troubles in v2.32
                GUICtrlSetData($t2, "|h265", "h265")
            Case "Cha"
                GUICtrlSetData($t2, "|txt", "txt")
            Case "SUP"  ; with troubles in mkv
                GUICtrlSetData($t2, "|sup", "sup")
            Case "SRT"
                GUICtrlSetData($t2, "|srt", "srt")
            Case "ASS"
                GUICtrlSetData($t2, "|ass", "ass")
            Case "SSA"
                GUICtrlSetData($t2, "|ssa", "ssa")
            Case "SUB"
                GUICtrlSetData($t2, "|A.Tools", "A.Tools")
            Case "DVB"
                GUICtrlSetData($t2, "|A.Tools", "A.Tools")
            Case "AAC"
                GUICtrlSetData($t2, "|aac|ac3|flac|wav|wavs|pcm|w64|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "aac")
            Case "AC3"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3")
            Case "FLA"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3-ffm")
            Case "MLP"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3-ffm")
            Case "MP1"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "qaa-ext")
            Case "RAW"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3-ffm")
            Case "RF6"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3-ffm")
            Case "W64"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3-ffm")
            Case "WAV"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3-ffm")
            Case "MP2"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|mp2|m4a|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "qaa-ext")
            Case "MP3"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|mp3|m4a|dts|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "qaa-ext")
            Case "DTS"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|dtshd|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "dts")
            Case "E-A"    ; eac3 in m2ts may work or not
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|eac3|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3-ffm")
            Case "EAC"    ; eac3 in mkv only extract
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|eac3|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "eac3")
            Case "Tru"
                GUICtrlSetData($t2, "|ac3|flac|wav|wavs|pcm|w64|m4a|dts|thd|thd+ac3|mp3-ext|mp2-ext|ogg-ext|ac3-ffm|m4a-ext|qaa-ext|fgh-ext|dca-ext|opusext|pcm-tsm", "ac3")
            Case "OGG"
                GUICtrlSetData($t2, "|A.Tools", "A.Tools")
            Case Else
                GUICtrlSetData($t2, "|A.Tools", "A.Tools")
        EndSwitch
    Endif
EndFunc

Func t2_add()
    $par0 = GUICtrlRead($param_info)
    $out_ext = GUICtrlRead($t2)
    If $out_ext <> "A.Tools" and $extension <> "" and StringInStr($par0, "|") == 0 Then
        If $track_max <> "" Then
            $par0 = $par0 & " " & StringTrimRight(GUICtrlRead($t1), 5)
        EndIf
        $track = StringTrimRight(GUICtrlRead($t1), 6)
        $lgx = ""
        If $track <> "" Then
            $lgx = "eng"
            $pos = StringInStr($tw, $track & ": ")
            $poc = StringInStr($tw, @CRLF, 2, 1, $pos)
            $pos = StringInStr($tw, ",", 2, 1, $pos)
            If $pos > 0 and $pos < $poc Then $lgx = StringLower(StringMid($tw, $pos + 2, 3))
            If StringIsLower($lgx) = 0 Then $lgx = "eng"
        EndIf
;        $track = " %_" & $lgx & $track & "."
        $track = " %_" & $track & $lgx & "."

        Switch $out_ext
            Case "m4a"
                $encoder = $ruta_eac & "NeroAacEnc.exe"
                If FileExists($encoder) Then
                    $par0 = $par0 & $track & $out_ext
                Else
                    MsgBox(4096, "NeroAacEnc", "Don't found: " & $encoder, 20)
                EndIf
            Case "m4a-ext"
                $encoder = Search_enc("NeroAacEnc", 1)
                If $encoder <> "" Then
                    $par0 = $par0 & " stdout.wav | NeroAacEnc -q 0.45 -ignorelength -if - -of" & $track & "m4a"
                EndIf
            Case "qaa-ext"
                $encoder = Search_enc("qaac", 1)
                If $encoder <> "" Then
                    $par0 = $par0 & " stdout.wav | qaac -V 99 --ignorelength --adts --no-delay -o" & $track & "aac -"
                EndIf
            Case "fgh-ext"
                $encoder = Search_enc("fhgaacenc", 1)
                If $encoder <> "" Then
                    $par0 = $par0 & " stdout.wav | fhgaacenc --vbr 5 --ignorelength -" & $track & "m4a"
                EndIf
            Case "dca-ext"
                $encoder = Search_enc("ffdcaenc", 1)
                If $encoder <> "" Then
                    $par0 = $par0 & " stdout.wav | ffdcaenc -i - -o" & $track & "dts -l -b 1509.75"
                EndIf
;           Case "ac3-ext"
;               $encoder = Search_enc("Aften", 1)
;               If $encoder <> "" Then
;                   $par0 = $par0 & " stdout.wav | Aften -b 640 -pad 0 -readtoeof 1 -exps 32 -s 1 -" & $track & "ac3"
;               EndIf
            Case "ac3-ffm"
                $encoder = Search_enc("ffmpeg", 1)
                If $encoder <> "" Then
                    $par0 = $par0 & " stdout.w64 | ffmpeg -i - -c:a ac3 -b:a 640k -center_mixlev 0.707" & $track & "ac3"
                EndIf
            Case "mp3-ext"
                $encoder = Search_enc("Lame", 1)
                If $encoder <> "" Then
                    $par0 = $par0 & " stdout.wav | Lame -b 128 -" & $track & "mp3"
                EndIf
            Case "mp2-ext"
                $encoder = Search_enc("ffmpeg", 1)
                If $encoder <> "" Then
                    $par0 = $par0 & " stdout.w64 | ffmpeg -i - -c:a mp2 -b:a 192k" & $track & "mp2"
                EndIf
            Case "ogg-ext"
                $encoder = Search_enc("OggEnc2", 1)
                If $encoder <> "" Then
                    $par0 = $par0 & " stdout.wav | OggEnc2 -q 3 --ignorelength -o" & $track & "ogg -"
                EndIf
            Case "opusext"
                $encoder = Search_enc("opusenc", 1)
                If $encoder <> "" Then
                    $par0 = $par0 & " stdout.wav | opusenc --ignorelength --bitrate 128 -" & $track & "opus"
                EndIf
            Case "pcm-tsm"
                $encoder = Search_enc("Pcm2Tsmu", 1)
                If $encoder <> "" Then
                    $par0 = $par0 & " stdout.pcm | Pcm2Tsmu -" & $track & "pcm -i 24 -c 6 -s 48000"
                EndIf
            Case Else
                $par0 = $par0 & $track & $out_ext
        EndSwitch
        GUICtrlSetData ( $param_info, $par0)
    EndIf
EndFunc

Func t3_add()
    If $extension <> "" Then
        $par0 = GUICtrlRead($param_info)
        If StringInStr($par0, "|") Then
            $pos = StringInStr($par0, "|")
            $par0 = StringLeft($par0, $pos - 1) & "-" & GUICtrlRead($t3) & StringMid($par0, $pos - 1)
        Else
            $par0 = $par0 & " -" & GUICtrlRead($t3)
        EndIf
        GUICtrlSetData($param_info, $par0)
    EndIf
EndFunc

Func t4_add()
    If $extension <> "" Then
        $par0 = GUICtrlRead($param_info)
        If StringInStr($par0, "|") Then
            $pos = StringInStr($par0, "|")
            $par0 = StringLeft($par0, $pos - 1) & "-" & GUICtrlRead($t4) & StringMid($par0, $pos - 1)
        Else
            $par0 = $par0 & " -" & GUICtrlRead($t4)
        EndIf
        GUICtrlSetData ( $param_info, $par0)
    EndIf
EndFunc

Func Search_enc($enco, $men)
    $encod = @ScriptDir & "\" & $enco & ".exe"
    If not FileExists($encod) Then
        $encod = $ruta_enco & "\" & $enco & ".exe"
        If not FileExists($encod) Then
            $encod = $ruta_eac & $enco & ".exe"
            If not FileExists($encod) Then
                $encod = ""
                If $men Then MsgBox(4096, $enco, "Don't found " & $enco & ".exe", 10)
            EndIf
         EndIf
    EndIf
    Return $encod
EndFunc

; aux to control the log
;================================================================================================================================================
Func parse_track()
    $track_max = ""
    $solo_aud = ""
    $now = 0
    $log_handle = FileOpen ( $ruta_log, 512 )
    $bits = 24
    While 1
        $line = FileReadLine($log_handle)
        If @error = -1 Then ExitLoop
        If StringLeft($line, 9) == "---------" Then $now = 1
        If $now Then
            $pos = StringInStr($line, ":")
            If $pos > 0 and $pos < 6 Then
                $track = StringMid($line, $pos + 2, 4)
                If StringInStr($line, "MPEG4/ISO/ASP") Then $track = "AVI "
                If StringInStr($line, "HEVC") Then $track = "HEVC"
                If $track == "MPEG" Then $track = "M2V "
                If $track == "MS/V" Then $track = "AVI "
                If $track == "VORB" Then $track = "OGG "
                If $track == "Subt" Then $track = StringMid($line, $pos + 12, 3) & " "
                If $track == "PGS " Then $track = "SUP "
                If $track == "DVD " Then $track = "SUP " ; work with .evo, not with .ts or .vob
                If $track == "Vob " Then $track = "SUB "
                $track_max = $track_max & "|" & StringLeft($line, $pos + 1) & $track
            ElseIf StringInStr("AAC|AC3|DTS|E-A|FLA|MLP|MP1|MP2|MP3|RAW|RF6|Tru|W64|WAV|VC-|h26|MPE|", StringLeft($line, 3)) Then
                $solo_aud = StringLeft($line, 6)
                If StringInStr($line, " 16 bits") Then $bits = 16
            EndIf
        EndIf
    Wend
    FileClose($log_handle)
    If $track_max == "" Then
        GUICtrlSetData($t1, "|" & $solo_aud, $solo_aud)
    Else
        GUICtrlSetData($t1, $track_max, StringMid($track_max, 2, 7))
    EndIf
    t1_add()
EndFunc

Func parse_feat()
    $log_handle = FileOpen ( $ruta_log, 512 )
    While 1
        $line = FileReadLine($log_handle)
        If @error = -1 Then ExitLoop
        If StringInStr($line, ".mpls") Then $feat = StringLeft($line, StringInStr($line, ")") - 1)
    Wend
    FileClose($log_handle)
    If $feat <> "" Then
;        If $feat <> "1" Then
           $feat = InputBox("Select feature", "You must select the feature between 1 and " & $feat, "1", " M3")
           If @error = -1 Then $feat = "1"
           If $feat = "" Then $feat = "1"
;        EndIf
        $feat = " " & $feat & ")"
        funcion_run("","")
    EndIf
EndFunc

; Bottom buttons
;================================================================================================================================================
Func Clear_Param()
    GUICtrlSetData ( $param_info, "")
EndFunc

Func Global_run()
    If $aux == 0 Then
        parse_cmd()
        funcion_run($par0, $par1)
        $shutd = 9
    EndIf
EndFunc

Func funcion_run($pp0, $pp1)
    If ($extension <> "" or $pp0 = " -test") and $pp0 <> "No" Then
        $aux = 1
        $PID = 0
        If ($extension == "mpls") Then $feat = " 1)"
        $sources = GUICtrlRead($cuadro_add)
        $param = chr(34) & $eac3to & chr(34) & " " & chr(34) & $ruta_file & chr(34) & $sources & $feat & $pp0 & " -progressnumbers" & " -log=" & chr(34) & $ruta_log & chr(34) & $pp1
        If $pp0 = " -test" Then $param = chr(34) & $eac3to & chr(34) & " " & $pp0 & " -progressnumbers" & " -log=" & chr(34) & $ruta_log & chr(34)
        Param_page()

        $ruta_cmd = @ScriptDir & "\UsEac3To.cmd"
        $cmd_handle = FileOpen ($ruta_cmd , 514 )
        FileWriteLine($cmd_handle, $param)
        FileClose($cmd_handle)
        GUICtrlSetData($cuadro_info, $param & @CRLF & "Processing Info... Please wait or Ctrl+C over CMD window." & @CRLF)
        ShellExecute($ruta_cmd)

        While $aux == 1
            If ProcessExists ( "eac3to.exe") Then
                $PID = ProcessExists ( "eac3to.exe" )
                $decorar = GUICtrlRead($cuadro_info) & "."
                GUICtrlSetData ( $cuadro_info, $decorar)
                Sleep(1000)
            ElseIf $PID <> 0 Then
                $aux = 0
                $log_handle = FileOpen ( $ruta_log, 512 )
                $tw = FileRead($log_handle)
                FileClose($log_handle)
                GUICtrlSetState ( $cuadro_info, $GUI_ENABLE)
                GUICtrlSetData ( $cuadro_info, $tw)
                $decorar = ""
                If $mode == "file" Then
                    If StringRight($ruta_file, 1) == "\" and $feat == "" Then
                        parse_feat()
                    Else
                        parse_track()
                    EndIf
                EndIf
            EndIf
        WEnd
    EndIf
EndFunc

Func Enqueue()
    If $aux == 0 Then
        parse_cmd()
        If $extension <> "" and $par0 <> "" and $par0 <> "No" Then
            $search = FileFindFirstFile(@ScriptDir & "\zzJob_?.cmd")
            If $search = -1 Then
                $last = "0"
            Else
                While 1
                    $file = FileFindNextFile($search)
                    If @error Then ExitLoop
                    $last = StringMid($file, 7, 1)
                WEnd
            EndIf
            FileClose($search)
            $last = chr(asc($last) + 1)
            If $last = ":" Then $last = "A"
            If $last > "Z" Then
                MsgBox(4096, "QUEUE", "Queue Full." & @CRLF & "Please empty your Queue before.", 5)
                Return
            EndIf
            $ruta_cmd = @ScriptDir & "\zzJob_" & $last & ".cmd"

            If ($extension == "mpls") Then $feat = " 1)"
            $sources = GUICtrlRead($cuadro_add)
            $param = chr(34) & $eac3to & chr(34) & " " & chr(34) & $ruta_file & chr(34) & $sources & $feat & $par0 & " -progressnumbers" & " -log=" & chr(34) & $ruta_filo & "_Job_"  & $last  & ".log" & chr(34) & $par1
            Param_page()

            $cmd_handle = FileOpen ($ruta_cmd , 514 )
            FileWriteLine($cmd_handle, $param)
            FileClose($cmd_handle)
            ;$feat = ""
            MsgBox(4096, "QUEUE", "Job zzJob_" & $last & ".cmd created.", 5)
        Else                                                            ; Show Queue
            $search = FileFindFirstFile(@ScriptDir & "\zzJob_?.cmd")
            If $search = -1 Then
                MsgBox(4096, "QUEUE", "Queue empty.", 5)
            Else
                $decorar = "Pending Jobs in Queue:"
                While 1
                    $file = FileFindNextFile($search)
                    If @error Then ExitLoop
                    $decorar = $decorar & @CRLF & $file
                WEnd
                MsgBox(4096, "QUEUE", $decorar, 99)
            EndIf
            FileClose($search)
        EndIf
    EndIf
EndFunc

Func Queue_run()
    If $aux == 0 Then
        $search = FileFindFirstFile(@ScriptDir & "\zzJob_?.cmd")
        If $search = -1 Then
            MsgBox(4096, "QUEUE", "Queue empty.", 5)
            FileClose($search)
        Else
            GUICtrlSetData($cuadro_info, "Processing Queue. Please wait." & @CRLF)
            While 1
                $file = FileFindNextFile($search)
                If @error Then ExitLoop
                $aux = 1
                $decorar = GUICtrlRead($cuadro_info) & $file & " ..." & @CRLF
                GUICtrlSetData ($cuadro_info, $decorar)
                ShellExecuteWait(@ScriptDir & "\" & $file)
;
                $log_handle = FileOpen (@ScriptDir & "\" & $file, 512)
                $line = FileReadLine($log_handle)
                FileClose($log_handle)
                FileDelete(@ScriptDir & "\" & $file)

            If StringInStr($line, "{ClEaN}") Then       ; Log need Clean
                $line = StringTrimRight ($line, 1)      ; Delete last "
                $pa = StringSplit($line, chr(34))
                $ruta_log2 = $pa[$pa[0]]
                $ruta_log3 = StringTrimRight($ruta_log2, 11) & ".log"

                $log_in = FileOpen ($ruta_log2, 512)
                $log_out = FileOpen ($ruta_log3, 514)
                $xvid = 0
                $frames = 0
                $bytes = 0
                While 1
                    $line = FileReadLine($log_in)
                    If @error = -1 Then ExitLoop
                    If StringLeft($line, 4) == "xvid" Then $xvid = 1
                    If $xvid Then
                     If StringLeft($line, 4) == "Tot:" Then $bytes = StringRight($line, 10)
                     If StringInStr($bytes, "=") Then $bytes = StringMid($bytes, StringInStr($bytes, "=") + 1)
                     If StringMid($line, 3, 7) == "frames:" Then $frames = $frames + StringMid($line, 10, 7)
                     FileWriteLine($log_out, $line)
                    Else
                        If StringLeft($line, 1) <> "[" Then FileWriteLine($log_out, $line)
                    EndIf
                Wend
                If $xvid and $frames Then
                    FileWriteLine($log_out, "")
                    $bytes = ($bytes/5)/$frames
                    $line = "Tot. frames: " & $frames & ", Average Kb/s (24/25/30 fps): " & round(($bytes*24)/25) & "/" & round($bytes) & "/" & round(($bytes*6)/5)
                    FileWriteLine($log_out, $line)
                EndIf
                FileClose($log_in)
                FileClose($log_out)
                FileDelete($ruta_log2)
            EndIf
;
            WEnd
            $decorar = GUICtrlRead($cuadro_info) & "Done." & @CRLF
            GUICtrlSetData ($cuadro_info, $decorar)
            FileClose($search)
            $aux = 0
            $shutd = 9
        EndIf
    EndIf
EndFunc

Func Param_page()     ; Workaround to change ANSI char to OEM ASCII in .cmd files
    For $i = 1 to StringLen($param)
        $n = asc(StringMid($param, $i, 1))
;       If $n > 160 Then $param = StringLeft($param, $i - 1) & StringMid("≠Ωúœæ˛ı˘∏¶Æ™©Ó¯Ò˝¸ÔÊÙ˙˜˚ßØ¨´Û®∑µ∂«éèíÄ‘ê“”ﬁ÷◊ÿ—•„‡‚ÂôûùÎÈÍöÌË·Ö†É∆ÑÜëáäÇàâç°åã–§ï¢ì‰îˆõó£ñÅÏÁò", $n - 160, 1) & StringMid($param, $i + 1)
        If $n > 160 Then $param = StringLeft($param, $i - 1) & StringMid("≠Ωúœæ›ı˘∏¶Æ™©Ó¯Ò˝¸ÔÊÙ˙˜˚ßØ¨´Û®∑µ∂«éèíÄ‘ê“”ﬁ÷◊ÿ—•„‡‚ÂôûùÎÈÍöÌË·Ö†É∆ÑÜëáäÇàâç°åã–§ï¢ì‰îˆõó£ñÅÏÁò", $n - 160, 1) & StringMid($param, $i + 1)
    next
EndFunc

Func parse_cmd()   ; Replace % with $ruta_file and | $encoder returning $par0 (before |) and $par1 (| and after)
    $par1 = ""
    $par0 = GUICtrlRead($param_info)
    If $par0 <> "" Then
        $ruta_filo = $ruta_file
        If GUICtrlRead($user_def) == $GUI_CHECKED Then $ruta_filo = $ruta_out & "\" & $filename
        If StringLeft($par0, 1) <> " " Then $par0 = " " & $par0
        $pa = StringSplit($par0, "%")   ; % filename
        $par0 = $pa[1]
        $mode = "file"
        For $i = 2 to $pa[0]
            $mode = "comm"
            $par1 = $pa[$i]
            $pos = StringInStr($par1, " ")
            If $pos == 0 Then
               $par0 = $par0 & chr(34) & $ruta_filo & $par1 & chr(34)
            Else
               $par0 = $par0 & chr(34) & $ruta_filo & StringLeft($par1, $pos - 1) & chr(34) & StringMid($par1, $pos)
            EndIf
        Next
        $par1 = ""
        If StringInStr($par0, "|") Then                    ; | External encoders
            $pos = StringInStr($par0, "|")
            $par1 = StringMid($par0, $pos + 2)
            $par0 = StringLeft($par0, $pos - 1)            ; before log
            $pos = StringInStr($par1, " ")
            $encoder = Search_enc(StringLeft($par1, $pos - 1), 1)
            If $encoder = "" Then $par0 = ""               ; error
            $par2 = StringMid($par1, $pos)
            $par1 = " | " & chr(34) & $encoder & chr(34)   ; after log
            while StringInStr($par2, "|")                  ; more than one pipe (sox for instance)
                $pos = StringInStr($par2, "|")
                $par1 = $par1 & StringLeft($par2, $pos - 1)
                $par2 = StringMid($par2, $pos + 2)
                $pos = StringInStr($par2, " ")
                $encoder = Search_enc(StringLeft($par2, $pos - 1), 1)
                If $encoder = "" Then $par0 = "No"         ; error
                $par1 = $par1 & " | " & chr(34) & $encoder & chr(34)
                $par2 = StringMid($par2, $pos)
            wend
            $par1 = $par1 & $par2
        EndIf
    EndIf
EndFunc

; Mix eac3to and Muxer   (Auxiliary Tools with Run)
;===================================================================================================================================== Button:
;===================================================================================================================================== Run and MkvMux
Func run_MkvMux()
    If $aux == 0 Then
        parse_cmdAV()
        If $audio1 <> "" and $video <> "" Then
            $tcod = MsgBox(260, "Use Queue", "Do you want send the jobs to Queue" & @CRLF &  "instead Run inmediatly?")
            If $tcod == 6 Then Enqueue()
            If $tcod <> 6 Then Global_run()
            $param = chr(34) & $MkvMerge & chr(34) & " -o " & chr(34) & $ruta_filo & "_m.mkv" & chr(34) & " --compression -1:none -A -S " & chr(34) & $video & chr(34)
;            $track = 0
;            If StringRight($audio1, 3) == "m4a" Then $track = 1
            If StringRight($audio1, 7) == "thd+ac3" Then
                If $lg1 <> "" Then $lg1 = " --language -1:" & $lg1
                $param = $param & $lg1 & " --compression -1:none -a 0,1 " & chr(34) & $audio1 & chr(34)
            Else
                If $lg1 <> "" Then $lg1 = " --language 0:" & $lg1
                $param = $param & $lg1 & " --compression 0:none -a 0 " & chr(34) & $audio1 & chr(34)
            Endif

            If $audio2 <> "" Then
;                $track = 0
;                If StringRight($audio2, 3) == "m4a" Then $track = 1
                If StringRight($audio2, 7) == "thd+ac3" Then
                    If $lg2 <> "" Then $lg2 = " --language -1:" & $lg2
                    $param = $param & $lg2 & " --compression -1:none -a 0,1 " & chr(34) & $audio2 & chr(34)
                Else
                    If $lg2 <> "" Then $lg2 = " --language 0:" & $lg2
                    $param = $param & $lg2 & " --compression 0:none -a 0 " & chr(34) & $audio2 & chr(34)
                EndIf
            EndIf
            $param = $param & " -D -A -M -B -T --no-chapters --no-global-tags " & chr(34) & $video & chr(34)   ; only subtitles
            If $tcod == 6 Then funcion_run2($param, 1)
            If $tcod <> 6 Then funcion_run2($param, 3)
        EndIf
    EndIf
EndFunc

;===================================================================================================================================== Button:
;===================================================================================================================================== Run and TsMux
Func run_TsMux()
    If $aux == 0 Then
        parse_cmdAV()
        If $audio1 <> "" and $video <> "" Then
            $tcod = MsgBox(259, "TsMuxer to m2ts", "Split the m2ts in 4GB fragments" & @CRLF & "to support FAT32 formatted devices?")
            If $tcod <> 2 Then
                $ruta_cmd = $video & "_.meta"
                $cmd_handle = FileOpen ($ruta_cmd, 514)
                If $tcod == 6 Then
                    FileWriteLine($cmd_handle, "MUXOPT --no-pcr-on-video-pid --new-audio-pes --vbr  --split-size=4GB --vbv-len=500")
                Else
                    FileWriteLine($cmd_handle, "MUXOPT --no-pcr-on-video-pid --new-audio-pes --vbr  --vbv-len=500")
                Endif
                ; Video
                $track = ", track=" & $track
                Switch  StringRight($video, 3)
                    Case "264"
                        $par0 = "V_MPEG4/ISO/AVC, "
                        $track = ""
                    Case "vc1"
                        $par0 = "V_MS/VFW/WVC1, "
                        $track = ""
                    Case "m2v"
                        $par0 = "V_MPEG-2, "
                        $track = ""
                EndSwitch
                $param = $par0 & chr(34) & $video & chr(34) & ", level=4.1, insertSEI, contSPS" & $track
                FileWriteLine($cmd_handle, $param)
                ; Audio
                If $lg1 <> "" Then $lg1 = ", lang=" & $lg1
                If $lg2 <> "" Then $lg2 = ", lang=" & $lg2
                $param = StringUpper(StringRight($audio1, 3))
                If $param == "WAV" or $param == "PCM" Then $param = "LPCM"
                $param = "A_" & $param & ", " & chr(34) & $audio1 & chr(34) & $lg1
                FileWriteLine($cmd_handle, $param)
                If $audio2 <> "" Then
                    $param = StringUpper(StringRight($audio2, 3))
                    If $param == "WAV" or $param == "PCM" Then $param = "LPCM"
                    $param = "A_" & $param & ", " & chr(34) & $audio2 & chr(34) & $lg2
                    FileWriteLine($cmd_handle, $param)
                EndIf
                FileClose($cmd_handle)
                ;
                parse_cmd()
                funcion_run($par0, $par1)
                $param = chr(34) & $TsMuxer & chr(34) & " " & chr(34) & $video & "_.meta" & chr(34) & " " & chr(34) & $video & "_t.m2ts" & chr(34)
                funcion_run2($param, 3)
            EndIf
        EndIf
    EndIf
EndFunc

Func funcion_run2($pp0, $pp1)
    $param = $pp0
    Switch  $pp1
        Case 0
            Param_page()
            $ruta_cmd = @ScriptDir & "\UsEac3T2.cmd"
            $cmd_handle = FileOpen ($ruta_cmd , 514 )
            FileWriteLine($cmd_handle, $param)
            FileClose($cmd_handle)
            ShellExecuteWait($ruta_cmd)
        Case 3
            Param_page()
            $ruta_cmd = @ScriptDir & "\UsEac3T2.cmd"
            $cmd_handle = FileOpen ($ruta_cmd , 514 )
            FileWriteLine($cmd_handle, $param)
            FileWriteLine($cmd_handle, "@echo off")
            FileWriteLine($cmd_handle, "echo End job.")
            FileWriteLine($cmd_handle, "Pause")
            FileClose($cmd_handle)
            ShellExecuteWait($ruta_cmd)
        Case Else
            $search = FileFindFirstFile(@ScriptDir & "\zzJob_?.cmd")
            If $search = -1 Then
                $last = "0"
            Else
                While 1
                    $file = FileFindNextFile($search)
                    If @error Then ExitLoop
                    $last = StringMid($file, 7, 1)
                WEnd
            EndIf
            FileClose($search)
            $last = chr(asc($last) + 1)
            If $last = ":" Then $last = "A"
            If $last > "Z" Then
                MsgBox(4096, "QUEUE", "Queue Full." & @CRLF & "Please empty your Queue before.", 5)
                Return
            EndIf
            $ruta_cmd = @ScriptDir & "\zzJob_" & $last & ".cmd"

            If $pp1 > 3 Then
                $last = $last & "{ClEaN}"
                $pp1 = $pp1 - 3
            EndIf
            $param = $param & " " & $pp1 & "> " & chr(34) & $ruta_filo & "_Job_"  & $last  & ".log" & chr(34)
            Param_page()

            $cmd_handle = FileOpen ($ruta_cmd , 514 )
            FileWriteLine($cmd_handle, $param)
            FileClose($cmd_handle)
            MsgBox(4096, "QUEUE", "Job created:" & @CRLF & $ruta_cmd, 5)
    EndSwitch
EndFunc

Func parse_cmdAV()   ; Search video and audio in command line
    $ruta_filo = $ruta_file
    If GUICtrlRead($user_def) == $GUI_CHECKED Then $ruta_filo = $ruta_out & "\" & $filename
    $video = ""
    $track = "0"
    $audio1 = ""
    $audio2 = ""
    ; search first video track in input container
    If $track_max <> "" Then
        $pa = StringSplit($track_max, "|")
        For $i = 1 to $pa[0]
            $par1 = $pa[$i]
            Switch  StringRight($par1, 4)
                Case "h264"
                    $video = $ruta_file
                    $par0 = "V_MPEG4/ISO/AVC, "
                    $track = StringTrimRight($par1, 6)
                    $i = $pa[0]
                Case "h265"
                    $video = $ruta_file
                    $par0 = "V_MPEGH/ISO/HEVC, "
                    $track = StringTrimRight($par1, 6)
                    $i = $pa[0]
                Case "VC-1"
                    $video = $ruta_file
                    $par0 = "V_MS/VFW/WVC1, "
                    $track = StringTrimRight($par1, 6)
                    $i = $pa[0]
                Case "M2V "
                    $video = $ruta_file
                    $par0 = "V_MPEG-2, "
                    $track = StringTrimRight($par1, 6)
                    $i = $pa[0]
            EndSwitch
        Next
    Endif
    ; Now search in command line
    $pa = StringSplit(GUICtrlRead($param_info), "%")   ; % filename
    For $i = 2 to $pa[0]
        $par1 = $pa[$i]
        If StringInStr($par1, " ") Then $par1 = StringLeft($par1, StringInStr($par1, " ") - 1)
        If StringInStr("mkv|h264|vc1|m2v|", StringRight($par1, 3)) Then
            $video = $ruta_filo & $par1
            $track = "0"
            If StringRight($par1, 3) == "mkv" Then $track = "1"
        Endif
        If StringInStr("ac3|m4a|flac|wav|dts|shd|thd|mp3|mp2|ogg|pcm|aac|w64|opus|", StringRight($par1, 3)) Then
            $lg2 = ""
            $pos = StringInStr($par1, ".") - 1       ; "_TrLng.ext"
            $lgx = StringLeft($par1, $pos)           ; "_TrLng"
            $pos = StringInStr($lgx, "_")
            $lgx = StringMid($lgx, $pos + 1)         ; "TrLng"
            If StringLen($lgx) > 2 Then
                $lgx = StringLower(StringRight($lgx, 3))  ; @@
            Else
                $lgx = $lgx & ": "                   ; "Tr: "
                $pos = StringInStr($tw, $lgx)        ; search in log
                $pos = StringInStr($tw, ",", 2, 1, $pos)
                $lgx = StringLower(StringMid($tw, $pos + 2, 3))
            EndIf
            If StringIsAlpha($lgx) Then
                If StringInStr("alb|ara|arm|aus|bel|ben|bos|bul|chi|cze|dan|egy|eng|est|fil|fre|geo|ger|mod|haw|heb|hin|hun|ice|ind|ira|ita|jap|kor|mac|mal|mao|mol|mon|nep|nor|phi|pol|por|rum|rus|ser|cro|som|spa|swa|swe|syr|tur|ukr|und|uzb|vie|zul|", $lgx) Then
                    $lg2 = $lgx
                    If $lgx == "jap" Then $lg2 = "jpn"
                    If $lgx == "rom" Then $lg2 = "rum"
                    If $lgx == "ser" Then $lg2 = "srp"
                    If $lgx == "cro" Then $lg2 = "scr"
                    If $lgx == "mod" Then $lg2 = "gre"
                Else
                    $lg2 = ""
                EndIf
            Else
                $lg2 = "eng"
            EndIf
            If $audio1 == "" Then
                $audio1 = $ruta_filo & $par1
                $lg1 = $lg2
            Else
                $audio2 = $ruta_filo & $par1
            EndIf
        EndIf
    Next
    If $audio1 == "" or $video == "" Then
        MsgBox(4096, "No video/audio", "At least 1 video and 1 audio must be selected: " & @CRLF & "Video: " & $video & @CRLF & "Audio: " & $audio1, 10)
    EndIf
EndFunc

; Not eac3to related   (Auxiliary Tools without Run)
;===================================================================================================================================== Button:
;===================================================================================================================================== MkvToolNix
Func MkvMerge_run()
    $param = ""
    If StringInStr("mkv|avi|h264|vc1|m2v", $extension) Then $param = chr(34) & $ruta_file & chr(34)
    If not FileExists($MkvMerge) Then explorer_mkv()
    $par0 = StringTrimRight($MkvMerge, 12) & "mkvtoolnix-gui.exe"
    If FileExists($par0) Then
       ShellExecute ( $par0, $param)
    Else
       $par0 = StringTrimRight($MkvMerge, 12) & "mmg.exe"
       If FileExists($par0) Then ShellExecute ( $par0, $param)
    Endif
EndFunc

;===================================================================================================================================== Button:
;===================================================================================================================================== TsMuxerGUI
Func TsMuxer_run()
    $param = ""
    If StringInStr("m2ts|ts|mkv", $extension) Then $param =  " " & chr(34) & $ruta_file & chr(34)
    If not FileExists($TsMuxer) Then explorer_tsm()
    $par0 = StringTrimRight($TsMuxer, 4) & "GUI.exe"
    If FileExists($par0) Then ShellExecute ( $par0, $param)
EndFunc

;===================================================================================================================================== Button:
;===================================================================================================================================== DelayCut
Func DelayCut_run()
    $encoder = Search_enc("DelayCut", 1)
    If $encoder <> "" Then
        $param = ""
        If StringInStr("ac3|eac3|dts|mp3|mp2|wav", $extension) Then $param = " " & chr(34) & $ruta_file & chr(34)
        $param = chr(34) & $encoder & chr(34) & $param
        $ruta_cmd = @ScriptDir & "\UsEac3To.cmd"
        $cmd_handle = FileOpen ($ruta_cmd , 514 )
        Param_page()
        FileWriteLine($cmd_handle, $param)
        FileClose($cmd_handle)
        ShellExecute ($ruta_cmd, "", "", "", @SW_HIDE)
    EndIf
EndFunc

;===================================================================================================================================== Button:
;===================================================================================================================================== MkvExtract/INF
Func ext_track()                     ; MKVEXTRACT
        ext_comm()
        funcion_run2($param, 3)
        $param = ""
EndFunc

Func ext_que1()
        ext_comm()
        funcion_run2($param, 1)
        $param = ""
EndFunc

Func ext_comm()
        If $param <> "" Then
            $param = chr(34) & StringTrimRight($MkvMerge, 9) & "extract.exe" & chr(34) & " " & chr(34) & $ruta_file & chr(34) & $param
        Else
            $audio1 = chr(34) & $ruta_filo & "_info.log" & chr(34)
            $param = chr(34) & $MkvMerge & chr(34) & " --engage keep_track_statistics_tags -F verbose-text -i " & chr(34) & $ruta_file & chr(34) & " > " & $audio1
        Endif
        $mkv_6 = ""
        GUICtrlSetData ( $mkv_5, "")
EndFunc

Func ext_add()
        $track = StringMid(GUICtrlRead($t9), 1, 2)                                 ; ' 1'..'99', 'al'
        $par0 = StringLower(StringMid(GUICtrlRead($t9), 5))                        ; 'h264','ac3','sup','att name.ext', 'att'

        If GUICtrlRead($mkv_1) == $GUI_CHECKED Then      ; Extract track
            $audio1 = ""
            If StringLeft($par0,3) == "att" Then
                $param = $param & " attachments "
                If $track == 'al' then
                    $pa = StringSplit($track_mkv, "|")   ; parse tracks
                    For $i = 1 to $pa[0] - 2
                        If StringInStr($pa[$i], "ATT") Then
                            $audio1 = $audio1 & " " & StringLeft($pa[$i],3) & chr(34) & $ruta_filo & "_" & StringMid($pa[$i], 9) & chr(34)
                        EndIf
                    Next
                    $mkv_6 = $mkv_6 & "A:att, "
                Else
                    $audio1 = " " & $track & ":" & chr(34) & $ruta_filo & "_" & $track & StringMid(GUICtrlRead($t9), 8) & chr(34)
                    $mkv_6 = $mkv_6 & $track & ":att, "
                Endif
                $param = $param & $audio1
            Else
                $param = $param & " tracks "
                If $track == 'al' then
                    $pa = StringSplit($track_mkv, "|")   ; parse tracks
                    For $i = 1 to $pa[0] - 2
                        If StringInStr($pa[$i], "SUP") Then
                            $audio1 = $audio1 & " " & StringLeft($pa[$i],3) & chr(34) & $ruta_filo & "_" & StringLeft($pa[$i],2) & ".sup" & chr(34)
                        EndIf
                    Next
                    $mkv_6 = $mkv_6 & "A:sup, "
                Else
                    $audio1 = " " & $track & ":" & chr(34) & $ruta_filo & "_" & $track & "." & $par0 & chr(34)
                    $mkv_6 = $mkv_6 & $track & ":" & $par0 & ", "
                Endif
                $param = $param & $audio1
            Endif
        Elseif GUICtrlRead($mkv_2) == $GUI_CHECKED Then  ; Extract timestamps ;@m17
            $param = $param & " timestamps_v2 " & $track & ":" & chr(34) & $ruta_filo & "_" & $track & ".txt" & chr(34)
            $mkv_6 = $mkv_6 & $track & ":" & "txt, "
        Elseif GUICtrlRead($mkv_3) == $GUI_CHECKED Then  ; $param = $param & " chapters " & " -s --redirect-output " & $audio1
            $param = $param & " chapters " & "-s " & chr(34) & $ruta_filo & "_cOGM.txt" & chr(34)
            $mkv_6 = $mkv_6 & "C_OGM, "
        Elseif GUICtrlRead($mkv_4) == $GUI_CHECKED Then
            $param = $param & " chapters " & chr(34) & $ruta_filo & "_cXML.xml" & chr(34)
            $mkv_6 = $mkv_6 & "C_XML, "
;        Elseif GUICtrlRead($mkv_5) == $GUI_CHECKED Then
;                $audio1 = chr(34) & $ruta_filo & "_none.mkv" & chr(34)
;                $param = chr(34) & $MkvMerge & chr(34) & " -o " & $audio1 & " --compression -1:none " & chr(34) & $ruta_file & chr(34)
;       Elseif GUICtrlRead($mkv_5) == $GUI_CHECKED Then
;               $audio1 = chr(34) & $ruta_filo & "_info.log" & chr(34)
;               $param = chr(34) & $MkvMerge & chr(34) & " --engage keep_track_statistics_tags -F verbose-text -i " & chr(34) & $ruta_file & chr(34) & " > " & $audio1
        Endif
        GUICtrlSetData ( $mkv_5, $mkv_6)
EndFunc
                              ;   `mkvextract input.mkv tracks 0:video.h265 1:audio.aac chapters chapters.xml tags tags.xml`

Func mkv_gui()
    If $extension == "mkv" or $extension == "mka" Then          ; MkvExtractGUI
        $ruta_log2 = @ScriptDir & "\UsEac3T2.log"
        $param = chr(34) & $MkvMerge & chr(34) & " -i --ui-language en " & chr(34) & $ruta_file & chr(34) & " > " & chr(34) & $ruta_log2 & chr(34)
        funcion_run2($param, 0)
        $track_mkv = ""
        $first = ""
        $log_handle = FileOpen ( $ruta_log2, 512 )
        $tw = FileRead($log_handle)
        FileClose($log_handle)
        GUICtrlSetState ( $cuadro_info, $GUI_ENABLE)
        GUICtrlSetData ( $cuadro_info, $tw)

        $ruta_filo = $ruta_file
        If GUICtrlRead($user_def) == $GUI_CHECKED Then $ruta_filo = $ruta_out & "\" & $filename
        $param = ""
        $mkv_6 = ""

        $log_handle = FileOpen ( $ruta_log2, 512 )
        $line = FileReadLine($log_handle)
        While 1
            $line = FileReadLine($log_handle)
            If @error = -1 Then ExitLoop
            $pos = StringInStr($line, ")")
            If $pos > 0 Then
                $track = "MKV" ; default for unknow
                If StringInStr($line, " video ") Then   ; MkvToolNix v17
                    If StringInStr($line, "MPEG-1/2") Then $track = "MPG"
                    If StringInStr($line, "MPEG-4p2") Then $track = "AVI"
                    If StringInStr($line, "AVC") Then $track = "H264"
                    If StringInStr($line, "HEVC") Then $track = "H265"
                    If StringInStr($line, "VC-1") Then $track = "VC1"
                    If StringInStr($line, "RealVideo") Then $track = "RV"  ; def at least for ACDV, FLV1, WMV3, ProRes, VP9
                ElseIf StringInStr($line, " audio ") Then
                    $track = "MKA" ; def at least forA_MS/ACM, G2/Cook
                    If StringInStr($line, "AAC") Then $track = "AAC"
                    If StringInStr($line, "AC-3") Then $track = "AC3"
                    If StringInStr($line, "ALAC") Then $track = "ALAC"
                    If StringInStr($line, "DTS") Then $track = "DTS"
                    If StringInStr($line, "E-AC-3") Then $track = "EAC3"
                    If StringInStr($line, "FLAC") Then $track = "FLAC"
                    If StringInStr($line, "MP2") Then $track = "MP2"
                    If StringInStr($line, "MP3") Then $track = "MP3"
                    If StringInStr($line, "Opus") Then $track = "OPUS"
                    If StringInStr($line, "PCM") Then $track = "WAV"
                    If StringInStr($line, "TrueAudio") Then $track = "TTA"
                    If StringInStr($line, "TrueHD") Then $track = "THD"
                    If StringInStr($line, "Vorbis") Then $track = "OGG"
                    If StringInStr($line, "WavPack") Then $track = "WV" ;PK"
                ElseIf StringInStr($line, " subtitles") Then              ; def at least for DVBSUB
                    If StringInStr($line, "SRT") Then $track = "SRT"
                    If StringInStr($line, "Alpha") Then $track = "ASS"
                    If StringInStr($line, "PGS") Then $track = "SUP"
                    If StringInStr($line, "VobSub") Then $track = "SUB"
                    If StringInStr($line, "DVBSUB") Then $track = "SUP"
                EndIf

                $pos = StringInStr($line, ":")
                If $first == "" Then $first = StringMid($line, $pos - 2, 3) & " " & $track
                $track_mkv = $track_mkv & StringMid($line, $pos - 2, 3) & " " & $track & "|"
            Else
                If StringInStr($line, "Attachment") Then
                    $pos = StringInStr($line, "name")
                    $track = "ATT " & StringMid($line, $pos + 6, StringLen($line) - $pos - 6 )
                    $pos = StringInStr($line, ":")
                    $track_mkv = $track_mkv & StringMid($line, $pos - 2, 3) & " " & $track & "|"
                EndIf
            EndIf
        Wend
;        $track_mkv = StringTrimRight($track_mkv, 1)
        $track_mkv = $track_mkv & "all ATT|all SUP"
        FileClose($log_handle)
;
        $gui_mkv = GUICreate("MkvExtract/Inf", 310, 330, -1, -1, $WS_CAPTION+$WS_POPUP+$WS_SYSMENU, -1, $ppal)
        GUISetState (@SW_DISABLE, $ppal)
        GUISetState(@SW_SHOW, $gui_mkv)
        GUISetOnEvent($GUI_EVENT_CLOSE, "cerrar_acerca")

        GUICtrlCreateGroup("Select Option", 15, 15, 180, 135)
        $mkv_1 = GUICtrlCreateRadio("Extract selected Track ", 30,  30, 155, 25)
        $mkv_2 = GUICtrlCreateRadio("Extract Timestamps of Track", 30, 60, 155, 25) ;@m17
        $mkv_3 = GUICtrlCreateRadio("Extract Chapters OGM", 30, 90, 155, 25)
        $mkv_4 = GUICtrlCreateRadio("Extract Chapters XML", 30, 120, 155, 25)
;        $mkv_5 = GUICtrlCreateRadio("Extract Info (tags)", 30, 150, 155, 25)
;        $mkv_6 = GUICtrlCreateRadio("Remux without compression", 30, 180, 155, 25)
        GUICtrlCreateGroup("", -129, -129, 1, 1)  ;close group

        GUICtrlCreateLabel("Select Track:", 210, 20)
        $t9 = GUICtrlCreateCombo("", 210, 45, 90, 20) ; create first item
        GUICtrlSetData($t9, $track_mkv, $first)
        GUICtrlCreateLabel("Warning: eac3to track", 200, 70)
        GUICtrlCreateLabel("order can be different ", 200, 85)
        GUICtrlCreateLabel("than mkv order", 200, 100)
        $boton_add = GUICtrlCreateButton ("Add", 220, 125, 60, 20)
        GUICtrlSetOnEvent ($boton_add, "ext_add")

        GUICtrlCreateLabel("Now many tracks/timestamps/chapter can be extracted at", 15, 155)
        GUICtrlCreateLabel(" same job. Add the required before press Run/EnQueue.", 15, 170)
        GUICtrlCreateLabel("Left empty for Extract Info ( tags ):", 15, 185)
        $mkv_5 = GUICtrlCreateEdit ( "", 15, 205, 285, 80, $WS_VSCROLL + $ES_WANTRETURN)
        GUICtrlSetBkColor($mkv_5, 0xd5e1e9)
        GUICtrlSetFont ( $mkv_5, 9, 400, 0, "Fixedsys")
        GUICtrlSetData ( $mkv_5, "")

        GUICtrlSetState($mkv_1, $GUI_CHECKED)
        $boton_oks = GUICtrlCreateButton ("&Run", 85, 295, 60, 20)
        GUICtrlSetOnEvent ($boton_oks, "ext_track")
        $boton_queue = GUICtrlCreateButton ("&EnQueue", 165, 295, 80, 20)
        GUICtrlSetOnEvent ($boton_queue, "ext_que1")
    Else                                                                                         ; FFMPEG extract
        $encoder = Search_enc("ffmpeg", 1)   ; ffmpeg -report -i "INPUT FILE" 2>report.txt
        If $encoder <> "" Then
            $ruta_log2 = @ScriptDir & "\UsEac3T2.log"
            $param = chr(34) & $encoder & chr(34) & " -report -i " & chr(34) & $ruta_file & chr(34) & " 2> " & chr(34) & $ruta_log2 & chr(34)
            funcion_run2($param, 0)
            $track_mkv = ""
            $first = ""
            $log_handle = FileOpen ( $ruta_log2, 512 )
            $tw = $extension & " streams:" & @CRLF ; Stream #0:2: Audio: ac3 ([0] [0][0] / 0x2000), 48000 Hz, 5.1(side), fltp, 448 kb/s
            While 1
                $line = FileReadLine($log_handle)
                If @error = -1 Then ExitLoop
                $pos = StringInStr($line, "Stream #")
                If $pos Then
                    $line = StringMid($line, $pos + 10) ; 2: Audio: ac3 ([0] [0][0] / 0x2000), 48000 Hz, 5.1(side), fltp, 448 kb/
                    $pa = StringSplit($line, ":")
                    $par0 = $pa[2]
                    If $par0 == " Audio" or $par0 == " Video"or $par0 == " Subtitle" Then
                        $param = StringLower(StringMid($par0, 2, 1))
                        $x = Stringlen($pa[1]) + Stringlen($pa[2])
                        $par0 = $pa[1]
                        If StringInStr($par0, "[") Then $par0 = StringLeft($par0,  StringInStr($par0, "[") - 1) & StringMid($par0,  StringInStr($par0, "]") + 1)
                        $lin = $par0 & ": "
                        If StringInStr($par0, "(") Then $par0 = StringLeft($par0,  StringInStr($par0, "(") - 1) & StringMid($par0,  StringInStr($par0, ")") + 1)
                        $track_mkv = $track_mkv & $par0 & "-" & $param & "-"
                        $pa = StringSplit(StringMid($pa[3], 2), " ")
                        $par0 = $pa[1]
                        If StringInStr($par0, ",") Then $par0 = StringLeft($par0,  StringInStr($par0, ",") - 1)
                        If $par0 == "hevc" Then $par0 = "h265"
                        If $par0 == "truehd" Then $par0 = "thd"
                        If $par0 == "mpeg4" Then $par0 = "avi"
                        If $par0 == "mjpeg" Then $par0 = "avi"
                        If $par0 == "dvvideo" Then $par0 = "avi"
                        If $par0 == "mpeg2video" Then $par0 = "m2v"
                        If $par0 == "mpeg2video" Then $par0 = "m2v"
                        If StringLeft($par0, 3) == "wmv" Then $par0 = "wmv"
                        If StringLeft($par0, 3) == "wma" Then $par0 = "wma"
                        If $par0 == "hdmv_pgs_subtitle" Then $par0 = "sup"
                        If $par0 == "dvd_subtitle" Then $par0 = "sub"
                        If $par0 == "dvb_subtitle" Then $par0 = "sub"
                        If $par0 == "dvb_teletext" Then $par0 = "txt"
                        If $first == "" Then $first = $track_mkv & $par0
                        $track_mkv = $track_mkv & $par0 & "|"
                        $line = $lin & StringMid($line, $x + 4)
                        If StringInStr($line, "([") and StringInStr($line, "),") Then $line = StringLeft($line,  StringInStr($line, "([") - 2) & StringMid($line,  StringInStr($line, "),") + 1)
                        If StringLen($line) > 79 Then $line = StringLeft($line,  79) & "     " & StringMid($line, 80)
                        $tw = $tw & @CRLF & $line
                    EndIf
                EndIf
            Wend
            FileClose($log_handle)
            FileDelete(@ScriptDir & "\ffmpeg-*.log")

            GUICtrlSetState ( $cuadro_info, $GUI_ENABLE)
            GUICtrlSetData ( $cuadro_info, $tw)
            $gui_mkv = GUICreate("ffmpeg Extract", 210, 200, -1, -1, $WS_CAPTION+$WS_POPUP+$WS_SYSMENU, -1, $ppal)
            GUISetState (@SW_DISABLE, $ppal)
            GUISetState(@SW_SHOW, $gui_mkv)
            GUISetOnEvent($GUI_EVENT_CLOSE, "cerrar_acerca")
            If $track_mkv <> "" Then
                $track_mkv = StringTrimRight($track_mkv, 1)
                GUICtrlCreateLabel("Maybe ffmpeg can extract the track.", 20, 20)
                GUICtrlCreateLabel("To decode/recode use A/V Recode", 20, 40)

                GUICtrlCreateLabel("Select Track:", 20, 75)
                $t9 = GUICtrlCreateCombo("", 100, 70, 90, 20) ; create first item
                GUICtrlSetData($t9, $track_mkv, $first)

                $mkv_1 = GUICtrlCreateCheckbox ("Use CLP instead -xcodec copy", 20, 100)
                GUICtrlSetState($mkv_1, $GUI_UNCHECKED)
                GUICtrlCreateLabel("Change output extension to:", 20, 133)
                $mkv_2 = GUICtrlCreateInput("", 160, 130, 35, 20)

                $boton_oks = GUICtrlCreateButton ("&Run", 25, 165, 60, 20)
                GUICtrlSetOnEvent ($boton_oks, "ext_track2")
                $boton_queue = GUICtrlCreateButton ("&EnQueue", 105, 165, 80, 20)
                GUICtrlSetOnEvent ($boton_queue, "ext_que2")
            Else
                GUICtrlCreateLabel("ffmpeg can't recognize input:", 20, 20)
                $line = $ruta_file
                If StringLen($line) > 30 Then $line = "..." & StringRight($line,  27)
                GUICtrlCreateLabel($line, 20, 50)
                GUICtrlCreateLabel("Close this window.", 20, 80)
            Endif
        Endif
    EndIf
EndFunc

Func ext_track2()                    ; FFMPEG extract
        ext_comf()
        funcion_run2($param, 3)
EndFunc

Func ext_que2()
        ext_comf()
        funcion_run2($param, 1)
EndFunc

Func ext_comf()
        $ruta_filo = $ruta_file
        If GUICtrlRead($user_def) == $GUI_CHECKED Then $ruta_filo = $ruta_out & "\" & $filename
        $pa = StringSplit(GUICtrlRead($t9), "-")
        $encoder = Search_enc("ffmpeg", 1)

        $def = "-" & $pa[2] & "codec copy"
        If GUICtrlRead($mkv_1) == $GUI_CHECKED and GUICtrlRead($param_info) <> "" Then $def = GUICtrlRead($param_info)
        $ext = $pa[3]
        If $ext == "mp3" Then $def = $def & " -id3v2_version 0 -write_xing false"
        If GUICtrlRead($mkv_2) <> "" Then $ext = GUICtrlRead($mkv_2)

        $param = chr(34) & $encoder & chr(34) & " -i " & chr(34) & $ruta_file  & chr(34) & " -map 0:" & $pa[1] & " " & $def & " " & chr(34) & $ruta_filo & "_" & $pa[1] & "." & $ext & chr(34)
EndFunc

;===================================================================================================================================== Button: A/V Recode
;===================================================================================================================================== Recode Video
Func encod_set()
    $encod = GUICtrlRead($dec_1)
    If StringInStr($encod, "wavi") Then
        GUICtrlSetData ( $dec_2, "ac3")
        GUICtrlSetData ( $dec_4, "Aften")
    ElseIf StringInStr($encod, "xvid") Then
        GUICtrlSetData ( $dec_2, "avi")
        GUICtrlSetData ( $dec_4, "avi_pass_1")
    ElseIf StringInStr($encod, "x265") Then
        GUICtrlSetData ( $dec_2, "h265")
        GUICtrlSetData ( $dec_4, "x265_def")
    Else
        GUICtrlSetData ( $dec_2, $ext_def)
        GUICtrlSetData ( $dec_4, $par_def)
    EndIf
    ext_set()
    par_set()
EndFunc

Func ext_set()
    $ruta_filo = GUICtrlRead($dec_3)
    $pa = StringSplit($ruta_filo, ".")
    $xex = StringLen($pa[$pa[0]])
    $ruta_filo = StringLeft($ruta_filo, StringLen($ruta_filo) - $xex) & GUICtrlRead($dec_2)
    GUICtrlSetData ( $dec_3, $ruta_filo)
EndFunc

Func par_set()
    $par0 = GUICtrlRead($dec_4)
    $log_handle = FileOpen ($Vid_enc, 512)
    While 1
        $line = FileReadLine($log_handle)
        If @error = -1 Then ExitLoop
        $pos = StringInStr($line, "|")
        If $pos > 0 Then
            If StringLeft($line, $pos - 1) == $par0 Then
                GUICtrlSetData ( $dec_5, StringMid($line, $pos + 1))
                ExitLoop
            EndIf
        EndIf
    Wend
    FileClose($log_handle)
EndFunc

Func enc_que()
    $encod = chr(34) & GUICtrlRead($dec_1) & chr(34)
    If StringInStr($encod, "-binary") - StringInStr($encod, " --x26") == 7 Then
        $pp1 = StringInStr($encod, " --x26")
        $encod = StringLeft($encod, $pp1 - 1) & chr(34) & StringMid($encod, $pp1, 15) & chr(34) & StringMid($encod, $pp1 + 15)
    EndIf
    $param = " " & GUICtrlRead($dec_5)
    $input = " " & chr(34) & $ruta_file & chr(34)
    $output = " -o " & chr(34) & GUICtrlRead($dec_3) & chr(34)
    $pp1 = 2
    If StringInStr($encod, "wavi") Then
        $pp1 = 1
        $param = $input & $param
        $input = " - "
        $output = chr(34) & GUICtrlRead($dec_3) & chr(34)
    EndIf
    If StringInStr($encod, "xvid") Then
        $pp1 = 1
        $input = " -i" & $input
        $output = " -avi " & chr(34) & GUICtrlRead($dec_3) & chr(34)
        If StringInStr($param, "-pass1") Then $output = ""
        $pos = StringInStr($param, "-pass")
        If $pos Then $param = StringLeft($param, $pos + 6) & chr(34) & GUICtrlRead($dec_3) & ".stats" & chr(34) & StringMid($param, $pos + 6)
    EndIf
    $param = $encod & $param & $input & $output
    If GUICtrlRead($dec_6) == $GUI_CHECKED Then $pp1 = $pp1 + 3
    funcion_run2($param, $pp1)
;    cerrar_acerca()
EndFunc

Func avs_edi()
    ShellExecute($editor, chr(34) & $ruta_file & chr(34))
EndFunc

Func par_edi()
    ShellExecute($editor, $Vid_enc)
EndFunc

;===================================================================================================================================== Recode Common
Func dec_gui()
    If $extension == "avs" Then        ; only allowed to video recode
;        $editor = @SystemDir & "\notepad.exe"
        $editor = "Notepad.exe"
        $encoders = ""
        $extensions = ""
        $params = ""
        $now = 0
        $log_handle = FileOpen ($Vid_enc, 512)
        While 1
            $line = FileReadLine($log_handle)
            If @error = -1 Then ExitLoop
            If $line == "[Encoders]" Then
                $now = 1
            ElseIf $line == "[Extensions]" Then
                $now = 2
            ElseIf $line == "[Text Editor]" Then
                $now = 3
            ElseIf $line == "[Presets]" Then
                $now = 4
            ElseIf $line <> "" Then
                If $now == 1 Then
                    If $encoders == "" Then
                        $enc_def = $line
                        $encoders = $enc_def
                    Else
                        $encoders = $encoders & "|" & $line
                    EndIf
                ElseIf $now == 2 Then
                    If $extensions == "" Then
                        $ext_def = $line
                        $extensions = $ext_def
                    Else
                        $extensions = $extensions & "|" & $line
                    EndIf
                ElseIf $now == 3 Then
                       $editor = $line
                ElseIf $now == 4 Then
                    $pos = StringInStr($line, "|")
                    If $params == "" Then
                        $par_def = StringLeft($line, $pos - 1)
                        $par_val = StringMid($line, $pos + 1)
                        $params = $par_def
                    Else
                        $params = $params & "|" & StringLeft($line, $pos - 1)
                    EndIf
                EndIf
            EndIf
        Wend
        FileClose($log_handle)

        $gui_dec = GUICreate("Video Recode", 680, 280, -1, -1, $WS_CAPTION+$WS_POPUP+$WS_SYSMENU, -1, $ppal)
        GUISetState (@SW_DISABLE, $ppal)
        GUISetState(@SW_SHOW, $gui_dec)
        GUISetOnEvent($GUI_EVENT_CLOSE, "cerrar_acerca")

        $boton_avs = GUICtrlCreateButton ("Avs Edit:", 10, 10, 60, 20)
        GUICtrlSetOnEvent ($boton_avs, "avs_edi")
        GUICtrlCreateLabel($ruta_file , 80, 13)
        $ruta_filo = $ruta_file
        If GUICtrlRead($user_def) == $GUI_CHECKED Then $ruta_filo = $ruta_out & "\" & $filename
        $ruta_filo = StringLeft($ruta_filo, StringLen($ruta_filo) - 3) & $ext_def

        GUICtrlCreateLabel("Encoder:", 10, 43)
        $dec_1 = GUICtrlCreateCombo("", 70, 40, 600, 20)
        GUICtrlSetData($dec_1, $encoders, $enc_def)
        GUICtrlSetOnEvent ($dec_1, "encod_set")
        GUICtrlCreateLabel("Out Ext.:", 10, 73)
        $dec_2 = GUICtrlCreateCombo("", 70, 70, 55, 20)
        GUICtrlSetData($dec_2, $extensions , $ext_def)
        GUICtrlSetOnEvent ($dec_2, "ext_set")
        GUICtrlCreateLabel("Out file:", 10, 103)
        $dec_3 = GUICtrlCreateEdit("", 70, 100, 600, 20, $WS_VSCROLL + $ES_WANTRETURN)
        GUICtrlSetData($dec_3, $ruta_filo)

        GUICtrlCreateLabel("Presets:", 10, 133)
        $dec_4 = GUICtrlCreateCombo("", 70, 130, 150, 20)
        GUICtrlSetData($dec_4, $params, $par_def)
        GUICtrlSetOnEvent ($dec_4, "par_set")
        $boton_par = GUICtrlCreateButton ("Presets Edit", 250, 130, 80, 20)
        GUICtrlSetOnEvent ($boton_par, "par_edi")
        GUICtrlCreateLabel("(After edit you need reopen this window to see the changes)", 340, 133)


        $dec_5 = GUICtrlCreateEdit ( "", 10, 160, 660, 80, $WS_VSCROLL + $ES_WANTRETURN)
        GUICtrlSetBkColor($dec_5, 0xd5e1e9)
        GUICtrlSetFont ( $dec_5, 9, 400, 0, "Fixedsys")
        GUICtrlSetData ( $dec_5, $par_val)

;        $boton_oks = GUICtrlCreateButton ("&Run", 50, 400, 50, 20)
;        GUICtrlSetOnEvent ($boton_oks, "enc_run")
        $dec_6 = GUICtrlCreateCheckbox ("Clear progress lines from log/XviD bitrate", 10, 250)
        GUICtrlSetState ($dec_6, $GUI_CHECKED)
        $boton_queue = GUICtrlCreateButton ("&EnQueue", 300, 250, 80, 20)
        GUICtrlSetOnEvent ($boton_queue, "enc_que")

    Else                                                                                                     ; Audio
        $gui_dec = GUICreate("Audio Recode", 250, 500, -1, -1, $WS_CAPTION+$WS_POPUP+$WS_SYSMENU, -1, $ppal)
        GUISetState (@SW_DISABLE, $ppal)
        GUISetState(@SW_SHOW, $gui_dec)
        GUISetOnEvent($GUI_EVENT_CLOSE, "cerrar_acerca")
        $text = "Audio from " & $extension
        If $extension == "" Then $text = "No file selected"
        If $extension == "0" Then $text = "Don't work with BD folder"
        GUICtrlCreateLabel($text & ".", 10, 10)

        GUICtrlCreateLabel("map:X, >0 to force ffmpeg DECODER:", 10, 35)
        $map = GUICtrlCreateCombo("", 200, 30, 40, 20)
        GUICtrlSetData($map, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
        GUICtrlCreateLabel("Let 0 to search for a specific audio decoder first.", 10, 55)

        GUICtrlCreateLabel("Use Command Line Parameters", 5, 90)
        $clp = GUICtrlCreateCombo("", 160, 85, 85, 20)
        GUICtrlSetData($clp, "Ignore|Add to DEC|ReplaceDEC|Add to ENC|ReplaceENC", "Ignore")

        $bit_1 = GUICtrlCreateCombo("", 175, 135, 50, 20)
        If StringInStr($extension, "wav") Then
            If StringRight($ruta_file, 5) == "L.wav" Then
                GUICtrlSetData($bit_1, "wav|w64", "wav")
                $text = "Change header or Merge:"
            Else
                GUICtrlSetData($bit_1, "wav|w64|dts", "wav")
                $text = "Change or WavDts -> dts:"
            EndIf
        Else
            If $extension == "w64" Then
                GUICtrlSetData($bit_1, "wav|w64", "wav")
                $text = "Change header to:"
            Else
                GUICtrlSetData($bit_1, "wav|w64", "wav")
                $text = "Decode only to:"
            EndIf
        EndIf
        GUICtrlCreateGroup("Select ENCODER", 15, 120, 220, 320)
        $dec_1 = GUICtrlCreateRadio($text, 25, 135, 140, 25)
        $dec_2 = GUICtrlCreateRadio("Recode to E/AC3, ffmpeg:", 25, 165, 145, 25)
        $dec_8 = GUICtrlCreateRadio("Recode to AAC, Qaac:", 25, 195, 140, 25)
        $dec_4 = GUICtrlCreateRadio("Recode to MP3, Lame:", 25, 225, 140, 25)
        $dec_5 = GUICtrlCreateRadio("Recode to OPUS, bitrate:", 25, 255, 140, 25)
        $dec_6 = GUICtrlCreateRadio("Recode to MP2, ffmpeg:", 25, 285, 140, 25)
        $dec_7 = GUICtrlCreateRadio("Recode to OGG, quality 10-0:", 25, 315, 160, 25)
        $dec_3 = GUICtrlCreateRadio("Recode to M4A, NeroQua 1-0:", 25, 345, 160, 25)
        $dec_9 = GUICtrlCreateRadio("Recode to M4A, Fghaac:", 25, 375, 140, 25)
        $dec10 = GUICtrlCreateRadio("Recode to DTS, ffdca:", 25, 405, 130, 25)
        GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
        GUICtrlSetState($dec_2, $GUI_CHECKED)

        $bit_2 = GUICtrlCreateCombo("", 175, 165, 50, 20)
        GUICtrlSetData($bit_2, "640|576|512|448|384|320|256|224|192|160|128|112|E640|E576|E512|E448|E384|E320|E256|E224|E192|E160|E128|E112|E96|E80|E64", "640")
        $bit_8 = GUICtrlCreateCombo("", 175, 195, 50, 20)
        GUICtrlSetData($bit_8, "768|640|576|512|448|384|320|288|256|224|192|160|128|112|96|80|64|56|48|V125|V118|V109|V100|V91|V82|V73|V64|V54|V45|V36|V27|V18|V9|V1", "V91")
        $bit_4 = GUICtrlCreateCombo("", 175, 225, 50, 20)
        GUICtrlSetData($bit_4, "V 0|V 1|V 2|V 3|V 4|V 5|V 6|V 7|V 8|V 9|320|256|224|192|160|128|112|96|80|64|56|48|32", "V 5")
        $qua_5 = GUICtrlCreateCombo("", 175, 255, 50, 20)
        GUICtrlSetData($qua_5, "320|256|224|192|160|128|112|96|80|64|56|48|32|24|16", "96")
        $bit_6 = GUICtrlCreateCombo("", 175, 285, 50, 20)
        GUICtrlSetData($bit_6, "384|320|256|224|192|160|128|112|96|80|64|56|48|32", "192")
        $qua_7 = GUICtrlCreateInput("", 195, 315, 30, 20)
        GUICtrlSetData($qua_7, 3)
        $qua_3 = GUICtrlCreateInput("", 195, 345, 30, 20)
        GUICtrlSetData($qua_3, 0.45)
        $bit_9 = GUICtrlCreateCombo("", 175, 375, 50, 20)
        GUICtrlSetData($bit_9, "576|512|448|384|320|288|256|224|192|160|128|112|96|80|64|56|48|32|24|16|8|V5|V4|V3|V2|V1", "V5")
        $bit10 = GUICtrlCreateCombo("", 160, 405, 65, 20)
        GUICtrlSetData($bit10, "3842|1509.75|754.5|32", "1509.75")

        GUICtrlCreateLabel("Quality values allowed from high to low H-L", 20, 445)

        $boton_oks = GUICtrlCreateButton ("&Run", 50, 470, 50, 20)
        GUICtrlSetOnEvent ($boton_oks, "dec_track")
        $boton_queue = GUICtrlCreateButton ("&EnQueue", 125, 470, 80, 20)
        GUICtrlSetOnEvent ($boton_queue, "dec_que1")
    Endif
EndFunc

;===================================================================================================================================== Recode Audio
Func dec_track()
    dec_comm()
    If $encoder <> "" and $param <> ""  Then
        funcion_run2($param, 3)
    Endif
EndFunc

Func dec_que1()
    dec_comm()
    If $encoder <> "" and $param <> ""  Then
        funcion_run2($param, 2)
    Endif
EndFunc

Func clp_par($def)
    $fpar = $def
    If GUICtrlRead($clp) == "Add to ENC" Then
        $fpar = $def & " " & GUICtrlRead($param_info)
    ElseIf GUICtrlRead($clp) == "ReplaceENC" Then
        $fpar = GUICtrlRead($param_info)
    EndIf
    Return $fpar
EndFunc

Func clp_pard($def)
    $fpar = $def
    If GUICtrlRead($clp) == "Add to DEC" Then
        $fpar = $def & " " & GUICtrlRead($param_info)
    ElseIf GUICtrlRead($clp) == "ReplaceDEC" Then
        $fpar = GUICtrlRead($param_info)
    EndIf
    Return $fpar
EndFunc

Func merge_wav()                           ; -filter_complex "join=inputs=6:channel_layout=FL+FR+FC+LFE+SL+SR:map=0.0-FL|1.0-FR|2.0-FC|3.0-LFE|4.0-SL|5.0-SR"
    $root = StringTrimRight($ruta_file, 5)
    $file = chr(34) & $ruta_file & chr(34) ; L.wav -i R.wav -i C.wav -i LFE.wav -i SL.wav -i SR.wav
    $par3 = "FL"                           ; :channel_layout=FL+FR+FC+LFE+SL+SR
    $map  = ":map=0.0-FL"                  ; :map=0.0-FL|1.0-FR|2.0-FC|3.0-LFE|4.0-SL|5.0-SR
    $n = 1
    $pe = StringSplit("R|C|LFE|BL|BR|LC|RC|BC|SL|SR", "|")     ; eac3to channel sufix
    $pf = StringSplit("FR|FC|LFE|BL|BR|FLC|FRC|BC|SL|SR", "|") ; ffmpeg channel ID's
    For $i = 1 to $pe[0]
        If FileExists($root & $pe[$i] & ".wav") Then
            $file = $file & " -i " & chr(34) & $root & $pe[$i] & ".wav" & chr(34)
            $par3 = $par3 & "+" & $pf[$i]
            $map  = $map & "|" & $n & ".0-" & $pf[$i]
            $n = $n + 1
        EndIf
    Next
    If $n > 1 Then
        $tcod = MsgBox(4, "Merge", "Detected file channels:" & @CRLF & $par3 & @CRLF & @CRLF & "Do you want merge channels?")
        $par3 = $file & " -filter_complex " & chr(34) & "join=inputs=" & $n & ":channel_layout=" & $par3 & $map & chr(34)
        If $tcod <> 6 Then $par3 = ""
    Else
        $par3 = ""
    EndIf
    Return $par3
EndFunc

Func dec_comm()
    $ruta_filo = $ruta_file
    If GUICtrlRead($user_def) == $GUI_CHECKED Then $ruta_filo = $ruta_out & "\" & $filename
    $in_file = chr(34) & $ruta_file & chr(34)
    $merge = ""
    If StringRight($ruta_file, 5) == "L.wav" Then $merge = merge_wav()
    If $merge <> "" Then $in_file = $merge

    $encoder = ""
    $param = ""
    If not ($extension == "0" or $extension == "") Then
        $mapv = GUICtrlRead($map)
        $pass = 2                                                                          ; Select ENCODER
        If GUICtrlRead($dec_1) == $GUI_CHECKED Then          ; Decode only or merge
            If GUICtrlRead($bit_1) == "dts" then             ; dts output selected
                $encoder = Search_enc("BeSplit", 0)          ; BeSplit.exe -core( -input "%%A" -prefix "%%A" -type dtswav -fix )
                If $encoder <> "" and $merge == "" Then
                    $param = " -core( -input " & $in_file & " -prefix " & chr(34) & $ruta_filo & chr(34) & " -type dtswav -fix )"
                    $tcod = MsgBox(260, "WavDtsWav", "Try to extract DTS from wav using BeSplit?")
                    If $tcod <> 6 Then $param = ""
                Else
                    MsgBox(4096, "Not allowed.", "Don't found BeSplit or Merge selected.", 20)
                    $encoder = ""
                Endif
                $pass = 1
            Else   ; wav or w64 selected; force use ffmpeg, only way to obtain w64 or merge or decode other files without dedicated decoder
                If $merge <> "" or StringInStr("|ogg|wma|wmv|mp2|mp3|opus|aac|m4a|mp4", $extension) = 0 or $mapv > 0 then
                   $encoder = Search_enc("ffmpeg", 1)   ; -i INPUT -vn -acodec pcm_s24le OUTPUT_.w64
                   If $merge == "" Then                               ; decode input
                      $def = "-vn" & " -acodec pcm_s" & $bits & "le"
                      If $mapv > 1 then $def = "-map 0:" & $mapv & " -acodec pcm_s24le"
                      $def = clp_pard($def)
                      $param = " -drc_scale 0 -i " & $in_file & " " & $def & " " & chr(34) & $ruta_filo & "_." & GUICtrlRead($bit_1) & chr(34)     ; only decode to w64/wav
                   Else                                               ; merge channels
                      $param = " -i " & $in_file & " -acodec pcm_s" & $bits & "le " & chr(34) & $ruta_filo & "_." & GUICtrlRead($bit_1) & chr(34)  ; merge to wav or w64
                   Endif
                   $pass = 1
                Else                                                  ; try to search dedicated decoder
                    $encoder = "none"      ; only decode to WAV with dedicated decoder if exist, maybe with ffmpeg
                Endif
            Endif
        ElseIf GUICtrlRead($dec_2) == $GUI_CHECKED Then        ; Direct recode to AC3, only 1 pass, Aften.exe deprecated
            $encoder = Search_enc("ffmpeg", 1)    ; -i INPUT -vn -acodec ac3 -center_mixlev 0.707 -ab Kbk OUTPUT_.ac3
            $par1 = "-vn"
            If $mapv > 1 Then $par1 = "-map 0:" & $mapv
            $ac3 = "ac3"
            $Kb = GUICtrlRead($bit_2)
            If StringLeft($Kb, 1) == "E" Then     ; recode to EAC3
                $ac3 = "eac3"
                $Kb = StringMid($Kb, 2)
            Endif
            $def = clp_pard($par1 & " -acodec " & $ac3 & " -center_mixlev 0.707 -ab " & $Kb & "k")
            $param = " -drc_scale 0 -i " & $in_file & " " & $def & " " & chr(34) & $ruta_filo & "_." & $ac3 & chr(34)
            $pass = 1
        Elseif GUICtrlRead($dec_3) == $GUI_CHECKED Then
            $encoder = Search_enc("NeroAacEnc", 1)    ; | NeroAacEnc -q QUA -ignorelength -if - -of OUTPUT_.m4a    [WAV] -q QUA -ignorelength -if INPUT -of OUTPUT_.m4a
            $def = clp_par("-q " & GUICtrlRead($qua_3) & " -ignorelength")
            If $extension == "wav" and $merge == "" and $mapv = 0 Then
                $param = " " & $def & " -if " & $in_file & " -of " & chr(34) & $ruta_filo & "_.m4a" & chr(34)
                $pass = 1
            Else
                $param = " | " & chr(34) & $encoder & chr(34) & " " & $def & " -if - -of " & chr(34) & $ruta_filo & "_.m4a" & chr(34)
            Endif
        Elseif GUICtrlRead($dec_4) == $GUI_CHECKED Then
            $encoder = Search_enc("Lame", 1)          ; | Lame -b CBR - OUTPUT_.mp3                                [WAV] -b CBR INPUT OUTPUT_.mp3
            $par1 = GUICtrlRead($bit_4)    ;        -v
            If StringLeft($par1, 1) <> "V" Then $par1 = "b " & $par1
            $def = clp_par("-" & $par1)
            If StringInStr("wav|mp2|mp3", $extension) and $merge == "" and $mapv = 0 Then     ; encoder = decoder = Lame only 1 pass needed
                $param = " " & $def & " " & $in_file & " " & chr(34) & $ruta_filo & "_.mp3" & chr(34)
                $pass = 1
            Else
                $param = " | " & chr(34) & $encoder & chr(34) & " " & $def & " - " & chr(34) & $ruta_filo & "_.mp3" & chr(34)
            Endif
        Elseif GUICtrlRead($dec_5) == $GUI_CHECKED Then
            $encoder = Search_enc("opusenc", 1)          ; | opusenc --ignorelength --bitrate 128 - %_.opus
            $def = clp_par("--ignorelength --bitrate " & GUICtrlRead($qua_5))
            If $extension == "wav" and $merge == "" and $mapv = 0 Then
                $param = " " & $def & " " & $in_file & " " & chr(34) & $ruta_filo & "_.opus" & chr(34)
                $pass = 1
            Else
                $param = " | " & chr(34) & $encoder & chr(34) & " " & $def & " - " & chr(34) & $ruta_filo & "_.opus" & chr(34)
            Endif
        Elseif GUICtrlRead($dec_6) == $GUI_CHECKED Then       ; Direct recode to MP2, only 1 pass, TwoLame.exe deprecated
            $encoder = Search_enc("ffmpeg", 1)    ; -i INPUT -vn -acodec mp2 -ab Kbk OUTPUT_.ac3
            $par1 = "-vn"
            If $mapv > 1 Then $par1 = "-map 0:" & $mapv
            $def = clp_par($par1 & " -acodec mp2 -ab " & GUICtrlRead($bit_2) & "k")
            $param = " -drc_scale 0 -i " & $in_file & " " & $def & " " & chr(34) & $ruta_filo & "_.mp2" & chr(34)
            $pass = 1
        Elseif GUICtrlRead($dec_7) == $GUI_CHECKED Then
            $encoder = Search_enc("OggEnc2", 1)       ; | OggEnc2 -q QUA --ignorelength -o OUTPUT_.ogg -           [WAV] -q QUA --ignorelength -o OUTPUT_.ogg INPUT
            $def = clp_par("-q " & GUICtrlRead($qua_7) & " --ignorelength")
            If $extension == "wav" and $merge == "" and $mapv = 0 Then
                $param = " " & $def & " -o " & chr(34) & $ruta_filo & "_.ogg" & chr(34) & " " & $in_file
                $pass = 1
            Else
                $param = " | " & chr(34) & $encoder & chr(34) & " " & $def & " -o " & chr(34) & $ruta_filo & "_.ogg" & chr(34) & " - "
            Endif
        Elseif GUICtrlRead($dec_8) == $GUI_CHECKED Then
            $encoder = Search_enc("qaac", 1)          ; | qaac -V QUA --ignorelength --adts --no-delay -o OUTPUT_.aac -    [WAV] -V QUA --ignorelength --adts --no-delay -o OUTPUT_.aac INPUT
            $par1 = GUICtrlRead($bit_8)    ;        -v
            If StringLeft($par1, 1) == "V" Then
                $par1 = "-V " & StringMid($par1, 2)
            Else
                $par1 = "-v " & $par1
            Endif
            $def = clp_par($par1 & " --ignorelength --adts --no-delay")
            If StringInStr("wav|aac|m4a", $extension) and $merge == "" and $mapv = 0 Then     ; encoder = decoder = qaac only 1 pass needed
                $param = " " & $def & " -o " & chr(34) & $ruta_filo & "_.aac" & chr(34) & " " & $in_file
                $pass = 1
            Else
                $param = " | " & chr(34) & $encoder & chr(34) & " " & $def & " -o " & chr(34) & $ruta_filo & "_.aac" & chr(34) & " - "
            Endif
        Elseif GUICtrlRead($dec_9) == $GUI_CHECKED Then
            $encoder = Search_enc("fhgaacenc", 1)     ; | fhgaacenc --vbr QUA --ignorelength - OUTPUT_.m4a         [WAV] --vbr QUA --ignorelength INPUT OUTPUT_.m4a
            $par1 = GUICtrlRead($bit_9)    ;             --cbr CBR
            If StringLeft($par1, 1) == "V" Then
                $par1 = "--vbr " & StringMid($par1, 2)
            Else
                $par1 = "--cbr " & $par1
            Endif
            $def = clp_par($par1 & " --ignorelength")
            If $extension == "wav" and $merge == "" and $mapv = 0 Then
                $param = " " & $def & " " & $in_file & " " & chr(34) & $ruta_filo & "_.m4a" & chr(34)
                $pass = 1
            Else
                $param = " | " & chr(34) & $encoder & chr(34) & " " & $def & " - " & chr(34) & $ruta_filo & "_.m4a" & chr(34)
            Endif
        Elseif GUICtrlRead($dec10) == $GUI_CHECKED Then
            $encoder = Search_enc("ffdcaenc", 1)      ; | ffdcaenc -i - -o OUTPUT_.dts -l -b CBR                   [WAV] -i INPUT -o OUTPUT_.dts -l -b CBR
            $def = clp_par("-l -b " & GUICtrlRead($bit10))
            If $extension == "wav" and $merge == "" and $mapv = 0 Then
                $param = " -i " & $in_file & " -o " & chr(34) & $ruta_filo & "_.dts" & chr(34) & " " & $def
                $pass = 1
            Else
                $param = " | " & chr(34) & $encoder & chr(34) & " -i - -o " & chr(34) & $ruta_filo & "_.dts" & chr(34) & " " & $def
            Endif
        Endif
    Endif
;-----------------------------------------------------------------------------------------------  search DECODER
    If $encoder <> "" Then      ; if found the encoder continue else exit (msg sended alrady by Search_enc)
        $decoder = ""           ; now we need found a valid decoder
        If $pass = 2 Then       ; if we need 2 pass (decoder <> encoder or search dedicated decoder)
            If $mapv = 0 Then   ; search dedicated decoder)
                If StringInStr("m4a|mp4", $extension) Then $decoder = Search_enc("NeroAacDec", 0)  ; default for m4a,mp4
                If $extension == "ogg" Then
                    $decoder = Search_enc("oggdec", 1)
                    $def = clp_pard("-b 3")
                    If $param == "" Then      ; -b 3 -w OUTPUT_.wav INPUT
                        $param = " " & $def & " -w " & chr(34) & $ruta_filo & "_.wav" & chr(34) & " " & $in_file
                    Else                      ; -b 3 -o OUTPUT INPUT param
                        $param = " " & $def & " -o " & $in_file & $param
                    Endif
                ElseIf StringInStr("wma|wmv", $extension) Then
                    $decoder = Search_enc("wma2wav", 1)
                    $def = clp_pard("")  ; begin
                    If $param == "" Then      ; -i INPUT -o OUTPUT_.wav
                        $param = " " & $def & " -i " & $in_file & " -o " & chr(34) & $ruta_filo & "_.wav" & chr(34)
                    Else                      ; -i INPUT -w -s -o - param
                        $param = " " & $def & " -i " & $in_file & " -w -s -o - " & $param
                    Endif
                ElseIf StringInStr("mp2|mp3", $extension) Then
                    $decoder = Search_enc("lame", 1)
                    $def = clp_pard("")  ; before in_file
                    If $param == "" Then      ; --decode INPUT OUTPUT_.wav
                        $param = " --decode " & $def & " " & $in_file & " " & chr(34) & $ruta_filo & "_.wav" & chr(34)
                    Else                      ; --decode - INPUT param
                        $param = " --decode " & $def & " - " & $in_file & $param
                    Endif
                ElseIf $extension == "opus" Then
                    $decoder = Search_enc("opusdec", 1)
                    $def = clp_pard("") ; begin
                    If $param == "" Then      ; opusdec [--float] input.opus ouput.wav
                        $param = " " & $def & " " & $in_file & " " & chr(34) & $ruta_filo & "_.wav" & chr(34)
                    Else                      ;  opusdec --force-wav input.opus -
                        $param = " " & $def & " --force-wav " & $in_file & " - " & $param
                    Endif
                ElseIf StringInStr("aac|m4a|mp4", $extension) Then
                    If $decoder <> "" Then    ; NeroAacDec found
                        $def = clp_pard("") ; end
                        If $param == "" Then      ; -if INPUT -of OUTPUT_.wav
                            $param = " -if " & $in_file & " -of " & chr(34) & $ruta_filo & "_.wav" & chr(34) & " " & $def
                        Else                      ; -if INPUT -of - param
                            $param = " -if " & $in_file & " -of - " & $def & " " & $param
                        Endif
                    ElseIf StringInStr("aac|m4a", $extension) Then ; to allow use qaac or faad if don't found NeroAacDec, or .aac input
                        $decoder = Search_enc("qaac", 0)
                        If $decoder <> "" Then
                            $def = clp_pard("-b 24")
                            If $param == "" Then  ; -D -b 24 -o OUTPUT_.wav INPUT
                                $param = " -D " & $def & " -o " & chr(34) & $ruta_filo & "_.wav" & chr(34) & " " & $in_file
                            Else                  ; -D -b 24 -o - INPUT param
                                $param = " -D " & $def & " -o - " & $in_file & $param
                            Endif
                        Else
                            $decoder = Search_enc("faad", 1)
                            $def = clp_pard("-b 2")
                            If $param == "" Then  ; -b 2 -o OUTPUT_.wav INPUT
                                $param = " " & $def & " -o " & chr(34) & $ruta_filo & "_.wav" & chr(34) & " " & $in_file
                            Else                  ; -b 2 -w INPUT param
                                $param = " " & $def & " -w " & $in_file & $param
                            Endif
                        Endif
                    Endif
                Endif
            Endif
;
            If $decoder == "" Then               ; decoder not found, encoder found, maybe "none", 2 pass selected (don't want AC3 or W64 or solved by encoder)
                $decoder = Search_enc("ffmpeg", 1)          ; try with ffmpeg
                If $merge == "" Then
                    $def = "-vn -acodec pcm_s24le"
                    If $mapv > 1 then $def = "-map 0:" & $mapv & " -acodec pcm_s24le"
                    $def = clp_pard($def)     ; here ffmpeg can be set encoder
                    If $param == "" Then      ; want wav, encoder "none" ; -i INPUT -vn -acodec pcm_s24le OUTPUT_.wav
                        $param = " -drc_scale 0 -i " & $in_file & " " & $def & " " & chr(34) & $ruta_filo & "_.wav" & chr(34)
                    Else                      ; want ffmpeg decoder pipe wav to other encoder;
                        $param = " -drc_scale 0 -i " & $in_file & " " & $def & " -f wav - " & $param
                    Endif
                Else                      ; want ffmpeg merge channels to other decoder;
                    $def = clp_pard("-acodec pcm_s" & $bits & "le")
                    $param = " -i " & $in_file & " " & $def & " -f wav - " & $param
                Endif
            Endif
            $encoder = $decoder  ; If only 1 pass the encoder do all the job, with 2 pass the encoder is inside $param
        Endif
        If $encoder <> "" and $param <> "" Then
            $param = chr(34) & $encoder & chr(34) & $param
        Else
            MsgBox(4096, "Not allowed.", "Input not allowed or don't found external decoder.", 20)
        Endif
    Else
        MsgBox(4096, "Not allowed.", "Input empty or BD folder.", 20)
    Endif
EndFunc

;===================================================================================================================================== Button:
;===================================================================================================================================== SRT/.../TRIM
Func srt_sel()
        If StringInStr("srt|ssa|ass|txt|xml|cue|", $extension) Then
            srt_gui()
        ElseIf $extension == "avs" Then
            $srt_1 = $ruta_file                   ; avs file
            $srt_2 = $ruta_fold & "\EXAMPLE.AAC"  ; aud in dummy, only want Trim times in _Trim.bat
            avs_com()
        ElseIf StringInStr("eac3|dts|mp3|mp2|wav|aac|m4a|thd|flac|opus|ogg|w64", $extension) Then  ; AUDIO TRIM (Trim-Aud.vbs)
            $srt_2 = $ruta_file                   ; aud in
            $srt_1 = FileOpenDialog("Select AVS file if want TRIM", $ruta_fold, "avs file to TRIM (*.avs)", 1)
            If $srt_1 <> "" Then
                avs_com()
            Else
                MsgBox(4096, "Not allowed.", "Audio file can't be trimmed without a trim.avs.", 20)
            Endif
;       ElseIf $extension == "srt" Then                                                     ; PENDING SRT TRIM (Trim-Srt.vbs)
;           $srt_2 = $ruta_file                   ; srt in
;           $srt_1 = FileOpenDialog("Select AVS file if want TRIM", $ruta_fold, "avs file to TRIM (*.avs)", 1)
;           If $srt_1 <> "" Then
;               srt_trim()
;           Else
;               srt_gui()
;           EndIf
        Else
            MsgBox(4096, "Not allowed.", "Input file can't be managed here.", 20)
        Endif
EndFunc

;Func srt_trim()
;        If FileExists($ruta_fold & "\timestamps.txt") Then     ; also pending VFR management ;@m17
;            $n = 0
;        Endif
;EndFunc

Func avs_com()
        $srt_3 = $srt_2 & "_Trim.mka"     ; aud out
        $srt_4 = $srt_2 & "_Trim.bat"     ; bat + log new file
; parse avs
        $tx = ""                          ; to contain normalized Trim text
        $x = 0                            ; frame duration in ms (1000/fps)
        $srt_in = FileOpen($srt_1, 512)     ; avs file
        While 1
            $line = FileReadLine($srt_in)
            If @error = -1 Then ExitLoop
            $line = StringLower($line)
            $p = StringInStr($line, "trim(") ; search Trim line
            If $p Then
                $p2 = StringInStr($line, "#")
                If $p2 == 0 Then $tx = $line
                If $p2 > $p Then $tx = StringLeft($line, $p2 - 1)
            Endif
            $p = StringInStr($line, "assumefps(") ; search fps
            If $p Then
                $p2 = StringInStr($line, "#")
                If $p2 == 0 or $p2 > $p Then
                    $line = StringMid($line, $p + 10)
                    $p = StringInStr($line, ")")
                    $p2 = StringInStr($line, ",")
                    If $p2 > 0 and $p2 < $p Then
                        $x = 1000 * StringMid($line, $p2 + 1, $p - $p2 - 1) / StringLeft($line, $p2 - 1)
                    Else
                        $x = 1000 / StringLeft($line, $p - 1)
                    Endif
                Endif
            Endif
        Wend
        FileClose($srt_in)
; Common begin
        If $tx <> "" Then
            $part = ""
            $delay = " "
            If $extension <> "avs" Then
                $p = StringInStr($srt_2, "DELAY")
                If $p then
                    $fri = StringMid($srt_2, $p + 6)
                    $n = StringInStr($fri, "ms")
                    If $n Then
                        $delay = " --sync 0:" & StringLeft($fri, $n - 1) & " "
                        $srt_3 = StringLeft($srt_2, $p - 1) & "_Trim.mka"  ; Elimina DELAY XXXms del nombre para evitar duplicidad (delay ya considerado en --sync)
                    Endif
                Endif
            Endif
            $srt_in  = FileOpen ( $srt_4, 514 )  ; bat/log
            FileWriteLine($srt_in, "rem Time equivalences for: " & $tx)
; Check for timestamps
            $srt_5 = FileOpenDialog("Select TIMESTAMPS file if want a TRIM for VFR video", $ruta_fold, "Timestamps file to TRIM (*.txt)", 1)   ;@m17
            If $srt_5 <> "" Then
; Begin cut with timestamps
                $srt_tim = FileOpen($srt_5, 512 )
                $srt_out = FileOpen($srt_5 & "_Trim.txt", 514 )
                FileWriteLine($srt_in, "rem Times from timestamps.txt to trim audio for VFR video.")     ;@m17
                FileWriteLine($srt_in, "rem")
                $l = FileReadLine($srt_tim)
                FileWriteLine($srt_out, $l)         ;# timestamp format v2                               ;@m17
                $l0 = Round(FileReadLine($srt_tim))  ; almacena delay inicial
                FileWriteLine($srt_out, "0")         ; 0, el nuevo video no debe tener delay inicial
                $n = 0             ;primera frame de entrada que inicia su visualizacion en el tiempo 0:
                $tin = 0           ;y finalizara su visualizacion en siguiente timestamp
                $tout = 0          ;timestamp de la primera frame de salida
                $frn = 999999999
                While $n == 0
                    $p = StringInStr($tx, "trim(")
                    While $p
                        $p = $p + 5
                        $p2 = StringInStr($tx, ",")
                        $fri = StringMid($tx, $p, $p2 - $p)
                        $p = StringInStr($tx, ")")
                        $frf = StringMid($tx, $p2 + 1, $p - $p2 - 1)
                        While $n <= $frf or $frf = 0
                           $l = FileReadLine($srt_tim)  ;lee siguiente timestamp
                           If @error = -1 Then
                               $tx = ""
                               $frf = 0
                               ExitLoop
                           Endif
                           $l = Round($l) - $l0  ;corrigiendo delay inicial si existe
                           If $n = $frn Then
                               time_conv($l, ".")
                               $part = $part & $tf & ",+"
                               FileWriteLine($srt_in, "rem End:   " & $tf & " <- " & ($frn - 1) & " (" & $l & " ms)")
                           Endif
                           $dur = $l - $tin          ;duracion de la frame anterior
                           $tin = $l                 ;almacena valor para la siguiente
                           If $n >= $fri Then
                              $tout = $tout + $dur   ;calcula nuevo timestamp
                              FileWriteLine($srt_out, $tout)   ;y lo graba
                           EndIf
                           If $n = $fri Then
                               If $n = 0 Then
                                   $part = $part & "-"
                                   FileWriteLine($srt_in, "rem Begin: 00:00:00.000 <- 0 (0 ms)")
                               Else
                                   time_conv($l, ".")
                                   $part = $part & $tf & "-"
                                   FileWriteLine($srt_in, "rem Begin: " & $tf & " <- " & $fri & " (" & $l & " ms)")
                               Endif
                           Endif
                           $n = $n + 1               ;siguiente frame
                        Wend
                        $frn = $frf + 1
                        $tx = StringMid($tx, $p + 1)
                        $p = StringInStr($tx, "trim(")
                    Wend
                Wend
                If $frf <> 0 Then
                    $l = Round(FileReadLine($srt_tim)) - $l0 ;lee siguiente timestamp
                    time_conv($l, ".")
                    $part = $part & $tf
                Endif
                FileClose($srt_out)
                FileClose($srt_tim)
                MsgBox(4096, "Partial job ended.", "Created new:" & @CRLF & $srt_5 & "_Trim.txt", 10)
            Else
; Begin cut with FPS, no timestamps selected
                If $x = 0 Then
                    $z = InputBox("FPS not detected", "1 for 25, 2 for 23,976" & @CRLF & "3 for 24, 4 for 29,970" & @CRLF & "5 for 47,95, 6 for 59,940" & @CRLF & "Or other: ", "1", " M8")
                    If @error = -1 or $z = "" Then
                       $x = 40
                    Elseif $z == "1" then
                       $x = 1000/25
                    Elseif $z == "2" then
                       $x = 1001/24
                    Elseif $z == "3" then
                       $x = 1000/24
                    Elseif $z == "4" then
                       $x = 1001/30
                    Elseif $z == "5" then
                       $x = 1001/48
                    Elseif $z == "6" then
                       $x = 1001/60
                    Else
                       $x = 1000/$z
                    Endif
                Endif
                FileWriteLine($srt_in, "rem Times from CFR video with frame duration of: " & $x & " ms.")
                FileWriteLine($srt_in, "rem")
                $fr0 = 0
                $frf = -1                                   ; Aux frames initialize
                $p = StringInStr($tx, "trim(")              ; Parse trim line
                While $p
                    $p = $p + 5
                    $p2 = StringInStr($tx, ",")
                    $fri = StringMid($tx, $p, $p2 - $p)
                    $frc = $fri - $frf - 1                  ; Cut betwen trims
                    $t = Round($x * $fri)                   ; Initial frame
                    time_conv($t, ".")
                    FileWriteLine($srt_in, "rem Begin: " & $tf & " <- " & $fri & " (" & $t & " ms)")
                    If $fri = 0 Then
                        $part = $part & "-"
                    Else
                        $part = $part & $tf & "-"
                    Endif
                    $p = StringInStr($tx, ")")              ; End frame
                    $frf = StringMid($tx, $p2 + 1, $p - $p2 - 1)
                    $t = Round($x * ($frf + 1))
                    time_conv($t, ".")
                    FileWriteLine($srt_in, "rem End:   " & $tf & " <- " & $frf & " (" & $t & " ms)")
                    If $frf <> 0 Then $part = $part & $tf & ",+"
                    $t = Round($x * $frc)                   ; Show cut betwen trims
                    time_conv($t, ".")
                    FileWriteLine($srt_in, "rem Cut:   " & $tf & " <- " & $frc & " (" & $t & " ms)")
                    $frc = $frf - $fri + 1                  ; Selected frames in trim
                    $t = Round($x * $frc)
                    time_conv($t, ".")
                    FileWriteLine($srt_in, "rem Trim:  " & $tf & " <- " & $frc & " (" & $t & " ms)")
                    $t = Round($x * $fr0)                   ; New begin frame in output
                    time_conv($t, ".")
                    FileWriteLine($srt_in, "rem New B: " & $tf & " <- " & $fr0 & " (" & $t & " ms)")
                    $fr0 = $fr0 + $frc                      ; New end frame in output
                    $frc = $fr0 - 1
                    $t = Round($x * $fr0)
                    time_conv($t, ".")
                    FileWriteLine($srt_in, "rem New E: " & $tf & " <- " & $frc & " (" & $t & " ms)")
                    FileWriteLine($srt_in, "rem")
                    $tx = StringMid($tx, $p + 1)
                    $p = StringInStr($tx, "trim(")
                Wend
                If $frf <> 0 Then $part = StringTrimRight($part, 2)
            Endif
; Common End
            $param = chr(34) & $MkvMerge & chr(34) & " -o " & chr(34) & $srt_3 & chr(34) & $delay & chr(34) & $srt_2 & chr(34) & " --split parts:" & $part
            Param_page()
            FileWriteLine($srt_in, $param)
            FileWriteLine($srt_in, "pause")
            FileClose($srt_in)
            If $extension == "avs" Then
                MsgBox(4096, "Job ended.", "Done. Created info in:" & @CRLF & $srt_4, 10)
            Else
                ShellExecuteWait($srt_4)
                MsgBox(4096, "Job ended.", "Done. Created info and .mka:" & @CRLF & $srt_4 & @CRLF & $srt_3, 10)
            Endif
        Else
            MsgBox(4096, "Warning.", "Trim line not detected in .avs.", 10)
        Endif
EndFunc

Func srt_gui()
        $gui_srt = GUICreate("SRT/SSA/ASS/TXT/XML", 280, 400, -1, -1, $WS_CAPTION+$WS_POPUP+$WS_SYSMENU, -1, $ppal)
        GUISetState (@SW_DISABLE, $ppal)
        GUISetState(@SW_SHOW, $gui_srt)
        GUISetOnEvent($GUI_EVENT_CLOSE, "cerrar_acerca")

        GUICtrlCreateLabel("Beginning at ms:", 50, 10)
        $offset = GUICtrlCreateInput("", 155, 10, 70, 20)
        GUICtrlSetData($offset, 0)
        GUICtrlCreateLabel("Delay in ms:", 50, 35)
        $delay = GUICtrlCreateInput("", 155, 35, 70, 20)
        GUICtrlSetData($delay, 0)

        GUICtrlCreateGroup("Select Stretch", 40, 70, 200, 230)
        $srt_1 = GUICtrlCreateRadio("23,976 -> 25", 50,  85, 85, 25)
        $srt_2 = GUICtrlCreateRadio("23,976 -> 24",150,  85, 85, 25)
        $srt_3 = GUICtrlCreateRadio("24.000 -> 25", 50, 115, 85, 25)
        $srt_4 = GUICtrlCreateRadio("24 -> 23.976",150, 115, 85, 25)
        $srt_5 = GUICtrlCreateRadio("25 -> 24.000", 50, 145, 85, 25)
        $srt_6 = GUICtrlCreateRadio("25 -> 23.976",150, 145, 85, 25)
        $srt_7 = GUICtrlCreateRadio("Custom:", 50, 175, 80, 25)
        $srt_0 = GUICtrlCreateRadio("By 2 points at Begin and End:", 50, 205, 185, 25)
        GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
        GUICtrlSetState($srt_7, $GUI_CHECKED)
        $stretch = GUICtrlCreateInput("",130, 175, 60, 20)
        GUICtrlSetData($stretch, 1)
        $t11 = GUICtrlCreateInput("",60, 235, 70, 20)
        GUICtrlSetData($t11, "00:00:00,000")
        $t12 = GUICtrlCreateInput("",155, 235, 70, 20)
        GUICtrlSetData($t12, "00:00:00,000")
        $t21 = GUICtrlCreateInput("",60, 265, 70, 20)
        GUICtrlSetData($t21, "01:00:00,000")
        $t22 = GUICtrlCreateInput("",155, 265, 70, 20)
        GUICtrlSetData($t22, "01:00:00,000")
        GUICtrlCreateLabel("->", 135, 235)
        GUICtrlCreateLabel("->", 135, 265)

        $srt_8 = GUICtrlCreateCheckbox ("Do the same for all " & $extension & " in folder", 55, 320)
;       GUICtrlSetState ($dec_6, $GUI_CHECKED)

        $boton_oks = GUICtrlCreateButton ("&Convert",110, 360, 60, 20)
        GUICtrlSetOnEvent ($boton_oks, "srt_conv")
EndFunc

Func srt_conv()
    If StringInStr("srt|ssa|ass|txt|xml|cue|", $extension) Then
        $x = 1
        $of = GUICtrlRead($offset)
        $t0 = GUICtrlRead($delay)
        If GUICtrlRead($srt_1) == $GUI_CHECKED Then $x = 9.6 / 10.01
        If GUICtrlRead($srt_2) == $GUI_CHECKED Then $x = 1.0 / 1.001
        If GUICtrlRead($srt_3) == $GUI_CHECKED Then $x = 0.96
        If GUICtrlRead($srt_4) == $GUI_CHECKED Then $x = 1.001
        If GUICtrlRead($srt_5) == $GUI_CHECKED Then $x = 2.5 / 2.4
        If GUICtrlRead($srt_6) == $GUI_CHECKED Then $x = 10.01 / 9.6
        If GUICtrlRead($srt_7) == $GUI_CHECKED Then $x = GUICtrlRead($stretch)
        If GUICtrlRead($srt_0) == $GUI_CHECKED Then
            $line = GUICtrlRead($t11)
            $l11 = 3600000 * StringMid($line, 1, 2) + 60000 * StringMid($line, 4, 2) + 1000 * StringMid($line, 7, 2) + StringMid($line, 10, 3)
            $line = GUICtrlRead($t12)
            $l12 = 3600000 * StringMid($line, 1, 2) + 60000 * StringMid($line, 4, 2) + 1000 * StringMid($line, 7, 2) + StringMid($line, 10, 3)
            $line = GUICtrlRead($t21)
            $l21 = 3600000 * StringMid($line, 1, 2) + 60000 * StringMid($line, 4, 2) + 1000 * StringMid($line, 7, 2) + StringMid($line, 10, 3)
            $line = GUICtrlRead($t22)
            $l22 = 3600000 * StringMid($line, 1, 2) + 60000 * StringMid($line, 4, 2) + 1000 * StringMid($line, 7, 2) + StringMid($line, 10, 3)
            $x = ($l22 - $l12) / ($l21 - $l11)
            $t0 = $l12 - Round($x * $l11)
            $of = 0
        Endif
        GUICtrlSetData($cuadro_info, "Converting to file:" & @CRLF)
        $aux = 1
; @ Added option to process all files in folder input with the same extension
        If GUICtrlRead($srt_8) == $GUI_CHECKED Then $search = FileFindFirstFile($ruta_fold & "\*." & $extension)
        While 1
            If GUICtrlRead($srt_8) == $GUI_CHECKED Then
                $file = FileFindNextFile($search)
                If @error Then ExitLoop
            Else
                $file = $filename
            Endif
; @
            $ruta_filo = $ruta_fold & "\" & $file & "_s." & $extension
            If GUICtrlRead($user_def) == $GUI_CHECKED Then $ruta_filo = $ruta_out & "\" & $file & "_s." & $extension
            $srt_in = FileOpen ( $ruta_fold & "\" & $file, 0 )
            $srt_out = FileOpen ( $ruta_filo, 514 )
            $decorar = GUICtrlRead($cuadro_info) & $file & "_s." & $extension & " ..." & @CRLF
            GUICtrlSetData ($cuadro_info, $decorar)
; file process
            $p = 0
            $err = 0
            While 1
                $line = FileReadLine($srt_in)
                If @error = -1 Then ExitLoop
                If $extension == "srt" Then
                    If $x == 1 and $t0 = 0 Then   ;<font color="#ffffff">They shepherded humanity through</font>
                        While StringInStr($line, "<")
                            $p = StringInStr($line, "<")
                            $t = StringInStr($line, ">")
                            $line = StringLeft($line, $p - 1) & StringMid($line, $t + 1)
                        Wend
                        While StringInStr($line, "{")
                            $p = StringInStr($line, "{")
                            $t = StringInStr($line, "}")
                            $line = StringLeft($line, $p - 1) & StringMid($line, $t + 1)
                        Wend
                    Else
                        If StringLen($line) > 28 Then
                            If StringLeft($line, 1) & StringMid($line, 3, 1) & StringMid($line, 6, 1) == "0::" Then
                                $t = 3600000 * StringMid($line, 1, 2) + 60000 * StringMid($line, 4, 2) + 1000 * StringMid($line, 7, 2) + StringMid($line, 10, 3)
                                If $t >= $of Then
                                    $t = $t + $t0
                                    If $t < $of Then $err = $err + 1
                                EndIf
                                $t = Round($x * $t)
                                time_conv($t, ",")
                                $ti = $tf
                                $t = 3600000 * StringMid($line, 18, 2) + 60000 * StringMid($line, 21, 2) + 1000 * StringMid($line, 24, 2) + StringMid($line, 27, 3)
                                If $t >= $of Then $t = $t + $t0
                                $t = Round($x * $t)
                                time_conv($t, ",")
                                $line = $ti & " --> " & $tf
                            EndIf
                        Endif
                    Endif
                ElseIf $extension == "cue" Then
                    $p = StringInStr($line, "INDEX")
                    If $p Then
                        $p = StringInStr($line, ":")
                        If $p Then
                            $t = 60000 * StringMid($line, $p - 2, 2) + 1000 * StringMid($line, $p + 1, 2)
                            If StringLen($line) > ($p + 4) Then $t = $t + Round(1000 * StringMid($line, $p + 4, 2) / 75)
                            If $t >= $of Then
                                $t = $t + $t0
                                If $t < $of Then $err = $err + 1
                            EndIf
                            $t = Round($x * $t)
                            time_conv($t, ".")
                            $line = StringLeft($line, $p - 3) & StringMid($tf, 4)
                        Endif
                    Endif
                ElseIf $extension == "txt" Then
                    If StringLower(StringLeft($line, 7)) == "chapter" Then
                        $p = StringInStr($line, "=")
                        If StringLen($line) - $p > 11 Then
                            If StringMid($line, $p + 3, 1) & StringMid($line, $p + 6, 1) == "::" Then
                                $t = 3600000 * StringMid($line, $p + 1, 2) + 60000 * StringMid($line, $p + 4, 2) + 1000 * StringMid($line, $p + 7, 2) + 1 * StringMid($line, $p + 10, 3)
                                If $t >= $of Then
                                    $t = $t + $t0
                                    If $t < $of Then $err = $err + 1
                                EndIf
                                $t = Round($x * $t)
                                time_conv($t, ".")
                                $line = StringLeft($line, $p) & $tf
                            Endif
                        Endif
                    Endif
                ElseIf $extension == "xml" Then
                    $p = StringInStr($line, "<ChapterTime")
                    If $p Then
                        $p = $p + 16
                        If StringInStr($line, "<ChapterTimeStart>") Then $p = $p + 2
                        $t = 3600000 * StringMid($line, $p, 2) + 60000 * StringMid($line, $p + 3, 2) + 1000 * StringMid($line, $p + 6, 2) + 1 * StringMid($line, $p + 9, 3)
                        If $t >= $of Then
                            $t = $t + $t0
                            If $t < $of Then $err = $err + 1
                        EndIf
                        $t = Round($x * $t)
                        time_conv($t, ".")
                        $line = StringLeft($line, $p - 1) & $tf & StringMid($line, $p + 12)
                    Endif
                Else
                    If StringLen($line) > 34 Then
                        If StringLeft($line, 9) == "Dialogue:" Then
                            If $p == 0 Then $p = StringInStr($line, "0:")
                            $t = 3600000 * StringMid($line, $p, 1) + 60000 * StringMid($line, $p + 2, 2) + 1000 * StringMid($line, $p + 5, 2) + 10 * StringMid($line, $p + 8, 2)
                            If $t >= $of Then
                                $t = $t + $t0
                                If $t < $of Then $err = $err + 1
                            EndIf
                            $t = Round($x * $t)
                            time_conv($t, ".")
                            $ti = StringMid(StringTrimRight($tf, 1), 2)
                            $t = 3600000 * StringMid($line, $p + 11, 1) + 60000 * StringMid($line, $p + 13, 2) + 1000 * StringMid($line, $p + 16, 2) + 10 * StringMid($line, $p + 19, 2)
                            If $t >= $of Then $t = $t + $t0
                            $t = Round($x * $t)
                            time_conv($t, ".")
                            $line = StringLeft($line, $p - 1) & $ti & "," & StringMid(StringTrimRight($tf, 1), 2) & StringMid($line, $p + 21)
                        Endif
                    Endif
                Endif
                FileWriteLine($srt_out, $line)
            Wend
            FileClose($srt_in)
            FileClose($srt_out)
            If $err Then MsgBox(4096, "WARNING", "Because negative Delay there are" & @CRLF & $err & " invalid times in file:" & @CRLF & $ruta_filo, 20)
; @ Added option to process all files in folder input with the same extension
            If GUICtrlRead($srt_8) <> $GUI_CHECKED Then ExitLoop
        WEnd
        $decorar = GUICtrlRead($cuadro_info) & "Done." & @CRLF
        GUICtrlSetData ($cuadro_info, $decorar)
        If GUICtrlRead($srt_8) == $GUI_CHECKED Then FileClose($search)
        $aux = 0
; @    MsgBox(4096, "Job ended.", "Done. Created new:" & @CRLF & $ruta_filo, 10)
    Else
        MsgBox(4096, "No subs or chapter file", "Input file must be a srt, ass, ssa, txt or xml.", 10)
    Endif
    cerrar_acerca()
EndFunc

Func time_conv($z, $p)
    If $z < 0 then $z = 0
    $h = int($z / 3600000)
    $z = mod($z, 3600000)
    $m = int($z / 60000)
    $z = mod($z, 60000)
    $s = int($z / 1000)
    $i = mod($z, 1000)
    $tf = StringFormat("%02s", $h) & ":" & StringFormat("%02s", $m) & ":" & StringFormat("%02s", $s) & $p & StringFormat("%03s", $i)
EndFunc

