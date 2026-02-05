import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Modern popup menu with icons
///
/// Example:
/// ```dart
/// ModernPopupMenu(
///   items: [
///     MenuItem(icon: Icons.edit, title: 'Edit', onTap: () {}),
///     MenuItem(icon: Icons.delete, title: 'Delete', onTap: () {}),
///   ],
/// )
/// ```
class ModernPopupMenu extends StatelessWidget {
  const ModernPopupMenu({
    super.key,
    required this.items,
    this.icon = Icons.more_vert,
    this.tooltip = 'More options',
  });

  final List<MenuItem> items;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(icon),
      tooltip: tooltip,
      onSelected: (index) {
        items[index].onTap?.call();
      },
      itemBuilder: (context) {
        return List.generate(items.length, (index) {
          final item = items[index];
          if (item.isDivider) {
            return const PopupMenuDivider() as PopupMenuEntry<int>;
          }
          return PopupMenuItem<int>(
            value: index,
            enabled: !item.isDisabled,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 20,
                    color: item.isDestructive ? Colors.red : null,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: item.isDestructive ? Colors.red : null,
                    ),
                  ),
                ),
                if (item.trailing != null) item.trailing!,
              ],
            ),
          );
        });
      },
    );
  }
}

/// Menu item data model
class MenuItem {
  const MenuItem({
    required this.title,
    this.icon,
    this.trailing,
    this.onTap,
    this.isDivider = false,
    this.isDisabled = false,
    this.isDestructive = false,
  });

  final String title;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDivider;
  final bool isDisabled;
  final bool isDestructive;

  static const MenuItem divider = MenuItem(title: '', isDivider: true);
}

/// Context menu for long press
class ContextMenu extends StatelessWidget {
  const ContextMenu({
    super.key,
    required this.child,
    required this.menuItems,
  });

  final Widget child;
  final List<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showContextMenu(context);
      },
      child: child,
    );
  }

  void _showContextMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<int>(
      context: context,
      position: position,
      items: List.generate(menuItems.length, (index) {
        final item = menuItems[index];
        if (item.isDivider) {
          return const PopupMenuDivider() as PopupMenuEntry<int>;
        }
        return PopupMenuItem<int>(
          value: index,
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(item.icon, size: 20),
                const SizedBox(width: 12),
              ],
              Text(item.title),
            ],
          ),
        );
      }),
    ).then((index) {
      if (index != null) {
        menuItems[index].onTap?.call();
      }
    });
  }
}

/// Dropdown menu button
class ModernDropdown<T> extends StatelessWidget {
  const ModernDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.isExpanded = true,
  });

  final T? value;
  final List<DropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingMD,
        vertical: DesignSystem.spacingXS,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: DesignSystem.border,
        ),
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
      child: DropdownButton<T>(
        value: value,
        hint: hint != null ? Text(hint!) : null,
        isExpanded: isExpanded,
        underline: const SizedBox.shrink(),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item.value,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(item.icon, size: 20),
                  const SizedBox(width: DesignSystem.spacingSM),
                ],
                Expanded(child: Text(item.label)),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

/// Dropdown item data model
class DropdownItem<T> {
  const DropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}

/// Bottom sheet menu
class BottomSheetMenu extends StatelessWidget {
  const BottomSheetMenu({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<MenuItem> items;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<MenuItem> items,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetMenu(
        title: title,
        items: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingLG),
            child: Text(
              title,
              style: (DesignSystem.titleMedium).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...items.map((item) {
            if (item.isDivider) {
              return const Divider(height: 1);
            }
            return ListTile(
              leading: item.icon != null ? Icon(item.icon) : null,
              title: Text(item.title),
              trailing: item.trailing,
              enabled: !item.isDisabled,
              onTap: () {
                Navigator.pop(context);
                item.onTap?.call();
              },
            );
          }),
          const SizedBox(height: DesignSystem.spacingMD),
        ],
      ),
    );
  }
}

/// Icon button with menu
class IconMenuButton extends StatelessWidget {
  const IconMenuButton({
    super.key,
    required this.icon,
    required this.items,
    this.tooltip,
  });

  final IconData icon;
  final List<MenuItem> items;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return ModernPopupMenu(
      icon: icon,
      items: items,
      tooltip: tooltip ?? 'Menu',
    );
  }
}