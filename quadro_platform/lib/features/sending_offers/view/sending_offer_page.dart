import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/sending_offers/cubit/sending_offer_cubit.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/models/maintenance_request_data_model.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/features/workshop_profile/repository/reviews_repository.dart';
import 'package:quadro_platform/shared/widgets/custom_elevated_button.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/enum/maitenance_request_status.dart';
import '../../../shared/utils/constans/colors.dart';
import '../../../shared/widgets/overlay_dialog/overlay_sending_offer.dart';
import '../../workshop_main_screen/repository/offers_repository.dart';
import '../../workshop_main_screen/repository/repository_manager.dart';
import '../view/widgets/service_price_textField.dart';
import 'widgets/guarantee_period.dart';
import 'widgets/spare_parts_status.dart';

class SendingOfferPage extends StatelessWidget {
  final MaintenanceRequestDomainModel request;
  const SendingOfferPage({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "تقديم عرض",
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.apply(color: Qcolors.primarycolor),
          ),
        ),
        body: BlocProvider(
          create: (context) => SendingOfferCubit(RepositoryManager(
              reviewsRepository: ReviewsRepository(),
              maintenanceRequestsRepository: MaintenanceRequestsRepository(),
              offersRepository: OffersRepository(),
              userRepository: UserRepository(),
              workshopRepository: WorkshopRepository())),
          child: SendingOfferView(
            requestId: request.id,
            workshopId: request.workshop.ownerId,
          ),
        ));
  }
}

class SendingOfferView extends StatelessWidget {
  final String workshopId;
  final String requestId;
  const SendingOfferView(
      {super.key, required this.workshopId, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendingOfferCubit, SendingOfferState>(
      listener: (context, state) {
        if (state.sendingStatus == SendingOfferStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.exception ??
                    ' الرجاء تحديد حالة القطع التي ستستخدم للصيانة '),
              ),
            );
        }
        if (state.sendingStatus == SendingOfferStatus.success) {
          OverlaySendingOffer().show(
            context: context,
          );
        }
      },
      child: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            spacing: 5.h,
            children: [
              const SizedBox.shrink(),
              const SectionHeader(
                requestType: RequestType.workshop_id,
                text: "قم باظافة تفاصيل عرضك",
                islarge: true,
              ),
              const SectionHeader(
                requestType: RequestType.workshop_id,
                text: "مبلغ الخدمة",
              ),
              const ServicePriceTextfield(),
              const SectionHeader(
                requestType: RequestType.workshop_id,
                text: "مدة الضمان (عدد الايام)",
              ),
              const GuaranteePeriod(),
              const SectionHeader(
                requestType: RequestType.workshop_id,
                text: "حالة القطع التي ستستخدم للصيانة",
              ),
              const SparePartsRidosButton(),
              BlocSelector<SendingOfferCubit, SendingOfferState,
                  SendingOfferStatus>(
                selector: (state) {
                  return state.sendingStatus;
                },
                builder: (context, state) {
                  if (state == SendingOfferStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Qcolors.primarycolor,
                      ),
                    );
                  }
                  return CustomElevatedButton(
                    buttonColor: Qcolors.primarycolor,
                    buttonTitle: "ارسل العرض",
                    onPressed: () => context
                        .read<SendingOfferCubit>()
                        .sendOffer(
                            requestId: requestId, workshopId: workshopId),
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
