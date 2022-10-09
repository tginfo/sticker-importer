#!/usr/bin/env python
"""
Compare .arb files and point out differences between them.
Returns codes:
    0 — all .arb files have identical fields
    1 — some .arb files don't have some of others' .arb files fields
"""

import os
import json
from typing import List, Set


class L10nFile:
    def __init__(self, path: str) -> None:
        with open(path, "r") as f:
            self.path = path
            self.keys = list(json.loads(f.read()).keys())
            self.keys.sort()
            self.missing = set()

    def contains(self, item: str) -> bool:
        return item in self.keys

    def mark_missing(self, item: str) -> None:
        self.missing.add(item)


class L10nDiff:
    def __init__(self, files: List[str]) -> None:
        self.files = list(map(lambda path: L10nFile(path), files))
        self.dirty = False

    def all_keys(self) -> Set[str]:
        keys = set()
        for file in self.files:
            for key in file.keys:
                keys.add(key)
        return keys

    def compute(self) -> None:
        for key in self.all_keys():
            for file in self.files:
                if not file.contains(key):
                    file.mark_missing(key)
                    self.dirty = True

    def print_results(self) -> None:
        for file in self.files:
            if len(file.missing) == 0:
                continue

            print(f"{file.path} misses:")
            for missing in file.missing:
                print(f"\t{missing}")
            print()


def main() -> None:
    files = list(filter(lambda file: file.endswith('.arb'), os.listdir()))
    l10n_diff = L10nDiff(files)
    l10n_diff.compute()
    l10n_diff.print_results()
    exit(1 if l10n_diff.dirty else 0)


if __name__ == '__main__':
    main()
