import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/sp_services.dart';
import 'package:frontend/features/auth/repositary/auth_remote_repositary.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final authRemoteRepositary = AuthRemoteRepositary();
  final spServices = SpServices();

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await authRemoteRepositary.signUp(
        name: name,
        email: email,
        password: password,
      );
      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void logIn({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final user = await authRemoteRepositary.logIn(
        email: email,
        password: password,
      );
      if (user.token.isNotEmpty) {
        await spServices.setToken(user.token);
      }
      emit(AuthLoggedIn(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void getUserData() async {
    try {
      emit(AuthLoading());
      final user = await authRemoteRepositary.getUserData();
      if (user != null) {
        emit(AuthLoggedIn(user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }
}
