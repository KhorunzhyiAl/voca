import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/injectable/injectable_init.dart';

@LazySingleton(as: UserSettingsRepository, env: [mainEnv])
class UserSettingsRepositoryImpl extends UserSettingsRepository {
  UserSettingsRepositoryImpl(
    this._prefs,
  );

  final SharedPreferences _prefs;

  @override
  Future<void> setRepetitionCount(int n) async {
    if (!DomainConstants.cardRepetitionSettingWithinRange(n)) {
      throw RepetitionCountLimitException();
    }
    final success = await _prefs.setInt(_Keys.repetitionCount, n);

    if (!success) {
      throw StorageUpdateFailed();
    }
  }

  @override
  Future<int> getRepetitionCount() async {
    if (_prefs.getInt(_Keys.repetitionCount) case final repetitionCount?) {
      return repetitionCount;
    } else {
      await setRepetitionCount(DomainConstants.defaultCardRepetitionsSetting);
      return DomainConstants.defaultCardRepetitionsSetting;
    }
  }

  @override
  Future<bool?> isCrashlyticsCollectionAccepted() async {
    return _prefs.getBool(_Keys.crashlyticsCollectionAccepted);
  }

  @override
  Future<void> setCrashlyticsCollectionAccepted(bool accepted) async {
    await _prefs.setBool(_Keys.crashlyticsCollectionAccepted, accepted);
  }
}

class _Keys {
  static const repetitionCount = 'repetitionCount';
  static const crashlyticsCollectionAccepted = 'crashlyticsCollectionAccepted';
}

sealed class UserSettingsException implements Exception {}

class RepetitionCountLimitException extends UserSettingsException {}

class StorageUpdateFailed extends UserSettingsException {}