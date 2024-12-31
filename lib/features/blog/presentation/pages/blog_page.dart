import 'package:blogapp/core/common/widgets/loader.dart';
import 'package:blogapp/core/common/widgets/show_snackbar.dart';
import 'package:blogapp/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogapp/features/blog/presentation/pages/add_new_blog.dart';
import 'package:blogapp/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BLogFetchAllBlogs());
  }

  // Function to trigger blog reload
  Future<void> _reloadBlogs() async {
    // Dispatch the event to reload blogs
    context.read<BlogBloc>().add(BlogReloadBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, AddNewBlog.route());
              },
              icon: const Icon(
                CupertinoIcons.add_circled,
              ))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          if (state is BlogDisplaySuccess) {
            return RefreshIndicator(
              onRefresh: _reloadBlogs,
              child: ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(
                    blog: blog,
                    color: index % 3 == 0
                        ? const Color.fromARGB(255, 179, 71, 63)
                        : index % 3 == 1
                            ? const Color.fromARGB(255, 110, 72, 143)
                            : Colors.blueAccent,
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
