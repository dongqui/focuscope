import 'package:flutter/material.dart';

class FocusInputWidget extends StatefulWidget {
  const FocusInputWidget({super.key});

  @override
  State<FocusInputWidget> createState() => _State();
}

class _State extends State<FocusInputWidget> {
  final TextEditingController _focusTextController = TextEditingController();
  final List<String> _tags = ['수학 문제 풀기', '영어 단어 외우기', '독서', '코딩', '운동'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '어떤 일에 집중하실 건가요?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextField(
          controller: _focusTextController,
          decoration: const InputDecoration(
            hintText: '예: 수학 문제 풀기, 영어 단어 외우기',
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _tags
                .map((tag) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _focusTextController.text = tag;
                          });
                        },
                        child: Chip(
                          label: Text(tag),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              _tags.remove(tag);
                            });
                          },
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

