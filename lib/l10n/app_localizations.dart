import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'raspberry.tips'**
  String get appTitle;

  /// No description provided for @navScanner.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get navScanner;

  /// No description provided for @navTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get navTools;

  /// No description provided for @navDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get navDevices;

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'IP Scanner'**
  String get scannerTitle;

  /// No description provided for @scannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'raspberry.tips'**
  String get scannerSubtitle;

  /// No description provided for @stopScanTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stop scan'**
  String get stopScanTooltip;

  /// No description provided for @myIp.
  ///
  /// In en, this message translates to:
  /// **'Your IP: {ip}'**
  String myIp(String ip);

  /// No description provided for @scanningMessage.
  ///
  /// In en, this message translates to:
  /// **'Searching for Raspberry Pis…'**
  String get scanningMessage;

  /// No description provided for @emptyStateMessage.
  ///
  /// In en, this message translates to:
  /// **'Start a scan to\nfind Raspberry Pis'**
  String get emptyStateMessage;

  /// No description provided for @wifiHintMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Raspberry Pi must be on the same Wi-Fi as this device.'**
  String get wifiHintMessage;

  /// No description provided for @scanButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Scan network'**
  String get scanButtonLabel;

  /// No description provided for @rescanButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get rescanButtonLabel;

  /// No description provided for @scanningButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get scanningButtonLabel;

  /// No description provided for @sectionConfirmedPis.
  ///
  /// In en, this message translates to:
  /// **'Raspberry Pis ({count})'**
  String sectionConfirmedPis(int count);

  /// No description provided for @sectionPossiblePis.
  ///
  /// In en, this message translates to:
  /// **'Possible Pis ({count})'**
  String sectionPossiblePis(int count);

  /// No description provided for @sectionOtherDevices.
  ///
  /// In en, this message translates to:
  /// **'Other devices ({count})'**
  String sectionOtherDevices(int count);

  /// No description provided for @chipConfirmedPi.
  ///
  /// In en, this message translates to:
  /// **'Raspberry Pi'**
  String get chipConfirmedPi;

  /// No description provided for @chipPossiblePi.
  ///
  /// In en, this message translates to:
  /// **'Possible Pi?'**
  String get chipPossiblePi;

  /// No description provided for @tooltipDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get tooltipDismiss;

  /// No description provided for @buttonBrowser.
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get buttonBrowser;

  /// No description provided for @buttonSsh.
  ///
  /// In en, this message translates to:
  /// **'SSH'**
  String get buttonSsh;

  /// No description provided for @tooltipSaveDevice.
  ///
  /// In en, this message translates to:
  /// **'Save device'**
  String get tooltipSaveDevice;

  /// No description provided for @deviceSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} saved'**
  String deviceSavedMessage(String name);

  /// No description provided for @sshDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'SSH app required'**
  String get sshDialogTitle;

  /// No description provided for @sshDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'An SSH app is required, e.g. Termius or JuiceSSH.'**
  String get sshDialogMessage;

  /// No description provided for @menuPortSettings.
  ///
  /// In en, this message translates to:
  /// **'Port settings'**
  String get menuPortSettings;

  /// No description provided for @menuWebsite.
  ///
  /// In en, this message translates to:
  /// **'raspberry.tips'**
  String get menuWebsite;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAbout;

  /// No description provided for @portSettingsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Ports to scan'**
  String get portSettingsDialogTitle;

  /// No description provided for @aboutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Pi Scanner'**
  String get aboutDialogTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get aboutVersion;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'A simple IP scanner for Raspberry Pis on your home network.'**
  String get aboutDescription;

  /// No description provided for @aboutBy.
  ///
  /// In en, this message translates to:
  /// **'by raspberry.tips'**
  String get aboutBy;

  /// No description provided for @buttonPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get buttonPrivacy;

  /// No description provided for @devicesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Devices'**
  String get devicesTitle;

  /// No description provided for @devicesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No devices saved yet.\nUse the scanner to find\nRaspberry Pis and save them.'**
  String get devicesEmptyMessage;

  /// No description provided for @renameDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename device'**
  String get renameDialogTitle;

  /// No description provided for @renameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get renameFieldLabel;

  /// No description provided for @deleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove device'**
  String get deleteDialogTitle;

  /// No description provided for @deleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Really remove {name} from the list?'**
  String deleteDialogMessage(String name);

  /// No description provided for @buttonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get buttonRemove;

  /// No description provided for @menuOpenBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get menuOpenBrowser;

  /// No description provided for @menuOpenSsh.
  ///
  /// In en, this message translates to:
  /// **'Open SSH'**
  String get menuOpenSsh;

  /// No description provided for @menuRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get menuRename;

  /// No description provided for @menuDelete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get menuDelete;

  /// No description provided for @deviceLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen: {date}'**
  String deviceLastSeen(String date);

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsTitle;

  /// No description provided for @webviewOpeningMessage.
  ///
  /// In en, this message translates to:
  /// **'Opening in browser…'**
  String get webviewOpeningMessage;

  /// No description provided for @webviewReopenButton.
  ///
  /// In en, this message translates to:
  /// **'Open again'**
  String get webviewReopenButton;

  /// No description provided for @webviewReloadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get webviewReloadTooltip;

  /// No description provided for @buttonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get buttonOk;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
