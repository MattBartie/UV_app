import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/sun_viewmodel.dart';

class SunRing extends StatelessWidget {
  const SunRing({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the ViewModel
    final vm = Provider.of<SunViewModel>(context);

    // 2. Return the Stack for the Animated Timer Ring
    return Center(
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
                // The progress indicator shows how much time is *remaining*.
                // The formula for a countdown progress bar should be (1.0 - value)
                return CircularProgressIndicator(
                  value: 1.0 - value, // This is the fix to make it a countdown ring
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
    );
  }
}