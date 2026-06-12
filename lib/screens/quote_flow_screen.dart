import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../models/quote.dart';
import '../models/session.dart';
import '../services/quote_service.dart';
import '../services/storage_service.dart';
import '../widgets/quote_card.dart';
import '../widgets/expandable_context.dart';
import '../widgets/action_buttons.dart';
import '../theme/app_theme.dart';

/// The main quote display and interaction screen.
class QuoteFlowScreen extends StatefulWidget {
  final Mood mood;

  const QuoteFlowScreen({super.key, required this.mood});

  @override
  State<QuoteFlowScreen> createState() => _QuoteFlowScreenState();
}

class _QuoteFlowScreenState extends State<QuoteFlowScreen>
    with SingleTickerProviderStateMixin {
  List<Quote>? _allQuotes;
  Quote? _currentQuote;
  late SessionState _session;
  bool _loading = true;
  bool _liked = false;
  bool _disliked = false;
  bool _saved = false;

  // Animation
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _session = SessionState(selectedMood: widget.mood);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _load();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    _allQuotes = await QuoteService.loadQuotes();
    _advance();
  }

  void _advance() {
    if (_allQuotes == null) return;
    final next = QuoteService.nextQuote(_allQuotes!, _session);
    if (next == null) {
      setState(() {
        _currentQuote = null;
        _loading = false;
      });
      return;
    }
    // Mark as seen
    _session = _session.withSeen(next);
    setState(() {
      _currentQuote = next;
      _loading = false;
      _liked = false;
      _disliked = false;
      _saved = StorageService.isFavorite(next.id);
    });
    _fadeController.forward(from: 0);
  }

  void _onLike() {
    if (_currentQuote == null || _liked) return;
    setState(() {
      _liked = true;
      _disliked = false;
    });
    _session = _session.withLike(_currentQuote!);
    Future.delayed(const Duration(milliseconds: 500), _advance);
  }

  void _onDislike() {
    if (_currentQuote == null || _disliked) return;
    setState(() {
      _disliked = true;
      _liked = false;
    });
    _session = _session.withDislike(_currentQuote!);
    Future.delayed(const Duration(milliseconds: 500), _advance);
  }

  void _onSkip() {
    if (_currentQuote == null) return;
    _advance();
  }

  Future<void> _toggleSave() async {
    if (_currentQuote == null) return;
    if (_saved) {
      await StorageService.removeFavorite(_currentQuote!.id);
    } else {
      await StorageService.saveFavorite(_currentQuote!);
    }
    setState(() => _saved = !_saved);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moodConfig = widget.mood.config;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(moodConfig.icon, color: moodConfig.color, size: 18),
            const SizedBox(width: 8),
            Text(moodConfig.label),
          ],
        ),
        actions: [
          if (_currentQuote != null)
            IconButton(
              icon: Icon(
                _saved ? Icons.bookmark : Icons.bookmark_border,
                color: _saved ? moodConfig.color : null,
              ),
              tooltip: _saved ? 'Remove from favorites' : 'Save to favorites',
              onPressed: _toggleSave,
            ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _currentQuote == null
                ? _buildExhausted(context, isDark)
                : _buildQuoteView(context, isDark),
      ),
    );
  }

  Widget _buildQuoteView(BuildContext context, bool isDark) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          children: [
            QuoteCard(quote: _currentQuote!),
            const SizedBox(height: 32),
            ActionButtons(
              liked: _liked,
              disliked: _disliked,
              onLike: _onLike,
              onDislike: _onDislike,
              onSkip: _onSkip,
            ),
            const SizedBox(height: 32),
            ExpandableContext(quote: _currentQuote!),
            const SizedBox(height: 24),
            // Session summary chip
            if (_session.likedQuotes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${_session.likedQuotes.length} liked this session',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isDark ? AppTheme.subtleDark : AppTheme.subtleLight,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExhausted(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 56,
              color: isDark ? AppTheme.subtleDark : AppTheme.subtleLight,
            ),
            const SizedBox(height: 24),
            Text(
              "You've seen all quotes\nfor this mood.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.onSurfaceDark : AppTheme.onSurfaceLight,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try a different mood or come back later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppTheme.subtleDark : AppTheme.subtleLight,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Choose another mood'),
            ),
          ],
        ),
      ),
    );
  }
}
