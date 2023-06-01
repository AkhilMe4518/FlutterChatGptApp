// import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt_app/models/api_key.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
// import 'package:http/http.dart' as http;
// import 'package:chatgpt_app/models/api_key.dart';

import 'package:chatgpt_app/Widgets/chat_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessages> _messages = [];
  late OpenAI openAI;

  void _addMessage() {
    if (_controller.text.trim().isNotEmpty) {
      // print(ApiKey().apikey);
      setState(() {
        _messages.insert(
            0, ChatMessages(text: _controller.text, sender: "You"));
        gpt4(_controller.text);
      });
    }
    _controller.clear();
  }

  void gpt4(String message) async {
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": message})
    ], maxToken: 200, model: ChatModel.gptTurbo);

    final response = await openAI.onChatCompletion(request: request);
    setState(() {
      _messages.insert(
          0,
          ChatMessages(
              text: response!.choices[0].message!.content, sender: "AI"));
    });
    // print(response!.choices[0].message!.content);
  }

  @override
  void initState() {
    openAI = OpenAI.instance.build(
        token: ApiKey().apikey,
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20)),
        enableLog: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _inputBar() {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration.collapsed(
                hintText: "send a message",
              ),
            ),
          ),
          IconButton(
            onPressed: _addMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ).px16();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ChatGptApp",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              reverse: true,
              padding: Vx.m8,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            )),
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
              ),
              child: _inputBar(),
            )
          ],
        ),
      ),
    );
  }
}
