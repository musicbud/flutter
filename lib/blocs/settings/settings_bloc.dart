import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;
  final AuthRepository _authRepository;
  final UserProfileRepository _userProfileRepository;

  SettingsBloc({
    required SettingsRepository settingsRepository,
    required AuthRepository authRepository,
    required UserProfileRepository userProfileRepository,
  })  : _settingsRepository = settingsRepository,
        _authRepository = authRepository,
        _userProfileRepository = userProfileRepository,
        super(SettingsInitial()) {
    on<SettingsRequested>(_onSettingsRequested);
    on<NotificationSettingsUpdated>(_onNotificationSettingsUpdated);
    on<PrivacySettingsUpdated>(_onPrivacySettingsUpdated);
    on<ThemeSettingUpdated>(_onThemeSettingUpdated);
    on<LanguageSettingUpdated>(_onLanguageSettingUpdated);
    on<LoadSettingsEvent>(_onLoadSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
    on<UpdateNotificationSettingsEvent>(_onUpdateNotificationSettings);
    on<UpdatePrivacySettingsEvent>(_onUpdatePrivacySettings);
    on<UpdateThemeEvent>(_onUpdateTheme);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<ConnectSpotify>(_onConnectSpotify);
    on<ConnectYTMusic>(_onConnectYTMusic);
    on<ConnectLastFM>(_onConnectLastFM);
    on<ConnectMAL>(_onConnectMAL);
    on<UpdateLikes>(_onUpdateLikes);
    on<GetServiceLoginUrl>(_onGetServiceLoginUrl);
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

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
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

  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _onNotificationSettingsUpdated(
      NotificationSettingsUpdated(
        enabled: event.enabled,
        pushEnabled: event.pushEnabled,
        emailEnabled: event.emailEnabled,
        soundEnabled: event.soundEnabled,
      ),
      emit,
    );
  }

  Future<void> _onUpdatePrivacySettings(
    UpdatePrivacySettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _onPrivacySettingsUpdated(
      PrivacySettingsUpdated(
        profileVisible: event.profileVisible,
        locationVisible: event.locationVisible,
        activityVisible: event.activityVisible,
      ),
      emit,
    );
  }

  Future<void> _onUpdateTheme(
    UpdateThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _onThemeSettingUpdated(
      ThemeSettingUpdated(event.theme),
      emit,
    );
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _onLanguageSettingUpdated(
      LanguageSettingUpdated(event.languageCode),
      emit,
    );
  }

  Future<void> _onSaveSettings(
    SaveSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // Since individual updates already save to repository, just emit success
    emit(SettingsSaved());
  }

  Future<void> _onConnectSpotify(
    ConnectSpotify event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _authRepository.connectSpotify(event.spotifyToken);
      emit(ServiceConnected('spotify'));
    } catch (e) {
      emit(ServiceConnectionError('spotify', e.toString()));
    }
  }

  Future<void> _onConnectYTMusic(
    ConnectYTMusic event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _authRepository.connectYTMusic(event.ytmusicToken);
      emit(ServiceConnected('ytmusic'));
    } catch (e) {
      emit(ServiceConnectionError('ytmusic', e.toString()));
    }
  }

  Future<void> _onConnectLastFM(
    ConnectLastFM event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _authRepository.connectLastFM(event.lastfmToken);
      emit(ServiceConnected('lastfm'));
    } catch (e) {
      emit(ServiceConnectionError('lastfm', e.toString()));
    }
  }

  Future<void> _onConnectMAL(
    ConnectMAL event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _authRepository.connectMAL(event.malToken);
      emit(ServiceConnected('mal'));
    } catch (e) {
      emit(ServiceConnectionError('mal', e.toString()));
    }
  }

  Future<void> _onUpdateLikes(
    UpdateLikes event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _userProfileRepository.updateLikes({
        'service': event.service,
        'token': event.token,
      });
      emit(LikesUpdated(event.service));
    } catch (e) {
      emit(LikesUpdateError(event.service, e.toString()));
    }
  }

  Future<void> _onGetServiceLoginUrl(
    GetServiceLoginUrl event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final url = await _authRepository.getServiceLoginUrl(event.service);
      emit(ServiceLoginUrlReceived(event.service, url));
    } catch (e) {
      emit(ServiceLoginUrlError(event.service, e.toString()));
    }
  }
}
