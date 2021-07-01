package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.UUID;

import org.ztv.anmeldetool.anmeldetool.models.TiTuEnum;

import lombok.Builder;
import lombok.Value;
/*
 *  id: '-1',
    verein_id: '-1',
    lastName: '',
    firstName: '',
    password: '',
    userName: '',
    eMail: '',
    mobileNummer: '',
    enabled: true

 */
/**
 * 
 * @author heinz
 *
 */
@Value
@Builder
public class TeilnehmerDTO {
	
	private UUID id;
	
	private UUID organisationid;
	
	private String name;
	
	private String vorname;
	
	private int jahrgang;
	
	private TiTuEnum tiTu;
	
	private boolean aktiv;
	
	private boolean dirty;
}
