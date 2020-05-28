import 'package:flutter/material.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/page/graph/graph_page.dart';

class AddCommentWidget extends StatefulWidget {
  AddCommentWidget(this.commentTile, this.model);

  final GraphViewModel model;
  final CommentTile commentTile;

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddCommentWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Util(StackTrace.current).out('Comment Widget widget.commentTile=' +
        (widget.commentTile != null ? 'ok' : 'null'));

    controller.text =
    widget.commentTile != null ? widget.commentTile.comment : null;

    FocusNode _focus = new FocusNode();
    void _onFocusChange() {
      if (widget.model.store.state.isCommentFieldActive) return;
      debugPrint('*****Focus: ' + _focus.hasFocus.toString());
      widget.model.store.state.setCommentFieldActive();
      widget.model.store.dispatch(ToggleAddGraphButtonAction());
    }

    _focus.addListener(_onFocusChange);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 10, 0, 0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 6,
            child: TextField(
              autofocus: widget.model.store.state.isCommentFieldActive,
              key: PageStorageKey('commentField'),
              keyboardType: TextInputType.multiline,
              onEditingComplete: () {
//                print('***** onEditingComplete');
              },
              focusNode: _focus,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              controller: controller,
              decoration: InputDecoration(
                focusColor: Colors.white,
                hintText: widget.model.label('AddComment'),
                border: OutlineInputBorder(),
                suffixIcon: widget.commentTile == null
                    ? null
                    : IconButton(
                  onPressed: () => widget.commentTile.editCancel(),
                  icon: Icon(Icons.clear),
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
                    icon: Icon(Icons.add),
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
                    icon: Icon(Icons.cancel),
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
