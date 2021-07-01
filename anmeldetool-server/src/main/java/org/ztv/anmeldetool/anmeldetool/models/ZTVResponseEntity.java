package org.ztv.anmeldetool.anmeldetool.models;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ZTVResponseEntity<T> {
	private T response;
}
