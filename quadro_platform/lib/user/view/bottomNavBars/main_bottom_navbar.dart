import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/commonn/controller/services/firebasePushNotificationServices/push_notification_services.dart';
import 'package:quadro_platform/commonn/controller/services/profile_data_crud_service.dart';
import 'package:quadro_platform/commonn/model/profile_data_model.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/user/controller/provider/BottomNavBarProvider/bottom_nav_bar_provider.dart';
import 'package:quadro_platform/user/view/account/user_account_screen.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class MainBottomNavBar extends StatefulWidget {
  MainBottomNavBar({super.key});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  List<PersistentTabConfig> _navBarItems(int currentTab) {
    return [
      // PersistentTabConfig(
      //   screen: const MainUserScreen(),
      //   item: ItemConfig(
      //     icon: Icon(currentTab == 0
      //         ? CupertinoIcons.house_fill
      //         : CupertinoIcons.house),
      //     title: 'الرئيسية',
      //     inactiveForegroundColor: grey,
      //     activeForegroundColor: teal,
      //   ),
      // ),
      // PersistentTabConfig(
      //   icon: Icon(
      //       currentTab == 0 ? CupertinoIcons.car_fill : CupertinoIcons.car),
      //   title: 'Maintanence',
      //   activeForegroundColor: green200,
      // ),

      PersistentTabConfig(
        screen: UserAccountScreen(),
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
    return Consumer<BottomNavBarProvider>(
      builder: (context, tabProvider, child) {
        return PersistentTabView(
          controller: controller,
          tabs: _navBarItems(tabProvider.currentTab),
          avoidBottomPadding: true,
          //onItemSelected: ,

          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,

          popActionScreens: PopActionScreensType.all,

          navBarBuilder: (navBarConfig) => Style2BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(8.sp),
              color: white,
            ),
            // itemAnimationProperties: const ItemAnimation(
            //     duration: Duration(microseconds: 200), curve: Curves.ease),
          ),
        );
      },
    );
  }
}
