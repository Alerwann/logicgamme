// /// Définission du provider de gameManager
// ///
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logic_game/models/hive/level/level_model.dart';
import 'package:logic_game/models/tempory/session_state.dart';
import 'package:logic_game/providers/hive_service_provider.dart';
import 'package:logic_game/providers/money_provider.dart';
import 'package:logic_game/providers/money_service_provider.dart';
import 'package:logic_game/services/game_manager.dart';
import 'package:logic_game/services/move_manager_service.dart';

final gameManagerProvider =
    StateNotifierProvider.family<GameManager, SessionState, LevelModel>((
      ref,
      level,
    ) {
      final hiveService = ref.read(hiveServiceProvider);

      final moveManagerService = MoveManagerService();

      final moneyService = ref.read(moneyServiceProvider);

      final initialMoney = ref.read(moneyProvider);

      return GameManager(
        level,
        moneyService,
        hiveService,
        ref,
        moveManagerService,
        initialMoney: initialMoney,
      );
    });
