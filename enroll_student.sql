CREATE OR REPLACE PROCEDURE enroll_student(
    student_id INT,
    course_id INT,
    filial_id INT
) LANGUAGE plpgsql AS $$
DECLARE
    teacher_filial INT;
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM suggests 
        WHERE suggests.course_id = enroll_student.course_id 
          AND suggests.filial_id = enroll_student.filial_id
    ) THEN
        RAISE EXCEPTION 'Курс недоступен в указанном филиале';
    END IF;
    	IF EXISTS (
        SELECT 1 FROM registration 
        WHERE registration.student_id = enroll_student.student_id
          AND registration.course_id = enroll_student.course_id
          AND registration.status = TRUE
    ) THEN
        RAISE EXCEPTION 'Студент уже зарегистрирован на этот курс';
    END IF;
    SELECT t.filial_id INTO teacher_filial
    FROM course c
    JOIN teacher t ON c.teacher_id = t.teacher_id
    WHERE c.course_id = enroll_student.course_id;
    IF teacher_filial IS NULL OR teacher_filial != enroll_student.filial_id THEN
        RAISE EXCEPTION 'Преподаватель курса не привязан к филиалу';
    END IF;
    BEGIN
        INSERT INTO registration(student_id, filial_id, course_id, status)
        VALUES (enroll_student.student_id, enroll_student.filial_id, enroll_student.course_id, TRUE);
        INSERT INTO progress(course_id, student_id, progress_date, progress_attendance, progress_mark)
        SELECT 
            enroll_student.course_id,
            enroll_student.student_id,
            d.date,
            FALSE,  
            0       
        FROM generate_series(
            CURRENT_DATE, 
            CURRENT_DATE + INTERVAL '3 months', 
            INTERVAL '1 week'
        ) AS d(date);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END;
END;
$$;

