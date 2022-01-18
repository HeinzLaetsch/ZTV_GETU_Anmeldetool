package org.ztv.anmeldetool.anmeldetool.util;

import java.util.Optional;

import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ObjectFactory;
import org.mapstruct.TargetType;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.Base;
import org.ztv.anmeldetool.anmeldetool.repositories.AnlassRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface AnlassFromIdMapper {

	public abstract Anlass toEntity(OrganisationAnlassLinkDTO organisationAnlassLinkDto);

	@ObjectFactory
	default <T extends Base> T resolve(OrganisationAnlassLinkDTO oalDTO, @Context AnlassRepository repo,
			@TargetType Class<T> targetType) {
		@SuppressWarnings("unchecked")
		Optional<T> entity = (Optional<T>) repo.findById(oalDTO.getAnlassId());
		if (entity.isEmpty()) {
			entity = Optional.empty();
		}
		return (T) entity.get();
	}

	@ObjectFactory
	default <T extends Base> T resolve(TeilnehmerAnlassLinkDTO talDTO, @Context AnlassRepository repo,
			@TargetType Class<T> targetType) {
		Optional<T> entity = (Optional<T>) repo.findById(talDTO.getAnlassId());
		if (entity.isEmpty()) {
			entity = Optional.empty();
		}
		return (T) entity.get();
	}
}
