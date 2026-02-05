import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

void main() {
  group('ThemeDataDesignSystemExtension', () {
    testWidgets('provides correct design system values from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DesignSystem.darkTheme,
          home: const TestWidget(),
        ),
      );

      // Find the TestWidget
      final textWidget = tester.widget<Text>(find.byType(Text));
      final containerWidget = tester.widget<Container>(find.byType(Container));

      // Verify that the widget uses the correct color from the theme extension
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, DesignSystem.primary);

      // Verify that the widget uses the correct text style from the theme extension
      expect(textWidget.style?.fontSize, DesignSystem.headlineSmall.fontSize);
      expect(textWidget.style?.color, DesignSystem.onPrimary);
    });
  });
}

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the design system via theme extensions
    final ds = Theme.of(context).extension<DesignSystemThemeExtension>();

    return Container(
      color: ds?.designSystemColors.primary ?? Colors.black,
      child: Text(
        'Test Text',
        style: ds?.designSystemTypography.headlineSmall.copyWith(
          color: ds.designSystemColors.onPrimary,
        ),
      ),
    );
  }
}
