package org.ztv.anmeldetool.util;

import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.ObjectFactory;
import org.ztv.anmeldetool.models.RanglisteConfiguration;
import org.ztv.anmeldetool.transfer.RanglisteConfigurationDTO;
import org.ztv.anmeldetool.util.idmapper.AnlassFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING,
		builder = @Builder(disableBuilder = true),
		uses = {
		AnlassFromIdMapper.class, BaseFactory.class })
public interface RanglistenConfigurationMapper {

	@Mapping(source = "anlass.id", target = "anlassId")
	RanglisteConfigurationDTO fromEntity(RanglisteConfiguration entity);

	@Mapping(source = "anlassId", target = "anlass")
	RanglisteConfiguration toEntity(RanglisteConfigurationDTO dto);

	@ObjectFactory
	default RanglisteConfiguration map() { return new RanglisteConfiguration();}
}
