import 'package:injectable/injectable.dart';
import 'package:voca/data/repositories/user_settings_repository_impl.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/domain/entities/app_theme.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/injectable/injectable_init.dart';
import 'package:voca/presentation/base/theming/theming.dart';

@LazySingleton(as: UserSettingsRepository, env: [InjectableEnv.test])
class UserSettingsRepositoryMock extends UserSettingsRepository {
  UserSettingsRepositoryMock();

  int? _repetitionCount;
  bool? _crashlyticsCollectionAccepted;

  @override
  Future<void> setRepetitionCount(int n) async {
    if (!DomainConstants.cardRepetitionSettingWithinRange(n)) {
      throw RepetitionCountLimitException();
    }

    _repetitionCount = n;
  }

  @override
  Future<int> getRepetitionCount() async {
    if (_repetitionCount case final repetitionCount?) {
      return repetitionCount;
    } else {
      await setRepetitionCount(DomainConstants.defaultCardRepetitionsSetting);
      return DomainConstants.defaultCardRepetitionsSetting;
    }
  }

  @override
  Future<bool?> isCrashlyticsCollectionAccepted() async {
    return _crashlyticsCollectionAccepted;
  }

  @override
  Future<void> setCrashlyticsCollectionAccepted(bool accepted) async {
    _crashlyticsCollectionAccepted = accepted;
  }

  @override
  Future<AppTheme> getTheme() async {
    return const AppTheme(
      themeColor: ThemeColors.green,
      isDark: false,
    );
  }

  @override
  Future<void> setTheme(AppTheme theme) async {}
}
