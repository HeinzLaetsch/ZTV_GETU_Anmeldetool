package org.ztv.anmeldetool.util.idmapper;

import java.util.Optional;
import java.util.UUID;

import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ObjectFactory;
import org.mapstruct.TargetType;
import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.models.Base;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.repositories.TeilnehmerRepository;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, builder = @Builder(disableBuilder = true))
public abstract class TeilnehmerFromIdMapper {

	@Autowired
	TeilnehmerRepository orgRepo;

	public abstract Teilnehmer toEntity(UUID id);

	@ObjectFactory
	<T extends Base> T map(UUID id, @TargetType Class<T> targetType) {

		@SuppressWarnings("unchecked")
		Optional<T> entity = (Optional<T>) orgRepo.findById(id);
		if (entity.isEmpty()) {
			return null;
		}
		return (T) entity.get();
	}

}
