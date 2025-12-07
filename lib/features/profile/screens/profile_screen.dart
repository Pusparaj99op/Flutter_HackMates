import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils.dart';
import '../../auth/providers/auth_provider.dart';
import '../../shared/widgets/custom_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController.text = authProvider.userProfile?['name'] ?? '';
    _bioController.text = authProvider.userProfile?['bio'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProfile = authProvider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              }
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(userProfile),
            const SizedBox(height: 24),
            _buildProfileInfo(userProfile),
            const SizedBox(height: 24),
            _buildSkillsSection(userProfile),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic>? userProfile) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    (userProfile?['name'] ?? 'U')[0].toUpperCase(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 16),
                        color: Colors.white,
                        onPressed: () {
                          // TODO: Implement image picker
                        },
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isEditing) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ] else ...[
              Text(
                userProfile?['name'] ?? 'User',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              userProfile?['email'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(Map<String, dynamic>? userProfile) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (_isEditing) ...[
              TextField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                  hintText: 'Tell others about yourself...',
                ),
                maxLines: 3,
              ),
            ] else ...[
              Text(
                userProfile?['bio'] ?? 'No bio yet. Add one to tell others about yourself!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.calendar_today,
              'Joined',
              AppUtils.formatDate(userProfile?['createdAt']?.toDate() ?? DateTime.now()),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.location_on,
              'Location',
              userProfile?['location'] ?? 'Not specified',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.school,
              'Education',
              userProfile?['education'] ?? 'Not specified',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(Map<String, dynamic>? userProfile) {
    final skills = List<String>.from(userProfile?['skills'] ?? []);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Skills',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_isEditing)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addSkill,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (skills.isEmpty) ...[
              Text(
                'No skills added yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ] else ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: AppUtils.getSkillColor(skill).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: AppUtils.getSkillColor(skill),
                      fontWeight: FontWeight.w500,
                    ),
                    deleteIcon: _isEditing ? const Icon(Icons.close, size: 16) : null,
                    onDeleted: _isEditing ? () => _removeSkill(skill) : null,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Hackathons', '3', Icons.emoji_events),
                ),
                Expanded(
                  child: _buildStatItem('Projects', '12', Icons.work),
                ),
                Expanded(
                  child: _buildStatItem('Teams', '5', Icons.group),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return CustomCard(
      child: Column(
        children: [
          _buildSettingItem(
            Icons.notifications,
            'Notifications',
            'Manage notification preferences',
            () {
              // TODO: Navigate to notifications settings
            },
          ),
          const Divider(),
          _buildSettingItem(
            Icons.privacy_tip,
            'Privacy',
            'Control your privacy settings',
            () {
              // TODO: Navigate to privacy settings
            },
          ),
          const Divider(),
          _buildSettingItem(
            Icons.help,
            'Help & Support',
            'Get help and contact support',
            () {
              // TODO: Navigate to help
            },
          ),
          const Divider(),
          _buildSettingItem(
            Icons.logout,
            'Sign Out',
            'Sign out of your account',
            () => _showSignOutDialog(),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _addSkill() {
    // TODO: Show skill selection dialog
    AppUtils.showSnackBar(context, 'Skill selection coming soon!');
  }

  void _removeSkill(String skill) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.removeSkill(skill);
  }

  void _saveProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.updateProfile({
      'name': _nameController.text.trim(),
      'bio': _bioController.text.trim(),
    });

    if (success) {
      AppUtils.showSnackBar(context, 'Profile updated successfully!');
    } else {
      AppUtils.showSnackBar(context, 'Failed to update profile', isError: true);
    }
  }

  void _showSignOutDialog() {
    AppUtils.showConfirmationDialog(
      context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmText: 'Sign Out',
    ).then((confirmed) {
      if (confirmed) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.signOut();
        context.go('/');
      }
    });
  }
}
