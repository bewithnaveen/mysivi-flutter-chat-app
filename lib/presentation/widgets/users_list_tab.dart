import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/user.dart';
import '../controllers/user_controller.dart';
import '../controllers/chat_controller.dart';
import '../screens/chat_screen.dart';
import 'user_list_item.dart';
import 'add_user_bottomsheet.dart';

class UsersListTab extends StatefulWidget {
  const UsersListTab({super.key});

  @override
  State<UsersListTab> createState() => _UsersListTabState();
}

class _UsersListTabState extends State<UsersListTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late final UserController userController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    userController = Get.put(getIt<UserController>());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showAddUserBottomSheet() async {
    final name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddUserBottomSheet(),
    );

    if (name != null && name.trim().isNotEmpty && mounted) {
      final success = await userController.addUser(name);

      if (success && mounted) {
        Get.snackbar(
          'Success',
          'User "$name" added successfully',
          backgroundColor: AppTheme.successColor,
          colorText: Colors.white,
          icon: const Icon(LucideIcons.checkCircle, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(AppTheme.spacingMedium),
          borderRadius: AppTheme.radiusSmall,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  Future<void> _navigateToChat(User user) async {
    final chatId = 'chat_${user.id}';

    final chatController = Get.find<ChatController>();
    await chatController.loadChatHistory();

    if (mounted) {
      await Get.to(
        () => ChatScreen(
          user: user,
          chatId: chatId,
        ),
        transition: Transition.cupertino,
      );

      if (mounted) {
        chatController.loadChatHistory();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (userController.state.value == UserViewState.loading &&
            userController.users.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          );
        }

        if (userController.state.value == UserViewState.error) {
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
                  userController.errorMessage.value ?? 'Something went wrong',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        final users = userController.users;

        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.users,
                  size: 64,
                  color: AppTheme.textTertiaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No users yet',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to add a user',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppTheme.textTertiaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          itemCount: users.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppTheme.spacingSmall),
          itemBuilder: (context, index) {
            return UserListItem(
              user: users[index],
              onTap: () => _navigateToChat(users[index]),
            );
          },
        );
      }),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4E7FFF),
              Color(0xFF3D6FEE),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4E7FFF).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAddUserBottomSheet,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(
            LucideIcons.plus,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
