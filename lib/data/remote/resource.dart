
sealed class Resource<T> {
  const Resource._();

  factory Resource.loading() = ResourceLoading;

  factory Resource.success(T? data) = ResourceSuccess;

  static Resource<T> error<T>(dynamic error) {
    String message = "Unknown Error";

    if (error != null) {

      if (error is Exception) {
        message = error.toString().replaceAll('Exception: ', '');
      } else if (error is Error) {
        message = error.toString();
      } else if (error is String) {
        message = error;
      } else {
        message = error.toString();
      }
    }

    return ResourceError(error, message);
  }
}

class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading() : super._();
}

class ResourceSuccess<T> extends Resource<T> {
  final T? data;
  const ResourceSuccess(this.data) : super._();
}

class ResourceError<T> extends Resource<T> {
  final dynamic error;
  final String message;

  const ResourceError(this.error, this.message) : super._();
}