import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uv_app/viewmodels/sun_viewmodel.dart';
import 'package:uv_app/views/home_screen.dart';
import 'package:uv_app/views/settings_screen.dart';
import 'package:uv_app/views/widgets/sun_ring.dart';

// --- Helpers to setup the Provider environment ---
Widget createHomeScreen() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SunViewModel()),
    ],
    child: const MaterialApp(home: HomeScreen()),
  );
}

Widget createSettingsScreen() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SunViewModel()),
    ],
    child: const MaterialApp(home: SettingsScreen()),
  );
}

void main() {
  // TEST 1: Check Home Screen main elements
  testWidgets('Home Screen finds Start Protection button', (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());
    
    // Search for text that actually exists in SolarGuard
    expect(find.text('START PROTECTION'), findsOneWidget);
    expect(find.text('SolarGuard'), findsOneWidget);
  });

  // TEST 2: Check Settings Screen List
  testWidgets('Settings Screen renders Skin Types', (WidgetTester tester) async {
    await tester.pumpWidget(createSettingsScreen());
    
    expect(find.text('Type I'), findsOneWidget);
    expect(find.text('Type VI'), findsOneWidget);
  });

  // TEST 3: Check Toggle Timer Interaction
  testWidgets('Tapping Start button changes text to Pause', (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());

    // 1. Verify initial state
    expect(find.text('START PROTECTION'), findsOneWidget);

    // 2. Tap the button
    await tester.tap(find.text('START PROTECTION'));
    await tester.pump(); 

    // 3. Verify text changed
    expect(find.text('PAUSE TIMER'), findsOneWidget);
  });

  // TEST 4: ISOLATED WIDGET TEST (SunRing) - UPDATED!
  testWidgets('SunRing displays correct minutes', (WidgetTester tester) async {
    // 1. Create a dummy ViewModel with specific data
    final mockVM = SunViewModel();
    mockVM.maxSafeMinutes = 20;  
    mockVM.secondsRemaining = 1200; 

    // 2. Pump the SunRing wrapped in a Provider that holds our mock data
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SunViewModel>.value(value: mockVM),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SunRing(), 
          ),
        ),
      ),
    );

    // 3. Verify it calculated "20m" correctly
    expect(find.text('20m'), findsOneWidget);
    expect(find.text('SAFE TIME'), findsOneWidget);
  });
}