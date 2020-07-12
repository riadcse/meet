import 'dart:io';
import 'dart:ui';

import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';

void main() => runApp(MyApp());


const kBlackHalf = const Color(0xFF1e1bde);
const kBlackLight = const Color(0xFFffffff);
const kBlack = const Color(0xFFffffff);
const kWhite = Colors.white;

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(
    primaryColor: kBlack,
    scaffoldBackgroundColor: kBlackHalf,
    primaryIconTheme: base.iconTheme.copyWith(color: kWhite),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tryonex Meet',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: buildDarkTheme(),
      home: HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final serverText = TextEditingController();
  final subjectText = TextEditingController(text: "");
  final emailText = TextEditingController(text: "");
  final iosAppBarRGBAColor = TextEditingController(text: "");//transparent blue
  var isAudioOnly = true;
  var isAudioMuted = false;
  var isVideoMuted = false;

  TextEditingController roomNameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();

  String roomName;
  String displayName;

  bool status = false;
  bool switchStatus = true;
  bool isProcessed = true;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));

    Future.delayed(const Duration(seconds: 3)).then((value){
      setState(() {
        isProcessed = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var weight = MediaQuery.of(context).size.width;

    if(isProcessed){
      return Scaffold(
          body : Container(
          constraints: BoxConstraints.expand(),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/image/background2.jpg"),
                  fit: BoxFit.cover)
          ),
        ),
      );
    }
    return  Builder(builder: (context){
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tryonex Meet'),
          backgroundColor: Color(0xFF1e1bde),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/image/background.jpg"),
                  fit: BoxFit.cover)
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ListView(
              children: [
                SizedBox(height: 40,),
                Text('Simple & Secure Video Conferencing',style: TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                SizedBox(height: 80,),
                Text('Room name',style: TextStyle(fontSize: 14,color: Colors.white,),),
                SizedBox(height: 3,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      autocorrect: false,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                          height: 1.5, fontSize: 12, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          hintText: 'e.g. metting ID'
                      ),
                      controller: roomNameController,
                      onChanged: (text){
                        setState(() {
                          roomName = text;
                        });
                      },
                    ),
                  ),
                ),
                ((roomName==null&&status))?Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.error,size: 12,color: Colors.white,),
                    SizedBox(width: 5,),
                    Text('Room name required',style: TextStyle(fontSize: 12,color: Colors.white)),
                  ],
                ):Container(),
                SizedBox(
                  height: 20,
                ),
                Text('Your name',style: TextStyle(fontSize: 14,color: Colors.white),),
                SizedBox(height: 3,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      autocorrect: false,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                          height: 1.5, fontSize: 12, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                          hintText: 'e.g. John Smith'
                      ),
                      controller: displayNameController,

                      onChanged: (text){
                        setState(() {
                          displayName = text;
                        });
                      },
                    ),
                  ),
                ),
                ((displayName==null&&status))?Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.error,size: 12,color: Colors.white,),
                    SizedBox(width: 5,),
                    Text('Your name required',style: TextStyle(fontSize: 12,color: Colors.white)),
                  ],
                ):Container(),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Start with?',style: TextStyle(color: Colors.white,fontSize: 14),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: Text('Video',style: TextStyle(fontSize: 12,color: Colors.white),),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              switchStatus = !switchStatus;
                              _onAudioOnlyChanged(!switchStatus);
                              _onVideoMutedChanged(switchStatus);
                            });
                          },
                          child: CustomSwitchButton(
                            backgroundColor: Colors.blueGrey,
                            unCheckedColor: Colors.white,
                            animationDuration: Duration(milliseconds: 400),
                            checkedColor: Color(0xFF1e1bde),
                            checked: switchStatus,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8),
                          child: Text('Audio',style: TextStyle(fontSize: 12,color: Colors.white),),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 80,),
                InkWell(
                  onTap: (){
                    setState(() {
                      if(roomName!=null&&displayName!=null){
                        _joinMeeting();
                      }
                      status = true;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        height: 45,
                        width: MediaQuery.of(context).size.width/1.2,
                        child: Text('Join Meeting',style: TextStyle(color: Color(0xFF3c5ee4),fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl = 'https://meet.tryonex.com';
    serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {

      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags =
      {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED : false,
      };

      // Here is an example, disabling features for each platform
      if (Platform.isAndroid)
      {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      }
      else if (Platform.isIOS)
      {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = roomName
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = displayName
        ..userEmail = emailText.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint> customContraints =
  {
    RoomNameConstraintType.MAX_LENGTH : new RoomNameConstraint(
            (value) { return value.trim().length <= 50; },
        "Maximum room name length should be 30."),

    RoomNameConstraintType.FORBIDDEN_CHARS : new RoomNameConstraint(
            (value) { return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false).hasMatch(value) == false; },
        "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}