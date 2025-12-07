import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils.dart';
import '../providers/auth_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _skillsController = TextEditingController();
  bool _isLoading = false;
  final List<String> _selectedSkills = [];

  final List<String> _availableSkills = [
    'Flutter', 'Dart', 'React', 'JavaScript', 'Python', 'Java', 'C++', 'Go',
    'Node.js', 'Firebase', 'MongoDB', 'PostgreSQL', 'AWS', 'Docker', 'Kubernetes',
    'Machine Learning', 'AI', 'UI/UX Design', 'Figma', 'Adobe XD', 'Git', 'CI/CD'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _addSkill(String skill) {
    if (!_selectedSkills.contains(skill) && _selectedSkills.length < 10) {
      setState(() {
        _selectedSkills.add(skill);
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _selectedSkills.remove(skill);
    });
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.updateProfile({
      'name': _nameController.text.trim(),
      'bio': _bioController.text.trim(),
      'skills': _selectedSkills,
      'profileCompleted': true,
      'updatedAt': DateTime.now(),
    });

    setState(() => _isLoading = false);

    if (success) {
      context.go('/home');
    } else {
      AppUtils.showSnackBar(
        context,
        'Failed to save profile. Please try again.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tell us about yourself',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'This information will help others find and connect with you.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: AppUtils.validateName,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio (Optional)',
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Tell others about your interests and experience...',
                  ),
                  maxLines: 3,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 24),
                Text(
                  'Skills',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select up to 10 skills that best describe your expertise.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableSkills.map((skill) {
                    final isSelected = _selectedSkills.contains(skill);
                    return FilterChip(
                      label: Text(skill),
                      selected: isSelected,
                      onSelected: _isLoading
                          ? null
                          : (selected) {
                              if (selected) {
                                _addSkill(skill);
                              } else {
                                _removeSkill(skill);
                              }
                            },
                    );
                  }).toList(),
                ),
                if (_selectedSkills.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Selected Skills (${_selectedSkills.length}/10):',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedSkills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        onDeleted: _isLoading ? null : () => _removeSkill(skill),
                        backgroundColor: AppUtils.getSkillColor(skill).withOpacity(0.1),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _completeSetup,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Complete Setup'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
