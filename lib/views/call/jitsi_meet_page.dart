import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:ucabdemy/config/ucabdemy_colors.dart';

class JitsiMeetVideo extends StatefulWidget {

  const JitsiMeetVideo({Key? key,required this.nameRoom, this.videoMuted = false}) : super(key: key);
  final String nameRoom;
  final bool videoMuted;

  @override
  _JitsiMeetVideoState createState() => _JitsiMeetVideoState();
}

class _JitsiMeetVideoState extends State<JitsiMeetVideo>{

  String nameRooms = '';

  @override
  void initState() {
    super.initState();
    initialData();
  }

  Future initialData() async{
    nameRooms = widget.nameRoom;
    setState(() {});
    meet();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Future meet() async {
    _joinMeeting();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: const Scaffold(
        backgroundColor: UcabdemyColors.primary_4,
      ),
    );
  }

  Future _joinMeeting() async {
    try{
      String? serverUrl = 'https://meet.jit.si/';
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
        FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE: false,
        FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,
        FeatureFlagEnum.CALL_INTEGRATION_ENABLED: false,
        FeatureFlagEnum.RECORDING_ENABLED: false,
        FeatureFlagEnum.INVITE_ENABLED: false,
      };
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      var options = JitsiMeetingOptions(room: widget.nameRoom)
        ..serverURL = serverUrl
        ..subject = nameRooms
        ..userDisplayName = nameRooms
        ..audioOnly = false
        ..videoMuted = widget.videoMuted
        ..audioMuted = false
        ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(
            onError: (message) {
              debugPrint('JITSI : Error con el mensaje: $message');
              debugPrint("${options.room} Error con el mensaje: $message");
            },
            onConferenceJoined: (message) {
              debugPrint('JITSI : unido con mensaje: $message');
              debugPrint("${options.room} unido con mensaje: $message");
            },
            onConferenceWillJoin: (message) {
              debugPrint('JITSI : se unirá con el mensaje: $message');
              debugPrint("${options.room} se unirá con el mensaje: $message");
            },
            onConferenceTerminated: (message) async {
              debugPrint('JITSI : terminado con mensaje: $message');
              debugPrint("${options.room} terminado con mensaje: $message");
              Navigator.of(context).pop();
            },
            genericListeners: [
              JitsiGenericListener(
                  eventName: 'readyToClose',
                  callback: (dynamic message) {
                    debugPrint('JITSI : readyToClose callback');
                    debugPrint("readyToClose callback");
                  }),
            ]),
      );
    }catch(e){
      debugPrint(e.toString());
    }
  }
}
