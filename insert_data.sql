
INSERT INTO department (id, "name", manager) VALUES(1, 'DWH', 2);
INSERT INTO department (id, "name", manager) VALUES(2, 'CIS', 3);
INSERT INTO department (id, "name", manager) VALUES(3, 'R&D', 1);
INSERT INTO department (id, "name", manager) VALUES(4, 'Marketing', 4);

INSERT INTO employee (id, "name", second_name, surname, hire_at, birthday, "position", "level", salary, dep_id, driver_license, benefit_quarter) VALUES(2, 'Ivan', 'Ivanich', 'Petrov', '2021-09-01', '1990-09-05', 'developer', 'junior              ', $100,000.00, 1, 'B1', $110,000.00);
INSERT INTO employee (id, "name", second_name, surname, hire_at, birthday, "position", "level", salary, dep_id, driver_license, benefit_quarter) VALUES(3, 'Petr', 'Petrovich', 'Ivanov', '2021-01-15', '1995-08-14', 'designer', 'middle              ', $150,000.00, 2, 'B1', $180,000.00);
INSERT INTO employee (id, "name", second_name, surname, hire_at, birthday, "position", "level", salary, dep_id, driver_license, benefit_quarter) VALUES(4, 'Sidr', 'Ivanovich', 'Petrunkov', '2017-11-07', '1985-05-07', 'qa', 'senior              ', $200,000.00, 3, NULL, $200,000.00);
INSERT INTO employee (id, "name", second_name, surname, hire_at, birthday, "position", "level", salary, dep_id, driver_license, benefit_quarter) VALUES(5, 'Ilya', 'Mikhailovich', 'Odincev', '2022-05-13', '1982-02-22', 'developer', 'senior              ', $180,000.00, 3, NULL, $144,000.00);
INSERT INTO employee (id, "name", second_name, surname, hire_at, birthday, "position", "level", salary, dep_id, driver_license, benefit_quarter) VALUES(1, 'Mikhail', 'Andreevich', 'Tur', '2010-05-17', '1965-12-03', 'manager', 'senior              ', $350,000.00, 2, NULL, $315,000.00);

INSERT INTO score (id, score, emp_id, quarter) VALUES(2, 'B', 2, 'Q1');
INSERT INTO score (id, score, emp_id, quarter) VALUES(3, 'A', 3, 'Q1');
INSERT INTO score (id, score, emp_id, quarter) VALUES(4, 'C', 4, 'Q1');
INSERT INTO score (id, score, emp_id, quarter) VALUES(5, 'E', 5, 'Q1');
INSERT INTO score (id, score, emp_id, quarter) VALUES(1, 'D', 1, 'Q1');
INSERT INTO score (id, score, emp_id, quarter) VALUES(6, 'A', 3, 'Q2');
