import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sun_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Data for the list (Fitzpatrick Scale)
  final List<Map<String, dynamic>> skinTypes = const [
    {"type": 1, "label": "Type I", "desc": "Pale white skin, burns always, never tans."},
    {"type": 2, "label": "Type II", "desc": "Fair skin, burns easily, tans poorly."},
    {"type": 3, "label": "Type III", "desc": "Darker white skin, tans after initial burn."},
    {"type": 4, "label": "Type IV", "desc": "Light brown skin, burns minimally, tans easily."},
    {"type": 5, "label": "Type V", "desc": "Brown skin, rarely burns, tans dark profiles."},
    {"type": 6, "label": "Type VI", "desc": "Dark brown or black skin, never burns."},
  ];

  @override
  Widget build(BuildContext context) {
    // Access the VM to see current selection
    var vm = Provider.of<SunViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Skin Type Settings"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: const Text(
              "Select your skin type to calculate accurate burn times. "
              "The Fitzpatrick scale classifies skin based on its response to UV light.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: skinTypes.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final typeData = skinTypes[index];
                final int typeNum = typeData['type'];
                final bool isSelected = vm.userSkinType == typeNum;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? Colors.orange : Colors.grey.shade200,
                    child: Text(
                      "$typeNum",
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(typeData['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(typeData['desc']),
                  trailing: isSelected 
                      ? const Icon(Icons.check_circle, color: Colors.orange) 
                      : null,
                  onTap: () {
                    // Update the global state
                    vm.setSkinType(typeNum);
                    
                    // Go back to Home
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}