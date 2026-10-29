package org.ztv.anmeldetool.output;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

final class CsvColumnOrder {

  private CsvColumnOrder() {
  }

  /** Orders columns as listed in {@code order}; unlisted columns follow in natural order. */
  static Comparator<String> of(String[] order) {
    List<String> positions = Arrays.asList(order);
    return Comparator.<String>comparingInt(column -> {
      int index = positions.indexOf(column);
      return index < 0 ? Integer.MAX_VALUE : index;
    }).thenComparing(Comparator.naturalOrder());
  }
}
