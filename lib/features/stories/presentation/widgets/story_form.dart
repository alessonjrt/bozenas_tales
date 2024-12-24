import 'package:bozenas_tales/features/stories/domain/entities/story.dart';
import 'package:bozenas_tales/features/stories/domain/enums/story_genre.dart';
import 'package:bozenas_tales/features/stories/presentation/widgets/youtube_thumb.dart';
import 'package:flutter/material.dart';

Future<Story?> showStoryForm({
  required BuildContext context,
  Story? story,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Formulário de História em Tela Cheia',
    pageBuilder: (context, animation, secondaryAnimation) {
      return _FullScreenStoryFormDialog(story: story);
    },
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

class _FullScreenStoryFormDialog extends StatefulWidget {
  final Story? story;

  const _FullScreenStoryFormDialog({this.story});

  @override
  State<_FullScreenStoryFormDialog> createState() =>
      _FullScreenStoryFormDialogState();
}

class _FullScreenStoryFormDialogState
    extends State<_FullScreenStoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _urlController = TextEditingController();
  final _episodeController = TextEditingController();
  final _seasonController = TextEditingController();
  StoryGenre? _selectedGenre;

  @override
  void initState() {
    super.initState();
    if (widget.story != null) {
      _titleController.text = widget.story!.title;
      _contentController.text = widget.story!.content;
      _urlController.text = widget.story!.url;
      _episodeController.text = widget.story!.episode.toString();
      _seasonController.text = widget.story!.season.toString();
      _selectedGenre = widget.story!.genre;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _urlController.dispose();
    _episodeController.dispose();
    _seasonController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        Story(
          id: widget.story?.id ?? UniqueKey().toString(),
          title: _titleController.text,
          content: _contentController.text,
          genre: _selectedGenre!,
          url: _urlController.text,
          episode: int.parse(_episodeController.text),
          season: int.parse(_seasonController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.story == null
                ? 'Adicionar História'
                : 'Editar História'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(null),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _saveForm,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _StyledTextField(
                    controller: _titleController,
                    label: 'Título',
                    validatorMsg: 'Título é obrigatório',
                  ),
                  const SizedBox(height: 16),
                  _StyledTextField(
                    controller: _contentController,
                    label: 'Conteúdo',
                    validatorMsg: 'Conteúdo é obrigatório',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<StoryGenre>(
                    value: _selectedGenre,
                    decoration: InputDecoration(
                      labelText: 'Gênero',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                    ),
                    items: StoryGenre.values.map((genre) {
                      return DropdownMenuItem(
                        value: genre,
                        child: Text(genre.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGenre = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Gênero é obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _StyledTextField(
                    controller: _urlController,
                    label: 'URL',
                    validatorMsg: 'URL é obrigatória',
                    onChanged: (value) => setState(() {}),
                    extraValidation: (value) {
                      if (!Uri.tryParse(value)!.isAbsolute) {
                        return 'Insira uma URL válida';
                      }
                      return null;
                    },
                  ),
                  if (_urlController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: YoutubeThumb(youtubeUrl: _urlController.text),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StyledTextField(
                          controller: _episodeController,
                          label: 'Episódio',
                          validatorMsg: 'Episódio é obrigatório',
                          keyboardType: TextInputType.number,
                          extraValidation: (value) {
                            if (int.tryParse(value) == null) {
                              return 'Insira um número válido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StyledTextField(
                          controller: _seasonController,
                          label: 'Temporada',
                          validatorMsg: 'Temporada é obrigatória',
                          keyboardType: TextInputType.number,
                          extraValidation: (value) {
                            if (int.tryParse(value) == null) {
                              return 'Insira um número válido';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String validatorMsg;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String)? extraValidation;

  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.validatorMsg,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.extraValidation,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMsg;
        }
        if (extraValidation != null) {
          final extraMessage = extraValidation!(value);
          if (extraMessage != null && extraMessage.isNotEmpty) {
            return extraMessage;
          }
        }
        return null;
      },
    );
  }
}
