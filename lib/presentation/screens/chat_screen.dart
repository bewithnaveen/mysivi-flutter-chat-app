import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/user.dart';
import '../controllers/chat_controller.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  final String chatId;

  const ChatScreen({
    super.key,
    required this.user,
    required this.chatId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatController chatController;

  @override
  void initState() {
    super.initState();
    chatController = Get.find<ChatController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.loadChatMessages(widget.chatId, widget.user);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    final success = await chatController.sendMessage(text);

    if (success) {
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppTheme.primaryColor),
          onPressed: () {
            chatController.clearCurrentChat();
            Get.back();
          },
        ),
        title: Row(
          children: [
            // 👇 BLUE GRADIENT AVATAR (SAME FOR ALL)
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4E7FFF),
                    Color(0xFF3D6FEE),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.user.initials,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    widget.user.isOnline ? 'Online' : 'Offline',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: widget.user.isOnline
                          ? AppTheme.onlineColor
                          : AppTheme.textTertiaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatController.state.value == ChatViewState.loading &&
                  chatController.currentChatMessages.isEmpty) {
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
                        chatController.errorMessage.value ??
                            'Something went wrong',
                        style: GoogleFonts.outfit(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final messages = chatController.currentChatMessages;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    message: messages[index],
                    user: widget.user,
                  );
                },
              );
            }),
          ),
          ChatInput(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
