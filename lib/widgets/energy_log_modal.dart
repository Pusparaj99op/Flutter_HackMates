import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/activity_log_model.dart';

class EnergyLogModal extends StatefulWidget {
  const EnergyLogModal({super.key});

  @override
  State<EnergyLogModal> createState() => _EnergyLogModalState();
}

class _EnergyLogModalState extends State<EnergyLogModal> {
  String _selectedSource = 'Electricity';
  final _usageController = TextEditingController(text: '10.0');
  final _notesController = TextEditingController();
  bool _isLoading = false;

  final List<String> _energySources = [
    'Electricity',
    'Gas',
  ];

  @override
  Widget build(BuildContext context) {
    final usage = double.tryParse(_usageController.text) ?? 0.0;
    final co2Estimate = ActivityLogModel.calculateEnergyCO2(
      source: _selectedSource,
      usageKwh: usage,
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Log Energy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Energy Source',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ..._energySources.map((source) {
                return RadioListTile<String>(
                  title: Text(source),
                  value: source,
                  groupValue: _selectedSource,
                  onChanged: (value) {
                    setState(() {
                      _selectedSource = value!;
                    });
                  },
                  activeColor: const Color(0xFF4CAF50),
                );
              }),
              const SizedBox(height: 16),
              TextField(
                controller: _usageController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Usage (kWh)',
                  prefixIcon: const Icon(Icons.bolt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                maxLength: 200,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'Add any additional details...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Estimated CO₂ Impact',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${co2Estimate}g CO₂',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveLog,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save Log'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveLog() async {
    final usage = double.tryParse(_usageController.text);

    if (usage == null || usage <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid usage amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final user = authService.currentUser;

      if (user == null) {
        throw Exception('No user logged in');
      }

      final co2Grams = ActivityLogModel.calculateEnergyCO2(
        source: _selectedSource,
        usageKwh: usage,
      );

      final firestoreService = FirestoreService();
      await firestoreService.createActivityLog(
        userId: user.uid,
        category: 'energy',
        co2Grams: co2Grams,
        details: {
          'source': _selectedSource,
          'usageKwh': usage,
        },
        notes: _notesController.text,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Energy log saved! +${co2Grams ~/ 10} points'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving log: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _usageController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
