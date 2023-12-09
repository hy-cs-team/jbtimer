import 'package:flutter/material.dart';
import 'package:jbtimer/components/jb_button.dart';
import 'package:jbtimer/components/statistics.dart';
import 'package:jbtimer/edit_session/edit_session_page.dart';
import 'package:jbtimer/history/history_list.dart';
import 'package:jbtimer/main/session_controller.dart';

enum _SessionActionItem {
  view,
  saveAsText,
  saveAsImage,
  edit,
  delete,
}

class HistoryPage extends StatefulWidget {
  final SessionController sessionController;

  const HistoryPage({
    super.key,
    required this.sessionController,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: widget.sessionController,
          builder: (context, session, child) => Text(session.name),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<_SessionActionItem>(
            onSelected: (_SessionActionItem item) =>
                _onPopupMenuSelected(context, item),
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<_SessionActionItem>>[
              PopupMenuItem<_SessionActionItem>(
                value: _SessionActionItem.view,
                child: Text(
                    'View ${_pageController.page == 0 ? 'graph' : 'records'}'),
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
            sessionController: widget.sessionController,
            showTotalCount: false,
          ),
          const Divider(
            thickness: 1.0,
            height: 1.0,
            indent: 12.0,
            endIndent: 12.0,
            color: Color(0xff808080),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HistoryList(sessionController: widget.sessionController),
                const Center(child: Text('Graph')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onPopupMenuSelected(BuildContext context, _SessionActionItem item) {
    switch (item) {
      case _SessionActionItem.view:
        if (_pageController.page == 0) {
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCirc,
          );
        } else if (_pageController.page == 1) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCirc,
          );
        }
        break;
      case _SessionActionItem.saveAsText:
      case _SessionActionItem.saveAsImage:
        break;
      case _SessionActionItem.edit:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EditSessionPage(
              sessionController: widget.sessionController,
            ),
          ),
        );
        break;
      case _SessionActionItem.delete:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete this session?'),
            content: Text(widget.sessionController.value.name),
            actions: [
              JBButton(
                onPressed: () async {
                  await widget.sessionController.deleteSession();

                  if (!context.mounted) return;
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        );
        break;
    }
  }
}
