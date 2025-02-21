// sending_offer_cubit_test.dart

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// **************************************************************************
// Dummy implementations of related models, enums, exceptions, and interfaces.
// In your actual project, import the real implementations.
// **************************************************************************

enum OfferStatus { pending, accepted, rejected }

enum SparePartsStatus { available, notAvailable }

enum SendingOfferStatus { initial, loading, success, failure }

class Offer {
  final String requestId;
  final String workshopId;
  final SparePartsStatus sparePartsStatus;
  final OfferStatus status;
  final double servicePrice;
  final Timestamp dateCreated;
  final int guaranteePeriod;

  Offer({
    required this.requestId,
    required this.workshopId,
    required this.sparePartsStatus,
    required this.status,
    required this.servicePrice,
    required this.dateCreated,
    required this.guaranteePeriod,
  });

  @override
  String toString() {
    return 'Offer(requestId: $requestId, workshopId: $workshopId, sparePartsStatus: $sparePartsStatus, status: $status, servicePrice: $servicePrice, dateCreated: $dateCreated, guaranteePeriod: $guaranteePeriod)';
  }
}

class FirestoreReadWriteFailure implements Exception {
  final String message;
  FirestoreReadWriteFailure(this.message);
  @override
  String toString() => 'FirestoreReadWriteFailure: $message';
}

abstract class RepositoryManager {
  Future<void> addOffer(Offer offer);
}

/// A fake repository manager to simulate adding an offer.
/// You can assign a callback to [addOfferCallback] to simulate success or failure.
class FakeRepositoryManager implements RepositoryManager {
  Future<void> Function(Offer offer)? addOfferCallback;

  @override
  Future<void> addOffer(Offer offer) async {
    if (addOfferCallback != null) {
      await addOfferCallback!(offer);
    }
  }
}

/// The state for SendingOfferCubit. Adjust fields as in your real implementation.
class SendingOfferState {
  final bool isValid;
  final String? priceErrorMessage;
  final bool isPeriodValid;
  final String? periodErrorMessage;
  final SparePartsStatus? partsStatus;
  final SendingOfferStatus sendingStatus;
  final String? exception;

  const SendingOfferState({
    this.isValid = true,
    this.priceErrorMessage,
    this.isPeriodValid = true,
    this.periodErrorMessage,
    this.partsStatus,
    this.sendingStatus = SendingOfferStatus.initial,
    this.exception,
  });

  SendingOfferState copyWith({
    bool? isValid,
    String? priceErrorMessage,
    bool? isPeriodValid,
    String? periodErrorMessage,
    SparePartsStatus? partsStatus,
    SendingOfferStatus? sendingStatus,
    String? exception,
  }) {
    return SendingOfferState(
      isValid: isValid ?? this.isValid,
      priceErrorMessage: priceErrorMessage,
      isPeriodValid: isPeriodValid ?? this.isPeriodValid,
      periodErrorMessage: periodErrorMessage,
      partsStatus: partsStatus ?? this.partsStatus,
      sendingStatus: sendingStatus ?? this.sendingStatus,
      exception: exception,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SendingOfferState &&
        other.isValid == isValid &&
        other.priceErrorMessage == priceErrorMessage &&
        other.isPeriodValid == isPeriodValid &&
        other.periodErrorMessage == periodErrorMessage &&
        other.partsStatus == partsStatus &&
        other.sendingStatus == sendingStatus &&
        other.exception == exception;
  }

  @override
  int get hashCode {
    return isValid.hashCode ^
        priceErrorMessage.hashCode ^
        isPeriodValid.hashCode ^
        periodErrorMessage.hashCode ^
        partsStatus.hashCode ^
        sendingStatus.hashCode ^
        exception.hashCode;
  }

  @override
  String toString() {
    return 'SendingOfferState(isValid: $isValid, priceErrorMessage: $priceErrorMessage, isPeriodValid: $isPeriodValid, periodErrorMessage: $periodErrorMessage, partsStatus: $partsStatus, sendingStatus: $sendingStatus, exception: $exception)';
  }
}

// **************************************************************************
// The SendingOfferCubit implementation.
// In your actual project, import this from your cubit file.

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

  Future<void> sendOffer({
    required String workshopId,
    required String requestId,
  }) async {
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

// **************************************************************************
// Unit tests using bloc_test
// **************************************************************************

void main() {
  group('SendingOfferCubit sendOffer', () {
    const validPrice = "100";
    const validPeriod = "12";
    const invalidPriceText = "abc"; // non-numeric
    const invalidPeriodText = "xyz"; // non-numeric

    blocTest<SendingOfferCubit, SendingOfferState>(
      'emits price error when service price is invalid',
      build: () => SendingOfferCubit(FakeRepositoryManager()),
      act: (cubit) async {
        cubit.priceController.text = invalidPriceText;
        // Even if period is valid, the first validation fails.
        cubit.periodController.text = validPeriod;
        await cubit.sendOffer(workshopId: "w1", requestId: "r1");
      },
      expect: () => [
        const SendingOfferState(
          isValid: false,
          priceErrorMessage: 'الرجاء إدخال رقم صحيح للسعر.',
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: null,
          sendingStatus: SendingOfferStatus.initial,
          exception: null,
        ),
      ],
    );

    blocTest<SendingOfferCubit, SendingOfferState>(
      'emits period error when guarantee period is invalid',
      build: () => SendingOfferCubit(FakeRepositoryManager()),
      act: (cubit) async {
        cubit.priceController.text = validPrice; // Valid price
        cubit.periodController.text = invalidPeriodText; // Invalid period
        await cubit.sendOffer(workshopId: "w1", requestId: "r1");
      },
      expect: () => [
        // First, the valid price state (before period validation)
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: true, // Initial validation state
          periodErrorMessage: null,
          partsStatus: null,
          sendingStatus: SendingOfferStatus.initial,
          exception: null,
        ),
        // Second, the invalid period state (error is emitted)
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: false,
          periodErrorMessage: 'الرجاء إدخال رقم صحيح لمدة الضمان.',
          partsStatus: null,
          sendingStatus: SendingOfferStatus.initial,
          exception: null,
        ),
      ],
    );

    blocTest<SendingOfferCubit, SendingOfferState>(
      'emits failure if partsStatus is not set',
      build: () => SendingOfferCubit(FakeRepositoryManager()),
      act: (cubit) async {
        cubit.priceController.text = validPrice;
        cubit.periodController.text = validPeriod;
        // Do not set partsStatus.
        await cubit.sendOffer(workshopId: "w1", requestId: "r1");
      },
      expect: () => [
        // First emission is the initial state (unchanged)
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: null,
          sendingStatus: SendingOfferStatus.initial,
          exception: null,
        ),
        // Then the failure state
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: null,
          sendingStatus: SendingOfferStatus.failure,
          exception: null,
        ),
      ],
    );

    blocTest<SendingOfferCubit, SendingOfferState>(
      'emits loading then success when offer is sent successfully',
      build: () {
        final fakeRepo = FakeRepositoryManager();
        // Simulate a successful addOffer call.
        fakeRepo.addOfferCallback = (offer) async {};
        return SendingOfferCubit(fakeRepo);
      },
      act: (cubit) async {
        // Set partsStatus.
        cubit.onSparePartsStatus(SparePartsStatus.available);
        cubit.priceController.text = validPrice;
        cubit.periodController.text = validPeriod;
        await cubit.sendOffer(workshopId: "w1", requestId: "r1");
      },
      expect: () => [
        // Emitted by onSparePartsStatus.
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: SparePartsStatus.available,
          sendingStatus: SendingOfferStatus.initial,
          exception: null,
        ),
        // Emitted when sendOffer enters loading state.
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: SparePartsStatus.available,
          sendingStatus: SendingOfferStatus.loading,
          exception: null,
        ),
        // Emitted after a successful offer submission.
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: SparePartsStatus.available,
          sendingStatus: SendingOfferStatus.success,
          exception: null,
        ),
      ],
    );

    blocTest<SendingOfferCubit, SendingOfferState>(
      'emits loading then failure with exception when repository throws FirestoreReadWriteFailure',
      build: () {
        final fakeRepo = FakeRepositoryManager();
        fakeRepo.addOfferCallback = (offer) async {
          throw FirestoreReadWriteFailure("Test failure");
        };
        return SendingOfferCubit(fakeRepo);
      },
      act: (cubit) async {
        cubit.onSparePartsStatus(SparePartsStatus.available);
        cubit.priceController.text = validPrice;
        cubit.periodController.text = validPeriod;
        await cubit.sendOffer(workshopId: "w1", requestId: "r1");
      },
      expect: () => [
        // Emitted by onSparePartsStatus.
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: SparePartsStatus.available,
          sendingStatus: SendingOfferStatus.initial,
          exception: null,
        ),
        // Loading state.
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: SparePartsStatus.available,
          sendingStatus: SendingOfferStatus.loading,
          exception: null,
        ),
        // Failure state with exception message.
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: SparePartsStatus.available,
          sendingStatus: SendingOfferStatus.failure,
          exception: "Test failure",
        ),
      ],
    );
  });

  group('SendingOfferCubit individual field updates', () {
    blocTest<SendingOfferCubit, SendingOfferState>(
      'onServicePriceChanged emits price error when value is invalid',
      build: () => SendingOfferCubit(FakeRepositoryManager()),
      act: (cubit) {
        cubit.onServicePriceChanged("0"); // 0 is not > 0.
      },
      expect: () => [
        const SendingOfferState(
          isValid: false,
          priceErrorMessage: 'يجب أن يكون سعر الخدمة أكبر من الصفر.',
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: null,
          sendingStatus: SendingOfferStatus.initial,
          exception: null,
        ),
      ],
    );

    blocTest<SendingOfferCubit, SendingOfferState>(
      'onGuaranteePeriodChanged emits period error when value is empty',
      build: () => SendingOfferCubit(FakeRepositoryManager()),
      act: (cubit) {
        cubit.onGuaranteePeriodChanged("");
      },
      expect: () => [
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: false,
          periodErrorMessage: 'مدة الضمان مطلوبة.',
          partsStatus: null,
          sendingStatus: SendingOfferStatus.initial,
          exception: null,
        ),
      ],
    );

    blocTest<SendingOfferCubit, SendingOfferState>(
      'onSparePartsStatus emits updated partsStatus and resets sendingStatus',
      build: () => SendingOfferCubit(FakeRepositoryManager()),
      act: (cubit) {
        cubit.onSparePartsStatus(SparePartsStatus.available);
      },
      expect: () => [
        const SendingOfferState(
          isValid: true,
          priceErrorMessage: null,
          isPeriodValid: true,
          periodErrorMessage: null,
          partsStatus: SparePartsStatus.available,
          sendingStatus: SendingOfferStatus.initial,
          exception: null,
        ),
      ],
    );
  });
}
