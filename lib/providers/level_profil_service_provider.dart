import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logic_game/services/level_profil_service.dart';

final levelProfilServiceProvider = Provider<LevelProfilService>((ref) {
  return LevelProfilService();
});
