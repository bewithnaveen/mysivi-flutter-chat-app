import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/chat_controller.dart';
import '../screens/chat_screen.dart';
import 'chat_history_item.dart';

class ChatHistoryTab extends StatefulWidget {
  const ChatHistoryTab({super.key});

  @override
  State<ChatHistoryTab> createState() => _ChatHistoryTabState();
}

class _ChatHistoryTabState extends State<ChatHistoryTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late final ChatController chatController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Get or create the ChatController
    try {
      chatController = Get.find<ChatController>();
    } catch (e) {
      chatController = Get.put(getIt<ChatController>());
    }
    chatController.loadChatHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (chatController.state.value == ChatViewState.loading &&
            chatController.chatHistory.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          );
        }

        if (chatController.state.value == ChatViewState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  LucideIcons.alertCircle,
                  size: 48,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  chatController.errorMessage.value ?? 'Something went wrong',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        final chatHistory = chatController.chatHistory;

        if (chatHistory.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.messageCircle,
                  size: 64,
                  color: AppTheme.textTertiaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No conversations yet',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start a chat from the Users tab',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppTheme.textTertiaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => chatController.loadChatHistory(),
          color: AppTheme.primaryColor,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            itemCount: chatHistory.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppTheme.spacingSmall),
            itemBuilder: (context, index) {
              final chat = chatHistory[index];
              return ChatHistoryItem(
                chatHistory: chat,
                onTap: () async {
                  await Get.to(
                    () => ChatScreen(
                      user: chat.user,
                      chatId: chat.id,
                    ),
                    transition: Transition.cupertino,
                  );
                  
                  if (mounted) {
                    chatController.loadChatHistory();
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }
}
