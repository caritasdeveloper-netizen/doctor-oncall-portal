import 'package:flutter/material.dart';

// ── Base Shimmer Widget ───────────────────────────────────────────────────────

class ShimmerBox extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value, 0),
            colors: const [
              Color(0xFFECEFF1),
              Color(0xFFF5F7FA),
              Color(0xFFECEFF1),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}

// ── Shimmer for Daily Roster Department Accordion Card ────────────────────────

class ShimmerDepartmentAccordion extends StatelessWidget {
  const ShimmerDepartmentAccordion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF0)),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Department header row
          Row(
            children: [
              ShimmerBox(height: 40, width: 40, borderRadius: BorderRadius.circular(12)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(height: 14, width: 140, borderRadius: BorderRadius.circular(6)),
                    const SizedBox(height: 6),
                    ShimmerBox(height: 11, width: 80, borderRadius: BorderRadius.circular(6)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ShimmerBox(height: 26, width: 60, borderRadius: BorderRadius.circular(20)),
            ],
          ),
        ],
      ),
    );
  }
}

/// A list of [count] shimmer accordion placeholders for the daily roster.
class ShimmerDepartmentList extends StatelessWidget {
  final int count;
  const ShimmerDepartmentList({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index.isOdd) return const SizedBox(height: 12);
                return const ShimmerDepartmentAccordion();
              },
              childCount: count * 2 - 1,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Shimmer for Public On-Call Department Card ────────────────────────────────

class ShimmerPublicDeptCard extends StatelessWidget {
  const ShimmerPublicDeptCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF0)),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              ShimmerBox(height: 38, width: 38, borderRadius: BorderRadius.circular(10)),
              const SizedBox(width: 14),
              Expanded(
                child: ShimmerBox(height: 16, borderRadius: BorderRadius.circular(6)),
              ),
              const SizedBox(width: 10),
              ShimmerBox(height: 26, width: 60, borderRadius: BorderRadius.circular(20)),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: const Color(0xFFF0F4F8)),
          const SizedBox(height: 16),
          // Two shift columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildShiftPlaceholder()),
              const SizedBox(width: 16),
              Expanded(child: _buildShiftPlaceholder()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShiftPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(height: 30, width: 90, borderRadius: BorderRadius.circular(10)),
        const SizedBox(height: 12),
        // Doctor card placeholder
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8ECF0)),
          ),
          child: Row(
            children: [
              ShimmerBox(height: 44, width: 44, borderRadius: BorderRadius.circular(22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(height: 13, borderRadius: BorderRadius.circular(6)),
                    const SizedBox(height: 6),
                    ShimmerBox(height: 11, width: 80, borderRadius: BorderRadius.circular(6)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A sliver list of [count] shimmer public dept cards.
class ShimmerPublicDeptList extends StatelessWidget {
  final int count;
  const ShimmerPublicDeptList({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const ShimmerPublicDeptCard(),
          childCount: count,
        ),
      ),
    );
  }
}
