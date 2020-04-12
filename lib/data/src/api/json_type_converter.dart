import 'dart:convert';

import 'package:chopper/chopper.dart';

class JsonToTypeConverter extends JsonConverter {
  final Map<Type, Function> typeToJsonFactoryMap;

  JsonToTypeConverter(this.typeToJsonFactoryMap);

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    Function parser = typeToJsonFactoryMap[InnerType];
    // No parser, just return
    if (parser == null) {
      return response as Response<BodyType>;
    }
    return response.copyWith(
      body: fromJsonData<BodyType, InnerType>(response.body as String, parser),
    );
  }

  T fromJsonData<T, InnerType>(String jsonData, Function jsonParser) {
    dynamic jsonMap = json.decode(jsonData);

    if (jsonMap is Iterable) {
      return jsonMap
          .map((dynamic item) =>
              jsonParser(item as Map<String, dynamic>) as InnerType)
          .toList() as T;
    }

    // ignore
    return jsonParser(jsonMap) as T;
  }
}
