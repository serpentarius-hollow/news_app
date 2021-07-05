part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoadInProgress extends PostState {}

class PostLoadSuccess extends PostState {
  final List<Post> posts;

  const PostLoadSuccess(this.posts);

  @override
  List<Object> get props => [posts];
}

class PostLoadFailure extends PostState {
  final String message;

  PostLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
