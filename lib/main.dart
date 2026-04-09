import 'package:flutter/material.dart';

import 'models/user.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'widgets/user_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Data Persistence Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _savedName = '';
  String _savedNote = '';
  bool _isLoadingUsers = false;
  List<User> _users = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Load the saved name, note, and users when the app starts.
  Future<void> _loadSavedData() async {
    setState(() {
      _isLoadingUsers = true;
      _errorMessage = '';
    });

    final savedName = await StorageService.getSavedName();
    final savedNote = await StorageService.readNoteFromFile();

    try {
      final users = await ApiService.fetchUsers();
      setState(() {
        _savedName = savedName;
        _savedNote = savedNote;
        _users = users;
      });
    } catch (error) {
      setState(() {
        _savedName = savedName;
        _savedNote = savedNote;
        _errorMessage = 'Could not load users. Try again later.';
      });
    } finally {
      setState(() {
        _isLoadingUsers = false;
      });
    }
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    await StorageService.saveName(name);
    setState(() {
      _savedName = name;
      _nameController.clear();
    });
  }

  Future<void> _saveNote() async {
    final note = _noteController.text.trim();
    if (note.isEmpty) {
      return;
    }

    await StorageService.saveNoteToFile(note);
    setState(() {
      _savedNote = note;
      _noteController.clear();
    });
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _isLoadingUsers = true;
      _errorMessage = '';
    });

    try {
      final users = await ApiService.fetchUsers();
      setState(() {
        _users = users;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Failed to fetch users. Please try again.';
      });
    } finally {
      setState(() {
        _isLoadingUsers = false;
      });
    }
  }

  Widget _buildSection({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Persistence Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '1. Save your name locally',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter your name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _saveName,
                    child: const Text('Save Name'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _savedName.isEmpty
                        ? 'No name saved yet.'
                        : 'Saved name: $_savedName',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '2. Save a note to a file',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Write a short note',
                    ),
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _saveNote,
                    child: const Text('Save Note'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _savedNote.isEmpty
                        ? 'No note saved yet.'
                        : 'Saved note:\n$_savedNote',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '3. Fetch users from API',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: _refreshUsers,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_isLoadingUsers)
                    const Center(child: CircularProgressIndicator())
                  else if (_errorMessage.isNotEmpty)
                    Text(_errorMessage, style: const TextStyle(color: Colors.red))
                  else if (_users.isEmpty)
                    const Text('No users loaded yet.')
                  else
                    UserList(users: _users),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
