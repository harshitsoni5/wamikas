abstract class UploadImageState {}

class UploadImageInitial extends UploadImageState {}

class UploadImageLoading extends UploadImageState {}

class UploadImageSuccess extends UploadImageState {
  final String? path;
  UploadImageSuccess({required this.path});
}

class UploadImageError extends UploadImageState {}
