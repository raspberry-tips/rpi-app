// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'raspberry.tips';

  @override
  String get navScanner => 'Scanner';

  @override
  String get navTools => 'Tools';

  @override
  String get navDevices => 'Geräte';

  @override
  String get scannerTitle => 'IP Scanner';

  @override
  String get scannerSubtitle => 'raspberry.tips';

  @override
  String get stopScanTooltip => 'Scan stoppen';

  @override
  String myIp(String ip) {
    return 'Deine IP: $ip';
  }

  @override
  String get scanningMessage => 'Suche Raspberry Pis im Netzwerk…';

  @override
  String get emptyStateMessage =>
      'Starte einen Scan um\nRaspberry Pis zu finden';

  @override
  String get wifiHintMessage =>
      'Dein Raspberry Pi muss im selben WLAN wie dieses Gerät sein.';

  @override
  String get scanButtonLabel => 'Netzwerk scannen';

  @override
  String get rescanButtonLabel => 'Erneut scannen';

  @override
  String get scanningButtonLabel => 'Scanne Netzwerk…';

  @override
  String sectionConfirmedPis(int count) {
    return 'Raspberry Pis ($count)';
  }

  @override
  String sectionPossiblePis(int count) {
    return 'Mögliche Pis ($count)';
  }

  @override
  String sectionOtherDevices(int count) {
    return 'Andere Geräte ($count)';
  }

  @override
  String get chipConfirmedPi => 'Raspberry Pi';

  @override
  String get chipPossiblePi => 'Möglicher Pi?';

  @override
  String get tooltipDismiss => 'Ausblenden';

  @override
  String get buttonBrowser => 'Browser';

  @override
  String get buttonSsh => 'SSH';

  @override
  String get tooltipSaveDevice => 'Gerät speichern';

  @override
  String deviceSavedMessage(String name) {
    return '$name gespeichert';
  }

  @override
  String get sshDialogTitle => 'SSH-App benötigt';

  @override
  String get sshDialogMessage =>
      'Für SSH wird eine SSH-App benötigt, z.B. Termius oder JuiceSSH.';

  @override
  String get menuPortSettings => 'Port-Einstellungen';

  @override
  String get menuWebsite => 'raspberry.tips';

  @override
  String get menuAbout => 'Über die App';

  @override
  String get portSettingsDialogTitle => 'Ports scannen';

  @override
  String get aboutDialogTitle => 'Pi Scanner';

  @override
  String get aboutVersion => 'Version 1.0.0';

  @override
  String get aboutDescription =>
      'Ein einfacher IP-Scanner für Raspberry Pis im Heimnetzwerk.';

  @override
  String get aboutBy => 'von raspberry.tips';

  @override
  String get buttonPrivacy => 'Datenschutz';

  @override
  String get devicesTitle => 'Meine Geräte';

  @override
  String get devicesEmptyMessage =>
      'Noch keine Geräte gespeichert.\nNutze den Scanner um Raspberry Pis\nzu finden und zu speichern.';

  @override
  String get renameDialogTitle => 'Gerät umbenennen';

  @override
  String get renameFieldLabel => 'Name';

  @override
  String get deleteDialogTitle => 'Gerät entfernen';

  @override
  String deleteDialogMessage(String name) {
    return '$name wirklich aus der Liste entfernen?';
  }

  @override
  String get buttonRemove => 'Entfernen';

  @override
  String get menuOpenBrowser => 'Browser öffnen';

  @override
  String get menuOpenSsh => 'SSH öffnen';

  @override
  String get menuRename => 'Umbenennen';

  @override
  String get menuDelete => 'Entfernen';

  @override
  String deviceLastSeen(String date) {
    return 'Gesehen: $date';
  }

  @override
  String get toolsTitle => 'Tools';

  @override
  String get webviewOpeningMessage => 'Wird im Browser geöffnet…';

  @override
  String get webviewReopenButton => 'Erneut öffnen';

  @override
  String get webviewReloadTooltip => 'Neu laden';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonCancel => 'Abbrechen';

  @override
  String get buttonSave => 'Speichern';
}
