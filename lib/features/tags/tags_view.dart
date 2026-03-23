import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/isar_service.dart';
import '../../data/models/tag_model.dart';
import '../../data/models/tag_group_model.dart';
import '../photos/photo_gallery_view.dart';
import 'tag_edit_sheet.dart';
import 'tag_group_edit_sheet.dart';

class AllTagsPage extends StatefulWidget {
  const AllTagsPage({super.key});

  @override
  State<AllTagsPage> createState() => _AllTagsPageState();
}

class _AllTagsPageState extends State<AllTagsPage> {
  List<TagModel> _tags = [];
  Map<int, int> _tagCounts = {};
  bool _sortByName = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    setState(() => _isLoading = true);

    final tags = _sortByName
        ? await IsarService.getTagsSortedByName()
        : await IsarService.getAllTags();

    Map<int, int> counts = {};
    for (var tag in tags) {
      counts[tag.id] = await IsarService.getPhotoCountWithTag(tag.name);
    }

    if (mounted) {
      setState(() {
        _tags = tags;
        _tagCounts = counts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('标签管理'),
        actions: [
          IconButton(
            icon: Icon(_sortByName ? LucideIcons.clock : LucideIcons.arrowUpAZ),
            onPressed: () {
              setState(() => _sortByName = !_sortByName);
              _loadTags();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tags.isEmpty
              ? const Center(child: Text('暂无标签'))
              : ListView.builder(
                  itemCount: _tags.length,
                  itemBuilder: (context, index) {
                    final tag = _tags[index];
                    final count = _tagCounts[tag.id] ?? 0;
                    return _TagListTile(
                      tag: tag,
                      count: count,
                      onTap: () => _showTagActions(context, tag),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TagEditSheet.show(context, null),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  void _showTagActions(BuildContext context, TagModel tag) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.eye),
              title: const Text('查看'),
              onTap: () {
                Navigator.pop(context);
                _viewTaggedPhotos(tag);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.pencil),
              title: const Text('编辑'),
              onTap: () {
                Navigator.pop(context);
                TagEditSheet.show(context, tag);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2),
              title: const Text('删除'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(tag);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewTaggedPhotos(TagModel tag) async {
    final photos = await IsarService.getPhotosWithTag(tag.name);
    if (mounted && photos.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoGalleryView(photos: photos, title: tag.name),
        ),
      );
    }
  }

  void _confirmDelete(TagModel tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除标签'),
        content: Text('确定删除标签 "${tag.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await IsarService.deleteTag(tag.id);
      _loadTags();
    }
  }
}

class UngroupedTagsPage extends StatefulWidget {
  const UngroupedTagsPage({super.key});

  @override
  State<UngroupedTagsPage> createState() => _UngroupedTagsPageState();
}

class _UngroupedTagsPageState extends State<UngroupedTagsPage> {
  List<TagModel> _tags = [];
  Map<int, int> _tagCounts = {};
  bool _sortByName = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    setState(() => _isLoading = true);

    List<TagModel> tags;
    if (_sortByName) {
      final allTags = await IsarService.getTagsSortedByName();
      tags = allTags.where((t) => t.groupId == null).toList();
    } else {
      tags = await IsarService.getUngroupedTags();
    }

    Map<int, int> counts = {};
    for (var tag in tags) {
      counts[tag.id] = await IsarService.getPhotoCountWithTag(tag.name);
    }

    if (mounted) {
      setState(() {
        _tags = tags;
        _tagCounts = counts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('未分类标签'),
        actions: [
          IconButton(
            icon: Icon(_sortByName ? LucideIcons.clock : LucideIcons.arrowUpAZ),
            onPressed: () {
              setState(() => _sortByName = !_sortByName);
              _loadTags();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tags.isEmpty
              ? const Center(child: Text('暂无未分类标签'))
              : ListView.builder(
                  itemCount: _tags.length,
                  itemBuilder: (context, index) {
                    final tag = _tags[index];
                    final count = _tagCounts[tag.id] ?? 0;
                    return _TagListTile(
                      tag: tag,
                      count: count,
                      onTap: () => _showTagActions(context, tag),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TagEditSheet.show(context, null),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  void _showTagActions(BuildContext context, TagModel tag) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.eye),
              title: const Text('查看'),
              onTap: () {
                Navigator.pop(context);
                _viewTaggedPhotos(tag);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.pencil),
              title: const Text('编辑'),
              onTap: () {
                Navigator.pop(context);
                TagEditSheet.show(context, tag);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2),
              title: const Text('删除'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(tag);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewTaggedPhotos(TagModel tag) async {
    final photos = await IsarService.getPhotosWithTag(tag.name);
    if (mounted && photos.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoGalleryView(photos: photos, title: tag.name),
        ),
      );
    }
  }

  void _confirmDelete(TagModel tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除标签'),
        content: Text('确定删除标签 "${tag.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await IsarService.deleteTag(tag.id);
      _loadTags();
    }
  }
}

class FrequentTagsPage extends StatefulWidget {
  const FrequentTagsPage({super.key});

  @override
  State<FrequentTagsPage> createState() => _FrequentTagsPageState();
}

class _FrequentTagsPageState extends State<FrequentTagsPage> {
  List<TagModel> _tags = [];
  Map<int, int> _tagCounts = {};
  bool _sortByName = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    setState(() => _isLoading = true);

    List<TagModel> tags;
    if (_sortByName) {
      final allTags = await IsarService.getFrequentlyUsedTags();
      tags = allTags..sort((a, b) => a.name.compareTo(b.name));
    } else {
      tags = await IsarService.getFrequentlyUsedTags();
    }

    Map<int, int> counts = {};
    for (var tag in tags) {
      counts[tag.id] = await IsarService.getPhotoCountWithTag(tag.name);
    }

    if (mounted) {
      setState(() {
        _tags = tags;
        _tagCounts = counts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('常用标签'),
        actions: [
          IconButton(
            icon: Icon(_sortByName ? LucideIcons.clock : LucideIcons.arrowUpAZ),
            onPressed: () {
              setState(() => _sortByName = !_sortByName);
              _loadTags();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tags.isEmpty
              ? const Center(child: Text('暂无常用标签'))
              : ListView.builder(
                  itemCount: _tags.length,
                  itemBuilder: (context, index) {
                    final tag = _tags[index];
                    final count = _tagCounts[tag.id] ?? 0;
                    return _TagListTile(
                      tag: tag,
                      count: count,
                      onTap: () => _showTagActions(context, tag),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TagEditSheet.show(context, null),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  void _showTagActions(BuildContext context, TagModel tag) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.eye),
              title: const Text('查看'),
              onTap: () {
                Navigator.pop(context);
                _viewTaggedPhotos(tag);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.pencil),
              title: const Text('编辑'),
              onTap: () {
                Navigator.pop(context);
                TagEditSheet.show(context, tag);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2),
              title: const Text('删除'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(tag);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewTaggedPhotos(TagModel tag) async {
    final photos = await IsarService.getPhotosWithTag(tag.name);
    if (mounted && photos.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoGalleryView(photos: photos, title: tag.name),
        ),
      );
    }
  }

  void _confirmDelete(TagModel tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除标签'),
        content: Text('确定删除标签 "${tag.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await IsarService.deleteTag(tag.id);
      _loadTags();
    }
  }
}

class TagGroupsPage extends StatefulWidget {
  const TagGroupsPage({super.key});

  @override
  State<TagGroupsPage> createState() => _TagGroupsPageState();
}

class _TagGroupsPageState extends State<TagGroupsPage> {
  List<TagGroupModel> _groups = [];
  Map<int, int> _groupCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() => _isLoading = true);

    final groups = await IsarService.getAllTagGroups();
    Map<int, int> counts = {};
    for (var group in groups) {
      counts[group.id] = await IsarService.getTagCountInGroup(group.id);
    }

    if (mounted) {
      setState(() {
        _groups = groups;
        _groupCounts = counts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('标签分组'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isEmpty
              ? const Center(child: Text('暂无标签分组'))
              : ListView.builder(
                  itemCount: _groups.length,
                  itemBuilder: (context, index) {
                    final group = _groups[index];
                    final count = _groupCounts[group.id] ?? 0;
                    return ListTile(
                      leading: const Icon(LucideIcons.folder),
                      title: Text(group.name),
                      subtitle: Text('$count 个标签'),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('编辑'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('删除'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            TagGroupEditSheet.show(context, group);
                          } else if (value == 'delete') {
                            _confirmDelete(group);
                          }
                        },
                      ),
                      onTap: () => _openGroupDetail(group),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TagGroupEditSheet.show(context, null),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  void _openGroupDetail(TagGroupModel group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _TagGroupDetailView(group: group),
      ),
    );
  }

  void _confirmDelete(TagGroupModel group) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除分组'),
        content: Text('确定删除分组 "${group.name}" 吗？标签将移至未分类。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await IsarService.deleteTagGroup(group.id);
      _loadGroups();
    }
  }
}

class _TagGroupDetailView extends StatefulWidget {
  final TagGroupModel group;

  const _TagGroupDetailView({required this.group});

  @override
  State<_TagGroupDetailView> createState() => _TagGroupDetailViewState();
}

class _TagGroupDetailViewState extends State<_TagGroupDetailView> {
  List<TagModel> _tags = [];
  Map<int, int> _tagCounts = {};
  bool _sortByName = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    setState(() => _isLoading = true);

    var tags = await IsarService.getTagsInGroup(widget.group.id);

    if (_sortByName) {
      tags.sort((a, b) => a.name.compareTo(b.name));
    }

    Map<int, int> counts = {};
    for (var tag in tags) {
      counts[tag.id] = await IsarService.getPhotoCountWithTag(tag.name);
    }

    if (mounted) {
      setState(() {
        _tags = tags;
        _tagCounts = counts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          IconButton(
            icon: Icon(_sortByName ? LucideIcons.clock : LucideIcons.arrowUpAZ),
            onPressed: () {
              setState(() => _sortByName = !_sortByName);
              _loadTags();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tags.isEmpty
              ? const Center(child: Text('暂无标签'))
              : ListView.builder(
                  itemCount: _tags.length,
                  itemBuilder: (context, index) {
                    final tag = _tags[index];
                    final count = _tagCounts[tag.id] ?? 0;
                    return _TagListTile(
                      tag: tag,
                      count: count,
                      onTap: () => _showTagActions(context, tag),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TagEditSheet.show(context, null, preselectedGroupId: widget.group.id),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  void _showTagActions(BuildContext context, TagModel tag) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.eye),
              title: const Text('查看'),
              onTap: () {
                Navigator.pop(context);
                _viewTaggedPhotos(tag);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.pencil),
              title: const Text('编辑'),
              onTap: () {
                Navigator.pop(context);
                TagEditSheet.show(context, tag);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2),
              title: const Text('删除'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(tag);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewTaggedPhotos(TagModel tag) async {
    final photos = await IsarService.getPhotosWithTag(tag.name);
    if (mounted && photos.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoGalleryView(photos: photos, title: tag.name),
        ),
      );
    }
  }

  void _confirmDelete(TagModel tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除标签'),
        content: Text('确定删除标签 "${tag.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await IsarService.deleteTag(tag.id);
      _loadTags();
    }
  }
}

class _TagListTile extends StatelessWidget {
  final TagModel tag;
  final int count;
  final VoidCallback onTap;

  const _TagListTile({
    required this.tag,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.pink.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          LucideIcons.tag,
          color: Colors.pink,
          size: 20,
        ),
      ),
      title: Text(tag.name),
      subtitle: Text('$count 张照片'),
      trailing: const Icon(LucideIcons.chevronRight),
      onTap: onTap,
    );
  }
}