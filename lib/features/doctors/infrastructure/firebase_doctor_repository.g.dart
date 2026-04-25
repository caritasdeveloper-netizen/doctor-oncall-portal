// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_doctor_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(doctorRepository)
final doctorRepositoryProvider = DoctorRepositoryProvider._();

final class DoctorRepositoryProvider
    extends
        $FunctionalProvider<
          DoctorRepository,
          DoctorRepository,
          DoctorRepository
        >
    with $Provider<DoctorRepository> {
  DoctorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doctorRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doctorRepositoryHash();

  @$internal
  @override
  $ProviderElement<DoctorRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DoctorRepository create(Ref ref) {
    return doctorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DoctorRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DoctorRepository>(value),
    );
  }
}

String _$doctorRepositoryHash() => r'1abb764740b7e47135ec8adb92ce0a02620b10d4';
