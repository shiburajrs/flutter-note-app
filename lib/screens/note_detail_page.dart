import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/utils/color_utils.dart';
import 'package:notes_app/utils/time_convert_utils.dart';
import '../database/database_services.dart';
import '../models/note_model.dart';
import '../utils/text_style_utils.dart';
import '../widgets/custom_color_picker.dart';

class NoteDetailPage extends StatefulWidget {
  NoteDetailPage({super.key, required this.note, this.newNote = false});

  Note? note;
  bool newNote;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;
  Color? _selectedColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.newNote;

    if (!widget.newNote) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final time = DateTime.now();
    final label = 'General';

    if(title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title and description are required'),
        )
      );
    } else {
      if (widget.newNote) {
        final newNote = Note(
          title: title,
          description: description,
          time: time,
          label: label,
          backgroundColor: _selectedColor!.value,
        );
        await DatabaseService().insertNote(newNote);
      } else {
        final updatedNote = Note(
          id: widget.note!.id,
          title: title,
          description: description,
          time: widget.note!.time,
          label: widget.note!.label,
        );
        await DatabaseService().updateNote(updatedNote);
      }
      Navigator.pop(context, true);
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.note?.backgroundColor == null
          ? _selectedColor
          : Color(widget.note!.backgroundColor!),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: widget.note?.backgroundColor == null
            ? _selectedColor
            : Color(widget.note!.backgroundColor!),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: widget.note?.backgroundColor == null
                      ? Colors.grey.withOpacity(0.6)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
            Spacer(),
            if (!widget.newNote)
              InkWell(
                onTap: _toggleEditing,
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: widget.note?.backgroundColor == null
                        ? Colors.grey.withOpacity(0.6)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              ),
            SizedBox(width: 10),
            if (_isEditing)
              InkWell(
                onTap: () async {
                  await _saveNote();
                },
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: widget.note?.backgroundColor == null
                        ? Colors.grey.withOpacity(0.6)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.save,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              ),
            SizedBox(width: 10),
            if (_isEditing)
              PopupMenuButton<String>(
                color: Colors.white,
                onSelected: (value) {
                  switch (value) {
                    case 'Copy':
                      _copyToClipboard();
                      break;
                    case 'Change Color':
                      _selectColor(widget.note ?? null);
                      break;
                    case 'Pin':
                      _pinNote(widget.note!);
                      break;
                    default:
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'Copy',
                    child: Row(
                      children: [
                        Icon(
                          Icons.copy,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Copy to Clipboard',
                          style: TextStyles.medium(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                      value: 'Change Color',
                      child: Row(
                        children: [
                          Icon(Icons.color_lens, color: Colors.black, size: 20),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Change Color',
                              style: TextStyles.medium(
                                  fontSize: 14, color: Colors.black)),
                        ],
                      )),
                  PopupMenuItem<String>(
                      value: 'Pin',
                      child: Row(
                        children: [
                          Icon(Icons.push_pin, color: Colors.black, size: 20),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              widget.note?.isPinned ?? false
                                  ? 'Unpin Note'
                                  : 'Pin Note',
                              style: TextStyles.medium(
                                  fontSize: 14, color: Colors.black)),
                        ],
                      )),
                ],
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: widget.note?.backgroundColor == null
                        ? Colors.grey.withOpacity(0.6)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  enabled: _isEditing,
                  focusNode: widget.newNote ? _focusNode : null,
                  style: TextStyles.regular(fontSize: 26),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your title",
                    hintStyle: TextStyles.regular(fontSize: 30),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  widget.note != null
                      ? "Last edited on ${TimeConvertUtils.formatDateTime(widget.note!.time)}"
                      : "",
                  style: TextStyles.light(
                      fontSize: 14, color: Colors.black.withOpacity(0.6)),
                ),
                SizedBox(height: 5),
                Scrollbar(controller: _scrollController,
                  child: TextField(
                    controller: _descriptionController,
                    enabled: _isEditing,
                    maxLines: 20,
                    style: TextStyles.light(fontSize: 14),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter the note here..",
                      hintStyle: TextStyles.light(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
        )
        ),
    );
  }

  void _copyToClipboard() {
    FocusScope.of(context).unfocus();
    _focusNode.unfocus();
    final String content = _descriptionController.text;
    Clipboard.setData(ClipboardData(text: content)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Copied to clipboard')),
      );
    });
  }
  void _selectColor(Note? note) {
    FocusScope.of(context).unfocus();
    _focusNode.unfocus();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a Color'),
          content: Container(
            width: double.maxFinite,
            height: 200,
            child: ColorPicker(
              colors: ColorUtils.cardColors,
              selectedColor: widget.note?.backgroundColor == null
                  ? Colors.white
                  : Color(widget.note!.backgroundColor!),
              onColorSelected: (color) async {
                if(note != null) {
                  Note updatedNote = Note(
                    id: note.id,
                    title: note.title,
                    description: note.description,
                    time: note.time,
                    label: note.label,
                    backgroundColor: color.value,
                    isPinned: note.isPinned,
                  );
                  await DatabaseService().updateNote(updatedNote);
                  widget.note = updatedNote;
                }
                setState(() {
                  _selectedColor = color;
                  print(_selectedColor?.value.toString());
                });
                Navigator.pop(context);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _pinNote(Note note) async {
    print(note);
    if (note != null) {
      Note updatedNote = Note(
        id: note.id,
        title: note.title,
        description: note.description,
        time: note.time,
        label: note.label,
        backgroundColor: note.backgroundColor,
        isPinned: !note.isPinned,
      );
      await DatabaseService().updateNote(updatedNote);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save the note first')),
      );
    }
  }
}
