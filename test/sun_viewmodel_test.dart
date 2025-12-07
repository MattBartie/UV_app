import 'package:flutter_test/flutter_test.dart';
import 'package:uv_app/viewmodels/sun_viewmodel.dart'; 

void main() {
  group('SunViewModel Logic Tests', () {
    late SunViewModel viewModel;

    setUp(() {
      viewModel = SunViewModel();
    });

    test('Calculate Safe Time logic works correctly for Skin Type 2', () {
      // 1. Arrange
      viewModel.uvIndex = 5.0; 
      viewModel.userSkinType = 2; // Constant is 100

      // 2. Act
      viewModel.setSkinType(2);

      // 3. Assert: 100 / 5 = 20 minutes
      expect(viewModel.maxSafeMinutes, 20);
    });
  });
}