import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/chat_controller.dart';
import '../widgets/custom_tab_switcher.dart';
import '../widgets/users_list_tab.dart';
import '../widgets/chat_history_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _isAppBarVisible = true;

  @override
  void initState() {
    super.initState();

    // Initialize ChatController
    Get.put(getIt<ChatController>());

    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.hasClients) {
      final isScrollingDown = _scrollController.position.userScrollDirection ==
          ScrollDirection.reverse;
      final isScrollingUp = _scrollController.position.userScrollDirection ==
          ScrollDirection.forward;

      if (isScrollingDown && _isAppBarVisible) {
        setState(() => _isAppBarVisible = false);
      } else if (isScrollingUp && !_isAppBarVisible) {
        setState(() => _isAppBarVisible = true);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              backgroundColor: Colors.white,
              elevation: 0,
              toolbarHeight: 80,
              flexibleSpace: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isAppBarVisible ? 1.0 : 0.0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: CustomTabSwitcher(
                      controller: _tabController,
                      tabs: const ['Users', 'Chat History'],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            UsersListTab(),
            ChatHistoryTab(),
          ],
        ),
      ),
    );
  }
}
