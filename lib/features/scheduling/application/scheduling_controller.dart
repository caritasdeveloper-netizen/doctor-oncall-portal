import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oncall_doctor/features/scheduling/domain/schedule.dart';
import 'package:oncall_doctor/features/scheduling/infrastructure/firebase_schedule_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'scheduling_controller.freezed.dart';
part 'scheduling_controller.g.dart';

@freezed
abstract class SchedulingState with _$SchedulingState {
  const factory SchedulingState({
    required DateTime selectedDate,
    @Default('') String searchQuery,
    @Default({}) Map<String, DailySchedule> draftSchedules,
    @Default({}) Map<String, DailySchedule> originalSchedules,
    @Default(false) bool isSaving,
  }) = _SchedulingState;

  const SchedulingState._();

  bool get hasUnsavedChanges {
    if (draftSchedules.length != originalSchedules.length) {
      for (final draft in draftSchedules.values) {
        final original = originalSchedules[draft.departmentId];
        if (original == null) {
          if (draft.dayFirstOnCallDoctorIds.isNotEmpty || 
              draft.daySecondOnCallDoctorIds.isNotEmpty ||
              draft.nightFirstOnCallDoctorIds.isNotEmpty ||
              draft.nightSecondOnCallDoctorIds.isNotEmpty) {
            return true;
          }
        } else if (draft != original) {
          return true;
        }
      }
      // Also check if any original is missing in draft (unlikely but for completeness)
      for (final original in originalSchedules.values) {
        if (!draftSchedules.containsKey(original.departmentId)) return true;
      }
      return false;
    }
    for (final key in draftSchedules.keys) {
      if (draftSchedules[key] != originalSchedules[key]) return true;
    }
    return false;
  }
}

@riverpod
Stream<List<DailySchedule>> dailySchedules(Ref ref, DateTime date) {
  return ref.watch(scheduleRepositoryProvider).watchSchedules(date);
}

@riverpod
class SchedulingController extends _$SchedulingController {
  ProviderSubscription? _subscription;

  @override
  SchedulingState build() {
    final date = DateTime.now();

    // Read initial data synchronously to avoid updating state during build
    final initialAsync = ref.read(dailySchedulesProvider(date));
    var original = <String, DailySchedule>{};
    var draft = <String, DailySchedule>{};

    initialAsync.whenData((schedules) {
      original = {for (var s in schedules) s.departmentId: s};
      draft = original;
    });

    // Watch the schedules for future updates on the selected date
    _subscription = ref.listen(dailySchedulesProvider(date), (prev, next) {
      final asyncNext = next as AsyncValue<List<DailySchedule>>;
      asyncNext.whenData((schedules) {
        final scheduleMap = <String, DailySchedule>{for (var s in schedules) s.departmentId: s};
        state = state.copyWith(
          originalSchedules: scheduleMap,
          // Only update draft if it hasn't been modified yet or if it was empty
          draftSchedules: state.hasUnsavedChanges ? state.draftSchedules : scheduleMap,
        );
      });
    });

    return SchedulingState(
      selectedDate: date,
      originalSchedules: original,
      draftSchedules: draft,
    );
  }

  void setDate(DateTime date) {
    _subscription?.close();

    // Read initial data synchronously for the new date
    final initialAsync = ref.read(dailySchedulesProvider(date));
    var original = <String, DailySchedule>{};
    var draft = <String, DailySchedule>{};

    initialAsync.whenData((schedules) {
      original = {for (var s in schedules) s.departmentId: s};
      draft = original;
    });

    state = state.copyWith(
      selectedDate: date,
      draftSchedules: draft,
      originalSchedules: original,
    );

    // Listen to the new date's stream for future updates
    _subscription = ref.listen(dailySchedulesProvider(date), (prev, next) {
      final asyncNext = next as AsyncValue<List<DailySchedule>>;
      asyncNext.whenData((schedules) {
        final scheduleMap = <String, DailySchedule>{for (var s in schedules) s.departmentId: s};
        state = state.copyWith(
          originalSchedules: scheduleMap,
          draftSchedules: scheduleMap,
        );
      });
    });
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> saveAssignment(String departmentId, {
    List<String>? firstOnCall, 
    List<String>? secondOnCall,
    bool isNight = false,
  }) async {
    final currentDraft = state.draftSchedules[departmentId] ??
        DailySchedule(
          id: '',
          date: state.selectedDate,
          departmentId: departmentId,
        );

    final updatedDraft = isNight 
      ? currentDraft.copyWith(
          nightFirstOnCallDoctorIds: firstOnCall ?? currentDraft.nightFirstOnCallDoctorIds,
          nightSecondOnCallDoctorIds: secondOnCall ?? currentDraft.nightSecondOnCallDoctorIds,
        )
      : currentDraft.copyWith(
          dayFirstOnCallDoctorIds: firstOnCall ?? currentDraft.dayFirstOnCallDoctorIds,
          daySecondOnCallDoctorIds: secondOnCall ?? currentDraft.daySecondOnCallDoctorIds,
        );

    // Update draft immediately for UI responsiveness
    final newDrafts = Map<String, DailySchedule>.from(state.draftSchedules);
    newDrafts[departmentId] = updatedDraft;
    state = state.copyWith(draftSchedules: newDrafts, isSaving: true);

    try {
      // Save directly to backend
      await ref.read(scheduleRepositoryProvider).saveSchedules([updatedDraft]);
      
      // Update original so it matches draft
      final newOriginals = Map<String, DailySchedule>.from(state.originalSchedules);
      newOriginals[departmentId] = updatedDraft;
      state = state.copyWith(originalSchedules: newOriginals);
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  void resetChanges() {
    state = state.copyWith(draftSchedules: Map.from(state.originalSchedules));
  }

  Future<void> saveChanges() async {
    state = state.copyWith(isSaving: true);
    try {
      final changedSchedules = state.draftSchedules.values
          .where((draft) => draft != state.originalSchedules[draft.departmentId])
          .toList();
      
      await ref.read(scheduleRepositoryProvider).saveSchedules(changedSchedules);
      state = state.copyWith(originalSchedules: Map.from(state.draftSchedules));
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
