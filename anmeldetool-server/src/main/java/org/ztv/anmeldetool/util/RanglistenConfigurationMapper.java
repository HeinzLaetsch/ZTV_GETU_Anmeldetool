package org.ztv.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.models.RanglisteConfiguration;
import org.ztv.anmeldetool.transfer.RanglisteConfigurationDTO;
import org.ztv.anmeldetool.util.idmapper.AnlassFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { AnlassFromIdMapper.class })
public abstract class RanglistenConfigurationMapper {

	@Mapping(source = "anlass.id", target = "anlassId")
	public abstract RanglisteConfigurationDTO fromEntity(RanglisteConfiguration entity);

	@Mapping(source = "anlassId", target = "anlass")
	public abstract RanglisteConfiguration toEntity(RanglisteConfigurationDTO dto);
}
