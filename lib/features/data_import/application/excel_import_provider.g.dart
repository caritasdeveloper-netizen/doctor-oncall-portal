// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excel_import_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExcelImportNotifier)
final excelImportProvider = ExcelImportNotifierProvider._();

final class ExcelImportNotifierProvider
    extends $NotifierProvider<ExcelImportNotifier, ExcelImportState> {
  ExcelImportNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'excelImportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$excelImportNotifierHash();

  @$internal
  @override
  ExcelImportNotifier create() => ExcelImportNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExcelImportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExcelImportState>(value),
    );
  }
}

String _$excelImportNotifierHash() =>
    r'5b3c3eda3a0bd29e08cb16eb5c511246afb78c43';

abstract class _$ExcelImportNotifier extends $Notifier<ExcelImportState> {
  ExcelImportState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExcelImportState, ExcelImportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExcelImportState, ExcelImportState>,
              ExcelImportState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
