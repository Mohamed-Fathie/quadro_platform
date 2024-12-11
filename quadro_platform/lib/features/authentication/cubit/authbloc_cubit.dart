import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'authbloc_state.dart';

class AuthblocCubit extends Cubit<AuthblocState> {
  AuthblocCubit() : super(AuthblocInitial());
}
