import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scheduling_ui_providers.g.dart';

/// Tracks which department accordion cards are expanded.
/// Key = department ID → Value = is expanded.
@riverpod
class AccordionExpandedState extends _$AccordionExpandedState {
  @override
  Map<String, bool> build() => {};

  void toggle(String departmentId) {
    final current = state[departmentId] ?? false;
    state = {...state, departmentId: !current};
  }

  bool isExpanded(String departmentId) => state[departmentId] ?? false;
}

/// Tracks the temporary selected doctor IDs inside the picker modal.
/// Key = a unique picker key (e.g. "${deptId}_day_primary") → selected IDs list.
@riverpod
class DoctorPickerSelection extends _$DoctorPickerSelection {
  @override
  Map<String, List<String>> build() => {};

  void init(String key, List<String> ids) {
    if (!state.containsKey(key)) {
      state = {...state, key: List<String>.from(ids)};
    }
  }

  void reset(String key, List<String> ids) {
    state = {...state, key: List<String>.from(ids)};
  }

  void toggle(String key, String doctorId) {
    final current = List<String>.from(state[key] ?? []);
    if (current.contains(doctorId)) {
      current.remove(doctorId);
    } else {
      current.add(doctorId);
    }
    state = {...state, key: current};
  }

  void remove(String key) {
    final newState = Map<String, List<String>>.from(state);
    newState.remove(key);
    state = newState;
  }

  List<String> getSelected(String key) => state[key] ?? [];
}

/// Simple search query per picker instance.
@riverpod
class DoctorPickerSearch extends _$DoctorPickerSearch {
  @override
  Map<String, String> build() => {};

  void setQuery(String key, String query) {
    state = {...state, key: query};
  }

  void clear(String key) {
    state = {...state, key: ''};
  }

  void remove(String key) {
    final newState = Map<String, String>.from(state);
    newState.remove(key);
    state = newState;
  }

  String getQuery(String key) => state[key] ?? '';
}

/// Tracks if the main scheduling search bar is expanded or just an icon.
@riverpod
class SchedulingSearchExpanded extends _$SchedulingSearchExpanded {
  @override
  bool build() => false;

  void setExpanded(bool expanded) => state = expanded;
  void toggle() => state = !state;
}

/// Tracks the current view index in the scheduling page (0 = Daily, 1 = Bulk).
@riverpod
class SchedulingViewIndex extends _$SchedulingViewIndex {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}
