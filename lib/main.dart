import 'package:flutter/material.dart';

void main() {
  runApp(const CustomSpotifyApp());
}

class CustomSpotifyApp extends StatelessWidget {
  const CustomSpotifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Custom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1DB954),
        fontFamily: 'CircularSp',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DB954),
          surface: Color(0xFF181818),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  double _crossfadeDuration = 6.0; // 1 to 12 seconds, default 6s
  bool _autoplayEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeScreen(),
              _buildSearchScreen(),
              _buildLibraryScreen(),
              _buildSettingsScreen(),
            ],
          ),
          _buildMiniPlayer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF121212).withOpacity(0.95),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFFB3B3B3),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Моя медиатека'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Добрый вечер', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1DB954),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.download, color: Colors.black),
            label: const Text('Импортировать плейлист из Spotify', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            onPressed: _showImportDialog,
          ),
          const SizedBox(height: 24),
          const Text('Недавно прослушано', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildTrackTile('Starboy', 'The Weeknd, Daft Punk', '3:50'),
          _buildTrackTile('Blinding Lights', 'The Weeknd', '3:20'),
          _buildTrackTile('One Dance', 'Drake, WizKid, Kyla', '2:54'),
        ],
      ),
    );
  }

  Widget _buildTrackTile(String title, String artist, String duration) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.music_note, color: Color(0xFF1DB954)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(artist, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 13)),
      trailing: Text(duration, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 13)),
      onTap: () {},
    );
  }

  Widget _buildSettingsScreen() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Настройки воспроизведения', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          // Crossfade Setting (1-12s, step 1s)
          Card(
            color: const Color(0xFF181818),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Плавный переход (Crossfade)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text('${_crossfadeDuration.toInt()} сек', style: const TextStyle(color: Color(0xFF1DB954), fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Позволяет плавно сводить треки без тишины между ними.', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 13)),
                  Slider(
                    value: _crossfadeDuration,
                    min: 1.0,
                    max: 12.0,
                    divisions: 11, // 1 to 12 with 1s step
                    activeColor: const Color(0xFF1DB954),
                    inactiveColor: const Color(0xFF282828),
                    onChanged: (val) => setState(() => _crossfadeDuration = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Autoplay Setting
          SwitchListTile(
            tileColor: const Color(0xFF181818),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            activeColor: const Color(0xFF1DB954),
            title: const Text('Автовоспроизведение похожих треков', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Непрерывное воспроизведение похожей музыки после окончания плейлиста.', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 13)),
            value: _autoplayEnabled,
            onChanged: (val) => setState(() => _autoplayEnabled = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchScreen() => const Center(child: Text('Поиск треков и плейлистов'));
  Widget _buildLibraryScreen() => const Center(child: Text('Ваша медиатека'));

  Widget _buildMiniPlayer() {
    return Positioned(
      bottom: 0,
      left: 8,
      right: 8,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Starboy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('The Weeknd', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
                ],
              ),
            ),
            IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
            IconButton(icon: const Icon(Icons.play_arrow, size: 30), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  void _showImportDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text('Импорт плейлиста Spotify'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Вставьте ссылку на плейлист Spotify...',
            hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена', style: TextStyle(color: Colors.white))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954), foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Плейлист успешно импортирован!')));
            },
            child: const Text('Импортировать'),
          ),
        ],
      ),
    );
  }
}
