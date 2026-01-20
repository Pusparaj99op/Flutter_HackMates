import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/quick_log_card.dart';
import '../widgets/leaderboard_item.dart';
import '../widgets/food_log_modal.dart';
import '../widgets/transport_log_modal.dart';
import '../widgets/energy_log_modal.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/tracker');
        break;
      case 2:
        Navigator.pushNamed(context, '/ar-challenges');
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/auth');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<UserModel?>(
          stream: _firestoreService.getUserProfile(user.uid),
          builder: (context, snapshot) {
            final userName = snapshot.data?.name ?? 'User';
            final hour = DateTime.now().hour;
            final greeting = hour < 12
                ? 'Good Morning'
                : hour < 18
                    ? 'Good Afternoon'
                    : 'Good Evening';
            return Text('$greeting, $userName!');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/auth');
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder<UserModel?>(
          stream: _firestoreService.getUserProfile(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No profile data found'));
            }

            final userProfile = snapshot.data!;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CO2 Progress Circle
                  Center(
                    child: _buildCO2ProgressCircle(userProfile),
                  ),
                  const SizedBox(height: 24),

                  // Streak Counter
                  _buildStreakCard(userProfile),
                  const SizedBox(height: 24),

                  // Quick Log Section
                  const Text(
                    'Quick Log',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: QuickLogCard(
                          category: 'Food',
                          icon: Icons.restaurant,
                          title: 'Log Meal',
                          onTap: () => _showFoodLogModal(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: QuickLogCard(
                          category: 'Transport',
                          icon: Icons.directions_car,
                          title: 'Log Trip',
                          onTap: () => _showTransportLogModal(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: QuickLogCard(
                          category: 'Energy',
                          icon: Icons.bolt,
                          title: 'Log Usage',
                          onTap: () => _showEnergyLogModal(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Top 3 Leaderboard
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Top Eco Warriors',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/social');
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTopLeaderboard(userProfile.city),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }

  Widget _buildCO2ProgressCircle(UserModel user) {
    final progress = user.weeklyTarget > 0
        ? (user.totalCO2Saved / user.weeklyTarget).clamp(0.0, 1.0)
        : 0.0;

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${user.totalCO2Saved}g',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const Text(
                'CO₂ Saved',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '🌿',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Text(
              '🔥',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.currentStreak} Day Streak',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Keep logging to maintain your streak!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopLeaderboard(String city) {
    return StreamBuilder<List<UserModel>>(
      stream: _firestoreService.getCityLeaderboard(city, limit: 3),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No leaderboard data yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          );
        }

        final topUsers = snapshot.data!;

        return Column(
          children: topUsers.asMap().entries.map((entry) {
            final rank = entry.key + 1;
            final user = entry.value;
            return LeaderboardItem(
              rank: rank,
              name: user.name,
              points: user.points,
              totalCO2: user.totalCO2Saved,
            );
          }).toList(),
        );
      },
    );
  }

  void _showFoodLogModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FoodLogModal(),
    );
  }

  void _showTransportLogModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TransportLogModal(),
    );
  }

  void _showEnergyLogModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EnergyLogModal(),
    );
  }
}
