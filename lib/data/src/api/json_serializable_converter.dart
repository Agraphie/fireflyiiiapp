import 'package:chopper/chopper.dart';

typedef T JsonFactory<T>(Map<String, dynamic> json);

// ignore_for_file: argument_type_not_assignable
class JsonSerializableConverter extends JsonConverter {
  final Map<Type, JsonFactory> factories;

  JsonSerializableConverter(this.factories);

  T _decodeMap<T>(Map<String, dynamic> values) {
    /// Get jsonFactory using Type parameters
    /// if not found or invalid, throw error or return null
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! JsonFactory<T>) {
      /// throw serializer not found error;
      return null;
    }

    return jsonFactory(values) as T;
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((dynamic v) => v != null).map<T>(_decode).toList();

  dynamic _decode<T>(dynamic entity) {
    if (entity is Iterable) return _decodeList<T>(entity);

    if (entity is Map) return _decodeMap<T>(entity);

    return entity;
  }

  @override
  Response<ResultType> convertResponse<ResultType, Item>(Response response) {
    if (ResultType is String) {
      return response.body as Response<ResultType>;
    }
    // use [JsonConverter] to decode json
    final jsonRes = super.convertResponse<Map, dynamic>(response);

    return jsonRes.copyWith<ResultType>(body: _decode<Item>(jsonRes.body));
  }

  @override
  // all objects should implements toJson method
  Request convertRequest(Request request) => super.convertRequest(request);
}
