// /// Définission du provider de gameManager
// ///
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logic_game/models/tempory/session_state.dart';
import 'package:logic_game/services/game_manager.dart';
import 'package:logic_game/services/move_manager_service.dart';

final gameManagerProvider = StateNotifierProvider.autoDispose
    .family<GameManager, SessionState, int>((ref, levelId) {

      final moveManagerService = MoveManagerService();

      return GameManager(levelId, ref, moveManagerService);
    });
