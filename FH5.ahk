#NoEnv
#MaxThreadsperHotkey 2
#SingleInstance ignore
SetKeyDelay, 35
SendMode Input

Class Car{
    __New(MANVNUM, MANHNUM, MANVDIR, MANHDIR, MODELNUM, MODELDIR, MONEY, HOWMANY)
    {
        this.MANVNUM := MANVNUM
        this.MANHNUM := MANHNUM
        this.MANVDIR := MANVDIR
        this.MANHDIR := MANHDIR
        this.MODELNUM := MODELNUM
        this.MODELDIR := MODELDIR
        this.MONEY := MONEY
        this.HOWMANY := HOWMANY
    }
}

car := new Car(0,0,"{DOWN}","{RIGHT}",0,"{LEFT}",20000,2)
daytona := new Car(16,4,"{DOWN}","{RIGHT}",1,"{LEFT}", 10000000,1)

FOUNDCAR = 0

q:: ; q hotkey.
    ; Waiting for search menu
    WinGetPos, winX, winY, winWidth, winHeight, A
    While % car.HOWMANY > 0
    {
        Loop
        { ; be sure we returned to main menu
            PixelGetColor, PixColor, 0.462109375*winWidth, 0.7520833333333333*winHeight, RGB
            if (PixColor = "0xFFDE39")
            {
                Send {Enter}
                Sleep, 35 ; 35
                break
            }
        }

        ; search options
        ; Waiting for search menu
        Loop{
            PixelGetColor, PixColor, 0.401953125*winWidth,0.3388888888888889*winHeight, RGB
            if (PixColor = "0x341735"){
                break
            }
        }
        ; Clear previous options

        Loop, 6
        {
            Send {Y}
            Sleep, 30
            Send {Up}
            Sleep, 30 ; 35
        }

        ; Select Manu
        Send {Enter}
        Sleep, 30
        Loop
        { ; waiting for manfacturer menu
            PixelGetColor, PixColor, 0.160546875*winWidth, 0.2104166666666667*winHeight, RGB
            if (PixColor = "0x341735")
            {
                break
            }
        }

        Loop % car.MANHNUM
        {
            Send % car.MANHDIR
            Sleep, 40 ; 40
        }
        Sleep, 30

        Loop % car.MANVNUM
        {
            Send % car.MANVDIR
            Sleep, 40 ; 40
        }

        Send {Enter}
        Sleep, 30

        ; Waiting for search menu
        Loop{
            PixelGetColor, PixColor, 0.401953125*winWidth,0.3388888888888889*winHeight, RGB
            if (PixColor = "0x341735"){
                break
            }
        }

        Send {Down}
        Sleep, 70

        Loop % car["MODELNUM"]
        {
            Send % car["MODELDIR"]
            Sleep, 35 ; 40
        }

        Loop, 4
        {
            Send {Down}
            Sleep, 30 ; 35		
        }	

        ; Converts money to maxbuyout

        A = 0
        B = 
        MBO = 
        MTMP := car["MONEY"]
        while MTMP>9999{
            ;chop last digit
            A := A+1
            MTMP := Floor(MTMP/10)
        }
        while MTMP>99{
            MTMP:=Floor(MTMP/10)
        }
        B := MTMP
        if (B<11){
            MBO := A*10+1
        }
        else{
            MBO := A*10+Floor(B/10)
        }

        Loop, %MBO%{
            Send {Right}
            Sleep, 30
        }

        Send {Down}
        Sleep, 30
        Send {Enter}
        Sleep, 30

        ; cars list

        Sleep, 1100 ; 1100
        PixelGetColor, PixColor0, 0.2875*winWidth, 0.3430555555555556*winHeight, RGB
        if (PixColor0 = "0xF7F7F7")
        {
            FOUNDCAR = 1
        }
        else
        {
            Send {Esc}
            Sleep, 30
        }

        if(FOUNDCAR = 1)
        {
            Send {Y}
            Sleep, 70		
            Loop
            {
                PixelGetColor, PixColor, 0.612890625*winWidth, 0.3965277777777778*winHeight, RGB
                if (PixColor = "0x341735")
                {
                    Send {Down}
                    Sleep, 30
                    Send {Enter}
                    Sleep, 70	
                    break
                }
            }

            Loop
            {
                PixelGetColor, PixColor, 0.50078125*winWidth, 0.4458333333333333*winHeight, RGB
                if (PixColor = "0x341735")
                {
                    Send {Enter}
                    break
                }
            }

            ; check if bought
            Sleep 10000
            Send {Enter}
            Sleep, 5000
            Send {Esc}
            Sleep, 5000
            Send {Enter}
            Sleep, 5000
            Loop
            {
                PixelGetColor, PixColor, 0.135546875*winWidth, 0.6930555555555556*winHeight, RGB
                if (PixColor = "0x3cc64f")
                {
                    FOUNDCAR = 0
                    car.HOWMANY--
                    Send {Esc}
                    Sleep, 2000
                    Send {Esc}
                    Sleep, 2000
                    break
                }
                else{
                    FOUNDCAR = 0
                    Send {Esc}
                    Sleep, 2000
                    Send {Esc}
                    Sleep, 2000
                    break
                }
            }				
        }
        Sleep, 1000
    }
    MsgBox, "SUCCESS!"
return
