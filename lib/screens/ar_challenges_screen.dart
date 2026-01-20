import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/challenge_model.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/challenge_card.dart';

class ARChallengesScreen extends StatefulWidget {
  const ARChallengesScreen({super.key});

  @override
  State<ARChallengesScreen> createState() => _ARChallengesScreenState();
}

class _ARChallengesScreenState extends State<ARChallengesScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 2;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          _cameraController = CameraController(
            cameras.first,
            ResolutionPreset.medium,
          );
          await _cameraController!.initialize();
          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      } catch (e) {
        print('Camera initialization error: $e');
      }
    }
  }

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/tracker');
        break;
      case 2:
        // Already on AR challenges
        break;
      case 3:
        Navigator.pushNamed(context, '/social');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Challenges'),
      ),
      body: Column(
        children: [
          // Camera Preview
          if (_isCameraInitialized && _cameraController != null)
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  CameraPreview(_cameraController!),
                  if (_isProcessing)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Point camera at objects to detect',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Camera access required',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Challenge List
          Expanded(
            flex: 3,
            child: StreamBuilder<List<ChallengeModel>>(
              stream: _firestoreService.getChallenges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final challenges = snapshot.data ?? [];

                return StreamBuilder<Map<String, int>>(
                  stream: _firestoreService.getTodayChallengeCompletions(user.uid),
                  builder: (context, completionSnapshot) {
                    final completions = completionSnapshot.data ?? {};

                    return ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        const Text(
                          'Today\'s Challenges',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${completions.length}/${challenges.length} completed',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...challenges.map((challenge) {
                          final completionCount = completions[challenge.challengeId] ?? 0;
                          final isCompleted = completionCount >= challenge.dailyLimit;

                          return ChallengeCard(
                            challenge: challenge,
                            isCompleted: isCompleted,
                            onStart: () => _startChallenge(challenge),
                          );
                        }),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }

  Future<void> _startChallenge(ChallengeModel challenge) async {
    if (!_isCameraInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not available')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate AR detection (in real app, use ML Kit)
    await Future.delayed(const Duration(seconds: 2));

    final authService = context.read<AuthService>();
    final user = authService.currentUser;

    if (user != null) {
      try {
        await _firestoreService.recordChallengeCompletion(
          userId: user.uid,
          challengeId: challenge.challengeId,
          pointsAwarded: challenge.pointValue,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Challenge completed! +${challenge.pointValue} points'),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }

    setState(() => _isProcessing = false);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
