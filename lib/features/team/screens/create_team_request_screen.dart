import 'package:flutter/material.dart';
import '../../shared/widgets/custom_card.dart';

class CreateTeamRequestScreen extends StatefulWidget {
  const CreateTeamRequestScreen({super.key});

  @override
  State<CreateTeamRequestScreen> createState() => _CreateTeamRequestScreenState();
}

class _CreateTeamRequestScreenState extends State<CreateTeamRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedHackathon = '';
  final List<String> _requiredSkills = [];
  int _teamSize = 2;

  final List<String> _hackathons = [
    'Flutter Hack 2024',
    'AI Innovation Challenge',
    'Web3 Builderthon',
    'Mobile Dev Challenge',
  ];

  final List<String> _availableSkills = [
    'Flutter', 'Dart', 'React', 'JavaScript', 'Python', 'Java', 'C++',
    'Node.js', 'Firebase', 'UI/UX Design', 'Figma', 'Git', 'AWS', 'Docker'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addSkill(String skill) {
    if (!_requiredSkills.contains(skill)) {
      setState(() {
        _requiredSkills.add(skill);
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _requiredSkills.remove(skill);
    });
  }

  void _submitRequest() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedHackathon.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a hackathon')),
      );
      return;
    }

    // TODO: Submit team request to Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Team request created successfully!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find teammates for your next hackathon',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a team request to connect with developers who share your interests and skills.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hackathon',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedHackathon.isEmpty ? null : _selectedHackathon,
                        decoration: const InputDecoration(
                          labelText: 'Select Hackathon',
                          border: OutlineInputBorder(),
                        ),
                        items: _hackathons.map((hackathon) {
                          return DropdownMenuItem(
                            value: hackathon,
                            child: Text(hackathon),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedHackathon = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a hackathon';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Team Details',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Project Title',
                          hintText: 'e.g., AI-Powered Task Manager',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a project title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Project Description',
                          hintText: 'Describe your project idea, goals, and what you\'re looking for in teammates...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a project description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Team Size',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _teamSize.toDouble(),
                              min: 2,
                              max: 5,
                              divisions: 3,
                              label: _teamSize.toString(),
                              onChanged: (value) {
                                setState(() {
                                  _teamSize = value.toInt();
                                });
                              },
                            ),
                          ),
                          Text(
                            '$_teamSize members',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Required Skills',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _showSkillSelectionDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Skill'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_requiredSkills.isEmpty) ...[
                        Text(
                          'No skills selected yet. Add skills that your team needs.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ] else ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _requiredSkills.map((skill) {
                            return Chip(
                              label: Text(skill),
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () => _removeSkill(skill),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Create Team Request'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSkillSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Skills'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: _availableSkills.map((skill) {
              final isSelected = _requiredSkills.contains(skill);
              return CheckboxListTile(
                title: Text(skill),
                value: isSelected,
                onChanged: (selected) {
                  if (selected == true) {
                    _addSkill(skill);
                  } else {
                    _removeSkill(skill);
                  }
                  Navigator.of(context).pop();
                  _showSkillSelectionDialog();
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
