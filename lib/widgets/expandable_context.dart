import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../theme/app_theme.dart';

/// Expandable accordion widget that reveals the author context blurb.
class ExpandableContext extends StatefulWidget {
  final Quote quote;

  const ExpandableContext({super.key, required this.quote});

  @override
  State<ExpandableContext> createState() => _ExpandableContextState();
}

class _ExpandableContextState extends State<ExpandableContext>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;
  late final Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor =
        isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header / toggle row
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Text(
                    'About ${widget.quote.author}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.onSurfaceDark.withAlpha(180)
                          : AppTheme.onSurfaceLight.withAlpha(180),
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOut,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: isDark ? AppTheme.subtleDark : AppTheme.subtleLight,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Animated body
          ClipRect(
            child: AnimatedBuilder(
              animation: _heightFactor,
              builder: (context, child) => Align(
                alignment: Alignment.topCenter,
                heightFactor: _heightFactor.value,
                child: child,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: (isDark
                              ? AppTheme.onSurfaceDark
                              : AppTheme.onSurfaceLight)
                          .withAlpha(30),
                      height: 1,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.quote.context,
                      style: AppTheme.bodyStyle(isDark: isDark),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.quote.source,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? AppTheme.subtleDark
                            : AppTheme.subtleLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
