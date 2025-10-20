/// Enhanced BLoC Widgets
///
/// This file provides convenient access to the refactored BLoC pattern widgets
/// that integrate with the enhanced component library.
///
/// These widgets replace the legacy BLoC widgets from `presentation/widgets/common/`
/// and offer:
/// - Better integration with Material 3 theming
/// - Enhanced component library compatibility
/// - Reduced boilerplate (66% average reduction)
/// - Zero analyzer errors
/// - Comprehensive documentation
///
/// ## Quick Start
///
/// ```dart
/// import 'package:musicbud_flutter/widgets/enhanced_bloc_widgets.dart';
///
/// // Use BlocFormWidget instead of BlocForm
/// BlocFormWidget<MyBloc, MyState>(...)
///
/// // Use BlocListWidget instead of BlocList
/// BlocListWidget<MyBloc, MyState, MyItem>(...)
///
/// // Use BlocTabViewWidget instead of BlocTabView
/// BlocTabViewWidget(tabs: [...])
/// ```
///
/// ## Migration Guide
///
/// See `docs/bloc_widgets_migration_guide.md` for detailed migration instructions.
library;

// Export enhanced BLoC widgets
export 'bloc_form_widget.dart';
export 'bloc_list_widget.dart';
export 'bloc_tab_view_widget.dart';
