package org.ztv.anmeldetool.anmeldetool.util.idmapper;

import java.util.Optional;
import java.util.UUID;

import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ObjectFactory;
import org.mapstruct.TargetType;
import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.anmeldetool.models.Base;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationsRepository;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, builder = @Builder(disableBuilder = true))
public abstract class OrganisationFromIdMapper {

	@Autowired
	OrganisationsRepository orgRepo;

	public abstract Organisation toEntity(UUID id);

	@ObjectFactory
	<T extends Base> T resolve(UUID id, @TargetType Class<T> targetType) {
		@SuppressWarnings("unchecked")
		Optional<T> entity = (Optional<T>) orgRepo.findById(id);
		if (entity.isEmpty()) {
			return null;
		}
		return (T) entity.get();
	}
}
