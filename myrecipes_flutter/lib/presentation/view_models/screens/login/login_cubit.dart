import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  void login(String email, String password) async {
    emit(LoginProgress());
    try {
      await _authRepository.login(email, password);
      emit(LoginSuccess());
    } catch (e) {
      print(e);
      emit(LoginFailure());
    }
  }
}
