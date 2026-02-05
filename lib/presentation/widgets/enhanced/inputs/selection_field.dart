import 'package:flutter/material.dart';

/// Selection field components for user choices
/// 
/// This file provides reusable selection widgets:
/// - SelectionField: Generic dropdown/picker field
/// - GenderSelector: Gender selection field
/// - CountrySelector: Country selection field
/// - LanguageSelector: Language selection field
/// - OptionSelector: Generic option selector

/// Generic selection field with dropdown
/// 
/// Perfect for any list-based selection.
/// 
/// Example:
/// ```dart
/// SelectionField<String>(
///   label: 'Select Genre',
///   options: ['Pop', 'Rock', 'Jazz', 'Classical'],
///   selectedOption: _genre,
///   onOptionSelected: (genre) => setState(() => _genre = genre),
/// )
/// ```
class SelectionField<T> extends StatelessWidget {
  /// Field label
  final String label;
  
  /// Available options
  final List<T> options;
  
  /// Currently selected option
  final T? selectedOption;
  
  /// Callback when option is selected
  final ValueChanged<T> onOptionSelected;
  
  /// Function to convert option to display string
  final String Function(T) optionToString;
  
  /// Field decoration
  final InputDecoration? decoration;
  
  /// Icon to display
  final IconData icon;
  
  /// Whether field is enabled
  final bool enabled;

  const SelectionField({
    super.key,
    required this.label,
    required this.options,
    this.selectedOption,
    required this.onOptionSelected,
    String Function(T)? optionToString,
    this.decoration,
    this.icon = Icons.arrow_drop_down,
    this.enabled = true,
  }) : optionToString = optionToString ?? _defaultToString;

  static String _defaultToString(dynamic value) => value.toString();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: selectedOption,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: Icon(icon),
          ),
      items: options.map((option) {
        return DropdownMenuItem<T>(
          value: option,
          child: Text(optionToString(option)),
        );
      }).toList(),
      onChanged: enabled ? (T? value) {
        if (value != null) onOptionSelected(value);
      } : null,
    );
  }
}

/// Gender selection field
/// 
/// Perfect for user profiles, registration forms.
/// 
/// Example:
/// ```dart
/// GenderSelector(
///   selectedGender: _gender,
///   onGenderSelected: (gender) => setState(() => _gender = gender),
/// )
/// ```
class GenderSelector extends StatelessWidget {
  /// Currently selected gender
  final String? selectedGender;
  
  /// Callback when gender is selected
  final ValueChanged<String> onGenderSelected;
  
  /// Available gender options
  final List<String> genderOptions;
  
  /// Field decoration
  final InputDecoration? decoration;
  
  /// Whether to show as buttons or dropdown
  final bool showAsButtons;

  const GenderSelector({
    super.key,
    this.selectedGender,
    required this.onGenderSelected,
    List<String>? genderOptions,
    this.decoration,
    this.showAsButtons = true,
  }) : genderOptions = genderOptions ??
            const ['Male', 'Female', 'Non-binary', 'Prefer not to say'];

  @override
  Widget build(BuildContext context) {
    if (showAsButtons) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: genderOptions.map((gender) {
              final isSelected = selectedGender == gender;
              return ChoiceChip(
                label: Text(gender),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onGenderSelected(gender);
                  }
                },
              );
            }).toList(),
          ),
        ],
      );
    }

    return SelectionField<String>(
      label: 'Gender',
      options: genderOptions,
      selectedOption: selectedGender,
      onOptionSelected: onGenderSelected,
      decoration: decoration,
      icon: Icons.person,
    );
  }
}

/// Country selection field
/// 
/// Perfect for user profiles, shipping addresses.
/// 
/// Example:
/// ```dart
/// CountrySelector(
///   selectedCountry: _country,
///   onCountrySelected: (country) => setState(() => _country = country),
/// )
/// ```
class CountrySelector extends StatelessWidget {
  /// Currently selected country
  final String? selectedCountry;
  
  /// Callback when country is selected
  final ValueChanged<String> onCountrySelected;
  
  /// List of countries (provide your own or use a package)
  final List<String> countries;
  
  /// Field decoration
  final InputDecoration? decoration;

  const CountrySelector({
    super.key,
    this.selectedCountry,
    required this.onCountrySelected,
    List<String>? countries,
    this.decoration,
  }) : countries = countries ?? _defaultCountries;

  static const List<String> _defaultCountries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Germany',
    'France',
    'Japan',
    'Australia',
    'Brazil',
    'Mexico',
    'India',
    'China',
    'South Korea',
    'Italy',
    'Spain',
    'Netherlands',
    // Add more as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SelectionField<String>(
      label: 'Country',
      options: countries,
      selectedOption: selectedCountry,
      onOptionSelected: onCountrySelected,
      decoration: decoration,
      icon: Icons.public,
    );
  }
}

/// Language selection field
/// 
/// Perfect for app settings, user preferences.
/// 
/// Example:
/// ```dart
/// LanguageSelector(
///   selectedLanguage: _language,
///   onLanguageSelected: (lang) => setState(() => _language = lang),
/// )
/// ```
class LanguageSelector extends StatelessWidget {
  /// Currently selected language
  final String? selectedLanguage;
  
  /// Callback when language is selected
  final ValueChanged<String> onLanguageSelected;
  
  /// Available languages
  final List<String> languages;
  
  /// Field decoration
  final InputDecoration? decoration;

  const LanguageSelector({
    super.key,
    this.selectedLanguage,
    required this.onLanguageSelected,
    List<String>? languages,
    this.decoration,
  }) : languages = languages ?? _defaultLanguages;

  static const List<String> _defaultLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
    'Russian',
    'Hindi',
  ];

  @override
  Widget build(BuildContext context) {
    return SelectionField<String>(
      label: 'Language',
      options: languages,
      selectedOption: selectedLanguage,
      onOptionSelected: onLanguageSelected,
      decoration: decoration,
      icon: Icons.language,
    );
  }
}

/// Generic option selector with radio buttons or chips
/// 
/// Perfect for any mutually exclusive options.
/// 
/// Example:
/// ```dart
/// OptionSelector(
///   label: 'Music Preference',
///   options: ['Live', 'Studio', 'Both'],
///   selectedOption: _preference,
///   onOptionSelected: (pref) => setState(() => _preference = pref),
///   displayStyle: OptionDisplayStyle.chips,
/// )
/// ```
class OptionSelector extends StatelessWidget {
  /// Section label
  final String label;
  
  /// Available options
  final List<String> options;
  
  /// Currently selected option
  final String? selectedOption;
  
  /// Callback when option is selected
  final ValueChanged<String> onOptionSelected;
  
  /// Display style for options
  final OptionDisplayStyle displayStyle;
  
  /// Whether to show in a card
  final bool showInCard;

  const OptionSelector({
    super.key,
    required this.label,
    required this.options,
    this.selectedOption,
    required this.onOptionSelected,
    this.displayStyle = OptionDisplayStyle.chips,
    this.showInCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        _buildOptions(context),
      ],
    );

    if (showInCard) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildOptions(BuildContext context) {
    switch (displayStyle) {
      case OptionDisplayStyle.chips:
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final isSelected = selectedOption == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onOptionSelected(option);
                }
              },
            );
          }).toList(),
        );

      case OptionDisplayStyle.radio:
        return Column(
          children: options.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              // groupValue: selectedOption, // Deprecated
              // onChanged: (value) { // Deprecated
              //   if (value != null) {
              //     onOptionSelected(value);
              //   }
              // },
              dense: true,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        );

      case OptionDisplayStyle.list:
        return Column(
          children: options.map((option) {
            final isSelected = selectedOption == option;
            return ListTile(
              title: Text(option),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              selected: isSelected,
              onTap: () => onOptionSelected(option),
              dense: true,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        );
    }
  }
}

/// Display style options for OptionSelector
enum OptionDisplayStyle {
  /// Display as choice chips
  chips,
  
  /// Display as radio buttons
  radio,
  
  /// Display as list tiles
  list,
}

/// Multi-select option selector
/// 
/// Perfect for selecting multiple options.
/// 
/// Example:
/// ```dart
/// MultiSelectOption(
///   label: 'Select Genres',
///   options: ['Pop', 'Rock', 'Jazz', 'Classical'],
///   selectedOptions: _genres,
///   onOptionsChanged: (genres) => setState(() => _genres = genres),
/// )
/// ```
class MultiSelectOption extends StatelessWidget {
  /// Section label
  final String label;
  
  /// Available options
  final List<String> options;
  
  /// Currently selected options
  final Set<String> selectedOptions;
  
  /// Callback when selection changes
  final ValueChanged<Set<String>> onOptionsChanged;
  
  /// Display style
  final OptionDisplayStyle displayStyle;
  
  /// Minimum selections required
  final int? minSelections;
  
  /// Maximum selections allowed
  final int? maxSelections;

  const MultiSelectOption({
    super.key,
    required this.label,
    required this.options,
    required this.selectedOptions,
    required this.onOptionsChanged,
    this.displayStyle = OptionDisplayStyle.chips,
    this.minSelections,
    this.maxSelections,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (minSelections != null || maxSelections != null)
              Text(
                _getSelectionHint(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        const SizedBox(height: 12),
        _buildOptions(context),
      ],
    );
  }

  String _getSelectionHint() {
    if (minSelections != null && maxSelections != null) {
      return 'Select $minSelections-$maxSelections (${selectedOptions.length} selected)';
    } else if (minSelections != null) {
      return 'Select at least $minSelections (${selectedOptions.length} selected)';
    } else if (maxSelections != null) {
      return 'Select up to $maxSelections (${selectedOptions.length} selected)';
    }
    return '${selectedOptions.length} selected';
  }

  Widget _buildOptions(BuildContext context) {
    switch (displayStyle) {
      case OptionDisplayStyle.chips:
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            final canSelect = maxSelections == null ||
                selectedOptions.length < maxSelections!;

            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected && !canSelect && !isSelected) {
                  // Can't select more
                  return;
                }
                _toggleSelection(option);
              },
            );
          }).toList(),
        );

      case OptionDisplayStyle.radio:
      case OptionDisplayStyle.list:
        return Column(
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            return CheckboxListTile(
              title: Text(option),
              value: isSelected,
              onChanged: (selected) {
                if (selected == true) {
                  if (maxSelections != null &&
                      selectedOptions.length >= maxSelections!) {
                    return;
                  }
                }
                _toggleSelection(option);
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        );
    }
  }

  void _toggleSelection(String option) {
    final newSelection = Set<String>.from(selectedOptions);
    if (newSelection.contains(option)) {
      if (minSelections == null || newSelection.length > minSelections!) {
        newSelection.remove(option);
      }
    } else {
      newSelection.add(option);
    }
    onOptionsChanged(newSelection);
  }
}
