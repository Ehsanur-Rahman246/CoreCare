import 'package:core_care/boarding_screen.dart';
import 'package:core_care/pages/diet_module.dart';
import 'package:core_care/pages/fitness_module.dart';
import 'package:core_care/pages/home_screen.dart';
import 'package:core_care/pages/login_screen.dart';
import 'package:core_care/pages/profile_page.dart';
import 'package:core_care/pages/shop_module.dart';
import 'package:core_care/time_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(create: (_) => TimeProvider(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void updateTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoreCare',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: const OnboardingScreen(),
      routes: {
        '/home': (context) => ScreenState(),
        '/profile': (context) => ProfilePage(),
        '/settings': (context) =>
            SettingsPage(currentTheme: _themeMode, onThemeChanged: updateTheme),
        '/login': (context) => LoginScreen(),
        '/notifications': (context) => NotificationsPage(),
        '/fit': (context) => FitScreen(),
        '/diet': (context) => DietScreen(),
        '/shop': (context) => ShopScreen(),
        // '/google': (context) => GoogleLoginScreen(),
        // '/apple': (context) => AppleLoginScreen(),
        '/signup': (context) => SignupPage(),
        '/onboard': (context) => OnboardingScreen(),
        '/auth' : (context) => AuthPage(),
      },
    );
  }
}

final ColorScheme lightMode = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff009999),
  onPrimary: Color(0xfffcfcfc),
  secondary: Color(0xff009999),
  onSecondary: Color(0xfffcfcfc),
  error: Color(0xffcc0000),
  onError: Color(0xffffe6e6),
  surface: Color(0xfff2f2f2),
  onSurface: Color(0xff0d0d0d),
  outline: Color(0xff009999),
  shadow: Color(0xff007a7a).withValues(alpha: 0.25),
  tertiary: Color(0xffdddddd),
  //background
  onTertiary: Color(0xff4d4d4d),
  //mutedText
  errorContainer: Color(0xffe53935), //badge
);

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xffe6e6e6),
  colorScheme: lightMode,
  textTheme: customTexts(lightMode),
  useMaterial3: true,
  appBarTheme: AppBarTheme(centerTitle: false),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 20,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    menuPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 5,
    position: PopupMenuPosition.under,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    fillColor: Color(0xfff2f2f2),
    iconColor: Color(0xff4d4d4d),
    labelStyle: TextStyle(fontSize: 14, color: Color(0xffdddddd)),
    floatingLabelStyle: TextStyle(color: Color(0xff009999)),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    hintStyle: TextStyle(fontSize: 14, color: Color(0xff4d4d4d)),
    helperStyle: TextStyle(fontSize: 12, color: Color(0xff0d0d0d)),
    errorStyle: TextStyle(fontSize: 10, color: Color(0xffb71c1c)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xffb71c1c)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xff009999)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xffb71c1c)),
    ),
  ),
  badgeTheme: BadgeThemeData(
    backgroundColor: Color(0xffe53935),
    alignment: Alignment.topRight,
  ),
);

final ColorScheme darkMode = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff33cccc),
  onPrimary: Color(0xff030303),
  secondary: Color(0xff33cccc),
  onSecondary: Color(0xff030303),
  error: Color(0xffff6666),
  onError: Color(0xff660000),
  surface: Color(0xff262626),
  onSurface: Color(0xfff2f2f2),
  outline: Color(0xff33cccc),
  shadow: Color(0xff248f8f).withValues(alpha: 0.35),
  tertiary: Color(0xff4d4d4d),
  //background
  onTertiary: Color(0xffb3b3b3),
  //mutedText
  errorContainer: Color(0xffff6e6e), //badge
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xff1a1a1a),
  colorScheme: darkMode,
  textTheme: customTexts(darkMode),
  useMaterial3: true,
  appBarTheme: AppBarTheme(centerTitle: false),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 20,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    menuPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 5,
    position: PopupMenuPosition.under,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xff262626),
    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    iconColor: Color(0xffdddddd),
    labelStyle: TextStyle(fontSize: 14, color: Color(0xff4d4d4d)),
    floatingLabelStyle: TextStyle(color: Color(0xff33cccc)),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    hintStyle: TextStyle(fontSize: 14, color: Color(0xffdddddd)),
    helperStyle: TextStyle(fontSize: 12, color: Color(0xfff2f2f2)),
    errorStyle: TextStyle(fontSize: 10, color: Color(0xfff28b82)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xfff28b82)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xff33cccc)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xfff28b82)),
    ),
  ),
  badgeTheme: BadgeThemeData(
    backgroundColor: Color(0xffff6e6e),
    largeSize: 20,
    padding: const EdgeInsets.all(8),
    alignment: Alignment.topRight,
  ),
);

TextTheme customTexts(ColorScheme scheme) {
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: "Montserrat",
      fontSize: 32,
      fontWeight: FontWeight(700),
      color: scheme.onSurface,
    ),
    displayMedium: TextStyle(
      fontFamily: "Montserrat",
      fontSize: 28,
      fontWeight: FontWeight(600),
      color: scheme.onSurface,
    ),
    displaySmall: TextStyle(
      fontFamily: "Montserrat",
      fontSize: 22,
      fontWeight: FontWeight(400),
      color: scheme.onSurface,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight(700),
      color: scheme.onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: "Poppins",
      fontSize: 22,
      fontWeight: FontWeight(600),
      color: scheme.onSurface,
    ),
    headlineSmall: TextStyle(
      fontFamily: "Poppins",
      fontSize: 18,
      fontWeight: FontWeight(500),
      color: scheme.onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: "Poppins",
      fontSize: 20,
      fontWeight: FontWeight(600),
      color: scheme.onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: "Poppins",
      fontSize: 20,
      fontWeight: FontWeight(500),
      color: scheme.onSurface,
    ),
    titleSmall: TextStyle(
      fontFamily: "Poppins",
      fontSize: 18,
      fontWeight: FontWeight(400),
      color: scheme.onSurface,
    ),
    bodyLarge: TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      fontWeight: FontWeight(400),
      color: scheme.onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      fontWeight: FontWeight(400),
      color: scheme.onSurface,
    ),
    bodySmall: TextStyle(
      fontFamily: "Poppins",
      fontSize: 12,
      fontWeight: FontWeight(400),
      color: scheme.onSurface,
    ),
    labelLarge: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      fontWeight: FontWeight(300),
      color: scheme.onTertiary,
    ),
    labelMedium: TextStyle(
      fontFamily: "Poppins",
      fontSize: 12,
      fontWeight: FontWeight(300),
      color: scheme.onTertiary,
    ),
    labelSmall: TextStyle(
      fontFamily: "Poppins",
      fontSize: 10,
      fontWeight: FontWeight(300),
      color: scheme.onTertiary,
    ),
  );
}

class CustomColors {
  CustomColors._();

  static bool _isDark(BuildContext context) =>
      Theme.of(context).colorScheme.brightness == Brightness.dark;

  static Color redPrimary(BuildContext context) =>
      _isDark(context) ? const Color(0xffff6b6b) : Color(0xffd32f2f);

  static Color redOutline(BuildContext context) =>
      _isDark(context) ? const Color(0xffff8787) : Color(0xffe53935);

  static Color redMuted(BuildContext context) =>
      _isDark(context) ? const Color(0xff662222) : Color(0xfff5c6c6);

  static Color bluePrimary(BuildContext context) =>
      _isDark(context) ? const Color(0xff4dabf5) : Color(0xff1565c0);

  static Color blueOutline(BuildContext context) =>
      _isDark(context) ? const Color(0xff80c1ff) : Color(0xff1976d2);

  static Color blueMuted(BuildContext context) =>
      _isDark(context) ? const Color(0xff224466) : Color(0xffcce0f5);

  static Color greenPrimary(BuildContext context) =>
      _isDark(context) ? const Color(0xff6edc82) : Color(0xff2e7d32);

  static Color greenOutline(BuildContext context) =>
      _isDark(context) ? const Color(0xff8ff2a0) : Color(0xff388e3c);

  static Color greenMuted(BuildContext context) =>
      _isDark(context) ? const Color(0xff225522) : Color(0xffc8e6c9);

  static Color yellowPrimary(BuildContext context) =>
      _isDark(context) ? const Color(0xfffdd54f) : Color(0xfffbc02d);

  static Color yellowOutline(BuildContext context) =>
      _isDark(context) ? const Color(0xffffe082) : Color(0xfffdd835);

  static Color yellowMuted(BuildContext context) =>
      _isDark(context) ? const Color(0xff665522) : Color(0xfffff9c4);

  static Color purplePrimary(BuildContext context) =>
      _isDark(context) ? const Color(0xffb084f5) : Color(0xff6a1b9a);

  static Color purpleOutline(BuildContext context) =>
      _isDark(context) ? const Color(0xffc4a3ff) : Color(0xff7b1fa2);

  static Color purpleMuted(BuildContext context) =>
      _isDark(context) ? const Color(0xff332244) : Color(0xffe1bee7);

  static Color orangePrimary(BuildContext context) =>
      _isDark(context) ? const Color(0xffffa657) : Color(0xfff57c00);

  static Color orangeOutline(BuildContext context) =>
      _isDark(context) ? const Color(0xffffc078) : Color(0xfffb8c00);

  static Color orangeMuted(BuildContext context) =>
      _isDark(context) ? const Color(0xff664422) : Color(0xffffe0b2);

  static Color greyDark(BuildContext context) =>
      _isDark(context) ? const Color(0xff595959) : Color(0xff4d4d4d);

  static Color greyLight(BuildContext context) =>
      _isDark(context) ? const Color(0xffbfbfbf) : Color(0xffd9d9d9);

  static Color white(BuildContext context) =>
      _isDark(context) ? const Color(0xfff7f7f7) : Color(0xffffffff);

  static Color black(BuildContext context) =>
      _isDark(context) ? const Color(0xff000000) : Color(0xff080808);

  static Color back(BuildContext context) => _isDark(context)
      ? const Color(0xff000000).withValues(alpha: 0.6)
      : Color(0xff000000).withValues(alpha: 0.4);
}

class ScreenState extends StatefulWidget {
  const ScreenState({super.key});

  @override
  State<ScreenState> createState() => _ScreenStateState();
}

class _ScreenStateState extends State<ScreenState> {
  int _selectedIndex = 0;

  void _changeIndex(int idx) {
    setState(() {
      _selectedIndex = idx;
    });
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(onNavigate: _changeIndex),
      FitScreen(),
      DietScreen(),
      ShopScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        animationDuration: Duration(milliseconds: 300),
        destinations: [
          NavigationDestination(
            icon: Icon(Symbols.home_filled_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Symbols.exercise),
            label: 'Exercise',
          ),
          NavigationDestination(
            icon: Icon(Symbols.dinner_dining),
            label: 'Meals',
          ),
          NavigationDestination(
            icon: Icon(Symbols.shopping_cart_rounded),
            label: 'Shop',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _changeIndex,
      ),
    );
  }
}
