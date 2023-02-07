# Shortcuts Bug

A demo project which demonstrate a shortcuts bug (I had it on windows 10).

## Versions used

Flutter: 3.7.0

window_manager: 0.3.0

OS: Windows 10

## How to produce the problem

1. Start app on Windows
2. Press `Arrow Down` or `Arrow Up` Key, which will decrease or increase the Counter
3. Press `ESC` (Escape Key) to hide the window via window_manager
4. Press `Ctrl + Alt + Space` to show the window again
5. Now the shortcuts Arrow Up and Arrow Down don't work anymore. Type something in the textfield and press `Arrow Up` and `Arrow Down` will now have the default behavior.

Also shortcuts which includes Ctrl + another-key will also trigger by just press `Ctrl` alone.

## Workaround

Only app reload fix the problem.
