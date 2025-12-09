import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';

abstract class PreviewState {}
class PreviewInitial extends PreviewState {}
class PreviewSaving extends PreviewState {}
class PreviewSaved extends PreviewState {}
class PreviewError extends PreviewState {
  final String message;
  PreviewError(this.message);
}

class PreviewCubit extends Cubit<PreviewState> {
  PreviewCubit() : super(PreviewInitial());

  Future<void> saveMedia(String filePath, bool isVideo) async {
    emit(PreviewSaving());
    try {
      if(isVideo){
        await Gal.putVideo(filePath, album: 'DemoGemma3');
      }else {
        await Gal.putImage(filePath, album: 'DemoGemma3');
      }
      emit(PreviewSaved());
    } catch (e) {
      emit(PreviewError("Failed to save: $e"));
    }
  }
}