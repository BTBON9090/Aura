import 'package:flutter/material.dart';
import '../../data/isar_service.dart';
import '../../data/models/tag_group_model.dart';

class TagGroupEditSheet extends StatefulWidget {
  final TagGroupModel? group;

  const TagGroupEditSheet({
    super.key,
    this.group,
  });

  static Future<void> show(BuildContext context, TagGroupModel? group) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagGroupEditSheet(group: group),
    );
  }

  @override
  State<TagGroupEditSheet> createState() => _TagGroupEditSheetState();
}

class _TagGroupEditSheetState extends State<TagGroupEditSheet> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.group == null ? '新建分组' : '编辑分组',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '分组名称',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('保存'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('分组名称不能为空')),
      );
      return;
    }

    if (widget.group == null) {
      await IsarService.createTagGroup(name);
    } else {
      await IsarService.db.writeTxn(() async {
        final group = await IsarService.db.tagGroupModels.get(widget.group!.id);
        if (group != null) {
          group.name = name;
          await IsarService.db.tagGroupModels.put(group);
        }
      });
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}