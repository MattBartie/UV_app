import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/sun_viewmodel.dart';
import 'views/home_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. MVVM Setup: We "Provide" the ViewModel to the whole app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SunViewModel()),
      ],
      child: MaterialApp(
        title: 'SolarGuard',
        debugShowCheckedModeBanner: false, // Polish: Hides the 'Debug' sash
        
        // 2. Production Polish: Consistent Theming
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange, // Solar themed
            brightness: Brightness.light,
          ),
          // Polish: Better typography defaults
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            bodyLarge: TextStyle(fontSize: 18),
          ),
        ),
        
        // 3. Navigation: We start at the Home Screen
        home: const HomeScreen(),
      ),
    );
  }
}