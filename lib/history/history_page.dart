import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics.dart';
import 'package:jbtimer/edit_session/edit_session_page.dart';
import 'package:jbtimer/history/history_list.dart';
import 'package:jbtimer/main/session_controller.dart';

enum _SessionActionItem {
  graph,
  saveAsText,
  saveAsImage,
  edit,
  delete,
}

class HistoryPage extends StatelessWidget {
  final SessionController sessionController;

  const HistoryPage({
    super.key,
    required this.sessionController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: sessionController,
          builder: (context, session, child) => Text(session.name),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<_SessionActionItem>(
            onSelected: (_SessionActionItem item) {
              switch (item) {
                case _SessionActionItem.graph:
                case _SessionActionItem.saveAsText:
                case _SessionActionItem.saveAsImage:
                  break;
                case _SessionActionItem.edit:
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => EditSessionPage(
                        sessionController: sessionController,
                      ),
                    ),
                  );
                  break;
                case _SessionActionItem.delete:
                  break;
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<_SessionActionItem>>[
              const PopupMenuItem<_SessionActionItem>(
                value: _SessionActionItem.graph,
                child: Text('See graph'),
              ),
              const PopupMenuItem<_SessionActionItem>(
                value: _SessionActionItem.saveAsText,
                child: Text('Save as text'),
              ),
              const PopupMenuItem<_SessionActionItem>(
                value: _SessionActionItem.saveAsImage,
                child: Text('Save as image'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<_SessionActionItem>(
                value: _SessionActionItem.edit,
                child: Text('Edit session'),
              ),
              const PopupMenuItem<_SessionActionItem>(
                value: _SessionActionItem.delete,
                child: Text('Delete session'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Statistics(
            sessionController: sessionController,
            showTotalCount: false,
          ),
          const Divider(
            thickness: 1.0,
            height: 1.0,
            indent: 12.0,
            endIndent: 12.0,
            color: Color(0xff808080),
          ),
          Expanded(child: HistoryList(sessionController: sessionController)),
        ],
      ),
    );
  }
}
