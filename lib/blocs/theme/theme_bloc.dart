import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_test_kanban/blocs/theme/theme_event.dart';
import 'package:innoscripta_test_kanban/blocs/theme/theme_state.dart';
import '../../data/services/local_storage_service.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String themeKey = 'app_theme_mode';

  ThemeBloc() : super(const ThemeInitial(false)) {
    on<LoadTheme>((event, emit) async {
      final isDarkMode = event.isDarkMode;
      emit(ThemeInitial(isDarkMode));
    });
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onToggleTheme(
      ToggleTheme event, Emitter<ThemeState> emit) async {
    final newIsDarkMode = !state.isDarkMode;
    await LocalStorageService.setString(
        themeKey, newIsDarkMode ? 'dark' : 'light');
    emit(ThemeInitial(newIsDarkMode));
  }
}
