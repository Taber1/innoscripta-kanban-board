abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class LoadTheme extends ThemeEvent {
  final bool isDarkMode;
  
  LoadTheme({this.isDarkMode = true});
} 