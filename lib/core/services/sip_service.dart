import 'dart:async';
import 'package:sip_ua/sip_ua.dart';
import 'package:flutter/foundation.dart';

class SipService extends ChangeNotifier implements SipUaHelperListener {
  late SIPUAHelper _helper;
  SIPUAHelper get helper => _helper;

  String? _registeredState;
  String? get registeredState => _registeredState;

  Completer<bool>? _registrationCompleter;

  SipService() {
    _helper = SIPUAHelper();
    _helper.addSipUaHelperListener(this);
  }

  Future<bool> connect(String username, String password, String domain) async {
    try {
      UaSettings settings = UaSettings();
      settings.webSocketUrl = 'ws://$domain:8088/ws';
      settings.webSocketSettings.extraHeaders = {};
      settings.webSocketSettings.allowBadCertificate = true;
      settings.uri = '$username@$domain';
      settings.authorizationUser = username;
      settings.password = password;
      settings.displayName = username;
      settings.userAgent = 'VetenCall';
      settings.dtmfMode = DtmfMode.RFC2833;

      _registrationCompleter = Completer<bool>();
      _helper.start(settings);
      
      // Wait for registration state change up to 10 seconds
      return await _registrationCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          _helper.stop();
          return false;
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('SIP Connect Error: $e');
      }
      return false;
    }
  }

  void disconnect() {
    _helper.stop();
    _registeredState = null;
    notifyListeners();
  }

  @override
  void callStateChanged(Call call, CallState state) {}

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void registrationStateChanged(RegistrationState state) {
    if (kDebugMode) {
      print('SIP Registration State: ${state.state}');
    }
    _registeredState = state.state.toString();
    notifyListeners();

    if (_registrationCompleter != null && !_registrationCompleter!.isCompleted) {
      if (state.state == RegistrationStateEnum.REGISTERED) {
        _registrationCompleter!.complete(true);
      } else if (state.state == RegistrationStateEnum.REGISTRATION_FAILED) {
        _registrationCompleter!.complete(false);
      }
    }
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {}
  
  @override
  void onNewNotify(Notify ntf) {}

  @override
  void onNewReinvite(ReInvite event) {}
}
