// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(departments)
final departmentsProvider = DepartmentsProvider._();

final class DepartmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Department>>,
          List<Department>,
          Stream<List<Department>>
        >
    with $FutureModifier<List<Department>>, $StreamProvider<List<Department>> {
  DepartmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentsHash();

  @$internal
  @override
  $StreamProviderElement<List<Department>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Department>> create(Ref ref) {
    return departments(ref);
  }
}

String _$departmentsHash() => r'6462eaf5ad0d3a064d4a1c2c3d5bb447a2931735';
