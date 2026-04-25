// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_assignment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BulkAssignmentController)
final bulkAssignmentControllerProvider = BulkAssignmentControllerProvider._();

final class BulkAssignmentControllerProvider
    extends $NotifierProvider<BulkAssignmentController, BulkAssignmentState> {
  BulkAssignmentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bulkAssignmentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bulkAssignmentControllerHash();

  @$internal
  @override
  BulkAssignmentController create() => BulkAssignmentController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BulkAssignmentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BulkAssignmentState>(value),
    );
  }
}

String _$bulkAssignmentControllerHash() =>
    r'ef6b4824ba4f9508045df4e7a1c403a512fed421';

abstract class _$BulkAssignmentController
    extends $Notifier<BulkAssignmentState> {
  BulkAssignmentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BulkAssignmentState, BulkAssignmentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BulkAssignmentState, BulkAssignmentState>,
              BulkAssignmentState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
