import 'package:flutter/material.dart';

class MusicSetting extends StatefulWidget {
  const MusicSetting({super.key});

  @override
  _MusicSettingState createState() => _MusicSettingState();
}

class _MusicSettingState extends State<MusicSetting> {
  bool isMusicOn = false;
  Map<String, bool> whiteNoiseOptions = {
    'Rain': false,
    'Wind': false,
    'Forest': false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 음악 선택 토글 버튼
        SwitchListTile(
          title: Text('음악 켜기/끄기'),
          value: isMusicOn,
          onChanged: (bool value) {
            setState(() {
              isMusicOn = value;
            });
          },
        ),
        // 백색 소음 체크박스
        ...whiteNoiseOptions.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: whiteNoiseOptions[key],
            onChanged: (bool? value) {
              setState(() {
                whiteNoiseOptions[key] = value ?? false;
              });
            },
          );
        }),
      ],
    );
  }
}
