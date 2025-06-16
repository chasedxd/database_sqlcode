CREATE OR REPLACE PROCEDURE update_course_materials(
    course_id INT,
    teacher_id INT,
    new_content VARCHAR
) LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM course 
        WHERE course.course_id = update_course_materials.course_id
          AND course.teacher_id = update_course_materials.teacher_id
    ) THEN
        RAISE EXCEPTION 'Преподаватель не ведет этот курс';
    END IF;
    UPDATE materials
    SET 
        materials_content = new_content,
        materials_lastupdate = CURRENT_DATE
    WHERE materials.course_id = update_course_materials.course_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Материалы для курса не найдены';
    END IF;
END;
$$;
