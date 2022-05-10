import 'package:flutter/material.dart';
import 'package:websocket_manager/websocket_manager.dart';
import 'dart:io';

late Connection socketConnection;
late WebSocket webSocket;
var messageListen;
ValueNotifier messageIn = ValueNotifier('');
List<String> subList = [];

class Connection {
  Connection();
  Future<WebSocket> createClient() {
    // the socket web you want to connect
    return WebSocket.connect('wss://echo.websocket.events'
//      protocols: ['wamp'],
    );
  }

  Future connect() async {
    webSocket.close();
    await createClient().then((webSocket) {
      webSocket = webSocket;
      webSocket.pingInterval = const Duration(seconds: 15); // ping connection for every 15 second
      webSocket.listen((event) {
        try{
          print('--event--');
          print(event);
          messageListen = event;
          print('message Listen data');
          print(messageListen);
          messageIn.value = '';
          messageIn.value = event;
        }catch(e){
          print(e);
        }
      }, onDone: (){}
      );
      print('==========Socket connected==========');
      return;
    });
  }

  // for one socket connection can have multiple channel
  // subscribe to channel
  void subscribe(socket, channel){
    print('sub_'+channel);
    if(webSocket != null) {
      webSocket.add('sub_'+channel); // todo change the channel name that you want to subscribe
    }
    if(!subList.contains(channel)) {
      subList.add(channel);
    }
  }

  void unSubscribe(socket, channel, {isTemporary = false}){
    print('unsub_'+channel);
    if(webSocket!=null) {
      webSocket.add('unsub_'+channel); // todo change the channel name that you want to unsubscribe
    }

    if(subList.contains(channel) && !isTemporary) {
      subList.remove(channel);
    }
  }

  // reconnect socket connection
  void recon(socket){
    if(subList.isNotEmpty){
      // have subscribe to socket connection before
      var tmpSubList = List.from(subList);
//    tmpSubList = subList;
      tmpSubList.forEach((element) {
        print(element);
        subscribe(socket, element);
      });
    }
  }

  // disconnect socket
  void disConnect(){
    if(webSocket.readyState == WebSocket.open) {
      webSocket.close();
    }
  }

  // disconnect socket and unsubscribe to all channel
  Future<void> disConnectAll(socket) async {
    if(subList.isNotEmpty) {
      var tmpSubList = List.from(subList);
      for (var element in tmpSubList) {
        unSubscribe(socket, element);
      }
    }
  }

}