package org.ztv.anmeldetool.anmeldetool.util;

import java.util.Optional;

import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.ObjectFactory;
import org.mapstruct.TargetType;
import org.ztv.anmeldetool.anmeldetool.models.Base;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.repositories.AnlassRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationsRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationAnlassLinkDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface OrganisationAnlassLinkMapper {

	@Mapping(source = "organisationAnlassLink.anlass.id", target = "anlassId")
	@Mapping(source = "organisationAnlassLink.organisation.id", target = "organisationsId")
	@Mapping(source = "organisationAnlassLink.aktiv", target = "startet")
	public abstract OrganisationAnlassLinkDTO toDto(OrganisationAnlassLink organisationAnlassLink);

	@Mapping(source = "organisationAnlassLinkDto.startet", target = "aktiv")
	public abstract OrganisationAnlassLink toEntity(OrganisationAnlassLinkDTO organisationAnlassLinkDto);

	@ObjectFactory
	default <T extends Base> T lookupOrganisation(OrganisationAnlassLinkDTO oalDTO,
			@Context OrganisationsRepository orgRepo, @TargetType Class<T> targetType) {
		@SuppressWarnings("unchecked")
		Optional<T> entity = (Optional<T>) orgRepo.findById(oalDTO.getOrganisationsId());
		if (entity.isEmpty()) {
			entity = Optional.empty();
		}
		return (T) entity.get();
	}

	@ObjectFactory
	default <T extends Base> T lookupAnlass(OrganisationAnlassLinkDTO oalDTO, @Context AnlassRepository orgRepo,
			@TargetType Class<T> targetType) {
		@SuppressWarnings("unchecked")
		Optional<T> entity = (Optional<T>) orgRepo.findById(oalDTO.getAnlassId());
		if (entity.isEmpty()) {
			entity = Optional.empty();
		}
		return (T) entity.get();
	}
}
