import 'package:flutter/material.dart';
import '../../../core/utils.dart';

class SkillChip extends StatelessWidget {
  final String skill;
  final bool selected;
  final bool showDelete;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;

  const SkillChip({
    super.key,
    required this.skill,
    this.selected = false,
    this.showDelete = false,
    this.onDeleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppUtils.getSkillColor(skill);

    return FilterChip(
      label: Text(
        skill,
        style: TextStyle(
          color: selected ? Colors.white : color,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      backgroundColor: color.withOpacity(0.1),
      selectedColor: color,
      checkmarkColor: Colors.white,
      deleteIcon: showDelete ? const Icon(Icons.close, size: 16) : null,
      onDeleted: showDelete ? onDeleted : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? color : color.withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }
}
