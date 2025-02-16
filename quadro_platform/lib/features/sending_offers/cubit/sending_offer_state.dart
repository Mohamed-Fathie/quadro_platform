part of 'sending_offer_cubit.dart';

enum SendingOfferStatus { initial, loading, failure, success }

@immutable
class SendingOfferState extends Equatable {
  final SparePartsStatus? partsStatus;
  final String? priceErrorMessage;
  final String? periodErrorMessage;
  final String? exception;
  final SendingOfferStatus sendingStatus;

  const SendingOfferState({
    this.priceErrorMessage,
    this.exception,
    this.periodErrorMessage,
    this.partsStatus,
    this.sendingStatus = SendingOfferStatus.initial,
  });
  SendingOfferState copyWith({
    SparePartsStatus? partsStatus,
    String? priceErrorMessage,
    String? periodErrorMessage,
    String? exception,
    bool? isValid,
    bool? isPeriodValid,
    SendingOfferStatus? sendingStatus,
  }) {
    return SendingOfferState(
      exception: exception ?? this.exception,
      sendingStatus: sendingStatus ?? this.sendingStatus,
      partsStatus: partsStatus ?? this.partsStatus,
      priceErrorMessage: isValid != null && !isValid ? priceErrorMessage : null,
      periodErrorMessage:
          isPeriodValid != null && !isPeriodValid ? periodErrorMessage : null,
    );
  }

  @override
  List<Object?> get props => [
        partsStatus,
        priceErrorMessage,
        periodErrorMessage,
        sendingStatus,
        exception
      ];
}
