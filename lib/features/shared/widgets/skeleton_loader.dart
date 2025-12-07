import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
      highlightColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double height;

  const SkeletonCard({
    super.key,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonLoader(width: 100, height: 20),
                const Spacer(),
                SkeletonLoader(
                  width: 60,
                  height: 24,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SkeletonLoader(width: double.infinity, height: 16),
            const SizedBox(height: 8),
            const SkeletonLoader(width: 200, height: 16),
            const SizedBox(height: 16),
            Row(
              children: [
                const SkeletonLoader(width: 80, height: 14),
                const SizedBox(width: 16),
                const SkeletonLoader(width: 60, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
