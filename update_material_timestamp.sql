CREATE OR REPLACE FUNCTION update_material_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.materials_lastupdate = CURRENT_DATE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER material_update_trigger
BEFORE UPDATE ON materials
FOR EACH ROW
EXECUTE FUNCTION update_material_timestamp();
