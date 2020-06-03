import 'package:flutter/material.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/page/graph/graph_conversation_page.dart';
import 'package:focus/page/graph/add_comment_helper.dart';

class AddCommentWidget extends StatefulWidget {
  AddCommentWidget(this.commentTile, this.model);

  final GraphViewModel model;
  final CommentTile commentTile;

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddCommentWidget> with WidgetsBindingObserver {
  final TextEditingController controller = TextEditingController();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Util(StackTrace.current).out('Comment Widget widget.commentTile=' +
        (widget.commentTile != null ? 'ok' : 'null'));

    controller.text =
    widget.commentTile != null ? widget.commentTile.comment : null;

    FocusNode _focus = new FocusNode();
    void _onFocusChange() {
      if (widget.model.store.state.isCommentFieldActive) return;
      widget.model.store.state.setCommentFieldActive();
      widget.model.store.dispatch(ToggleAddGraphButtonAction());
    }

    _focus.addListener(_onFocusChange);

    @override
    void dispose(){
      _focus.removeListener(_onFocusChange);
      super.dispose();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 10, 0, 0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 6,
            child: EnsureVisibleWhenFocused(
              focusNode: _focus,
              child: TextField(
                autofocus: widget.model.store.state.isCommentFieldActive,
                key: const PageStorageKey('commentField'),
                keyboardType: TextInputType.multiline,
                onEditingComplete: () {
//                print('***** onEditingComplete');
                },
                maxLines: 4,
                focusNode: _focus,
                textInputAction: TextInputAction.newline,
                controller: controller,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  focusColor: Colors.white,
                  hintText: widget.model.label('AddComment'),
                  border: OutlineInputBorder(),
                  suffixIcon: widget.commentTile == null
                      ? null
                      : IconButton(
                    onPressed: () => widget.commentTile.editCancel(),
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Visibility(
              visible: widget.model.store.state.isCommentFieldActive,
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    onPressed: () {
                      widget.model.store.state.clearCommentFieldActive();
                      widget.model.onAddComment(
                          widget.commentTile == null
                              ? null
                              : widget.commentTile.id,
                          controller.text);
                      controller.clear();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    onPressed: () {
                      widget.model.store.state.clearCommentFieldActive();
                      controller.clear();
                      FocusScope.of(context).unfocus();
                      widget.model.store.dispatch(ToggleAddGraphButtonAction());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
