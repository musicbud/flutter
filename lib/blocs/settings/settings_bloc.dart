import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsBloc({
    required SettingsRepository settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(SettingsInitial()) {
    on<SettingsRequested>(_onSettingsRequested);
    on<NotificationSettingsUpdated>(_onNotificationSettingsUpdated);
    on<PrivacySettingsUpdated>(_onPrivacySettingsUpdated);
    on<ThemeSettingUpdated>(_onThemeSettingUpdated);
    on<LanguageSettingUpdated>(_onLanguageSettingUpdated);
  }

  Future<void> _onSettingsRequested(
    SettingsRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final settings = await _settingsRepository.getSettings();
      emit(SettingsLoaded(
        notifications: NotificationSettings(
          enabled: settings['notifications']['enabled'],
          pushEnabled: settings['notifications']['push_enabled'],
          emailEnabled: settings['notifications']['email_enabled'],
          soundEnabled: settings['notifications']['sound_enabled'],
        ),
        privacy: PrivacySettings(
          profileVisible: settings['privacy']['profile_visible'],
          locationVisible: settings['privacy']['location_visible'],
          activityVisible: settings['privacy']['activity_visible'],
        ),
        theme: settings['theme'],
        languageCode: settings['language_code'],
      ));
    } catch (e) {
      emit(SettingsFailure(e.toString()));
    }
  }

  Future<void> _onNotificationSettingsUpdated(
    NotificationSettingsUpdated event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await _settingsRepository.updateNotificationSettings({
          'enabled': event.enabled,
          'push_enabled': event.pushEnabled,
          'email_enabled': event.emailEnabled,
          'sound_enabled': event.soundEnabled,
        });

        emit(currentState.copyWith(
          notifications: NotificationSettings(
            enabled: event.enabled,
            pushEnabled: event.pushEnabled,
            emailEnabled: event.emailEnabled,
            soundEnabled: event.soundEnabled,
          ),
        ));
      } catch (e) {
        emit(SettingsFailure(e.toString()));
      }
    }
  }

  Future<void> _onPrivacySettingsUpdated(
    PrivacySettingsUpdated event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await _settingsRepository.updatePrivacySettings({
          'profile_visible': event.profileVisible,
          'location_visible': event.locationVisible,
          'activity_visible': event.activityVisible,
        });

        emit(currentState.copyWith(
          privacy: PrivacySettings(
            profileVisible: event.profileVisible,
            locationVisible: event.locationVisible,
            activityVisible: event.activityVisible,
          ),
        ));
      } catch (e) {
        emit(SettingsFailure(e.toString()));
      }
    }
  }

  Future<void> _onThemeSettingUpdated(
    ThemeSettingUpdated event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await _settingsRepository.updateTheme(event.theme);
        emit(currentState.copyWith(theme: event.theme));
      } catch (e) {
        emit(SettingsFailure(e.toString()));
      }
    }
  }

  Future<void> _onLanguageSettingUpdated(
    LanguageSettingUpdated event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await _settingsRepository.updateLanguage(event.languageCode);
        emit(currentState.copyWith(languageCode: event.languageCode));
      } catch (e) {
        emit(SettingsFailure(e.toString()));
      }
    }
  }
}
