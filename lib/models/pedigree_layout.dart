import 'pessoa_model.dart';

class PedigreePoint {
  final double x;
  final double y;

  const PedigreePoint(this.x, this.y);
}

class PedigreeSegment {
  final PedigreePoint start;
  final PedigreePoint end;

  const PedigreeSegment(this.start, this.end);
}

class PedigreeLayout {
  static const nodeSpacing = 150.0;
  static const rowSpacing = 170.0;
  static const marginX = 90.0;
  static const marginY = 85.0;

  final Map<String, PedigreePoint> positions;
  final List<PedigreeSegment> relationshipLines;
  final List<int> generations;
  final double width;
  final double height;

  const PedigreeLayout({
    required this.positions,
    required this.relationshipLines,
    required this.generations,
    required this.width,
    required this.height,
  });

  factory PedigreeLayout.fromPeople(List<Pessoa> people) {
    if (people.isEmpty) {
      return const PedigreeLayout(
        positions: {},
        relationshipLines: [],
        generations: [],
        width: 800,
        height: 500,
      );
    }

    final byId = {for (final person in people) person.id: person};
    final generationById = <String, int>{
      for (final person in people) person.id: _inferredGeneration(person),
    };

    // Known parent links are more reliable than labels.
    for (var pass = 0; pass < people.length; pass++) {
      var changed = false;
      for (final child in people) {
        final childGeneration = generationById[child.id]!;
        for (final parentId in [child.paiId, child.maeId]) {
          if (parentId == null || !byId.containsKey(parentId)) continue;
          final expected = childGeneration - 1;
          if (generationById[parentId] != expected) {
            generationById[parentId] = expected;
            changed = true;
          }
        }
      }
      if (!changed) break;
    }

    final minimum = generationById.values.reduce((a, b) => a < b ? a : b);
    final maximum = generationById.values.reduce((a, b) => a > b ? a : b);
    final rows = <int, List<Pessoa>>{};
    for (var generation = minimum; generation <= maximum; generation++) {
      rows[generation] = _orderCouples(
        people.where((p) => generationById[p.id] == generation).toList(),
        byId,
      );
    }

    final largestRow = rows.values.fold<int>(1, (max, row) {
      return row.length > max ? row.length : max;
    });
    final width = marginX * 2 + (largestRow - 1) * nodeSpacing + 80;
    final positions = <String, PedigreePoint>{};
    for (final entry in rows.entries) {
      final row = entry.value;
      final rowWidth = (row.length - 1) * nodeSpacing;
      final startX = (width - rowWidth) / 2;
      final y = marginY + (entry.key - minimum) * rowSpacing;
      for (var index = 0; index < row.length; index++) {
        positions[row[index].id] = PedigreePoint(
          startX + index * nodeSpacing,
          y,
        );
      }
    }

    return PedigreeLayout(
      positions: positions,
      relationshipLines: _buildLines(people, positions),
      generations: [for (var i = minimum; i <= maximum; i++) i],
      width: width,
      height: marginY * 2 + (maximum - minimum) * rowSpacing + 115,
    );
  }

  static int _inferredGeneration(Pessoa person) {
    final relationship = person.parentesco.toLowerCase();
    if (relationship.contains('bisav')) return -1;
    if (relationship.contains('avô') || relationship.contains('avó')) return 0;
    if (relationship == 'pai' ||
        relationship == 'mae' ||
        relationship == 'mãe' ||
        relationship.contains('tio') ||
        relationship.contains('tia')) {
      return 1;
    }
    if (relationship.contains('neto') || relationship.contains('neta')) {
      return 3;
    }
    if (relationship.contains('filho') || relationship.contains('filha')) {
      return 2;
    }
    return 2;
  }

  static List<Pessoa> _orderCouples(
    List<Pessoa> row,
    Map<String, Pessoa> byId,
  ) {
    final ordered = <Pessoa>[];
    final added = <String>{};
    for (final person in row) {
      if (!added.add(person.id)) continue;
      ordered.add(person);
      final spouse = person.conjugeId == null ? null : byId[person.conjugeId];
      if (spouse != null && row.contains(spouse) && added.add(spouse.id)) {
        ordered.add(spouse);
      }
    }
    return ordered;
  }

  static List<PedigreeSegment> _buildLines(
    List<Pessoa> people,
    Map<String, PedigreePoint> positions,
  ) {
    final lines = <PedigreeSegment>[];
    final drawnCouples = <String>{};
    for (final person in people) {
      final spouseId = person.conjugeId;
      if (spouseId == null) continue;
      final key = [person.id, spouseId]..sort();
      if (!drawnCouples.add(key.join('|'))) continue;
      final first = positions[person.id];
      final second = positions[spouseId];
      if (first != null && second != null) {
        lines.add(PedigreeSegment(first, second));
      }
    }

    // Cadastros manuais antigos não possuem conjugeId. Nesses casos, o grau
    // de parentesco ainda permite reconhecer o casal parental do probando.
    final inferredFather = people.where((person) {
      final value = person.parentesco.toLowerCase();
      return value == 'pai' || value == 'father';
    }).firstOrNull;
    final inferredMother = people.where((person) {
      final value = person.parentesco.toLowerCase();
      return value == 'mãe' || value == 'mae' || value == 'mother';
    }).firstOrNull;
    if (inferredFather != null && inferredMother != null) {
      final key = [inferredFather.id, inferredMother.id]..sort();
      if (drawnCouples.add(key.join('|'))) {
        final fatherPoint = positions[inferredFather.id];
        final motherPoint = positions[inferredMother.id];
        if (fatherPoint != null && motherPoint != null) {
          lines.add(PedigreeSegment(fatherPoint, motherPoint));
        }
      }
    }

    final families = <String, List<Pessoa>>{};
    for (final child in people) {
      final parents = [child.paiId, child.maeId]
          .whereType<String>()
          .where(positions.containsKey)
          .toList()
        ..sort();
      if (parents.isEmpty) continue;
      families.putIfAbsent(parents.join('|'), () => []).add(child);
    }

    if (inferredFather != null && inferredMother != null) {
      final parentIds = [inferredFather.id, inferredMother.id]..sort();
      final inferredChildren = people.where((person) {
        if (person.id == inferredFather.id || person.id == inferredMother.id) {
          return false;
        }
        if (person.paiId != null || person.maeId != null) return false;
        final value = person.parentesco.toLowerCase();
        return value == 'filho' ||
            value == 'filha' ||
            value == 'filho(a)' ||
            value.contains('irmão') ||
            value.contains('irmã');
      }).toList();
      if (inferredChildren.isNotEmpty) {
        families.putIfAbsent(parentIds.join('|'), () => inferredChildren);
      }
    }

    for (final entry in families.entries) {
      final parentIds = entry.key.split('|');
      final parentPoints = parentIds.map((id) => positions[id]!).toList();
      final unionX = parentPoints.fold<double>(0, (sum, p) => sum + p.x) /
          parentPoints.length;
      final parentY = parentPoints.first.y;
      final children = entry.value
          .map((child) => positions[child.id])
          .whereType<PedigreePoint>()
          .toList();
      if (children.isEmpty) continue;
      final siblingY = children.first.y - 55;
      final minX = children.fold<double>(
          children.first.x, (min, p) => p.x < min ? p.x : min);
      final maxX = children.fold<double>(
          children.first.x, (max, p) => p.x > max ? p.x : max);
      lines.add(PedigreeSegment(
          PedigreePoint(unionX, parentY), PedigreePoint(unionX, siblingY)));
      lines.add(PedigreeSegment(
          PedigreePoint(minX, siblingY), PedigreePoint(maxX, siblingY)));
      for (final child in children) {
        lines.add(PedigreeSegment(PedigreePoint(child.x, siblingY), child));
      }
    }
    return lines;
  }
}
