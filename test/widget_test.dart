import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uv_app/viewmodels/sun_viewmodel.dart';
import 'package:uv_app/views/home_screen.dart';
import 'package:uv_app/views/settings_screen.dart';
import 'package:uv_app/views/widgets/sun_ring.dart';

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

  // TEST 4: ISOLATED WIDGET TEST (SunRing)
  testWidgets('SunRing displays correct minutes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          // Pass dummy data: 50% progress, 1200 seconds (20 mins)
          body: SunRing(progress: 0.5, secondsRemaining: 1200),
        ),
      ),
    );

    // Verify it calculated "20m" correctly
    expect(find.text('20m'), findsOneWidget);
    expect(find.text('SAFE TIME'), findsOneWidget);
  });
}
