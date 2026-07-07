#!/usr/bin/env python3
# /// script
# dependencies = ["textual", "rich"]
# requires-python = ">=3.10"
# ///
"""
tmutil-diff-browser: An ncdu-like browser for Time Machine diff XML files.

Usage: tmutil-diff-browser.py <path-to-tmutil-diff.xml>

Navigation:
  ↑/↓        Navigate
  Enter      Expand/collapse
  q/Esc      Quit

Sorting:
  s          Cycle sort mode
  c          Sort by count
  z          Sort by size
  n          Sort by name
"""

import sys
import plistlib
from pathlib import Path
from dataclasses import dataclass, field
from typing import Optional
from collections import defaultdict
from enum import Enum

try:
    from textual.app import App, ComposeResult
    from textual.widgets import Header, Footer, Static, Tree
    from textual.widgets.tree import TreeNode
    from textual.reactive import reactive
    from rich.text import Text
except ImportError:
    print("Missing dependencies. Install with:")
    print("  pip install textual rich")
    sys.exit(1)


class SortMode(Enum):
    COUNT = "count"
    SIZE = "size"
    NAME = "name"


@dataclass
class DirStats:
    """Aggregated statistics for a directory."""
    added_count: int = 0
    added_size: int = 0
    removed_count: int = 0
    removed_size: int = 0
    modified_count: int = 0
    size_delta: int = 0  # positive = grew, negative = shrunk
    children: dict = field(default_factory=dict)
    files: list = field(default_factory=list)  # individual file changes


@dataclass
class FileChange:
    """A single file change entry."""
    path: str
    change_type: str  # 'added', 'removed', 'modified'
    size: int = 0
    old_size: int = 0
    new_size: int = 0
    differences: list = field(default_factory=list)


def parse_tmutil_xml(xml_path: str) -> list[FileChange]:
    """Parse tmutil diff XML and return list of file changes."""
    print(f"Loading {xml_path}... (this may take a moment for large files)")

    with open(xml_path, 'rb') as f:
        plist = plistlib.load(f)

    changes = []
    raw_changes = plist.get('Changes', [])
    total = len(raw_changes)

    for i, entry in enumerate(raw_changes):
        if i % 100000 == 0 and i > 0:
            print(f"  Processing {i:,}/{total:,} entries...")

        if 'AddedItem' in entry:
            item = entry['AddedItem']
            path = clean_path(item.get('Path', ''))
            changes.append(FileChange(
                path=path,
                change_type='added',
                size=item.get('Size', 0),
                new_size=item.get('Size', 0),
            ))
        elif 'RemovedItem' in entry:
            item = entry['RemovedItem']
            path = clean_path(item.get('Path', ''))
            changes.append(FileChange(
                path=path,
                change_type='removed',
                size=item.get('Size', 0),
                old_size=item.get('Size', 0),
            ))
        elif 'NewerItem' in entry and 'OlderItem' in entry:
            newer = entry['NewerItem']
            older = entry['OlderItem']
            path = clean_path(newer.get('Path', ''))
            new_size = newer.get('Size', 0)
            old_size = older.get('Size', 0)
            changes.append(FileChange(
                path=path,
                change_type='modified',
                size=abs(new_size - old_size),
                old_size=old_size,
                new_size=new_size,
                differences=entry.get('Differences', []),
            ))

    print(f"  Loaded {len(changes):,} changes")
    return changes


def clean_path(path: str) -> str:
    """Clean up Time Machine paths to show the actual filesystem path."""
    # Remove the TM backup prefix to show actual paths
    markers = ['.backup/Data/', '.backup/']
    for marker in markers:
        if marker in path:
            idx = path.rfind(marker)
            path = path[idx + len(marker):]
            break

    # Also handle /System/Volumes/Data prefix
    if path.startswith('/System/Volumes/Data/'):
        path = path[len('/System/Volumes/Data'):]

    return path or '/'


def build_tree(changes: list[FileChange]) -> DirStats:
    """Build a directory tree with aggregated statistics."""
    print("Building directory tree...")
    root = DirStats()

    for change in changes:
        path = change.path
        if not path.startswith('/'):
            path = '/' + path

        parts = [p for p in path.split('/') if p]

        # Navigate/create tree structure
        current = root
        for i, part in enumerate(parts[:-1]):  # All but the last part (directories)
            if part not in current.children:
                current.children[part] = DirStats()
            current = current.children[part]

        # Add file stats to current directory
        if parts:
            filename = parts[-1]
            current.files.append((filename, change))

        # Aggregate stats up the tree
        current = root
        for part in parts[:-1]:
            _add_stats(current, change)
            current = current.children[part]
        _add_stats(current, change)  # Also add to the final directory

    return root


def _add_stats(stats: DirStats, change: FileChange):
    """Add a file change's stats to a DirStats object."""
    if change.change_type == 'added':
        stats.added_count += 1
        stats.added_size += change.size
        stats.size_delta += change.size
    elif change.change_type == 'removed':
        stats.removed_count += 1
        stats.removed_size += change.size
        stats.size_delta -= change.size
    elif change.change_type == 'modified':
        stats.modified_count += 1
        stats.size_delta += (change.new_size - change.old_size)


def format_size(size: int) -> str:
    """Format size in human-readable format."""
    if size == 0:
        return "0 B"

    sign = '-' if size < 0 else ''
    size = abs(size)

    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if size < 1024:
            if unit == 'B':
                return f"{sign}{size} {unit}"
            return f"{sign}{size:.1f} {unit}"
        size /= 1024
    return f"{sign}{size:.1f} PB"


def format_delta(delta: int) -> str:
    """Format size delta with +/- prefix."""
    if delta > 0:
        return f"+{format_size(delta)}"
    elif delta < 0:
        return format_size(delta)
    return "±0 B"


class TmutilBrowser(App):
    """An ncdu-like browser for tmutil diffs."""

    CSS = """
    Tree {
        background: $surface;
    }

    #stats {
        dock: bottom;
        height: 3;
        background: $primary-background;
        padding: 0 1;
    }

    .tree--label {
        padding: 0 1;
    }
    """

    BINDINGS = [
        ("q", "quit", "Quit"),
        ("escape", "quit", "Quit"),
        ("s", "cycle_sort", "Sort"),
        ("c", "sort_count", "By Count"),
        ("z", "sort_size", "By Size"),
        ("n", "sort_name", "By Name"),
    ]

    sort_mode = reactive(SortMode.COUNT)

    def __init__(self, root_stats: DirStats, **kwargs):
        super().__init__(**kwargs)
        self.root_stats = root_stats

    def compose(self) -> ComposeResult:
        yield Header()
        yield Tree("/ (root)", id="tree")
        yield Static(id="stats")
        yield Footer()

    def on_mount(self) -> None:
        tree = self.query_one(Tree)
        tree.root.data = self.root_stats
        tree.root.expand()
        self._populate_node(tree.root, self.root_stats)
        self._update_stats(self.root_stats)

    def _populate_node(self, node: TreeNode, stats: DirStats) -> None:
        """Populate a tree node with its children."""
        sorted_children = self._sort_children(stats.children.items())

        for name, child_stats in sorted_children:
            label = self._format_label(name, child_stats, is_dir=True)
            child_node = node.add(label, data=child_stats)
            if child_stats.children or child_stats.files:
                child_node.allow_expand = True

        sorted_files = self._sort_files(stats.files)

        for filename, change in sorted_files[:100]:  # Limit files shown
            label = self._format_file_label(filename, change)
            node.add_leaf(label, data=change)

        if len(stats.files) > 100:
            node.add_leaf(f"... and {len(stats.files) - 100} more files")

    def _sort_children(self, children):
        """Sort directory children based on current sort mode."""
        if self.sort_mode == SortMode.COUNT:
            return sorted(
                children,
                key=lambda x: x[1].added_count + x[1].removed_count + x[1].modified_count,
                reverse=True
            )
        elif self.sort_mode == SortMode.SIZE:
            return sorted(
                children,
                key=lambda x: abs(x[1].size_delta),
                reverse=True
            )
        else:  # NAME
            return sorted(children, key=lambda x: x[0].lower())

    def _sort_files(self, files):
        """Sort files based on current sort mode."""
        if self.sort_mode == SortMode.COUNT:
            return sorted(files, key=lambda x: x[1].size, reverse=True)
        elif self.sort_mode == SortMode.SIZE:
            return sorted(files, key=lambda x: x[1].size, reverse=True)
        else:  # NAME
            return sorted(files, key=lambda x: x[0].lower())

    def _format_label(self, name: str, stats: DirStats, is_dir: bool = False) -> Text:
        """Format a directory label with stats."""
        total = stats.added_count + stats.removed_count + stats.modified_count

        parts = []
        if stats.added_count:
            parts.append(f"+{stats.added_count}")
        if stats.removed_count:
            parts.append(f"-{stats.removed_count}")
        if stats.modified_count:
            parts.append(f"~{stats.modified_count}")

        stats_str = " ".join(parts) if parts else "0"
        delta_str = format_delta(stats.size_delta)

        text = Text()
        if is_dir:
            text.append("📁 ", style="yellow")
        text.append(f"{name}/", style="bold")
        text.append(f"  [{stats_str}]", style="cyan")

        if stats.size_delta > 0:
            text.append(f"  {delta_str}", style="red")
        elif stats.size_delta < 0:
            text.append(f"  {delta_str}", style="green")

        return text

    def _format_file_label(self, filename: str, change: FileChange) -> Text:
        """Format a file label."""
        text = Text()

        if change.change_type == 'added':
            text.append("+ ", style="bold green")
            text.append(filename)
            if change.size:
                text.append(f"  ({format_size(change.size)})", style="green")
        elif change.change_type == 'removed':
            text.append("- ", style="bold red")
            text.append(filename)
            if change.size:
                text.append(f"  ({format_size(change.size)})", style="red")
        elif change.change_type == 'modified':
            text.append("~ ", style="bold yellow")
            text.append(filename)
            diffs = ", ".join(change.differences) if change.differences else "modified"
            text.append(f"  ({diffs}", style="yellow")
            if change.old_size != change.new_size:
                delta = change.new_size - change.old_size
                text.append(f", {format_delta(delta)}", style="yellow")
            text.append(")", style="yellow")

        return text

    def on_tree_node_expanded(self, event: Tree.NodeExpanded) -> None:
        """Handle node expansion - lazy load children."""
        node = event.node
        if node.data and isinstance(node.data, DirStats):
            # Only populate if not already done
            if not node.children:
                self._populate_node(node, node.data)

    def on_tree_node_highlighted(self, event: Tree.NodeHighlighted) -> None:
        """Update stats panel when a node is highlighted."""
        node = event.node
        if node.data:
            if isinstance(node.data, DirStats):
                self._update_stats(node.data)
            elif isinstance(node.data, FileChange):
                self._update_file_stats(node.data)

    def _update_stats(self, stats: DirStats) -> None:
        """Update the stats panel."""
        total = stats.added_count + stats.removed_count + stats.modified_count
        panel = self.query_one("#stats", Static)
        sort_info = f"(Sort: {self.sort_mode.value} — s:cycle c:count z:size n:name)"
        panel.update(
            f"Added: {stats.added_count:,} ({format_size(stats.added_size)}) | "
            f"Removed: {stats.removed_count:,} ({format_size(stats.removed_size)}) | "
            f"Modified: {stats.modified_count:,} | "
            f"Net delta: {format_delta(stats.size_delta)}  {sort_info}"
        )

    def _update_file_stats(self, change: FileChange) -> None:
        """Update the stats panel for a file."""
        panel = self.query_one("#stats", Static)
        sort_info = f"(Sort: {self.sort_mode.value})"
        if change.change_type == 'modified':
            panel.update(
                f"Path: {change.path}  {sort_info}\n"
                f"Changes: {', '.join(change.differences)} | "
                f"Old size: {format_size(change.old_size)} | "
                f"New size: {format_size(change.new_size)} | "
                f"Delta: {format_delta(change.new_size - change.old_size)}"
            )
        else:
            panel.update(
                f"Path: {change.path}  {sort_info}\n"
                f"Type: {change.change_type} | Size: {format_size(change.size)}"
            )

    def action_cycle_sort(self) -> None:
        """Cycle through sort modes."""
        modes = list(SortMode)
        current_idx = modes.index(self.sort_mode)
        self.sort_mode = modes[(current_idx + 1) % len(modes)]
        self._refresh_tree()

    def action_sort_count(self) -> None:
        """Sort by change count."""
        self.sort_mode = SortMode.COUNT
        self._refresh_tree()

    def action_sort_size(self) -> None:
        """Sort by size delta."""
        self.sort_mode = SortMode.SIZE
        self._refresh_tree()

    def action_sort_name(self) -> None:
        """Sort by name."""
        self.sort_mode = SortMode.NAME
        self._refresh_tree()

    def _refresh_tree(self) -> None:
        """Refresh the tree with new sort order."""
        tree = self.query_one(Tree)
        tree.clear()
        tree.root.data = self.root_stats
        tree.root.expand()
        self._populate_node(tree.root, self.root_stats)
        self._update_stats(self.root_stats)


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        print("\nError: Please provide path to tmutil diff XML file")
        sys.exit(1)

    xml_path = sys.argv[1]
    if not Path(xml_path).exists():
        print(f"Error: File not found: {xml_path}")
        sys.exit(1)

    changes = parse_tmutil_xml(xml_path)
    root_stats = build_tree(changes)

    print("Starting browser...")
    app = TmutilBrowser(root_stats)
    app.run()


if __name__ == "__main__":
    main()
