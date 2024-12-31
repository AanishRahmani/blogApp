import 'dart:io';

import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/features/blog/domain/entity/blog.dart';
import 'package:blogapp/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blogapp/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUploadEvent>(_onBLogUpload);
    on<BLogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogReloadBlogs>(_onBlogReload);
  }

  // Fetch all blogs
  void _onFetchAllBlogs(
      BLogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());

    res.fold((l) => emit(BlogFailure(l.message)),
        (r) => emit(BlogDisplaySuccess(r)));
  }

  // Upload blog
  void _onBLogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  // Handle Blog Reload
  void _onBlogReload(BlogReloadBlogs event, Emitter<BlogState> emit) async {
    emit(BlogLoading()); // Show loading indicator while fetching

    final res = await _getAllBlogs(NoParams());

    res.fold((l) => emit(BlogFailure(l.message)),
        (r) => emit(BlogDisplaySuccess(r))); // Update state with new blogs
  }
}
