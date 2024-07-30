import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobigic_assignment/data/model/media_model.dart';

import '../../../../utils/exception/app_exception.dart';
import '../../../repo/file_repo.dart';

class GetFilesBloc extends Bloc<GetFilesEvent, GetFilesState> {
  GetFilesBloc() : super(GetFilesInitial()) {
    on<GetMyFilesEvent>((event, emit) async {
      emit(GetFilesLoading());
      try {
        final files = await FileRepo().getFiles();
        emit(GetFilesSuccessfully(files: files));
      } on AppException catch (e) {
        emit(GetFilesError(exception: e));
        e.print;
      } catch (e) {
        log("Error ${e.toString()}");
        emit(GetFilesError(exception: AppException()));
      }
    });

    on<RemoveFileEvent>((event, emit) async {
      if (state is GetFilesSuccessfully) {
        GetFilesSuccessfully currentState = state as GetFilesSuccessfully;
        List<MediaModel> files = currentState.files;
        files.removeAt(event.index);
        return emit(
            currentState.copyWith(newFiles: files.isNotEmpty ? files : []));
      }
    });

    on<AddFileEvent>((event, emit) async {
      if (state is GetFilesSuccessfully) {
        GetFilesSuccessfully currentState = state as GetFilesSuccessfully;
        List<MediaModel> files = currentState.files;
        files.insert(0, event.file);
        return emit(
            currentState.copyWith(newFiles: files.isNotEmpty ? files : []));
      }
    });
  }
}

class GetFilesEvent extends Equatable {
  const GetFilesEvent();

  @override
  List<Object> get props => [];
}

class GetMyFilesEvent extends GetFilesEvent {}

class RemoveFileEvent extends GetFilesEvent {
  final int index;
  const RemoveFileEvent({required this.index});
}

class AddFileEvent extends GetFilesEvent {
  final MediaModel file;
  const AddFileEvent({required this.file});
}

class GetFilesState extends Equatable {
  const GetFilesState();

  @override
  List<Object> get props => [];
}

class GetFilesInitial extends GetFilesState {}

class GetFilesLoading extends GetFilesState {}

class GetFilesSuccessfully extends GetFilesState {
  final List<MediaModel> files;
  const GetFilesSuccessfully({required this.files});
  GetFilesSuccessfully copyWith({List<MediaModel>? newFiles}) {
    return GetFilesSuccessfully(files: newFiles ?? files);
  }
}

class GetFilesError extends GetFilesState {
  final AppException exception;
  const GetFilesError({required this.exception});

  @override
  List<Object> get props => [exception];
}
