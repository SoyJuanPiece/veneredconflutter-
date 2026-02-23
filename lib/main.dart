import 'package:flutter/material.dart';

void main() {
  runApp(VeneredApp());
}

class VeneredApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venered Social',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardTheme(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.blueAccent),
          titleTextStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey[900]),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blueAccent),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent,
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: Colors.purpleAccent),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Color(0xFF181A20),
        cardTheme: CardTheme(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Color(0xFF23243A),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF23243A),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.blueAccent),
          titleTextStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blueAccent),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent,
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue, brightness: Brightness.dark).copyWith(secondary: Colors.purpleAccent),
      ),
      themeMode: ThemeMode.system,
      home: AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthGate extends StatefulWidget {
  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loggedIn = false;
  String _username = '';

  void _login(String username) {
    setState(() {
      _loggedIn = true;
      _username = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loggedIn) {
      return MainScreen();
    }
    return AuthPage(onLogin: _login);
  }
}

class AuthPage extends StatefulWidget {
  final void Function(String username) onLogin;
  AuthPage({required this.onLogin});
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLogin = true;

  void _submit() {
    if (_userController.text.isNotEmpty && _passController.text.isNotEmpty) {
      widget.onLogin(_userController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_isLogin ? 'Iniciar sesión' : 'Registrarse', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              TextField(
                controller: _userController,
                decoration: InputDecoration(labelText: 'Usuario'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _passController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Entrar' : 'Registrar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin ? '¿No tienes cuenta? Regístrate' : '¿Ya tienes cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _unreadNotifications = 2;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final List<Widget> _pages = [
    FeedPage(),
    SearchPage(),
    PublishPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) _unreadNotifications = 0;
    });
  }

  // Simula notificaciones push cada cierto tiempo
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 8), _showRealtimeNotification);
  }

  void _showRealtimeNotification() {
    if (_selectedIndex != 3) {
      setState(() {
        _unreadNotifications++;
      });
      _scaffoldMessengerKey.currentState?.showMaterialBanner(
        MaterialBanner(
          content: Text('¡Tienes una nueva notificación!'),
          leading: Icon(Icons.notifications_active, color: Colors.blue),
          backgroundColor: Colors.blue[50],
          actions: [
            TextButton(
              onPressed: () => _scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner(),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    }
    Future.delayed(Duration(seconds: 20), _showRealtimeNotification);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 350),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: _pages[_selectedIndex],
          layoutBuilder: (currentChild, previousChildren) => Stack(
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, semanticLabel: 'Inicio'),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, semanticLabel: 'Buscar'),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box, semanticLabel: 'Publicar'),
              label: 'Publicar',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.notifications, semanticLabel: 'Notificaciones'),
                  if (_unreadNotifications > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${_unreadNotifications}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Notificaciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, semanticLabel: 'Perfil'),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

// Accesibilidad: agrega labels y contraste en FeedPage
class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Map<String, dynamic>> stories = [
    {'user': 'juanito', 'profilePic': 'https://randomuser.me/api/portraits/men/1.jpg', 'storyImage': 'https://picsum.photos/200/300?random=101'},
    {'user': 'maria', 'profilePic': 'https://randomuser.me/api/portraits/women/2.jpg', 'storyImage': 'https://picsum.photos/200/300?random=102'},
    {'user': 'pedro', 'profilePic': 'https://randomuser.me/api/portraits/men/3.jpg', 'storyImage': 'https://picsum.photos/200/300?random=103'},
    {'user': 'ana', 'profilePic': 'https://randomuser.me/api/portraits/women/4.jpg', 'storyImage': 'https://picsum.photos/200/300?random=104'},
  ];

  List<Map<String, dynamic>> posts = [
    {'user': 'juanito', 'profilePic': 'https://randomuser.me/api/portraits/men/1.jpg', 'image': 'https://picsum.photos/400/300?random=1', 'desc': '¡Qué buen día!', 'likes': 12, 'liked': false, 'comments': ['Genial!', 'Me encanta', 'Buen día!']},
    {'user': 'maria', 'profilePic': 'https://randomuser.me/api/portraits/women/2.jpg', 'image': 'https://picsum.photos/400/300?random=2', 'desc': 'Disfrutando la vida', 'likes': 34, 'liked': false, 'comments': ['Hermosa foto', '¡Wow!', 'Inspirador', 'Me gusta', 'Perfecto', 'Linda']},
    {'user': 'pedro', 'profilePic': 'https://randomuser.me/api/portraits/men/3.jpg', 'image': 'https://picsum.photos/400/300?random=3', 'desc': 'Vacaciones en la playa', 'likes': 21, 'liked': false, 'comments': ['Quiero ir!', 'Disfruta', '¡Qué envidia!', 'Playa top', 'Relajante']},
  ];

  void _toggleLike(int index) {
    setState(() {
      posts[index]['liked'] = !posts[index]['liked'];
      if (posts[index]['liked']) {
        posts[index]['likes']++;
      } else {
        posts[index]['likes']--;
      }
    });
  }

  void _addComment(int index, String comment) {
    setState(() {
      posts[index]['comments'].add(comment);
    });
  }

  void _showComments(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        final TextEditingController _commentController = TextEditingController();
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Comentarios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: posts[index]['comments'].length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Icon(Icons.person, size: 22),
                      title: Text(posts[index]['comments'][i]),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(hintText: 'Escribe un comentario...'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        _addComment(index, _commentController.text);
                        _commentController.clear();
                        Navigator.pop(context);
                        _showComments(context, index);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  void _showStory(BuildContext context, Map<String, dynamic> story) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (ctx, anim, secAnim) {
          return FadeTransition(
            opacity: anim,
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(0.95),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'story_${story['user']}',
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(story['profilePic']),
                        radius: 48,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(story['user'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(height: 24),
                    Hero(
                      tag: 'storyimg_${story['user']}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(story['storyImage'], height: 320, width: 240, fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text('Story temporal', style: TextStyle(color: Colors.grey[300])),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cerrar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: isWide ? 24 : 0),
          children: [
            SizedBox(height: 8),
            // Stories
            Container(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return GestureDetector(
                    onTap: () => _showStory(context, story),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Hero(
                            tag: 'story_${story['user']}',
                            child: Semantics(
                              label: 'Historia de ${story['user']}${story['verified'] == true ? ", verificado" : ""}',
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.blueAccent, Colors.purpleAccent],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(story['profilePic']),
                                  radius: 36,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(story['user'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              if (story['verified'] == true)
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Icon(Icons.verified, color: Colors.blue, size: 15, semanticLabel: 'Verificado'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            // Feed
            ...posts.asMap().entries.map((entry) {
              final index = entry.key;
              final post = entry.value;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(post['profilePic']),
                        radius: 24,
                      ),
                      title: Row(
                        children: [
                          Text(post['user'], style: TextStyle(fontWeight: FontWeight.bold)),
                          if (post['verified'] == true)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(Icons.verified, color: Colors.blue, size: 16),
                            ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        post['image'],
                        height: isWide ? 320 : 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            height: isWide ? 320 : 220,
                            color: Colors.grey[300],
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(post['desc'], style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 1, end: post['liked'] ? 1.3 : 1),
                            duration: Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: IconButton(
                                  icon: Icon(
                                    post['liked'] ? Icons.favorite : Icons.favorite_border,
                                    color: post['liked'] ? Colors.red : null,
                                    size: 26,
                                  ),
                                  onPressed: () => _toggleLike(index),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 4),
                          Text('${post['likes']}', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 16),
                          IconButton(
                            icon: Icon(Icons.comment, size: 24),
                            onPressed: () => _showComments(context, index),
                          ),
                          SizedBox(width: 4),
                          Text('${post['comments'].length}', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> users = [
    {'name': 'juanito', 'profilePic': 'https://randomuser.me/api/portraits/men/1.jpg', 'bio': 'Amante de la tecnología', 'verified': true},
    {'name': 'maria', 'profilePic': 'https://randomuser.me/api/portraits/women/2.jpg', 'bio': 'Fotógrafa profesional', 'verified': false},
    {'name': 'pedro', 'profilePic': 'https://randomuser.me/api/portraits/men/3.jpg', 'bio': 'Viajero y blogger', 'verified': true},
    {'name': 'ana', 'profilePic': 'https://randomuser.me/api/portraits/women/4.jpg', 'bio': 'Diseñadora gráfica', 'verified': false},
  ];
  // Acceso a posts globales
  List<Map<String, dynamic>> get posts => (context.findAncestorStateOfType<_FeedPageState>()?.posts ?? []);

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((u) => u['name'].toLowerCase().contains(_query.toLowerCase())).toList();
    final filteredPosts = posts.where((p) => p['desc']!.toLowerCase().contains(_query.toLowerCase())).toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Buscar usuarios o publicaciones',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
          ),
          SizedBox(height: 24),
          if (_query.isNotEmpty) ...[
            Text('Usuarios', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            filteredUsers.isEmpty
                ? Text('Sin resultados')
                : Column(
                    children: filteredUsers.map((u) => ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(u['profilePic'])),
                      title: Row(
                        children: [
                          Text(u['name']),
                          if (u['verified'] == true)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(Icons.verified, color: Colors.blue, size: 16),
                            ),
                        ],
                      ),
                    )).toList(),
                  ),
            SizedBox(height: 24),
            Text('Publicaciones', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            filteredPosts.isEmpty
                ? Text('Sin resultados')
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredPosts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(filteredPosts[index]['image']!, height: 100, width: 100, fit: BoxFit.cover),
                          ),
                          SizedBox(height: 4),
                          Text(filteredPosts[index]['desc']!),
                        ],
                      );
                    },
                  ),
          ],
          if (_query.isEmpty)
            Center(child: Text('Busca usuarios o publicaciones')), 
        ],
      ),
    );
  }
}

class PublishPage extends StatefulWidget {
  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  String? _imageUrl;
  final TextEditingController _descController = TextEditingController();

  void _pickImage() {
    // Simulación: alterna entre imágenes
    setState(() {
      _imageUrl = 'https://picsum.photos/400/300?random=${DateTime.now().millisecondsSinceEpoch % 100}';
    });
  }

  void _publish() {
    // Simulación: muestra snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('¡Publicación realizada!')),
    );
    setState(() {
      _imageUrl = null;
      _descController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(_imageUrl!, height: 220, width: double.infinity, fit: BoxFit.cover),
                )
              : Container(
                  height: 220,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 80, color: Colors.grey[600]),
                ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Seleccionar imagen'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _imageUrl != null && _descController.text.isNotEmpty ? _publish : null,
            child: Text('Publicar'),
          ),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {'type': 'like', 'user': 'maria', 'msg': 'maria le dio like a tu foto'},
    {'type': 'comment', 'user': 'pedro', 'msg': 'pedro comentó: "¡Genial!"'},
    {'type': 'follow', 'user': 'ana', 'msg': 'ana empezó a seguirte'},
  ];

  IconData _getIcon(String type) {
    switch (type) {
      case 'like': return Icons.favorite;
      case 'comment': return Icons.comment;
      case 'follow': return Icons.person_add;
      default: return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final n = notifications[index];
        return ListTile(
          leading: Icon(_getIcon(n['type']!), color: Colors.blue),
          title: Text(n['msg']!),
        );
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> user = {
    'name': 'juanito',
    'bio': 'Desarrollador y amante de Flutter',
    'profilePic': 'https://randomuser.me/api/portraits/men/1.jpg',
    'followers': [
      {'name': 'maria', 'profilePic': 'https://randomuser.me/api/portraits/women/2.jpg'},
      {'name': 'pedro', 'profilePic': 'https://randomuser.me/api/portraits/men/3.jpg'},
      {'name': 'ana', 'profilePic': 'https://randomuser.me/api/portraits/women/4.jpg'},
    ],
    'following': [
      {'name': 'maria', 'profilePic': 'https://randomuser.me/api/portraits/women/2.jpg'},
      {'name': 'ana', 'profilePic': 'https://randomuser.me/api/portraits/women/4.jpg'},
    ],
    'posts': [
      'https://picsum.photos/200/200?random=11',
      'https://picsum.photos/200/200?random=12',
      'https://picsum.photos/200/200?random=13',
      'https://picsum.photos/200/200?random=14',
      'https://picsum.photos/200/200?random=15',
    ],
  };

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(userName: user['name'], profilePic: user['profilePic'])),
    );
  }

  void _editProfile(BuildContext context) {
    final nameController = TextEditingController(text: user['name']);
    final bioController = TextEditingController(text: user['bio']);
    final picController = TextEditingController(text: user['profilePic']);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Editar perfil'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: bioController,
                  decoration: InputDecoration(labelText: 'Biografía'),
                ),
                TextField(
                  controller: picController,
                  decoration: InputDecoration(labelText: 'URL foto de perfil'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  user['name'] = nameController.text;
                  user['bio'] = bioController.text;
                  user['profilePic'] = picController.text;
                });
                Navigator.pop(ctx);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showList(BuildContext context, String type) {
    final List usersList = user[type];
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(type == 'followers' ? 'Seguidores' : 'Seguidos'),
          content: Container(
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: usersList.length,
              itemBuilder: (context, index) {
                final u = usersList[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(u['profilePic'])),
                  title: Text(u['name']),
                  trailing: type == 'following'
                      ? IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              user['following'].removeAt(index);
                            });
                          },
                        )
                      : null,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 32),
          CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage(user['profilePic']),
          ),
          SizedBox(height: 12),
          Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          SizedBox(height: 6),
          Text(user['bio'], style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _showList(context, 'followers'),
                child: Column(
                  children: [
                    Text('${user['followers'].length}', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Seguidores'),
                  ],
                ),
              ),
              SizedBox(width: 32),
              GestureDetector(
                onTap: () => _showList(context, 'following'),
                child: Column(
                  children: [
                    Text('${user['following'].length}', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Seguidos'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text('Publicaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: user['posts'].length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(user['posts'][index], fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.white, size: 20),
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Editar'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Eliminar'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          final urlController = TextEditingController(text: user['posts'][index]);
                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text('Editar publicación'),
                                content: TextField(
                                  controller: urlController,
                                  decoration: InputDecoration(labelText: 'URL de imagen'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        user['posts'][index] = urlController.text;
                                      });
                                      Navigator.pop(ctx);
                                    },
                                    child: Text('Guardar'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (value == 'delete') {
                          setState(() {
                            user['posts'].removeAt(index);
                          });
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _editProfile(context),
                child: Text('Editar perfil'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _openChat(context),
                child: Text('Mensaje'),
              ),
            ],
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String userName;
  final String profilePic;
  ChatPage({required this.userName, required this.profilePic});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, String>> messages = [
    {'from': 'yo', 'text': '¡Hola!'},
    {'from': 'otro', 'text': '¡Hola, qué tal?'},
    {'from': 'yo', 'text': '¿Cómo estás?'},
    {'from': 'otro', 'text': 'Bien, gracias.'},
  ];
  final TextEditingController _msgController = TextEditingController();

  void _sendMessage() {
    if (_msgController.text.isNotEmpty) {
      setState(() {
        messages.add({'from': 'yo', 'text': _msgController.text});
        _msgController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.profilePic)),
            SizedBox(width: 8),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['from'] == 'yo';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text']!),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(hintText: 'Escribe un mensaje...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Comentarios para pruebas y documentación avanzada:
// - Prueba: la app debe mostrar banners de notificación y badge en el icono de notificaciones.
// - Prueba: los elementos interactivos tienen labels accesibles.
// - Prueba: los usuarios verificados muestran el icono azul en todas las vistas.
// - Prueba: la navegación y animaciones son suaves y accesibles.
