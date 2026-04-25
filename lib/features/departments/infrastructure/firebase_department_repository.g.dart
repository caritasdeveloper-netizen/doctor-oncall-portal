// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_department_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(departmentRepository)
final departmentRepositoryProvider = DepartmentRepositoryProvider._();

final class DepartmentRepositoryProvider
    extends
        $FunctionalProvider<
          DepartmentRepository,
          DepartmentRepository,
          DepartmentRepository
        >
    with $Provider<DepartmentRepository> {
  DepartmentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentRepositoryHash();

  @$internal
  @override
  $ProviderElement<DepartmentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DepartmentRepository create(Ref ref) {
    return departmentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DepartmentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DepartmentRepository>(value),
    );
  }
}

String _$departmentRepositoryHash() =>
    r'd341f69a6371b31fbcffb4b3c4c1cc4f6bb00b1d';
