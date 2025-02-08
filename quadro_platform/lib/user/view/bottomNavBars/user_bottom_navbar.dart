import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:quadro_platform/common/controller/services/firebasePushNotificationServices/push_notification_services.dart';
import 'package:quadro_platform/common/controller/services/profile_data_crud_service.dart';
import 'package:quadro_platform/common/modele/profile_data_model.dart';
import 'package:quadro_platform/constants/constants.dart';
import 'package:quadro_platform/constants/utils/colors.dart';
import 'package:quadro_platform/constants/utils/textStyles.dart';
import 'package:quadro_platform/user/controller/provider/BottomNavBarProvider/bottom_nav_bar_provider.dart';
import 'package:quadro_platform/user/view/account/user_account_screen.dart';
import 'package:quadro_platform/user/view/riderActivityScreen/rider_activity_screen.dart';
import 'package:quadro_platform/user/view/riderHomeScreen/user_home_screen.dart';
import 'package:quadro_platform/user/view/riderHomeScreen/user_home_screen_builder.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class UserBottomNavBar extends StatefulWidget {
  UserBottomNavBar({super.key});

  @override
  State<UserBottomNavBar> createState() => _UserBottomNavBarState();
}

class _UserBottomNavBarState extends State<UserBottomNavBar> {
  List<PersistentTabConfig> _navBarItems(int currentTab) {
    return [
      PersistentTabConfig(
        screen: const UserHomeScreenBuilder(),
        item: ItemConfig(
          icon: Icon(currentTab == 0
              ? CupertinoIcons.house_fill
              : CupertinoIcons.house),
          title: 'الرئيسية',
          inactiveForegroundColor: grey,
          activeForegroundColor: teal,
        ),
      ),
      // PersistentTabConfig(
      //   icon: Icon(
      //       currentTab == 0 ? CupertinoIcons.car_fill : CupertinoIcons.car),
      //   title: 'Maintanence',
      //   activeForegroundColor: green200,
      // ),
      PersistentTabConfig(
        screen: const RiderActivityScreen(),
        item: ItemConfig(
          icon: Icon(currentTab == 0
              ? CupertinoIcons.square_list_fill
              : CupertinoIcons.square_list),
          title: 'النشاطات',
          activeForegroundColor: teal,
        ),
      ),
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

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     ProfileDataModel profileData =
  //         await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
  //             auth.currentUser!.uid);
  //     PushNotivicationServices.initializeFirebaseMessagingForUsers(
  //         profileData, context);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavBarProvider>(
      builder: (context, tabProvider, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Quadro',
              style: AppTextStyles.heading20Bold,
            ),
          ),
          body: PersistentTabView(
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
          ),
        );
      },
    );
  }
}
