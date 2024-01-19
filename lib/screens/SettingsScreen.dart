import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProviderWidget(
      builder: (context, isDarkMode) {
        return MaterialApp(
          title: "HuruChat",
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: SettingsScreen(),
        );
      },
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  bool _receiveNotifications = true;
  bool _showOnlineStatus = true;
  String _selectedTheme = 'Light';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _receiveNotifications = _prefs.getBool('receiveNotifications') ?? true;
      _showOnlineStatus = _prefs.getBool('showOnlineStatus') ?? true;
      _selectedTheme = _prefs.getString('selectedTheme') ?? 'Light';
    });
  }

  _saveSettings() async {
    await _prefs.setBool('receiveNotifications', _receiveNotifications);
    await _prefs.setBool('showOnlineStatus', _showOnlineStatus);
    await _prefs.setString('selectedTheme', _selectedTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Receive Notifications'),
              value: _receiveNotifications,
              onChanged: (value) {
                setState(() {
                  _receiveNotifications = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: Text('Show Online Status'),
              value: _showOnlineStatus,
              onChanged: (value) {
                setState(() {
                  _showOnlineStatus = value;
                });
                _saveSettings();
              },
            ),
            ListTile(
              title: Text('Theme'),
              trailing: DropdownButton<String>(
                value: _selectedTheme,
                items: ['Light', 'Dark']
                    .map((theme) => DropdownMenuItem(
                          value: theme,
                          child: Text(theme),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                  _saveSettings();
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeProviderWidget extends StatelessWidget {
  final Widget Function(BuildContext, bool) builder;

  const ThemeProviderWidget({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return builder(
              context, Provider.of<ThemeProvider>(context).isDarkMode);
        },
      ),
    );
  }
}
