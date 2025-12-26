import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user.dart';
import 'word_meaning_bottomsheet.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final User user;

  const MessageBubble({
    super.key,
    required this.message,
    required this.user,
  });

  String _formatTime(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp);
  }

  void _showWordMeaning(BuildContext context, String word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WordMeaningBottomSheet(word: word),
    );
  }

  void _handleLongPress(BuildContext context, String text) {
    final words = text.split(RegExp(r'\s+'));

    if (words.isEmpty) return;

    if (words.length == 1) {
      _showWordMeaning(context, words[0]);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        title: Text(
          'Select a word',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: words.map((word) {
            final cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '');
            if (cleanWord.isEmpty) return const SizedBox.shrink();

            return ActionChip(
              label: Text(cleanWord),
              backgroundColor: AppTheme.primaryLightColor,
              labelStyle: GoogleFonts.outfit(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
              onPressed: () {
                Navigator.pop(context);
                _showWordMeaning(context, cleanWord);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isReceiver) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.getColorFromName(user.name),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user.initials,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: () => _handleLongPress(context, message.text),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      // 👇 Blue gradient for sender
                      gradient: message.isSender
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF4E7FFF),
                                Color(0xFF3D6FEE),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: message.isSender
                          ? null
                          : AppTheme.receiverBubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(
                          message.isSender ? 16 : 4,
                        ),
                        bottomRight: Radius.circular(
                          message.isSender ? 4 : 16,
                        ),
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        color: message.isSender
                            ? Colors.white
                            : AppTheme.receiverTextColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppTheme.textTertiaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (message.isSender) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppTheme.accentColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'M',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
