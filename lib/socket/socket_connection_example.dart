import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_example/socket/socket.dart' as globals;

class SocketConnectionExample extends StatefulWidget {

  const SocketConnectionExample({
    Key? key,
  }) : super(key: key);

  @override
  _SocketConnectionExampleState createState() {
    return _SocketConnectionExampleState();
  }
}

class _SocketConnectionExampleState extends State<SocketConnectionExample> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  initSocket(){
    try{
      //subscribe socket
      globals.socketConnection.subscribe(globals.webSocket, 'channelID');
      listenData();
    }catch(e){
      print(e);
    }
  }

  listenData({index = 0}) async {
    try{
      globals.messageIn.addListener(() {
        if (globals.messageIn.value != '') {
          var tmp2 = json.decode(globals.messageIn.value) as Map;
          if (mounted) {
            listenDataProcess(tmp2);
          }
        }
      });
    }catch(e){
      print(e);
    }
  }

  listenDataProcess(tmp2) {
    try{
      // data right here
      print(tmp2);
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }

}
