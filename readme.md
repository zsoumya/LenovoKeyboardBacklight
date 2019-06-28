# Readme
By default, the backlit keyboards of the Lenovo laptops do not turn on. One has to hit Fn + Spacebar once to turn them on with a lower intensity and Fn + Spacebar twice for the full glow. This project attempts to fix this minor annoyance in life by turning on the keyboard backlight to its full glow when:

 - The laptop powers on
 - The laptop wakes up from sleep

The idea behind this project is simple. Lenovo laptops (at least the 2018-2019 ones, one of which I have, a P52) ship with a DLL called **Keyboard_Core.dll** which is located in the following folder: **<ins>C:\ProgramData\Lenovo\ImController\Plugins\ThinkKeyboardPlugin\x86</ins>**. This is a .Net Framework class library (most likely written in C++/CLI) that exposes a public class called `KeyboardControl` which has two methods:

- `GetKeyboardBackLightLevel` - Returns an integer corresponding to the maximum backlight level of the keyboard
- `SetKeyboardBackLightStatus` - Sets the keyboard backlight to a specific level, 0 being backlight off.

**LenovoKeyboardBacklight.ps1** is a simple PowerShell script that references this **Keyboard_Core.dll**, instantiates the `KeyboardControl` class and invokes the two aforementioned methods in succession to turn on the keyboard backlight.

> This would have been a trivial task except for a tricky gotcha: The **Keyboard_Core.dll** is an x86 DLL. This means the PowerShell script cannot be run with x64 PowerShell. So the script checks the bitness of the environment first and switches to x86 PowerShell if it detects a x64 environment.

> No extra care was taken with the code, no error checking, no smart functionality. Only tested on my Lenovo P52.

**Turn On Lenovo Keyboard Backlight.xml** is a Windows Task Scheduler task that invokes LenovoKeyboardBacklight.ps1 when the laptop powers on and when it wakes up from sleep. The wake up trigger is accomplished by hooking up to an event with the following parameters:

- Log: System
- Source: Power-Troubleshooter
- Event ID: 1

More info on this can be found at:
- https://sumtips.com/how-to/run-program-windows-wakes-up-sleep-hibernate/
- https://superuser.com/questions/84442/trigger-task-scheduler-in-windows-7-when-computer-wakes-up-from-sleep-hibernate
