// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduling_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailySchedules)
final dailySchedulesProvider = DailySchedulesFamily._();

final class DailySchedulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DailySchedule>>,
          List<DailySchedule>,
          Stream<List<DailySchedule>>
        >
    with
        $FutureModifier<List<DailySchedule>>,
        $StreamProvider<List<DailySchedule>> {
  DailySchedulesProvider._({
    required DailySchedulesFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'dailySchedulesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dailySchedulesHash();

  @override
  String toString() {
    return r'dailySchedulesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<DailySchedule>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DailySchedule>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return dailySchedules(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DailySchedulesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dailySchedulesHash() => r'44cc56d4b5e60e78781d8e2b62515369aa609d0e';

final class DailySchedulesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<DailySchedule>>, DateTime> {
  DailySchedulesFamily._()
    : super(
        retry: null,
        name: r'dailySchedulesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DailySchedulesProvider call(DateTime date) =>
      DailySchedulesProvider._(argument: date, from: this);

  @override
  String toString() => r'dailySchedulesProvider';
}

@ProviderFor(SchedulingController)
final schedulingControllerProvider = SchedulingControllerProvider._();

final class SchedulingControllerProvider
    extends $NotifierProvider<SchedulingController, SchedulingState> {
  SchedulingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'schedulingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$schedulingControllerHash();

  @$internal
  @override
  SchedulingController create() => SchedulingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SchedulingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SchedulingState>(value),
    );
  }
}

String _$schedulingControllerHash() =>
    r'c8387395a9a07965d1d25450f0205e2fbc50dc7c';

abstract class _$SchedulingController extends $Notifier<SchedulingState> {
  SchedulingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SchedulingState, SchedulingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SchedulingState, SchedulingState>,
              SchedulingState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
