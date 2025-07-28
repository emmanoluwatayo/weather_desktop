import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';
import 'package:weather_desktop/core/constants/router.dart';
import 'package:weather_desktop/core/network/api_response.dart';
import 'package:weather_desktop/data/providers/auth/sign_out_notifier.dart';
import 'package:weather_desktop/gen/assets.gen.dart';
import 'package:weather_desktop/presentation/screens/favorites/favorites_screen.dart';
import 'package:weather_desktop/presentation/screens/home/home_screen.dart';
import 'package:weather_desktop/presentation/screens/settings/settings_screen.dart';
import 'package:weather_desktop/presentation/utilities/are_you_sure_dialog.dart';
import 'package:weather_desktop/utilities/loading.dart';
import 'package:weather_desktop/utilities/toast_info.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  bool isCollapsed = false;

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  logout() async {
    final notifier = ref.read(signOutNotifierProvider.notifier);
    await notifier.signOut();
  }

  logoutDialog() {
    areYouSureDialog(
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      context: context,
      action: logout,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SignOutState>(signOutNotifierProvider, (previous, next) {
      if (next.processingStatus == ProcessingStatus.waiting) {
        context.showLoader();
      } else {
        context.hideLoader();
      }

      if (next.processingStatus == ProcessingStatus.error) {
        toastInfo(msg: 'Oops! ${next.error.errorMsg}', status: Status.error);
      }

      if (next.processingStatus == ProcessingStatus.success) {
        // toastInfo(
        //   msg: 'Success! Account creation completed. You can now log in.',
        //   status: Status.completed,
        // );

        context.go(AppRouter.login);
      }
    });

    // final signOutState = ref.watch(signOutNotifierProvider);
    return Scaffold(
      body: Row(
        children: [
          Container(
            color: AppColors.backgroundDark,
            child: SideMenu(
              controller: sideMenu,
              style: SideMenuStyle(
                showTooltip: true,
                backgroundColor: AppColors.backgroundDark,
                displayMode:
                    isCollapsed
                        ? SideMenuDisplayMode.compact
                        : SideMenuDisplayMode.open,
                compactSideMenuWidth: 60, // Increased width
                openSideMenuWidth: 220,
                showHamburger: false,
                iconSize: 20, // Larger icons
                hoverColor: AppColors.lightBlueGrey,
                selectedColor: AppColors.primaryColor,
                selectedTitleTextStyle: const TextStyle(color: Colors.white),
                selectedIconColor: Colors.white,
                unselectedIconColor: Colors.white,
                unselectedTitleTextStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 79, 117, 134),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
              ),
              title: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          isCollapsed = !isCollapsed;
                        });
                      },
                    ),
                  ),
                  if (!isCollapsed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        Assets.images.clearsky.path,
                        width: 50,
                        height: 50,
                        color: AppColors.softLightGrey,
                      ),
                    ),
                  const Divider(indent: 8.0, endIndent: 8.0),
                ],
              ),
              footer: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    child: Text(
                      'Mxzy Weather',
                      style: AppFonts.poppins(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              items: [
                SideMenuItem(
                  title: 'Home',
                  icon: const Icon(Icons.home),
                  onTap: (index, _) => sideMenu.changePage(index),
                ),
                SideMenuItem(
                  title: 'Favorites',
                  icon: const Icon(Icons.favorite_border),
                  onTap: (index, _) => sideMenu.changePage(index),
                ),
                SideMenuItem(
                  title: 'Profile',
                  icon: const Icon(Icons.person),
                  onTap: (index, _) => sideMenu.changePage(index),
                ),
                SideMenuItem(
                  title: 'Exit',
                  icon: Icon(Icons.exit_to_app),
                  onTap: (index, _) => logoutDialog(),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 0),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),

              children: const [
                HomeScreen(),
                FavoritesScreen(),
                SettingsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
