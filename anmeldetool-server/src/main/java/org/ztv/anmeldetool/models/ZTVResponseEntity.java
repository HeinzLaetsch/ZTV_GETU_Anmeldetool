package org.ztv.anmeldetool.models;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ZTVResponseEntity<T> {
	private T response;
}
