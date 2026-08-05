import 'package:flutter/material.dart';
import 'package:marbella/generated/l10n.dart';

class SearchTextFieldWidget extends StatefulWidget {
  const SearchTextFieldWidget({
    super.key,
    required this.searchController,
    required this.onSubmitted,
    this.onChanged,
  });

  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final TextEditingController searchController;

  @override
  State<SearchTextFieldWidget> createState() => _SearchTextFieldWidgetState();
}

class _SearchTextFieldWidgetState extends State<SearchTextFieldWidget> {
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchTextChange);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchTextChange);
    super.dispose();
  }

  void _onSearchTextChange() {
    widget.onChanged?.call(widget.searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.searchController,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: S.of(context).search,
        hintStyle: TextStyle(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
        ),
        prefixIcon: IconButton(
          onPressed: () =>
              widget.onSubmitted?.call(widget.searchController.text),
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
