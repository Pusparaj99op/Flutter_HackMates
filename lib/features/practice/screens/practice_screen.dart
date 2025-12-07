import 'package:flutter/material.dart';
import '../../shared/widgets/custom_card.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice & Learn'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Challenges'),
            Tab(text: 'Tutorials'),
            Tab(text: 'Progress'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChallengesTab(),
          _buildTutorialsTab(),
          _buildProgressTab(),
        ],
      ),
    );
  }

  Widget _buildChallengesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coding Challenges',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sharpen your skills with daily coding challenges',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          _buildChallengeCard(
            title: 'Two Sum Problem',
            difficulty: 'Easy',
            difficultyColor: Colors.green,
            description: 'Given an array of integers and a target sum, find two numbers that add up to the target.',
            tags: ['Array', 'Hash Table'],
            completed: true,
            attempts: 2,
          ),
          const SizedBox(height: 16),
          _buildChallengeCard(
            title: 'Valid Parentheses',
            difficulty: 'Easy',
            difficultyColor: Colors.green,
            description: 'Given a string containing just the characters \'(\', \')\', \'{\', \'}\', \'[\' and \']\', determine if the input string is valid.',
            tags: ['String', 'Stack'],
            completed: false,
            attempts: 0,
          ),
          const SizedBox(height: 16),
          _buildChallengeCard(
            title: 'Merge Two Sorted Lists',
            difficulty: 'Easy',
            difficultyColor: Colors.green,
            description: 'Merge two sorted linked lists and return it as a sorted list.',
            tags: ['Linked List', 'Recursion'],
            completed: false,
            attempts: 1,
          ),
          const SizedBox(height: 16),
          _buildChallengeCard(
            title: 'Maximum Subarray',
            difficulty: 'Medium',
            difficultyColor: Colors.orange,
            description: 'Given an integer array nums, find the contiguous subarray with the largest sum.',
            tags: ['Array', 'Dynamic Programming'],
            completed: false,
            attempts: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required String difficulty,
    required Color difficultyColor,
    required String description,
    required List<String> tags,
    required bool completed,
    required int attempts,
  }) {
    return CustomCard(
      onTap: () {
        // TODO: Navigate to challenge detail
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    difficulty,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: difficultyColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (completed) ...[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Completed',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else ...[
                  Icon(
                    Icons.play_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    attempts > 0 ? '$attempts attempts' : 'Not attempted',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Start challenge
                  },
                  child: Text(completed ? 'Review' : 'Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learning Tutorials',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Step-by-step guides to master new technologies',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          _buildTutorialCard(
            title: 'Flutter State Management',
            description: 'Learn different approaches to manage state in Flutter applications.',
            duration: '45 min',
            difficulty: 'Intermediate',
            progress: 0.3,
          ),
          const SizedBox(height: 16),
          _buildTutorialCard(
            title: 'Firebase Integration',
            description: 'Complete guide to integrating Firebase services in your Flutter app.',
            duration: '60 min',
            difficulty: 'Beginner',
            progress: 0.0,
          ),
          const SizedBox(height: 16),
          _buildTutorialCard(
            title: 'Advanced Dart Concepts',
            description: 'Master advanced Dart features like generics, mixins, and async programming.',
            duration: '90 min',
            difficulty: 'Advanced',
            progress: 0.7,
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard({
    required String title,
    required String description,
    required String duration,
    required String difficulty,
    required double progress,
  }) {
    return CustomCard(
      onTap: () {
        // TODO: Navigate to tutorial
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    difficulty,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  duration,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).toInt()}% complete',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          _buildProgressCard(
            title: 'Problems Solved',
            value: '47',
            total: '200',
            color: Colors.blue,
            icon: Icons.check_circle,
          ),
          const SizedBox(height: 16),
          _buildProgressCard(
            title: 'Tutorials Completed',
            value: '12',
            total: '50',
            color: Colors.green,
            icon: Icons.school,
          ),
          const SizedBox(height: 16),
          _buildProgressCard(
            title: 'Current Streak',
            value: '7',
            subtitle: 'days',
            color: Colors.orange,
            icon: Icons.local_fire_department,
          ),
          const SizedBox(height: 32),
          Text(
            'Skill Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildSkillProgress('Flutter', 0.8),
          const SizedBox(height: 12),
          _buildSkillProgress('Dart', 0.7),
          const SizedBox(height: 12),
          _buildSkillProgress('Firebase', 0.6),
          const SizedBox(height: 12),
          _buildSkillProgress('UI/UX', 0.5),
          const SizedBox(height: 12),
          _buildSkillProgress('Algorithms', 0.4),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String value,
    String? total,
    String? subtitle,
    required Color color,
    required IconData icon,
  }) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    total != null ? '$value / $total' : value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillProgress(String skill, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
