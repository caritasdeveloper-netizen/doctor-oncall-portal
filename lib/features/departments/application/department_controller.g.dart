// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DepartmentController)
final departmentControllerProvider = DepartmentControllerProvider._();

final class DepartmentControllerProvider
    extends $NotifierProvider<DepartmentController, AsyncValue<void>> {
  DepartmentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentControllerHash();

  @$internal
  @override
  DepartmentController create() => DepartmentController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$departmentControllerHash() =>
    r'691f112d429c8ca7d2dba0baef32e59330b58260';

abstract class _$DepartmentController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
