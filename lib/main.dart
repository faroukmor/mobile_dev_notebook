import 'package:flutter/material.dart';
import 'db.dart';
import 'db_init.dart';
import 'editor_page.dart';
import 'note.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home(),
    debugShowCheckedModeBanner: false,);
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notes = [];
  List<Category> categories = [];
  String searchText = '';
  int? selectedCategoryId;
  int tab = 0;
  bool isGrid = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadNotes();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    isGrid = prefs.getBool('isGrid') ?? false;
  });
}

  Future<void> toggleGrid() async {
    setState(() {
      isGrid = !isGrid;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGrid', isGrid);
  }
  
  Future<void> loadCategories() async {
    final result = await DB.instance.getCategories();
    setState(() {
      categories = result;
    });
  }

  Future<void> loadNotes() async {
    final result = await DB.instance.getNotes(
      search: searchText,
      categoryId: selectedCategoryId,
      onlyFavorites: tab == 1,
    );
    setState(() {
      notes = result;
    });
  }

  String categoryName(int? id) {
    for (final c in categories) {
      if (c.id == id) return c.name;
    }
    return 'Sans catégorie';
  }

  Future<void> openEditor([Note? note]) async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (context) => EditorPage(note: note)),
    );

    if (result != null) {
      await DB.instance.saveNote(result);
    }
    loadNotes();
  }

  Widget buildNoteCard(Note note) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(
          '${categoryName(note.categoryId)} · ${note.content}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => openEditor(note),
        trailing: IconButton(
        icon: Icon(note.favorite ? Icons.star : Icons.star_border),
        onPressed: () async {
          await DB.instance.toggleFavorite(note);
          loadNotes();
        },
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tab == 0 ? 'Mes notes' : 'Favoris'),
      actions: [
      IconButton(
        icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
        onPressed: toggleGrid,
      ),
    ],),
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Rechercher par titre',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchText = value.trim();
                loadNotes();
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: const Text('Toutes'),
                    selected: selectedCategoryId == null,
                    onSelected: (_) {
                      selectedCategoryId = null;
                      loadNotes();
                    },
                  ),
                ),
                for (final c in categories)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(c.name),
                      selected: selectedCategoryId == c.id,
                      onSelected: (_) {
                        selectedCategoryId = c.id;
                        loadNotes();
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: notes.isEmpty
                ? const Center(child: Text('Aucune note'))
                : isGrid
    ? GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) => buildNoteCard(notes[index]),
      )
    : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) => buildNoteCard(notes[index]),
      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openEditor(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
  selectedIndex: tab,
  onDestinationSelected: (index) {
    setState(() {
      tab = index;
    });
    loadNotes();
  },
  destinations: const [
    NavigationDestination(icon: Icon(Icons.notes), label: 'Notes'),
    NavigationDestination(icon: Icon(Icons.star), label: 'Favoris'),
  ],
),
    );
  }
}