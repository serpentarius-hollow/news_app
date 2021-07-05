import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/post.dart';
import 'package:news_app/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc(this.postRepository) : super(PostInitial());

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    final currentState = state;

    if (event is PostFetched) {
      if (currentState is PostInitial) {
        try {
          yield PostLoadInProgress();

          final posts = await postRepository.getPosts();

          yield PostLoadSuccess(posts);
        } catch (err) {
          yield PostLoadFailure('Load Failure');
          yield currentState;
        }
      }
    }
  }
}
