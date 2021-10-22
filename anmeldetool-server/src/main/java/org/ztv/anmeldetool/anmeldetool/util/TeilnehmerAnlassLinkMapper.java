package org.ztv.anmeldetool.anmeldetool.util;

import java.util.Optional;

import org.mapstruct.Context;
import org.mapstruct.Mapping;
import org.mapstruct.ObjectFactory;
import org.mapstruct.TargetType;
import org.ztv.anmeldetool.anmeldetool.models.Base;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;

// @Mapper
public interface TeilnehmerAnlassLinkMapper {
	// @Mapping(source = "teilnehmer.id", target = "teilnehmerId")
	// @Mapping(source = "anlass.id", target = "AnlassId")
	// @InheritInverseConfiguration
	TeilnehmerAnlassLinkDTO fromTeilnehmerAnlassLink(TeilnehmerAnlassLink tal);

	@Mapping(target = "id", ignore = true)
	// @Mapping(source = "teilnehmerId", target = "")
	// @Mapping(source = "AnlassId", target = "")
	// @InheritInverseConfiguration
	TeilnehmerAnlassLink fromTeilnehmerAnlassLinkDTO(TeilnehmerAnlassLinkDTO talDTO,
			@Context TeilnehmerAnlassLinkRepository repo);

	@ObjectFactory
	default <T extends Base> T lookup(TeilnehmerAnlassLinkDTO talDTO, @Context TeilnehmerAnlassLinkRepository repo,
			@TargetType Class<T> targetType) {
		Optional<T> entity = (Optional<T>) repo.findById(talDTO.getAnlassId());
		if (entity.isEmpty()) {
			entity = Optional.empty();
		}
		return (T) entity.get();
	}
}
