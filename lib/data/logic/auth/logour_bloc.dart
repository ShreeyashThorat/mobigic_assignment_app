import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobigic_assignment/data/local%20database/local_db.dart';

import '../../../utils/exception/app_exception.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc() : super(LogoutInitial()) {
    on<LogoutButtonClicked>((event, emit) async {
      emit(LogoutLoading());
      try {
        await LocalDatabase.deleteUserData();
        emit(LogoutSuccess());
      } catch (e) {
        log(e.toString());
        emit(LogoutFailed(exception: AppException(message: "Logout Failed!")));
      }
    });
  }
}

sealed class LogoutEvent extends Equatable {
  const LogoutEvent();

  @override
  List<Object> get props => [];
}

class LogoutButtonClicked extends LogoutEvent {
  const LogoutButtonClicked();
}

sealed class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

final class LogoutInitial extends LogoutState {}

final class LogoutLoading extends LogoutState {}

final class LogoutSuccess extends LogoutState {}

final class LogoutFailed extends LogoutState {
  final AppException exception;
  const LogoutFailed({required this.exception});

  @override
  List<Object> get props => [exception];
}
