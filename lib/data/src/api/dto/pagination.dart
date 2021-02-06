import 'package:chopper/chopper.dart';
import 'package:fireflyapp/data/src/api/dto/metable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

@freezed
abstract class Pagination with _$Pagination {
  const factory Pagination(
      int total,
      int count,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'total_pages') int totalPages) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  //Only needed as long as API doesn't support a page size parameter.
  static Stream<S> test<S extends Metable>(
      S value, Future<Response<S>> Function(int) apiCall) {
    int pages = value?.meta?.pagination?.totalPages ?? 1;

    if (pages > 1) {
      return Rx.merge([
        Stream.value(value),
        // Skip the first page and "0" page, as we start the count from 0 but the Firefly API starts from 1
        RangeStream(2, pages)
            .flatMap((i) => apiCall(i).asStream())
            .map((response) => response.body)
      ]);
    } else {
      return Stream.value(value);
    }
  }
}
