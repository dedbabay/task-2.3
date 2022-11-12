-- public.department definition

-- Drop table

-- DROP TABLE department;

CREATE TABLE department (
	id serial4 NOT NULL,
	"name" varchar(100) NOT NULL,
	manager int8 NULL,
	CONSTRAINT department_pkey PRIMARY KEY (id)
);


-- public.employee definition

-- Drop table

-- DROP TABLE employee;

CREATE TABLE employee (
	id serial4 NOT NULL,
	"name" varchar(100) NOT NULL,
	second_name varchar(100) NULL,
	surname varchar(100) NULL,
	hire_at date NOT NULL,
	birthday date NOT NULL,
	"position" varchar(100) NOT NULL,
	"level" bpchar(20) NOT NULL,
	salary money NOT NULL,
	dep_id int8 NOT NULL,
	driver_license varchar(2) NULL,
	benefit_quarter money NULL,
	CONSTRAINT employee_pkey PRIMARY KEY (id)
);


-- public.score definition

-- Drop table

-- DROP TABLE score;

CREATE TABLE score (
	id serial4 NOT NULL,
	score varchar(1) NOT NULL,
	emp_id int8 NOT NULL,
	quarter varchar(2) NOT NULL,
	CONSTRAINT score_pkey PRIMARY KEY (id)
);


-- public.department foreign keys

ALTER TABLE public.department ADD CONSTRAINT manager FOREIGN KEY (manager) REFERENCES employee(id);


-- public.employee foreign keys

ALTER TABLE public.employee ADD CONSTRAINT employee FOREIGN KEY (dep_id) REFERENCES department(id);


-- public.score foreign keys

ALTER TABLE public.score ADD CONSTRAINT employee FOREIGN KEY (emp_id) REFERENCES employee(id);