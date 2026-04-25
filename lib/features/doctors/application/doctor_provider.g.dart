// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(doctors)
final doctorsProvider = DoctorsProvider._();

final class DoctorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Doctor>>,
          List<Doctor>,
          Stream<List<Doctor>>
        >
    with $FutureModifier<List<Doctor>>, $StreamProvider<List<Doctor>> {
  DoctorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doctorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doctorsHash();

  @$internal
  @override
  $StreamProviderElement<List<Doctor>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Doctor>> create(Ref ref) {
    return doctors(ref);
  }
}

String _$doctorsHash() => r'f2acd0a597bd99c488e5dc21d4a24c1a63fa389e';

@ProviderFor(DoctorController)
final doctorControllerProvider = DoctorControllerProvider._();

final class DoctorControllerProvider
    extends $AsyncNotifierProvider<DoctorController, void> {
  DoctorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doctorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doctorControllerHash();

  @$internal
  @override
  DoctorController create() => DoctorController();
}

String _$doctorControllerHash() => r'01861960fe9da866da4b17f2e161dbfd398c3017';

abstract class _$DoctorController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
