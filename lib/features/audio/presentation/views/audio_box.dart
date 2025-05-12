import 'package:flutter/material.dart';
import 'package:catodo/features/audio/presentation/viewmodels/audio_state.dart';
import 'package:catodo/features/audio/presentation/viewmodels/audio_controller.dart';

final List<AudioType> audioList = [
  AudioType.rain,
  AudioType.birds,
  AudioType.forest,
  AudioType.ocean,
  AudioType.wind,
  AudioType.fire,
  AudioType.thunder,
];

class AudioBox extends StatefulWidget {
  const AudioBox({super.key});

  @override
  State<AudioBox> createState() => _AudioBoxState();
}

class _AudioBoxState extends State<AudioBox> {
  final AudioController audioController = AudioController();

  @override
  void initState() {
    super.initState();
    initAudioList();
  }

  @override
  void dispose() {
    super.dispose();

    audioController.dispose();
  }

  bool isMusicOn = false;

  initAudioList() async {
    await AudioManager.instance.getAudioList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0D1B2A).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Background Music',
            style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('음악 켜기/끄기',
                  style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
              Switch(
                value: isMusicOn,
                onChanged: (bool value) {
                  setState(() {
                    isMusicOn = value;
                  });
                },
                activeColor: Color(0xFF3A86FF),
                thumbColor: WidgetStateProperty.all(Color(0xFFFFFFFF)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(
            color: Color(0x80FFFFFF),
            height: 16,
          ),
          const SizedBox(height: 8),
          Text(
            'White noise',
            style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          // 백색 소음 체크박스

          const SizedBox(height: 8),
          Wrap(
            spacing: 32,
            runSpacing: 16,
            children: audioList.map((AudioType type) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type.name,
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 8),
                  Checkbox(
                    activeColor: Color(0xFF3A86FF),
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: AudioManager.instance.state.whiteNoise
                        .contains(type.name),
                    onChanged: (bool? value) {
                      setState(() {
                        AudioManager.instance
                            .updateWhiteNoise(type.name, value ?? false);

                        if (value == true) {
                          audioController.play(type);
                        } else {
                          audioController.stop(type);
                        }
                      });
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
