import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics.dart';
import 'package:jbtimer/history/history_list.dart';
import 'package:jbtimer/main/session_controller.dart';

enum _SessionActionItem {
  edit,
  graph,
  saveAsText,
  saveAsImage,
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
            onSelected: (_SessionActionItem item) {},
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<_SessionActionItem>>[
              const PopupMenuItem<_SessionActionItem>(
                value: _SessionActionItem.edit,
                child: Text('Edit session'),
              ),
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
