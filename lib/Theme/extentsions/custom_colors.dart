// import 'package:flutter/material.dart';


// @immutable
// class CustomSelectColors extends ThemeExtension<CustomSelectColors> {
//   final Color selectedIcon;

//   const CustomSelectColors({required this.selectedIcon});

//   @override
//   CustomSelectColors copyWith({Color? selectedIcon}) {
//     return CustomSelectColors(selectedIcon: selectedIcon ?? this.selectedIcon);
//   }

//   @override
//   CustomSelectColors lerp(ThemeExtension<CustomSelectColors>? other, double t) {
//     if (other is! CustomSelectColors) return this;
//     return CustomSelectColors(
//       selectedIcon: Color.lerp(selectedIcon, other.selectedIcon, t)!,
//     );
//   }
// }

// @immutable
// class CustomUnselectColors extends ThemeExtension<CustomUnselectColors> {
//   final Color unselectedIcon;

//   const CustomUnselectColors({required this.unselectedIcon});

//   @override
//   CustomUnselectColors copyWith({Color? unselectedIcon}) {
//     return CustomUnselectColors(
//       unselectedIcon: unselectedIcon ?? this.unselectedIcon,
//     );
//   }

//   @override
//   CustomUnselectColors lerp(
//     ThemeExtension<CustomUnselectColors>? other,
//     double t,
//   ) {
//     if (other is! CustomUnselectColors) return this;
//     return CustomUnselectColors(
//       unselectedIcon: Color.lerp(unselectedIcon, other.unselectedIcon, t)!,
//     );
//   }
// }

