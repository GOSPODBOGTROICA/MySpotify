import 'package:flutter/material.dart';
import 'src/services/audio_service.dart';

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
  double _crossfadeDuration = 3.0;
  bool _autoplayEnabled = true;
  
  final AudioService _audioService = AudioService();
  String _currentTrack = '';
  String _currentArtist = '';
  bool _isPlaying = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _audioService.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _playTrack(String title, String artist) async {
    setState(() {
      _currentTrack = title;
      _currentArtist = artist;
      _isPlaying = true;
    });
    // Search youtube for the track + artist and play it
    await _audioService.playTrack("\$title \$artist audio");
  }

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
          if (_currentTrack.isNotEmpty) _buildMiniPlayer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFFB3B3B3),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Good Evening', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1DB954),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.download, color: Colors.black),
            label: const Text('Import Playlist from Spotify', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            onPressed: _showImportDialog,
          ),
          const SizedBox(height: 24),
          const Text('Recommended', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
      onTap: () => _playTrack(title, artist),
    );
  }

  Widget _buildSearchScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search songs...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFF282828),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              onSubmitted: (val) {
                if(val.isNotEmpty) _playTrack(val, 'Search Result');
              },
            ),
            const Expanded(child: Center(child: Text('Type a song and press enter to play'))),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryScreen() => const Center(child: Text('Your Library (Work in progress)'));

  Widget _buildSettingsScreen() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('App Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
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
                      const Text('Crossfade', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text('${_crossfadeDuration.toInt()} s', style: const TextStyle(color: Color(0xFF1DB954), fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Smooth transition between tracks.', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 13)),
                  Slider(
                    value: _crossfadeDuration,
                    min: 1.0,
                    max: 12.0,
                    divisions: 11,
                    activeColor: const Color(0xFF1DB954),
                    inactiveColor: const Color(0xFF282828),
                    onChanged: (val) {
                      setState(() => _crossfadeDuration = val);
                      _audioService.setCrossfade(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            tileColor: const Color(0xFF181818),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            activeColor: const Color(0xFF1DB954),
            title: const Text('Autoplay', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Keep listening to similar tracks when your audio ends.', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 13)),
            value: _autoplayEnabled,
            onChanged: (val) => setState(() => _autoplayEnabled = val),
          ),
        ],
      ),
    );
  }

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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_currentTrack, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(_currentArtist, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
                ],
              ),
            ),
            IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 30),
              onPressed: () {
                setState(() => _isPlaying = !_isPlaying);
                // Pause/play logic would go here
              },
            ),
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
        title: const Text('Import Spotify Playlist'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Paste Spotify URL...',
            hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954), foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Playlist imported successfully!')));
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }
}
