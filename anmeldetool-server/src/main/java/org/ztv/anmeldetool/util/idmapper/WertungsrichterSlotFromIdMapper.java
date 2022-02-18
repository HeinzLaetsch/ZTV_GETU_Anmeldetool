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
import org.ztv.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.repositories.WertungsrichterSlotRepository;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, builder = @Builder(disableBuilder = true))
public abstract class WertungsrichterSlotFromIdMapper {

	@Autowired
	WertungsrichterSlotRepository repo;

	public abstract WertungsrichterSlot toEntity(UUID id);

	@ObjectFactory
	<T extends Base> T resolve(UUID id, @TargetType Class<T> targetType) {
		@SuppressWarnings("unchecked")
		Optional<T> entity = (Optional<T>) repo.findById(id);
		if (entity.isEmpty()) {
			return null;
		}
		return (T) entity.get();
	}
}
