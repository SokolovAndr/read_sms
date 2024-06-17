import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

/*final Telephony telephony = Telephony.instance;
String textReceived = "";
//String textReceived2 = "";*/

backgroundMessageHandler(SmsMessage message) async {
  debugPrint("Сообщение в фоновом режиме: ${message.body}");
  /*textReceived = message.body!;
  debugPrint("test: $textReceived");*/
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ReadSmsScreen(),
    );
  }
}

class ReadSmsScreen extends StatefulWidget {
  const ReadSmsScreen({super.key});

  @override
  State<ReadSmsScreen> createState() => _ReadSmsScreenState();
}

class _ReadSmsScreenState extends State<ReadSmsScreen>
    with WidgetsBindingObserver {
  final Telephony telephony = Telephony.instance;
  String textReceived = "";

  void startListening() {
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          setState(() {
            textReceived = message.body!;
            //textReceived2 = backgroundMessageHandler(message.body!);
          });
        },
        listenInBackground: true,
        onBackgroundMessage: backgroundMessageHandler);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    startListening();
    super.initState();
    debugPrint("Run initState");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    debugPrint("Run dispose");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //debugPrint('state = $state');
    if (state == AppLifecycleState.paused) {
      debugPrint("Приложение в фоновом режиме");
    }
    if (state == AppLifecycleState.resumed) {
      debugPrint("Приложение в основном режиме");
      getMess();
    }
  }

  void getMess() async {
    //String newText = "";
    List<SmsMessage> messages = await telephony.getInboxSms(sortOrder: [
      OrderBy(SmsColumn.DATE, sort: Sort.DESC),
    ]);
    //newText = messages[0].body.toString();
    setState(() {
      textReceived = messages[0].body.toString();
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Чтение полученных SMS")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text("Полученное сообщение : $textReceived")),
      ),
    );
  }
}
