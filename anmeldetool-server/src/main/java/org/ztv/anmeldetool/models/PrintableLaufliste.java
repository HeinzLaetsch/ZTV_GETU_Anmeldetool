package org.ztv.anmeldetool.models;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class PrintableLaufliste {
	Laufliste Laufliste;
	int wechsel;
}
