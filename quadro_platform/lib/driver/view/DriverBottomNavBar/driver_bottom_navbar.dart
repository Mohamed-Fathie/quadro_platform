import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/services/firebasePushNotificationServices/push_notification_services.dart';
import 'package:quadro_platform/common/controller/services/profile_data_crud_service.dart';
import 'package:quadro_platform/common/model/profile_data_model.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/driver/controller/provider/bottom_nav_bar_provider.dart';
import 'package:quadro_platform/driver/view/DriverAccountScreen/driver_account_screen.dart';
import 'package:quadro_platform/driver/view/DriverActivityScreen/driver_activity_screen.dart';
import 'package:quadro_platform/driver/view/DriverHomeScreen/driver_home_screen.dart';
import 'package:quadro_platform/driver/view/DriverHomeScreen/driver_home_screen_builder.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class DriverBottomNavBar extends StatefulWidget {
  DriverBottomNavBar({super.key});

  @override
  State<DriverBottomNavBar> createState() => _DriverBottomNavBarState();
}

class _DriverBottomNavBarState extends State<DriverBottomNavBar> {
  List<PersistentTabConfig> _navBarItems(int currentTab) {
    return [
      PersistentTabConfig(
        screen: DriverHomeScreenBuilder(),
        item: ItemConfig(
          icon: Icon(currentTab == 0
              ? CupertinoIcons.house_fill
              : CupertinoIcons.house),
          title: 'الرئيسية',
          inactiveForegroundColor: grey,
          activeForegroundColor: teal,
        ),
      ),
      PersistentTabConfig(
        screen: const DriverActivityScreen(),
        item: ItemConfig(
          icon: Icon(currentTab == 0
              ? CupertinoIcons.square_list_fill
              : CupertinoIcons.square_list),
          title: 'النشاطات',
          activeForegroundColor: teal,
        ),
      ),
      PersistentTabConfig(
        screen: DriverAccountScreen(),
        item: ItemConfig(
          icon: Icon(currentTab == 0
              ? CupertinoIcons.person_fill
              : CupertinoIcons.person),
          title: 'الحساب',
          activeForegroundColor: teal,
        ),
      ),
    ];
  }

  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ProfileDataModel profileData =
          await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
              auth.currentUser!.uid);
      PushNotivicationServices.initializeFirebaseMessagingForUsers(
          profileData, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavBarDriverProvider>(
      builder: (context, tabProvider, child) {
        return Scaffold(
          body: PersistentTabView(
            controller: controller,
            tabs: _navBarItems(tabProvider.currentTab),
            avoidBottomPadding: true,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            popActionScreens: PopActionScreensType.all,
            navBarBuilder: (navBarConfig) {
              return Style2BottomNavBar(
                navBarConfig: navBarConfig,
                navBarDecoration: NavBarDecoration(
                  borderRadius: BorderRadius.circular(8.sp),
                  color: white,
                ),
                // itemAnimationProperties: const ItemAnimation(
                //     duration: Duration(microseconds: 200), curve: Curves.ease),
              );
            },
          ),
        );
      },
    );
  }
}
