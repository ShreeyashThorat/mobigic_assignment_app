import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../utils/exception/app_exception.dart';
import '../../model/user model/user_model.dart';
import '../../repo/auth_repo.dart';

class RegisterUserBloc extends Bloc<RegisterUserEvent, RegisterUserState> {
  RegisterUserBloc() : super(RegisterInitial()) {
    on<RegisterButtonClicked>((event, emit) async {
      emit(RegisterLoding());
      try {
        final userData = await AuthRepo().register(event.email, event.firstname,
            event.lastname, event.dob, event.password);
        emit(RegisterSuccessfully(userData: userData));
      } on AppException catch (e) {
        emit(RegisterError(exception: e));
        e.print;
      } catch (e) {
        log("Error ${e.toString()}");
        emit(RegisterError(exception: AppException()));
      }
    });
  }
}

class RegisterUserEvent extends Equatable {
  const RegisterUserEvent();

  @override
  List<Object> get props => [];
}

class RegisterButtonClicked extends RegisterUserEvent {
  final String email;
  final String password;
  final String firstname;
  final String lastname;
  final String dob;
  const RegisterButtonClicked(
      {required this.email,
      required this.password,
      required this.dob,
      required this.firstname,
      required this.lastname});
}

class RegisterUserState extends Equatable {
  const RegisterUserState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterUserState {}

class RegisterLoding extends RegisterUserState {}

class RegisterSuccessfully extends RegisterUserState {
  final UserModel userData;
  const RegisterSuccessfully({required this.userData});

  @override
  List<Object> get props => [userData];
}

class RegisterError extends RegisterUserState {
  final AppException exception;
  const RegisterError({required this.exception});

  @override
  List<Object> get props => [exception];
}
