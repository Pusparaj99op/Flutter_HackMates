import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/custom_card.dart';
import '../../shared/widgets/skeleton_loader.dart';

class HackathonsScreen extends StatefulWidget {
  const HackathonsScreen({super.key});

  @override
  State<HackathonsScreen> createState() => _HackathonsScreenState();
}

class _HackathonsScreenState extends State<HackathonsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
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
        title: const Text('Hackathons'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Ongoing'),
            Tab(text: 'Past'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filters
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHackathonList('upcoming'),
          _buildHackathonList('ongoing'),
          _buildHackathonList('past'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create hackathon
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHackathonList(String type) {
    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: const SkeletonLoader(
              height: 120,
            ),
          );
        },
      );
    }

    // TODO: Replace with actual data
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildHackathonCard(
          id: '1',
          title: 'Flutter Hack 2024',
          organizer: 'Google Developer Student Clubs',
          startDate: DateTime(2024, 12, 15),
          endDate: DateTime(2024, 12, 16),
          participants: 150,
          maxParticipants: 200,
          prize: '\$5,000',
          tags: ['Flutter', 'Mobile', 'Web'],
        ),
        const SizedBox(height: 16),
        _buildHackathonCard(
          id: '2',
          title: 'AI Innovation Challenge',
          organizer: 'Tech University',
          startDate: DateTime(2024, 12, 20),
          endDate: DateTime(2024, 12, 22),
          participants: 89,
          maxParticipants: 100,
          prize: '\$10,000',
          tags: ['AI', 'Machine Learning', 'Python'],
        ),
        const SizedBox(height: 16),
        _buildHackathonCard(
          id: '3',
          title: 'Web3 Builderthon',
          organizer: 'Blockchain Club',
          startDate: DateTime(2025, 1, 5),
          endDate: DateTime(2025, 1, 7),
          participants: 45,
          maxParticipants: 80,
          prize: '\$3,000 + NFTs',
          tags: ['Web3', 'Blockchain', 'Solidity'],
        ),
      ],
    );
  }

  Widget _buildHackathonCard({
    required String id,
    required String title,
    required String organizer,
    required DateTime startDate,
    required DateTime endDate,
    required int participants,
    required int maxParticipants,
    required String prize,
    required List<String> tags,
  }) {
    return CustomCard(
      onTap: () => context.go('/hackathon/$id'),
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
                    prize,
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
              'by $organizer',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.group,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  '$participants / $maxParticipants participants',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
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
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}
