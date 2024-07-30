import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobigic_assignment/data/model/media_model.dart';
import 'package:mobigic_assignment/data/repo/file_repo.dart';

import '../../../../utils/exception/app_exception.dart';

class UploadFilesBloc extends Bloc<UploadFilesEvent, UploadFilesState> {
  UploadFilesBloc() : super(UploadFilesInitial()) {
    on<UploadFile>((event, emit) async {
      try {
        emit(UploadFileLoading());
        final file = await FileRepo().uploadFile(event.file);
        emit(UploadFileSuccessfully(file: file));
      } on AppException catch (e) {
        emit(UploadFileError(exception: e));
        e.print;
      } catch (e) {
        log("Error ${e.toString()}");
        emit(UploadFileError(exception: AppException()));
      }
    });
  }
}

class UploadFilesEvent extends Equatable {
  const UploadFilesEvent();

  @override
  List<Object> get props => [];
}

class UploadFile extends UploadFilesEvent {
  final File file;
  const UploadFile({required this.file});
}

class UploadFilesState extends Equatable {
  const UploadFilesState();

  @override
  List<Object> get props => [];
}

class UploadFilesInitial extends UploadFilesState {}

class UploadFileLoading extends UploadFilesState {}

class UploadFileSuccessfully extends UploadFilesState {
  final MediaModel file;
  const UploadFileSuccessfully({required this.file});
}

class UploadFileError extends UploadFilesState {
  final AppException exception;
  const UploadFileError({required this.exception});

  @override
  List<Object> get props => [exception];
}
