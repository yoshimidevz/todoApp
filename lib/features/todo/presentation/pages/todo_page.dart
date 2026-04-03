import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/messages/app_messages.dart';
import '../cubit/todo_cubit.dart';
import '../widgets/todo_form.dart';
import '../widgets/todo_list.dart';
import '../widgets/todo_search.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TodoView();
  }
}

class _TodoView extends StatefulWidget {
  const _TodoView();

  @override
  State<_TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<_TodoView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _searchVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchVisible
            ? TodoSearch()          
            : const Text(AppMessages.pageTitle),
        actions: [
          IconButton(
            icon: Icon(_searchVisible ? Icons.close : Icons.search),
            onPressed: () {
              setState(() => _searchVisible = !_searchVisible);
              if (!_searchVisible) {
                context.read<TodoCubit>().search('');
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Importantes'),
            Tab(text: 'Para hoje'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TodoForm(),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  TodoList(filterToday: false, filterImportant: false),
                  TodoList(filterToday: false, filterImportant: true),
                  TodoList(filterToday: true, filterImportant: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}