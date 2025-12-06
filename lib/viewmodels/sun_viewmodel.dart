import 'dart:async'; // Required for the Timer
import 'package:flutter/foundation.dart';
import '../models/weather_data.dart';
import '../services/api_services.dart';
import '../services/location_services.dart';

class SunViewModel extends ChangeNotifier {
  // --- DEPENDENCIES ---
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();

  // --- STATE VARIABLES (The UI listens to these) ---
  bool isLoading = false;            // Req: Loading State
  String errorMessage = '';          // Req: Error State
  double uvIndex = 0.0;              // Data from API
  int userSkinType = 3;              // Default Skin Type (3 = Average)
  
  // --- TIMER STATE ---
  int maxSafeMinutes = 0;            // Calculated safe time
  int secondsRemaining = 0;          // For the countdown animation
  bool isTimerRunning = false;
  Timer? _timer;

  // --- CONSTANTS (Fitzpatrick Scale) ---
  // Key: Skin Type (1-6), Value: Constant for math
  final Map<int, int> _skinConstants = {
    1: 67,  // Very Fair (Burns easily)
    2: 100, // Fair
    3: 200, // Medium (Average)
    4: 300, // Olive
    5: 400, // Brown
    6: 500, // Dark (Rarely burns)
  };

  // --- METHOD 1: Fetch Data (Async & MVVM) ---
  // This satisfies Req 3: Asynchronous Programming
  Future<void> refreshData() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners(); // Tells UI to show spinner

    try {
      // 1. Get Hardware Location (Req: Hardware Interaction logic)
      final position = await _locationService.determinePosition();

      // 2. Call API (Req: Data Source Integration)
      final weatherData = await _apiService.fetchUV(
        position.latitude, 
        position.longitude
      );

      uvIndex = weatherData.uvIndex;
      _calculateSafeTime(); // Update math immediately

    } catch (e) {
      errorMessage = e.toString(); // Catch errors for UI
    } finally {
      isLoading = false;
      notifyListeners(); // Tells UI to re-render
    }
  }

  // --- METHOD 2: Business Logic (Math) ---
  void _calculateSafeTime() {
    if (uvIndex <= 0) {
      maxSafeMinutes = 999; // Safe indefinitely at night
    } else {
      int constant = _skinConstants[userSkinType] ?? 200;
      // Formula: Minutes = Constant / UV Index
      maxSafeMinutes = (constant / uvIndex).round();
    }
    
    // Reset timer if data changes
    stopTimer();
    secondsRemaining = maxSafeMinutes * 60; 
  }

  // --- METHOD 3: Update Skin Type (For Settings Screen) ---
  void setSkinType(int newType) {
    userSkinType = newType;
    _calculateSafeTime(); // Recalculate immediately
    notifyListeners();
  }

  // --- METHOD 4: Timer Logic (For Animation) ---
  void toggleTimer() {
    if (isTimerRunning) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  void startTimer() {
    isTimerRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        notifyListeners(); // Updates the Progress Ring every second
      } else {
        stopTimer();
        // Here is where you would trigger Haptics/Vibration later!
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    isTimerRunning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cleanup to prevent memory leaks
    super.dispose();
  }
}