import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../utils/exception/app_exception.dart';
import '../../../repo/file_repo.dart';

class FileActionBloc extends Bloc<FileActionEvent, FileActionState> {
  FileActionBloc() : super(FileActionInitial()) {
    on<DeleteFileEvent>((event, emit) async {
      try {
        emit(FileActionLoading());
        final message = await FileRepo().deleteFile(event.id);
        emit(FileActionSuccessful(removeFile: true, message: message));
      } on AppException catch (e) {
        emit(FileActionError(exception: e));
        e.print;
      } catch (e) {
        log("Error ${e.toString()}");
        emit(FileActionError(exception: AppException()));
      }
    });

    on<DownloadFileEvent>((event, emit) async {
      try {
        emit(FileActionLoading());
        await FileRepo().downloadFile(event.url, event.filename);
        emit(const FileActionSuccessful(
            removeFile: false, message: "File Downloaded Successfully"));
      } on AppException catch (e) {
        emit(FileActionError(exception: e));
        e.print;
      } catch (e) {
        log("Error ${e.toString()}");
        emit(FileActionError(exception: AppException()));
      }
    });
  }
}

class FileActionEvent extends Equatable {
  const FileActionEvent();

  @override
  List<Object> get props => [];
}

class DeleteFileEvent extends FileActionEvent {
  final int id;
  const DeleteFileEvent({required this.id});
}

class DownloadFileEvent extends FileActionEvent {
  final String url;
  final String filename;
  const DownloadFileEvent({required this.url, required this.filename});
}

class FileActionState extends Equatable {
  const FileActionState();

  @override
  List<Object> get props => [];
}

class FileActionInitial extends FileActionState {}

class FileActionLoading extends FileActionState {}

class FileActionSuccessful extends FileActionState {
  final bool removeFile;
  final String message;
  const FileActionSuccessful({required this.removeFile, required this.message});
}

class FileActionError extends FileActionState {
  final AppException exception;
  const FileActionError({required this.exception});

  @override
  List<Object> get props => [exception];
}
