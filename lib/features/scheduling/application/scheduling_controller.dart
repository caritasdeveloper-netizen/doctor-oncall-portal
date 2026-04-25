import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oncall_doctor/features/scheduling/domain/schedule.dart';
import 'package:oncall_doctor/features/scheduling/infrastructure/firebase_schedule_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
          if (draft.firstOnCallDoctorIds.isNotEmpty || draft.secondOnCallDoctorIds.isNotEmpty) {
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
  @override
  SchedulingState build() {
    final date = DateTime.now();
    
    // Watch the schedules for the selected date
    ref.listen(dailySchedulesProvider(date), (prev, next) {
      next.whenData((schedules) {
        final scheduleMap = {for (var s in schedules) s.departmentId: s};
        state = state.copyWith(
          originalSchedules: scheduleMap,
          // Only update draft if it hasn't been modified yet or if it was empty
          draftSchedules: state.hasUnsavedChanges ? state.draftSchedules : scheduleMap,
        );
      });
    });

    return SchedulingState(selectedDate: date);
  }

  void setDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date, 
      draftSchedules: {}, 
      originalSchedules: {}
    );
    
    // We need to listen to the new date's provider
    ref.listen(dailySchedulesProvider(date), (prev, next) {
      next.whenData((schedules) {
        final scheduleMap = {for (var s in schedules) s.departmentId: s};
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

  void updateAssignment(String departmentId, {List<String>? firstOnCall, List<String>? secondOnCall}) {
    final currentDraft = state.draftSchedules[departmentId] ??
        DailySchedule(
          id: '',
          date: state.selectedDate,
          departmentId: departmentId,
        );

    final updatedDraft = currentDraft.copyWith(
      firstOnCallDoctorIds: firstOnCall ?? currentDraft.firstOnCallDoctorIds,
      secondOnCallDoctorIds: secondOnCall ?? currentDraft.secondOnCallDoctorIds,
    );

    final newDrafts = Map<String, DailySchedule>.from(state.draftSchedules);
    newDrafts[departmentId] = updatedDraft;
    state = state.copyWith(draftSchedules: newDrafts);
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
