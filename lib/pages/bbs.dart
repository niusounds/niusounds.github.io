import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/bbs_entry.dart';
import '../repositories/bbs_repository.dart';

class BbsPage extends StatefulWidget {
  const BbsPage({
    Key? key,
    required this.repository,
    required this.dateFormat,
  }) : super(key: key);

  final BbsRepository repository;
  final DateFormat dateFormat;

  @override
  _BbsPageState createState() => _BbsPageState();
}

class _BbsPageState extends State<BbsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('BBS'),
          ),
          SliverToBoxAdapter(
            child: InputForm(
              onSubmit: _onSubmit,
            ),
          ),
          StreamBuilder<List<BbsEntry>>(
            stream: widget.repository.entries(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final entry = data[i];
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: BbsPostInfo(
                                    title: entry.title,
                                    name: entry.name,
                                    postDate: widget.dateFormat
                                        .format(entry.updatedAt!),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteEntry(entry);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              entry.body,
                              style: TextStyle(
                                color: Color(entry.textColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: data.length,
                  ),
                );
              } else if (snapshot.hasError) {
                return const SliverToBoxAdapter(
                  child: Text('書き込みリストの取得に失敗しました。'),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> _onSubmit(BbsPostData data) async {
    await widget.repository.save(BbsEntry(
      name: data.name,
      title: data.title,
      body: data.body,
      textColor: data.textColor.value,
      deleteKey: data.deleteKey,
    ));
  }

  Future<void> _deleteEntry(BbsEntry entry) async {
    final inputKey = await DeleteConfirmDialog.prompt(context);
    if (inputKey == entry.deleteKey) {
      widget.repository.delete(entry);
    }
  }
}

class DeleteConfirmDialog extends StatefulWidget {
  const DeleteConfirmDialog({
    Key? key,
  }) : super(key: key);

  @override
  _DeleteConfirmDialogState createState() => _DeleteConfirmDialogState();

  static Future<String?> prompt(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const DeleteConfirmDialog(),
    );
  }
}

class _DeleteConfirmDialogState extends State<DeleteConfirmDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('削除キーを入力してください'),
      content: TextField(
        controller: _controller,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, _controller.text);
          },
          child: const Text('削除'),
        ),
      ],
    );
  }
}

class BbsPostInfo extends StatelessWidget {
  const BbsPostInfo({
    Key? key,
    required this.title,
    required this.name,
    required this.postDate,
  }) : super(key: key);

  final String title;
  final String name;
  final String postDate;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(text: ' 投稿者: '),
          TextSpan(
            text: name,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' 投稿日: $postDate',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}

class BbsPostData {
  final String name;
  final String title;
  final String body;
  final Color textColor;
  final String deleteKey;

  const BbsPostData({
    required this.name,
    required this.title,
    required this.body,
    required this.textColor,
    required this.deleteKey,
  });
}

typedef BbsPostDataHandler = Future<void> Function(BbsPostData);

class InputForm extends StatefulWidget {
  const InputForm({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  final BbsPostDataHandler onSubmit;

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();
  final _deleteKeyTextController = TextEditingController();
  Color _color = Colors.black;
  bool _formIsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          BbsPostTextField(
            label: '名前',
            controller: _nameTextController,
            enabled: _formIsEnabled,
          ),
          BbsPostTextField(
            label: 'タイトル',
            controller: _titleTextController,
            enabled: _formIsEnabled,
          ),
          BbsPostTextField(
            label: '本文',
            maxLines: 5,
            controller: _bodyTextController,
            enabled: _formIsEnabled,
          ),
          BbsPostColor(
            selectedColor: _color,
            onChanged: _onChangeColor,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: _deleteKeyTextController,
                    decoration: const InputDecoration(
                      labelText: '削除キー',
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('書き込む'),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '※削除キーを設定しておくと、後で書き込みを削除することができます。削除キーを設定しないで書き込んだ場合は、削除することができません。',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }

  void _onChangeColor(Color? color) {
    if (color == null) return;
    setState(() {
      _color = color;
    });
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _formIsEnabled = false;
      });

      final name = _nameTextController.text;
      final title = _titleTextController.text;
      final body = _bodyTextController.text;
      final deleteKey = _deleteKeyTextController.text;
      final color = _color;

      FocusManager.instance.primaryFocus!.unfocus();
      _reset();

      widget
          .onSubmit(BbsPostData(
        name: name,
        title: title,
        body: body,
        deleteKey: deleteKey,
        textColor: color,
      ))
          .whenComplete(() {
        setState(() {
          _formIsEnabled = true;
        });
      });
    }
  }

  void _reset() {
    _nameTextController.text = '';
    _titleTextController.text = '';
    _bodyTextController.text = '';
    _deleteKeyTextController.text = '';
  }
}

class BbsPostColor extends StatelessWidget {
  const BbsPostColor({
    Key? key,
    required this.selectedColor,
    required this.onChanged,
  }) : super(key: key);

  final Color selectedColor;
  final ValueChanged<Color?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text('文字色:'),
        ),
        Radio(
          value: Colors.black,
          groupValue: selectedColor,
          onChanged: onChanged,
        ),
        const Text('黒'),
        Radio(
          value: Colors.red,
          groupValue: selectedColor,
          onChanged: onChanged,
        ),
        const Text('赤'),
        Radio(
          value: Colors.blue,
          groupValue: selectedColor,
          onChanged: onChanged,
        ),
        Text('青'),
      ],
    );
  }
}

class BbsPostTextField extends StatelessWidget {
  const BbsPostTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.enabled,
    this.maxLines = 1,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        validator: (value) {
          if (value?.isEmpty == true) {
            return '$labelを入力してください';
          }
          return null;
        },
        maxLines: maxLines,
      ),
    );
  }
}
