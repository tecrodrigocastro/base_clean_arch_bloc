import 'package:equatable/equatable.dart';

class AppResponse<T> extends Equatable {
  final bool success;

  final String message;

  final T? data;

  final int statusCode;

  final String statusMessage;

  const AppResponse._({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.statusMessage,
    this.data,
  });

  factory AppResponse({
    required bool success,
    required String message,
    int? statusCode,
    String? statusMessage,
    T? data,
  }) =>
      AppResponse._(
        success: success,
        message: message,
        statusCode: statusCode ?? 200,
        statusMessage:
            statusMessage ?? "A requisição foi concluída com sucesso",
        data: data,
      );
  factory AppResponse.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return AppResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      statusCode: json['statusCode'] ?? 200,
      statusMessage:
          json['statusMessage'] ?? "A requisição foi concluída com sucesso",
      data: fromJsonT(json['data']),
    );
  }

  Map<String, dynamic> toJson(Object? Function(T? value) toJsonT) {
    return {
      'success': success,
      'message': message,
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'data': toJsonT(data as T),
    };
  }

  Map<String, dynamic> fromJsonT(Object? json) {
    return json as Map<String, dynamic>;
  }

  Object toJsonT(Map<String, dynamic> value) {
    return value;
  }

  @override
  List<Object?> get props {
    return [
      success,
      message,
      data ?? "",
    ];
  }

  @override
  bool get stringify => true;
}
