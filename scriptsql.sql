BEGIN;


CREATE TABLE IF NOT EXISTS public.registration
(
    student_id integer NOT NULL,
    filial_id integer NOT NULL,
    course_id integer NOT NULL,
    status boolean NOT NULL,
    CONSTRAINT pk_registration PRIMARY KEY (student_id, filial_id, course_id)
);

CREATE TABLE IF NOT EXISTS public.course
(
    course_name character varying(128) COLLATE pg_catalog."default" NOT NULL,
    course_description character varying(500) COLLATE pg_catalog."default" NOT NULL,
    course_cost money NOT NULL,
    course_id serial NOT NULL,
    teacher_id integer NOT NULL,
    CONSTRAINT pk_course PRIMARY KEY (course_id)
);

CREATE TABLE IF NOT EXISTS public.teacher
(
    teacher_shedule character varying(200) COLLATE pg_catalog."default" NOT NULL,
    teacher_name character varying(128) COLLATE pg_catalog."default" NOT NULL,
    teacher_contact character varying(12) COLLATE pg_catalog."default" NOT NULL,
    teacher_id serial NOT NULL,
    filial_id integer,
    CONSTRAINT pk_teacher PRIMARY KEY (teacher_id)
);

CREATE TABLE IF NOT EXISTS public.filial
(
    filial_adress character varying(128) COLLATE pg_catalog."default" NOT NULL,
    filial_contact character varying(12) COLLATE pg_catalog."default" NOT NULL,
    filial_id serial NOT NULL,
    CONSTRAINT pk_filial PRIMARY KEY (filial_id)
);

CREATE TABLE IF NOT EXISTS public.admin
(
    admin_name character varying(128) COLLATE pg_catalog."default" NOT NULL,
    admin_id serial NOT NULL,
    filial_id integer NOT NULL,
    CONSTRAINT pk_admin PRIMARY KEY (admin_id)
);

CREATE TABLE IF NOT EXISTS public.suggests
(
    course_id integer NOT NULL,
    filial_id integer NOT NULL,
    CONSTRAINT pk_suggests PRIMARY KEY (course_id, filial_id)
);

CREATE TABLE IF NOT EXISTS public.materials
(
    course_id integer NOT NULL,
    materials_content character varying(300) COLLATE pg_catalog."default" NOT NULL,
    materials_lastupdate date NOT NULL,
    materials_id serial NOT NULL,
    CONSTRAINT pk_materials PRIMARY KEY (materials_id)
);

CREATE TABLE IF NOT EXISTS public.progress
(
    course_id integer NOT NULL,
    student_id integer NOT NULL,
    progress_date date NOT NULL,
    progress_attendance boolean NOT NULL,
    progress_mark integer NOT NULL,
    CONSTRAINT pk_progress PRIMARY KEY (course_id, student_id, progress_date)
);

CREATE TABLE IF NOT EXISTS public.student
(
    student_name character varying(128) COLLATE pg_catalog."default" NOT NULL,
    student_contact character varying(12) COLLATE pg_catalog."default" NOT NULL,
    student_id serial NOT NULL,
    CONSTRAINT pk_student PRIMARY KEY (student_id)
);

ALTER TABLE IF EXISTS public.registration
    ADD CONSTRAINT fk_registra_a_course FOREIGN KEY (course_id)
    REFERENCES public.course (course_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS a_fk
    ON public.registration(course_id);


ALTER TABLE IF EXISTS public.registration
    ADD CONSTRAINT fk_registra_b_filial FOREIGN KEY (filial_id)
    REFERENCES public.filial (filial_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS b_fk
    ON public.registration(filial_id);


ALTER TABLE IF EXISTS public.registration
    ADD CONSTRAINT fk_registra_c_student FOREIGN KEY (student_id)
    REFERENCES public.student (student_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS c_fk
    ON public.registration(student_id);


ALTER TABLE IF EXISTS public.course
    ADD CONSTRAINT fk_course_leads_teacher FOREIGN KEY (teacher_id)
    REFERENCES public.teacher (teacher_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS leads_fk
    ON public.course(teacher_id);


ALTER TABLE IF EXISTS public.teacher
    ADD CONSTRAINT fk_teacher_teach_filial FOREIGN KEY (filial_id)
    REFERENCES public.filial (filial_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS teach_fk
    ON public.teacher(filial_id);


ALTER TABLE IF EXISTS public.admin
    ADD CONSTRAINT fk_admin_manage_filial FOREIGN KEY (filial_id)
    REFERENCES public.filial (filial_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS manage_fk
    ON public.admin(filial_id);


ALTER TABLE IF EXISTS public.suggests
    ADD CONSTRAINT fk_suggests_suggests2_filial FOREIGN KEY (filial_id)
    REFERENCES public.filial (filial_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS suggests2_fk
    ON public.suggests(filial_id);


ALTER TABLE IF EXISTS public.suggests
    ADD CONSTRAINT fk_suggests_suggests_course FOREIGN KEY (course_id)
    REFERENCES public.course (course_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS suggests_fk
    ON public.suggests(course_id);


ALTER TABLE IF EXISTS public.materials
    ADD CONSTRAINT fk_material_relate_course FOREIGN KEY (course_id)
    REFERENCES public.course (course_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS relate_fk
    ON public.materials(course_id);


ALTER TABLE IF EXISTS public.progress
    ADD CONSTRAINT fk_progress_course_ha_course FOREIGN KEY (course_id)
    REFERENCES public.course (course_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS course_has_fk
    ON public.progress(course_id);


ALTER TABLE IF EXISTS public.progress
    ADD CONSTRAINT fk_progress_has_student FOREIGN KEY (student_id)
    REFERENCES public.student (student_id) MATCH SIMPLE
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;
CREATE INDEX IF NOT EXISTS has_fk
    ON public.progress(student_id);

END;