import 'package:flutter/material.dart';
import '../models/post.dart';
import 'login_page.dart';
import 'detail_page.dart';

class MovieListPage extends StatelessWidget {
  final String username;
    
  const MovieListPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, $username!'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: dummyPosts.length,
        itemBuilder: (context, index) {
          final post = dummyPosts[index];
          return PostItem(post: post);
        },
      ),
    );
  }
}

class PostItem extends StatefulWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late int upvotes;
  late int downvotes;
  bool hasUpvoted = false;
  bool hasDownvoted = false;

  @override
  void initState() {
    super.initState();
    upvotes = widget.post.upvotes;
    downvotes = widget.post.downvotes;
  }

  void _handleUpvote() {
    setState(() {
      if (hasUpvoted) {
        upvotes--;
        hasUpvoted = false;
      } else {
        if (hasDownvoted) {
          downvotes--;
          hasDownvoted = false;
        }
        upvotes++;
        hasUpvoted = true;
      }
    });
  }

  void _handleDownvote() {
    setState(() {
      if (hasDownvoted) {
        downvotes--;
        hasDownvoted = false;
      } else {
        if (hasUpvoted) {
          upvotes--;
          hasUpvoted = false;
        }
        downvotes++;
        hasDownvoted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[700]),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Image.network(
            widget.post.imageUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        hasUpvoted ? Icons.arrow_upward : Icons.arrow_upward_outlined,
                        color: hasUpvoted ? Colors.orange : Colors.grey,
                      ),
                      onPressed: _handleUpvote,
                    ),
                    Text(
                      '$upvotes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: hasUpvoted ? Colors.orange : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        hasDownvoted ? Icons.arrow_downward : Icons.arrow_downward_outlined,
                        color: hasDownvoted ? Colors.blue : Colors.grey,
                      ),
                      onPressed: _handleDownvote,
                    ),
                    Text(
                      '$downvotes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: hasDownvoted ? Colors.blue : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.comment, size: 20, color: Colors.grey[600]),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailPage(post: widget.post),
                          ),
                        );
                      },
                    ),
                    Text(
                      '${widget.post.comments.length}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.post.content,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Komentar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                ...widget.post.comments.map((comment) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        '• $comment',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}