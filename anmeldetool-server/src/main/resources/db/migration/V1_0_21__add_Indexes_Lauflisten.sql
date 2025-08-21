CREATE INDEX IF NOT EXISTS idx_einzelnote_notenblatt_id ON einzelnote USING btree (notenblatt_id ASC NULLS LAST);

CREATE INDEX IF NOT EXISTS idx_einzelnote_anlass_id ON lauflisten_container USING btree (anlass_id ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS idx_einzelnote_kategorie ON lauflisten_container USING btree (kategorie ASC NULLS LAST);
CREATE INDEX IF NOT EXISTS idx_einzelnote_startgeraet ON lauflisten_container USING btree (startgeraet ASC NULLS LAST);

CREATE INDEX IF NOT EXISTS idx_einzelnote_lauflisten_container_id ON laufliste USING btree (lauflisten_container_id ASC NULLS LAST);