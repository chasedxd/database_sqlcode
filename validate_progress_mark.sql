CREATE OR REPLACE FUNCTION validate_progress_mark()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.progress_mark NOT BETWEEN 1 AND 100 THEN
        RAISE EXCEPTION 'Недопустимое значение оценки: %. Допустимый диапазон: 1-100', NEW.progress_mark;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER progress_mark_check
BEFORE INSERT OR UPDATE ON progress
FOR EACH ROW
EXECUTE FUNCTION validate_progress_mark();
