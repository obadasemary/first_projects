sealed class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Exception? exception) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is Failure<T>) {
      final failureCase = this as Failure<T>;
      return failure(failureCase.message, failureCase.exception);
    }
    throw Exception('Unknown ApiResult type');
  }
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends ApiResult<T> {
  final String message;
  final Exception? exception;
  const Failure(this.message, [this.exception]);
}
