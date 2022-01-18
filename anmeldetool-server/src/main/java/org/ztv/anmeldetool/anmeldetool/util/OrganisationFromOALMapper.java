package org.ztv.anmeldetool.anmeldetool.util;

import java.util.Optional;

import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ObjectFactory;
import org.mapstruct.TargetType;
import org.ztv.anmeldetool.anmeldetool.models.Base;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationsRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationAnlassLinkDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface OrganisationFromOALMapper {

	public abstract Organisation toEntity(OrganisationAnlassLinkDTO organisationAnlassLinkDto);

	@ObjectFactory
	default <T extends Base> T resolve(OrganisationAnlassLinkDTO oalDTO, @Context OrganisationsRepository orgRepo,
			@TargetType Class<T> targetType) {
		@SuppressWarnings("unchecked")
		Optional<T> entity = (Optional<T>) orgRepo.findById(oalDTO.getOrganisationsId());
		if (entity.isEmpty()) {
			entity = Optional.empty();
		}
		return (T) entity.get();
	}
}
