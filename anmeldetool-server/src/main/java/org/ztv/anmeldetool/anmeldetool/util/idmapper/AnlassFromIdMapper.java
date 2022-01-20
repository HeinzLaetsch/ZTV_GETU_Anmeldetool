package org.ztv.anmeldetool.anmeldetool.util.idmapper;

import java.util.Optional;
import java.util.UUID;

import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ObjectFactory;
import org.mapstruct.TargetType;
import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.Base;
import org.ztv.anmeldetool.anmeldetool.repositories.AnlassRepository;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, builder = @Builder(disableBuilder = true))
public abstract class AnlassFromIdMapper {

	@Autowired
	AnlassRepository repo;

	public abstract Anlass toEntity(UUID id);

	@ObjectFactory
	<T extends Base> T resolve(UUID id, @TargetType Class<T> targetType) {
		Optional<T> entity = (Optional<T>) repo.findById(id);
		if (entity.isEmpty()) {
			return null;
		}
		return (T) entity.get();
	}
}
