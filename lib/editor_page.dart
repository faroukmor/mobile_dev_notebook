import 'package:flutter/material.dart';
import 'db.dart';
import 'note.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class EditorPage extends StatefulWidget {
  final Note? note;
  const EditorPage({super.key, this.note});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<Category> categories = [];
  int? categoryId;
  bool favorite = false;
  bool loadingQuote = false;

  Future<void> addQuote() async {
  setState(() {
    loadingQuote = true;
  });

  try {
    final response = await http
        .get(Uri.parse('https://dummyjson.com/quotes/random'))
        .timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) throw Exception('Erreur serveur');

    final data = jsonDecode(response.body);
    final quote = '“${data['quote']}” — ${data['author']}';
    contentController.text = contentController.text.isEmpty
        ? quote
        : '${contentController.text}\n\n$quote';
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de récupérer une citation')),
      );
    }
  }

  if (mounted) {
    setState(() {
      loadingQuote = false;
    });
  }
}



  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      categoryId = widget.note!.categoryId;
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      favorite = widget.note!.favorite;
    }
    loadCategories();
  }
  Future<void> loadCategories() async {
  final result = await DB.instance.getCategories();
  setState(() {
    categories = result;
    });
  }
  void save() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le titre et le contenu sont obligatoires')),
      );
      return;
    }

    final note = widget.note ?? Note(title: title, content: content);
    note.title = title;
    note.content = content;
    note.categoryId = categoryId;
    note.favorite = favorite;
    Navigator.pop(context, note);
  }

  Future<void> deleteNote() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette note ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    );

    if (sure == true) {
      await DB.instance.deleteNote(widget.note!.id!);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 104, 239, 237),
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nouvelle note' : 'Modifier la note'),
        actions: [
          if (widget.note != null)
            IconButton(
            icon: Icon(favorite ? Icons.star : Icons.star_border),
            onPressed: () {
              setState(() {
                favorite = !favorite;
              });
            },
          ),
            IconButton(icon: const Icon(Icons.delete), onPressed: deleteNote),
        ],
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
            value: categoryId,
            decoration: const InputDecoration(labelText: 'Catégorie', border: OutlineInputBorder()),
            items: [
              const DropdownMenuItem<int?>(value: null, child: Text('Aucune')),
              for (final c in categories)
                DropdownMenuItem<int?>(value: c.id, child: Text(c.name)),
            ],
            onChanged: (value) {
              setState(() {
                categoryId = value;
              });
            },
          ),
const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 8,
              decoration: const InputDecoration(labelText: 'Contenu', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
            onPressed: loadingQuote ? null : addQuote,
            icon: const Icon(Icons.lightbulb_outline),
            label: Text(loadingQuote ? 'Chargement...' : 'Ajouter une citation'),
          ),
          const SizedBox(height: 8),
            ElevatedButton(onPressed: save, child: const Text('Enregistrer')),
          ],
        ),
      ),
    );
  }
}