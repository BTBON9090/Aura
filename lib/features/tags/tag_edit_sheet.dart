import 'package:flutter/material.dart';
import '../../data/isar_service.dart';
import '../../data/models/tag_model.dart';
import '../../data/models/tag_group_model.dart';

class TagEditSheet extends StatefulWidget {
  final TagModel? tag;
  final int? preselectedGroupId;

  const TagEditSheet({super.key, this.tag, this.preselectedGroupId});

  static Future<void> show(
    BuildContext context,
    TagModel? tag, {
    int? preselectedGroupId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          TagEditSheet(tag: tag, preselectedGroupId: preselectedGroupId),
    );
  }

  @override
  State<TagEditSheet> createState() => _TagEditSheetState();
}

class _TagEditSheetState extends State<TagEditSheet> {
  late TextEditingController _nameController;
  List<TagGroupModel> _groups = [];
  int? _selectedGroupId;
  bool _isFrequentlyUsed = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tag?.name ?? '');
    _selectedGroupId = widget.tag?.groupId ?? widget.preselectedGroupId;
    _isFrequentlyUsed = widget.tag?.isFrequentlyUsed ?? false;
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final groups = await IsarService.getAllTagGroups();
    if (mounted) {
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    }
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
              widget.tag == null ? '新建标签' : '编辑标签',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '标签名称',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              DropdownButtonFormField<int?>(
                value: _selectedGroupId,
                decoration: const InputDecoration(
                  labelText: '分组（可选）',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('无分组')),
                  ..._groups.map(
                    (group) => DropdownMenuItem<int?>(
                      value: group.id,
                      child: Text(group.name),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedGroupId = value);
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('设为常用标签'),
                subtitle: const Text('常用标签会优先显示'),
                value: _isFrequentlyUsed,
                onChanged: (value) {
                  setState(() => _isFrequentlyUsed = value);
                },
              ),
            ],
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('标签名称不能为空')));
      return;
    }

    if (widget.tag == null) {
      await IsarService.createTag(
        name,
        groupId: _selectedGroupId,
        isFrequentlyUsed: _isFrequentlyUsed,
      );
    } else {
      await IsarService.updateTag(
        widget.tag!.id,
        name: name,
        groupId: _selectedGroupId,
        isFrequentlyUsed: _isFrequentlyUsed,
        clearGroup: _selectedGroupId == null && widget.tag!.groupId != null,
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
