import 'package:firebase_core/firebase_core.dart';
import 'package:ovadrive/providers/active_theme.dart';
import 'package:ovadrive/screens/chat.dart';
import 'package:ovadrive/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: activeTheme == Themes.light ? ThemeMode.light : ThemeMode.dark,
      home: const Chat(),
    );
  }
}
