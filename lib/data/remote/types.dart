class BaseResponse<T> {
  final T result;

  BaseResponse({required this.result});

  factory BaseResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) {
    return BaseResponse(
      result: fromJsonT(json['result']),
    );
  }
}