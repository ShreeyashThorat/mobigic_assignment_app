import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../utils/exception/app_exception.dart';
import '../../model/user model/user_model.dart';
import '../../repo/auth_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonClicked>((event, emit) async {
      emit(LoginLoding());
      try {
        final userData = await AuthRepo().login(event.email, event.password);
        emit(LoginSuccessfully(userData: userData));
      } on AppException catch (e) {
        emit(LoginError(exception: e));
        e.print;
      } catch (e) {
        log("Error ${e.toString()}");
        emit(LoginError(exception: AppException()));
      }
    });
  }
}

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonClicked extends LoginEvent {
  final String email;
  final String password;
  const LoginButtonClicked({required this.email, required this.password});
}

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoding extends LoginState {}

class LoginSuccessfully extends LoginState {
  final UserModel userData;
  const LoginSuccessfully({required this.userData});

  @override
  List<Object> get props => [userData];
}

class LoginError extends LoginState {
  final AppException exception;
  const LoginError({required this.exception});

  @override
  List<Object> get props => [exception];
}
