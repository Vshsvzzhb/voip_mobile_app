import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_avatar.dart';
import '../../widgets/veten_button.dart';

class SelectMembersScreen extends StatefulWidget {
  const SelectMembersScreen({super.key});

  @override
  State<SelectMembersScreen> createState() => _SelectMembersScreenState();
}

class _SelectMembersScreenState extends State<SelectMembersScreen> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pilih Anggota'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          if (_selected.isNotEmpty) ...[
            SizedBox(
              height: 72,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                children: DummyData.contacts
                    .where((c) => _selected.contains(c.id))
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  VetenAvatar(
                                      name: c.name,
                                      imageUrl: c.avatarUrl,
                                      size: 44),
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: GestureDetector(
                                      onTap: () => setState(
                                          () => _selected.remove(c.id)),
                                      child: Container(
                                        padding: const EdgeInsets.all(1),
                                        decoration: const BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                            Icons.close_rounded,
                                            size: 12,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            const Divider(height: 0),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: DummyData.contacts.length,
              itemBuilder: (context, i) {
                final c = DummyData.contacts[i];
                final isSelected = _selected.contains(c.id);
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (v) => setState(() {
                    if (v == true) {
                      _selected.add(c.id);
                    } else {
                      _selected.remove(c.id);
                    }
                  }),
                  secondary: VetenAvatar(
                      name: c.name, imageUrl: c.avatarUrl, size: 48),
                  title: Text(c.name),
                  subtitle: Text(c.bio, maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  activeColor: AppColors.primary,
                  checkboxShape: const CircleBorder(),
                );
              },
            ),
          ),
          if (_selected.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: VetenButton(
                label: 'Lanjut (${_selected.length} anggota)',
                onPressed: () => context.push('/group-info'),
              ),
            ),
        ],
      ),
    );
  }
}
