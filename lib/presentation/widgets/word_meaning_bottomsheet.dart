import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../data/datasources/remote/dictionary_remote_datasource.dart';

class WordMeaningBottomSheet extends StatefulWidget {
  final String word;

  const WordMeaningBottomSheet({
    super.key,
    required this.word,
  });

  @override
  State<WordMeaningBottomSheet> createState() => _WordMeaningBottomSheetState();
}

class _WordMeaningBottomSheetState extends State<WordMeaningBottomSheet> {
  bool _isLoading = true;
  String? _error;
  Map<String, String>? _meaning;

  @override
  void initState() {
    super.initState();
    _fetchMeaning();
  }

  Future<void> _fetchMeaning() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dataSource = DictionaryRemoteDataSourceImpl(http.Client());
      final meaning = await dataSource.fetchWordMeaning(widget.word);
      
      if (mounted) {
        setState(() {
          _meaning = meaning;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXLarge),
          topRight: Radius.circular(AppTheme.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(AppTheme.spacingXLarge),
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        ),
      );
    }

    if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: const Icon(
              LucideIcons.alertCircle,
              size: 48,
              color: AppTheme.errorColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Text(
            _error!,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          OutlinedButton.icon(
            onPressed: _fetchMeaning,
            icon: const Icon(LucideIcons.refreshCw, size: 18),
            label: const Text('Retry'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLarge,
                vertical: AppTheme.spacingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
          ),
        ],
      );
    }

    if (_meaning == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryLightColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: const Icon(
                LucideIcons.bookOpen,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _meaning!['word']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  if (_meaning!['partOfSpeech']!.isNotEmpty)
                    Text(
                      _meaning!['partOfSpeech']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppTheme.spacingLarge),
        
        // Definition
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    LucideIcons.messageSquare,
                    size: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Definition',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _meaning!['definition']!,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        
        // Example (if available)
        if (_meaning!['example']!.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingMedium),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: AppTheme.secondaryColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      LucideIcons.lightbulb,
                      size: 16,
                      color: AppTheme.secondaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Example',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '"${_meaning!['example']!}"',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
        
        const SizedBox(height: AppTheme.spacingMedium),
      ],
    );
  }
}
