import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/bud/bud_category_bloc.dart';
import '../../blocs/bud/bud_category_event.dart';
import '../../blocs/bud/bud_category_state.dart';
import '../widgets/loading_indicator.dart';
import 'buds_page.dart';

class BudsCategoryPage extends StatefulWidget {
  const BudsCategoryPage({super.key});

  @override
  State<BudsCategoryPage> createState() => _BudsCategoryPageState();
}

class _BudsCategoryPageState extends State<BudsCategoryPage> {
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    context.read<BudCategoryBloc>().add(BudCategoriesRequested());
  }

  void _onCategorySelected(String category, int index) {
    context.read<BudCategoryBloc>().add(
          BudCategorySelected(
            category: category,
            index: index,
          ),
        );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudsPage(initialCategoryIndex: index),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildCategoryTile(String category, int index) {
    return ListTile(
      title: Text(_getCategoryTitle(category)),
      onTap: () => _onCategorySelected(category, index),
    );
  }

  String _getCategoryTitle(String category) {
    return category
        .split('/')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bud Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<BudCategoryBloc>()
                  .add(BudCategoriesRefreshRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<BudCategoryBloc, BudCategoryState>(
        listener: (context, state) {
          if (state is BudCategoryFailure) {
            _showErrorSnackBar(state.error);
          }
        },
        builder: (context, state) {
          if (state is BudCategoryInitial) {
            _loadCategories();
            return const LoadingIndicator();
          }

          if (state is BudCategoryLoading) {
            return const LoadingIndicator();
          }

          if (state is BudCategoryLoaded) {
            if (state.categories.isEmpty) {
              return const Center(
                child: Text(
                    'No categories available. Connect some services first.'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<BudCategoryBloc>()
                    .add(BudCategoriesRefreshRequested());
              },
              child: ListView.builder(
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryTile(state.categories[index], index);
                },
              ),
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}
