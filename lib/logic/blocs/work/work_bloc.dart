import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/work_entity.dart';
import '../../../data/remote/resource.dart';
import '../../../domain/repositories/work_repository.dart';

// Events
abstract class WorkEvent extends Equatable {
  const WorkEvent();
  @override
  List<Object> get props => [];
}

// Keep this event for when you actually want to load the works
class LoadWorks extends WorkEvent {
  const LoadWorks();
}

// State (remains the same)
abstract class WorkState extends Equatable {
  const WorkState();
  @override
  List<Object> get props => [];
}
class WorkInitial extends WorkState {}
class WorkLoading extends WorkState {}
class WorkLoaded extends WorkState {
  final List<WorkEntity> works;
  const WorkLoaded(this.works);
}
class WorkError extends WorkState {
  final String message;
  const WorkError(this.message);
}

// Bloc
class WorkBloc extends Bloc<WorkEvent, WorkState> {
  final WorkRepository repository;

  WorkBloc(this.repository) : super(WorkInitial()) {
    on<LoadWorks>(_onLoadWorks);
  }

  Future<void> _onLoadWorks(LoadWorks event, Emitter<WorkState> emit) async {
    emit(WorkLoading());
    try {
      final resource = await repository.getWorks(101036);
      if (resource is ResourceSuccess<List<WorkEntity>>) {
        emit(WorkLoaded(resource.data ?? []));
      } else if (resource is ResourceError<List<WorkEntity>>) {
        emit(WorkError(resource.message));
      }
    } catch (e) {
      emit(WorkError(e.toString()));
    }
  }
}
