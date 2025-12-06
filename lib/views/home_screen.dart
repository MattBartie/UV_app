import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sun_viewmodel.dart';
import 'settings_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // Helper to pick background colors based on UV
  // Feature: Animation (Background Gradient)
  List<Color> _getGradientColors(double uv) {
    if (uv < 3) return [Colors.blue.shade300, Colors.green.shade200];
    if (uv < 6) return [Colors.yellow.shade400, Colors.orange.shade300];
    return [Colors.orange.shade800, Colors.red.shade900];
  }

  @override
  void initState() {
    super.initState();
    // Fetch data as soon as the app starts
    // Use addPostFrameCallback to avoid build collisions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SunViewModel>(context, listen: false).refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SunViewModel>(context);

    return Scaffold(
      extendBodyBehindAppBar: true, // Lets gradient go behind header
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("SolarGuard", style: TextStyle(color: Colors.white)),
        actions: [
          // Req 5: Navigation (Settings Button)
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          )
        ],
      ),
      body: AnimatedContainer(
        // Feature: Animation 1 (Daylight Gradient)
        duration: const Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _getGradientColors(vm.uvIndex),
          ),
        ),
        child: RefreshIndicator(
          // Feature: Gesture (Pull-to-Refresh)
          onRefresh: vm.refreshData,
          color: Colors.orange,
          child: ListView(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
            children: [
              
              // 1. Error Handling State
              if (vm.errorMessage.isNotEmpty)
                Card(
                  color: Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(vm.errorMessage, style: const TextStyle(color: Colors.red)),
                  ),
                ),

              const SizedBox(height: 20),

              // 2. The Main UV Display
              Center(
                child: Column(
                  children: [
                    if (vm.isLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else
                      Text(
                        "${vm.uvIndex.toStringAsFixed(1)}",
                        style: const TextStyle(
                          fontSize: 80, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white
                        ),
                      ),
                    const Text(
                      "UV INDEX",
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // 3. The Animated Timer Ring
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Circle
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 15,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    // Feature: Animation 2 (Filling Ring)
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0.0, 
                          end: vm.maxSafeMinutes > 0 
                              ? vm.secondsRemaining / (vm.maxSafeMinutes * 60)
                              : 0.0
                        ),
                        duration: const Duration(milliseconds: 1000), // Smooth update
                        builder: (context, value, _) {
                          return CircularProgressIndicator(
                            value: value,
                            strokeWidth: 15,
                            color: Colors.white,
                            strokeCap: StrokeCap.round,
                          );
                        },
                      ),
                    ),
                    // Timer Text inside the ring
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${(vm.secondsRemaining / 60).floor()}m",
                          style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const Text("SAFE TIME", style: TextStyle(color: Colors.white70)),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 4. Timer Control Button
              ElevatedButton(
                onPressed: vm.toggleTimer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                ),
                child: Text(
                  vm.isTimerRunning ? "PAUSE TIMER" : "START PROTECTION",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              
              const SizedBox(height: 50), // Spacing for scrolling
            ],
          ),
        ),
      ),
    );
  }
}