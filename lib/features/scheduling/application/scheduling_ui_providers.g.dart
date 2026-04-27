// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduling_ui_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks which department accordion cards are expanded.
/// Key = department ID → Value = is expanded.

@ProviderFor(AccordionExpandedState)
final accordionExpandedStateProvider = AccordionExpandedStateProvider._();

/// Tracks which department accordion cards are expanded.
/// Key = department ID → Value = is expanded.
final class AccordionExpandedStateProvider
    extends $NotifierProvider<AccordionExpandedState, Map<String, bool>> {
  /// Tracks which department accordion cards are expanded.
  /// Key = department ID → Value = is expanded.
  AccordionExpandedStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accordionExpandedStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accordionExpandedStateHash();

  @$internal
  @override
  AccordionExpandedState create() => AccordionExpandedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, bool>>(value),
    );
  }
}

String _$accordionExpandedStateHash() =>
    r'546dd1acd53c32ce3c31ff21201d85e581f4b0c3';

/// Tracks which department accordion cards are expanded.
/// Key = department ID → Value = is expanded.

abstract class _$AccordionExpandedState extends $Notifier<Map<String, bool>> {
  Map<String, bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, bool>, Map<String, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, bool>, Map<String, bool>>,
              Map<String, bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Tracks the temporary selected doctor IDs inside the picker modal.
/// Key = a unique picker key (e.g. "${deptId}_day_primary") → selected IDs list.

@ProviderFor(DoctorPickerSelection)
final doctorPickerSelectionProvider = DoctorPickerSelectionProvider._();

/// Tracks the temporary selected doctor IDs inside the picker modal.
/// Key = a unique picker key (e.g. "${deptId}_day_primary") → selected IDs list.
final class DoctorPickerSelectionProvider
    extends
        $NotifierProvider<DoctorPickerSelection, Map<String, List<String>>> {
  /// Tracks the temporary selected doctor IDs inside the picker modal.
  /// Key = a unique picker key (e.g. "${deptId}_day_primary") → selected IDs list.
  DoctorPickerSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doctorPickerSelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doctorPickerSelectionHash();

  @$internal
  @override
  DoctorPickerSelection create() => DoctorPickerSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<String>>>(value),
    );
  }
}

String _$doctorPickerSelectionHash() =>
    r'f6c88dc7ae749b0275a49730b3e75dff724692e2';

/// Tracks the temporary selected doctor IDs inside the picker modal.
/// Key = a unique picker key (e.g. "${deptId}_day_primary") → selected IDs list.

abstract class _$DoctorPickerSelection
    extends $Notifier<Map<String, List<String>>> {
  Map<String, List<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<String, List<String>>, Map<String, List<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, List<String>>, Map<String, List<String>>>,
              Map<String, List<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Simple search query per picker instance.

@ProviderFor(DoctorPickerSearch)
final doctorPickerSearchProvider = DoctorPickerSearchProvider._();

/// Simple search query per picker instance.
final class DoctorPickerSearchProvider
    extends $NotifierProvider<DoctorPickerSearch, Map<String, String>> {
  /// Simple search query per picker instance.
  DoctorPickerSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doctorPickerSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doctorPickerSearchHash();

  @$internal
  @override
  DoctorPickerSearch create() => DoctorPickerSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$doctorPickerSearchHash() =>
    r'875e3dc80445bc8c4500e54721eedfaaf1cae8a3';

/// Simple search query per picker instance.

abstract class _$DoctorPickerSearch extends $Notifier<Map<String, String>> {
  Map<String, String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, String>, Map<String, String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, String>, Map<String, String>>,
              Map<String, String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Tracks if the main scheduling search bar is expanded or just an icon.

@ProviderFor(SchedulingSearchExpanded)
final schedulingSearchExpandedProvider = SchedulingSearchExpandedProvider._();

/// Tracks if the main scheduling search bar is expanded or just an icon.
final class SchedulingSearchExpandedProvider
    extends $NotifierProvider<SchedulingSearchExpanded, bool> {
  /// Tracks if the main scheduling search bar is expanded or just an icon.
  SchedulingSearchExpandedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'schedulingSearchExpandedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$schedulingSearchExpandedHash();

  @$internal
  @override
  SchedulingSearchExpanded create() => SchedulingSearchExpanded();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$schedulingSearchExpandedHash() =>
    r'32bb1e57b0747c841576f22d6930fa494a7a74a2';

/// Tracks if the main scheduling search bar is expanded or just an icon.

abstract class _$SchedulingSearchExpanded extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
