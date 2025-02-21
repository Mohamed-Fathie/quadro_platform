import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/offers.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/offers_repository.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/repository_manager.dart';
import 'package:quadro_platform/shared/enum/offer_status.dart';
import 'package:quadro_platform/shared/enum/spare_parts.dart';

import '../../../shared/enum/maitenance_request_status.dart';
import '../../workshop_authentication/models/firestore_exceptions.dart';

part 'sending_offer_state.dart';

class SendingOfferCubit extends Cubit<SendingOfferState> {
  final RepositoryManager _repositoryManager;
  SendingOfferCubit(this._repositoryManager) : super(const SendingOfferState());
  final TextEditingController priceController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  @override
  Future<void> close() {
    periodController.dispose();
    priceController.dispose();
    return super.close();
  }

  Future<void> sendOffer(
      {required String workshopId, required String requestId}) async {
    final price = priceController.text;

    bool isvalid = validateAndEmit(
      value: price,
      validator: validateServicePrice,
      errorCallback: (errorMessage) {
        emit(state.copyWith(
          isValid: errorMessage == null,
          priceErrorMessage: errorMessage,
        ));
      },
    );
    if (!isvalid) {
      return;
    }
    final period = periodController.text;
    isvalid = validateAndEmit(
      value: period,
      validator: validateGuaranteePeriod,
      errorCallback: (errorMessage) {
        emit(state.copyWith(
          isPeriodValid: errorMessage == null,
          periodErrorMessage: errorMessage,
        ));
      },
    );
    if (!isvalid) {
      return;
    }
    isvalid = state.partsStatus != null;
    if (!isvalid) {
      emit(state.copyWith(sendingStatus: SendingOfferStatus.failure));
      return;
    }
    try {
      emit(state.copyWith(sendingStatus: SendingOfferStatus.loading));
      final offer = Offer(
        requestId: requestId,
        workshopId: workshopId,
        sparePartsStatus: state.partsStatus!,
        status: OfferStatus.pending,
        servicePrice: double.parse(price),
        dateCreated: Timestamp.now(),
        guaranteePeriod: int.parse(period),
      );
      await _repositoryManager.addOffer(offer);
      _repositoryManager.maintenanceRequestsRepository.updateRequest(
        id: requestId,
        map: {"status": MaitenanceRequestStatus.offerSent.name},
      );
      emit(state.copyWith(sendingStatus: SendingOfferStatus.success));
    } on FirestoreReadWriteFailure catch (e) {
      emit(state.copyWith(
          sendingStatus: SendingOfferStatus.failure, exception: e.message));
    }
  }

  void onServicePriceChanged(String? value) {
    validateAndEmit(
      value: value,
      validator: validateServicePrice,
      errorCallback: (errorMessage) {
        emit(state.copyWith(
          isValid: errorMessage == null,
          priceErrorMessage: errorMessage,
        ));
      },
    );
  }

  void onGuaranteePeriodChanged(String? value) {
    validateAndEmit(
      value: value,
      validator: validateGuaranteePeriod,
      errorCallback: (errorMessage) {
        emit(state.copyWith(
          isPeriodValid: errorMessage == null,
          periodErrorMessage: errorMessage,
        ));
      },
    );
  }

  void onSparePartsStatus(SparePartsStatus? status) {
    if (status != null) {
      emit(state.copyWith(
          partsStatus: status, sendingStatus: SendingOfferStatus.initial));
    }
  }

  bool validateAndEmit({
    required String? value,
    required String? Function(String?) validator,
    required Function(String?) errorCallback,
  }) {
    final validationMessage = validator(value);
    final isValid = validationMessage == null;

    errorCallback(isValid ? null : validationMessage);
    return isValid;
  }

  String? validateGuaranteePeriod(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'مدة الضمان مطلوبة.';
    }
    final parsedValue = int.tryParse(value);
    if (parsedValue == null) {
      return 'الرجاء إدخال رقم صحيح لمدة الضمان.';
    }
    if (parsedValue < 0) {
      return 'مدة الضمان لا يمكن أن تكون سالبة.';
    }
    return null;
  }

  String? validateServicePrice(String? value) {
    log(value ?? "null");
    if (value == null || value.trim().isEmpty) {
      return 'سعر الخدمة مطلوب.';
    }
    final parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return 'الرجاء إدخال رقم صحيح للسعر.';
    }
    if (parsedValue <= 0) {
      return 'يجب أن يكون سعر الخدمة أكبر من الصفر.';
    }
    return null;
  }
}
