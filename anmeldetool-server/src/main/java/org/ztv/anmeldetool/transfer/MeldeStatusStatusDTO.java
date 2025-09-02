package org.ztv.anmeldetool.transfer;

import lombok.Data;

@Data
public class MeldeStatusStatusDTO {
	private String meldeStatus;
	private int count;

	public MeldeStatusStatusDTO(String meldeStatus) {
		this.meldeStatus = meldeStatus;
		this.count = 1;
	}

	public int increment() {
		return this.count++;
	}

	public String getMeldeStatus() {
		return meldeStatus;
	}

	/*
	 * public void addMeldeStatus(String meldeStatus) { Integer count = null; if
	 * (meldeStatusStati.containsKey(meldeStatus)) { count =
	 * meldeStatusStati.get(meldeStatus); } else { count = Integer.valueOf(0); }
	 * count++; meldeStatusStati.put(meldeStatus, count); }
	 */
	@Override
	public boolean equals(Object other) {
		if (other instanceof MeldeStatusStatusDTO tO) {
			return tO.meldeStatus.equals(this.meldeStatus);
		}
		return false;
	}
}
