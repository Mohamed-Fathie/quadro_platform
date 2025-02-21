import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../features/user/model/user.dart';
import '../../../../../features/user/repository/user_repository.dart';
import '../../../../../features/workshop_main_screen/repository/models/maintenance_request.dart';
import '../../../../../features/workshop_main_screen/repository/repository_manager.dart';
import 'nav_event.dart';
import 'nav_state.dart';

class NavBloc extends Bloc<MainNav, NavState> {
  final RepositoryManager _manager;
  final UserRepository _userRepository;
  QuadroUser? _user;
  Future<QuadroUser?> getuser() async {
    _user ??= await _userRepository.getCachedUser();
    _user ??=
        await _userRepository.getUserById(_userRepository.getuserId ?? "");
    return _user;
  }

  NavBloc(this._userRepository, {required RepositoryManager repositoryManager})
      : _manager = repositoryManager,
        super(const NavState(
          requests: null,
        )) {
    on<MainScreenOfferNotfiction>((event, emit) async {
      final user = await getuser();
      await emit.forEach<List<MaintenanceRequest>>(
        _manager.maintenanceRequestsRepository
            .watchOfferSentRequests(id: user?.id ?? ""),
        onData: (requests) => state.copyWith(thereIsOffer: requests.isNotEmpty),
        onError: (_, __) => state.copyWith(thereIsOffer: false),
      );
    });
  }
}
