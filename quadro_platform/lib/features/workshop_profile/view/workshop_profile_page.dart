import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/features/workshop_profile/cubit/workshop_profile_cubit.dart';
import 'package:quadro_platform/features/workshop_profile/view/widgets/workshop_image_appbar.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:sizer/sizer.dart';

import 'widgets/profile_header.dart';
import 'widgets/tab_bar.dart';
import 'widgets/tabs_views.dart';

class WorkshopProfilePage extends StatelessWidget {
  final Workshop? workshop;
  final RequestType? requestType;

  const WorkshopProfilePage({super.key, this.workshop, this.requestType});

  @override
  Widget build(BuildContext context) {
    log(workshop?.toJson().toString() ?? "workshop is null ");
    return BlocProvider(
      create: (context) => WorkshopProfileCubit(
        workshop: workshop,
        repoManager: context.read<RepositoryManager>(),
        workshopRepo: context.read<RepositoryManager>().workshopRepository,
      )..initialize(),
      child: DefaultTabController(
        length: 3,
        child: Builder(builder: (context) {
          final tabController = DefaultTabController.of(context);
          bool listenerAdded = false;
          if (!listenerAdded) {
            listenerAdded = true;
            // ignore: invalid_use_of_protected_member
            if (!tabController.hasListeners) {
              tabController.addListener(() {
                if (tabController.index == 2 &&
                    !tabController.indexIsChanging) {
                  context
                      .read<WorkshopProfileCubit>()
                      .workshopProfileReviewFetched();
                }
              });
            }
          }

          return WorkshopProfileView(
            requestType: requestType,
          );
        }),
      ),
    );
  }
}

class WorkshopProfileView extends StatelessWidget {
  final RequestType? requestType;
  const WorkshopProfileView({super.key, this.requestType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocSelector<WorkshopProfileCubit, WorkshopProfileState,
          WorkshopProfileStatus>(
        selector: (state) {
          return state.status;
        },
        builder: (context, state) {
          if (state == WorkshopProfileStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Qcolors.primarycolor,
              ),
            );
          }
          if (state == WorkshopProfileStatus.failure) {
            return const Center(child: Text("somehting went wrong"));
          }
          return NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  WorkshopImageAppbar(
                    requestType: requestType,
                  ),
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    collapsedHeight:
                        8.h, // Adjust this to control the pinned height
                    flexibleSpace: const ProfileHeader(),
                    pinned: true,
                    bottom: const WorkshopTabBar(),
                  ),
                ];
              },
              body: Padding(
                padding: EdgeInsets.all(4.w),
                child: const TabsViews(),
              ));
        },
      ),
    );
  }
}
