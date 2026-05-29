import 'package:flutter/foundation.dart';

class SidebarState {
  SidebarState._();

  static final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);

  static void setExpanded(bool value) {
    isExpanded.value = value;
  }

  static void toggle() {
    isExpanded.value = !isExpanded.value;
  }
}
