import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'data/dummy_users.dart';
import 'widgets/profile_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dating App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  List<User> userStack = List.from(dummyUsers.reversed);

  void _onSwipe(bool liked) {
    if (userStack.isEmpty) return;
    setState(() {
      userStack.removeLast();
    });
    // Here you would handle the like/dislike logic
    print(liked ? 'Liked!' : 'Disliked!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover', style: TextStyle(color: Colors.pink)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.grey),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: userStack.isEmpty
                    ? [
                        const Text(
                          'No more profiles!',
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        )
                      ]
                    : userStack.map((user) {
                        final index = userStack.indexOf(user);
                        if (index == userStack.length - 1) {
                          return Draggable<User>(
                            data: user,
                            feedback: Material(
                              elevation: 8.0,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height: MediaQuery.of(context).size.height * 0.6,
                                child: ProfileCard(user: user),
                              ),
                            ),
                            childWhenDragging: Container(),
                            onDragEnd: (details) {
                              final screenWidth = MediaQuery.of(context).size.width;
                              if (details.offset.dx.abs() > screenWidth / 4) {
                                _onSwipe(details.offset.dx > 0);
                              }
                            },
                            child: ProfileCard(user: user),
                          );
                        } else {
                           return ProfileCard(user: user);
                        }
                      }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.close,
                  color: Colors.red,
                  onPressed: () => _onSwipe(false),
                ),
                _buildActionButton(
                  icon: Icons.star,
                  color: Colors.blue,
                  onPressed: () {
                    // Handle super like
                  },
                ),
                _buildActionButton(
                  icon: Icons.favorite,
                  color: Colors.green,
                  onPressed: () => _onSwipe(true),
                ),
              ],
            ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.white,
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}
