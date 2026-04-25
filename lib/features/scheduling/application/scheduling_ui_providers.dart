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

  String getQuery(String key) => state[key] ?? '';
}
