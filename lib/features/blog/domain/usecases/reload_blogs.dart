import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/features/blog/domain/entity/blog.dart';
import 'package:blogapp/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class ReloadBlogs implements Usecase<List<Blog>, NoParams> {
  // final Failures failures;
  final BlogRepository blogRepository;

  ReloadBlogs(this.blogRepository);
  @override
  Future<Either<Failures, List<Blog>>> call(NoParams params) async {
    final result = await blogRepository.getAllBlogs();

    return result.fold((failure) => Left(Failures(failure.message)), (blogs) {
      final uniqueBlogs = <Blog>[];

      for (var blog in blogs) {
        // Check if the blog already exists in the unique list
        if (!uniqueBlogs.any((existingBlog) => existingBlog.id == blog.id)) {
          uniqueBlogs.add(blog);
        }
      }

      return Right(uniqueBlogs); // Return the unique list of blogs
    });
  }
}
