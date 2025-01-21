import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/tts_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final TTSService _ttsService = TTSService();
  List<String> _savedPhrases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedPhrases();
    _textController.addListener(() {
      setState(() {
        // Trigger rebuild to show/hide clear button
      });
    });
  }

  Future<void> _loadSavedPhrases() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPhrases = prefs.getStringList('saved_phrases') ?? [];
      _isLoading = false;
    });
  }

  Future<void> _savePhrase(String phrase) async {
    if (phrase.isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    final phrases = prefs.getStringList('saved_phrases') ?? [];
    if (!phrases.contains(phrase)) {
      phrases.add(phrase);
      await prefs.setStringList('saved_phrases', phrases);
      setState(() {
        _savedPhrases = phrases;
      });
    }
  }

  Future<void> _deletePhrase(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final phrases = List<String>.from(_savedPhrases);
    phrases.removeAt(index);
    await prefs.setStringList('saved_phrases', phrases);
    setState(() {
      _savedPhrases = phrases;
    });
  }

  Future<void> _shareViaMessage(String text) async {
    final Uri smsUri = Uri.parse('sms:?body=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  void _clearText() {
    _textController.clear();
    _ttsService.stop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Ahoj!'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // Language selection to be implemented
          },
          child: const Icon(CupertinoIcons.globe),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  CupertinoTextField(
                controller: _textController,
                placeholder: 'Type or select a phrase...',
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                maxLines: 3,
                  ),
                  if (_textController.text.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _clearText,
                        child: const Icon(
                          CupertinoIcons.clear_circled_solid,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                    onPressed: () => _ttsService.speak(_textController.text),
                    child: const Icon(CupertinoIcons.play_fill),
                  ),
                  CupertinoButton(
                    onPressed: () => _savePhrase(_textController.text),
                    child: const Icon(CupertinoIcons.add),
                  ),
                  CupertinoButton(
                    onPressed: () => _shareViaMessage(_textController.text),
                    child: const Icon(CupertinoIcons.share),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Saved Phrases',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : ListView.builder(
                      itemCount: _savedPhrases.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(_savedPhrases[index]),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            color: CupertinoColors.destructiveRed,
                            child: const Icon(
                              CupertinoIcons.delete,
                              color: CupertinoColors.white,
                            ),
                          ),
                          onDismissed: (direction) => _deletePhrase(index),
                          child: CupertinoListTile(
                            title: Text(_savedPhrases[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _deletePhrase(index),
                                  child: const Icon(
                                    CupertinoIcons.delete,
                                    color: CupertinoColors.destructiveRed,
                                  ),
                                ),
                                const CupertinoListTileChevron(),
                              ],
                            ),
                            onTap: () {
                              _textController.text = _savedPhrases[index];
                              _ttsService.speak(_savedPhrases[index]);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
