import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/comment/comment_bloc.dart';
import '../../../../blocs/comment/comment_event.dart';

class CommentInput extends StatefulWidget {
  final String taskId;

  const CommentInput({
    super.key,
    required this.taskId,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitComment(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      context.read<CommentBloc>().add(
            AddComment(
              taskId: widget.taskId,
              content: _controller.text,
            ),
          );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 8.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submitComment(context),
                keyboardType: TextInputType.text,
                enableInteractiveSelection: true,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _submitComment(context),
            ),
          ],
        ),
      ),
    );
  }
}
