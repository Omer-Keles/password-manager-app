import 'dart:math';

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../models/password_entry.dart';

class AddPasswordSheet extends StatefulWidget {
  const AddPasswordSheet({super.key, this.initialEntry});

  final PasswordEntry? initialEntry;

  @override
  State<AddPasswordSheet> createState() => _AddPasswordSheetState();
}

class _AddPasswordSheetState extends State<AddPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;
  String _selectedCategory = 'Genel';

  final _categories = const [
    'Genel',
    'Sosyal Medya',
    'Banka / Finans',
    'E-Ticaret',
    'İş / Kurumsal',
    'E-Posta',
    'Oyun',
    'Kart / Kimlik',
    'Diğer',
  ];

  bool get _isEditing => widget.initialEntry != null;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: widget.initialEntry?.label ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.initialEntry?.username ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.initialEntry?.password ?? '',
    );
    _selectedCategory = widget.initialEntry?.category ?? 'Genel';
  }

  @override
  void dispose() {
    _labelController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _generateStrongPassword() {
    const length = 16;
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
    final random = Random.secure();
    final password = List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();

    setState(() {
      _passwordController.text = password;
      // Şifre oluşturulduğunda kullanıcı görsün diye görünür yapıyoruz
      _obscurePassword = false;
    });

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.strongPasswordGenerated),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final entry =
        (widget.initialEntry ??
                PasswordEntry(
                  label: _labelController.text.trim(),
                  username: _usernameController.text.trim(),
                  password: _passwordController.text.trim(),
                  createdAt: DateTime.now(),
                  category: _selectedCategory,
                ))
            .copyWith(
              label: _labelController.text.trim(),
              username: _usernameController.text.trim(),
              password: _passwordController.text.trim(),
              category: _selectedCategory,
            );
    Navigator.of(context).pop(entry);
  }

  String _getCategoryDisplay(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'Genel':
        return l10n.categoryGeneral;
      case 'Sosyal Medya':
        return l10n.categorySocial;
      case 'Banka / Finans':
        return l10n.categoryBanking;
      case 'E-Ticaret':
        return l10n.categoryEcommerce;
      case 'İş / Kurumsal':
        return l10n.categoryWork;
      case 'E-Posta':
        return l10n.categoryEmail;
      case 'Oyun':
        return l10n.categoryGaming;
      case 'Kart / Kimlik':
        return l10n.categoryCard;
      case 'Diğer':
        return l10n.categoryOther;
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final padding = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.only(bottom: padding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 48,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text(
                  _isEditing ? l10n.updateRecord : l10n.newRecord,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: _categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(_getCategoryDisplay(context, cat)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _labelController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.title,
                    hintText: l10n.titleHint,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.validationTitleRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.usernameOptional,
                    helperText: l10n.usernameHelper,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: l10n.passwordPin,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: l10n.generateStrongPassword,
                          onPressed: _generateStrongPassword,
                          icon: const Icon(Icons.casino),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ],
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.validationPasswordRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_isEditing ? l10n.update : l10n.save),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
