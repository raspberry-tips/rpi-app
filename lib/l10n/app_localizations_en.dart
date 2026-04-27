// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'raspberry.tips';

  @override
  String get navScanner => 'Scanner';

  @override
  String get navTools => 'Tools';

  @override
  String get navDevices => 'Devices';

  @override
  String get scannerTitle => 'IP Scanner';

  @override
  String get scannerSubtitle => 'raspberry.tips';

  @override
  String get stopScanTooltip => 'Stop scan';

  @override
  String myIp(String ip) {
    return 'Your IP: $ip';
  }

  @override
  String get scanningMessage => 'Searching for Raspberry Pis…';

  @override
  String get emptyStateMessage => 'Start a scan to\nfind Raspberry Pis';

  @override
  String get wifiHintMessage =>
      'Your Raspberry Pi must be on the same Wi-Fi as this device.';

  @override
  String get scanButtonLabel => 'Scan network';

  @override
  String get rescanButtonLabel => 'Scan again';

  @override
  String get scanningButtonLabel => 'Scanning…';

  @override
  String sectionConfirmedPis(int count) {
    return 'Raspberry Pis ($count)';
  }

  @override
  String sectionPossiblePis(int count) {
    return 'Possible Pis ($count)';
  }

  @override
  String sectionOtherDevices(int count) {
    return 'Other devices ($count)';
  }

  @override
  String get chipConfirmedPi => 'Raspberry Pi';

  @override
  String get chipPossiblePi => 'Possible Pi?';

  @override
  String get tooltipDismiss => 'Dismiss';

  @override
  String get buttonBrowser => 'Browser';

  @override
  String get buttonSsh => 'SSH';

  @override
  String get tooltipSaveDevice => 'Save device';

  @override
  String deviceSavedMessage(String name) {
    return '$name saved';
  }

  @override
  String get sshDialogTitle => 'SSH app required';

  @override
  String get sshDialogMessage =>
      'An SSH app is required, e.g. Termius or JuiceSSH.';

  @override
  String get menuPortSettings => 'Port settings';

  @override
  String get menuWebsite => 'raspberry.tips';

  @override
  String get menuAbout => 'About';

  @override
  String get portSettingsDialogTitle => 'Ports to scan';

  @override
  String get aboutDialogTitle => 'Pi Scanner';

  @override
  String get aboutVersion => 'Version 1.0.0';

  @override
  String get aboutDescription =>
      'A simple IP scanner for Raspberry Pis on your home network.';

  @override
  String get aboutBy => 'by raspberry.tips';

  @override
  String get buttonPrivacy => 'Privacy Policy';

  @override
  String get devicesTitle => 'My Devices';

  @override
  String get devicesEmptyMessage =>
      'No devices saved yet.\nUse the scanner to find\nRaspberry Pis and save them.';

  @override
  String get renameDialogTitle => 'Rename device';

  @override
  String get renameFieldLabel => 'Name';

  @override
  String get deleteDialogTitle => 'Remove device';

  @override
  String deleteDialogMessage(String name) {
    return 'Really remove $name from the list?';
  }

  @override
  String get buttonRemove => 'Remove';

  @override
  String get menuOpenBrowser => 'Open in browser';

  @override
  String get menuOpenSsh => 'Open SSH';

  @override
  String get menuRename => 'Rename';

  @override
  String get menuDelete => 'Remove';

  @override
  String deviceLastSeen(String date) {
    return 'Last seen: $date';
  }

  @override
  String get toolsTitle => 'Tools';

  @override
  String get webviewOpeningMessage => 'Opening in browser…';

  @override
  String get webviewReopenButton => 'Open again';

  @override
  String get webviewReloadTooltip => 'Reload';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonSave => 'Save';
}
