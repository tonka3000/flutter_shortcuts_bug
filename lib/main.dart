import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';

class DownIntent extends Intent {}

class UpIntent extends Intent {}

class EscapeIntent extends Intent {}

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

Future<void> initGlobalHotkeys() async {
  await hotKeyManager.unregisterAll();
  var ShowHotkey = HotKey(KeyCode.space,
      modifiers: [KeyModifier.control, KeyModifier.alt],
      scope: HotKeyScope.system);
  await hotKeyManager.register(ShowHotkey, keyDownHandler: (hotKey) async {
    if (!(await windowManager.isVisible())) {
      await windowManager.show();
      await windowManager.focus();
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isDesktop) {
    await windowManager.ensureInitialized();
    //await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.setSize(const Size(800, 600));
      await windowManager.setMinimumSize(const Size(350, 600));
      await windowManager.center();
      await windowManager.show();
      await windowManager.setSkipTaskbar(false);
      await initGlobalHotkeys();
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter broken Shortcuts Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Shortcuts broken Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.arrowDown): DownIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowUp): UpIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): EscapeIntent()
        },
        child: Actions(
            actions: {
              DownIntent: CallbackAction<DownIntent>(onInvoke: (intent) {
                setState(() {
                  _counter--;
                });
              }),
              UpIntent: CallbackAction<UpIntent>(onInvoke: (intent) {
                setState(() {
                  _counter++;
                });
              }),
              EscapeIntent:
                  CallbackAction<EscapeIntent>(onInvoke: (intent) async {
                await windowManager.hide();
              })
            },
            child: Scaffold(
                body: Column(
              children: <Widget>[
                const TextField(
                  autofocus: true,
                ),
                const Text(
                  'Arrow Down or Arrow Up:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Text(
                          "Reproduce the bug",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Text(
                            "1. Press `Arrow Down` or `Arrow Up` Key, which will decrease or increase the Counter"),
                        const Text(
                            "2. Press `ESC` (Escape Key) to hide the window via window_manager"),
                        const Text(
                            "3. Press `Ctrl + Alt + Space` to show the window again"),
                        const Text(
                            "4. Now the shortcuts Arrow Up and Arrow Down don't work anymore."),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Type something in the textfield and press `Arrow Up` and `Arrow Down` will now have the default behavior.",
                        )
                      ],
                    ))
              ],
            ))));
  }
}
