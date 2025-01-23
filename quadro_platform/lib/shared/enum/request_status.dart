import '../../features/workshop_main_screen/bloc/main_screenbloc_bloc.dart';
import '../../user/view/mainUserScreen/bloc/main_screen_bloc.dart';

enum RequestStatus {
  loading,
  failure,
  success,
}

extension MainUserScreenStatusMapper on MainUserScreenState {
  RequestStatus get requestStatus {
    switch (status) {
      case MainUserScreenStatus.reqestloading:
        return RequestStatus.loading;
      case MainUserScreenStatus.requestFailure:
        return RequestStatus.failure;
      case MainUserScreenStatus.success:
        return RequestStatus.success;
      default:
        return RequestStatus.loading;
    }
  }
}

extension MainScreenStatusMapper on MainScreenState {
  RequestStatus get requestStatus {
    switch (status) {
      case MainScreenStatus.reqestloading:
        return RequestStatus.loading;
      case MainScreenStatus.requestFailure:
        return RequestStatus.failure;
      case MainScreenStatus.success:
        return RequestStatus.success;
      default:
        return RequestStatus.loading;
    }
  }
}
