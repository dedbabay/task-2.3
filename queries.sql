-- Уникальный номер сотрудника, его ФИО и стаж работы – для всех сотрудников компании
select id, surname, name, second_name, extract(day from NOW() - hire_at) as days_in_company
from employee

-- Уникальный номер сотрудника, его ФИО и стаж работы – только первых 3-х сотрудников
select id, surname, name, second_name, extract(day from NOW() - hire_at) as days_in_company
from employee
limit 3

-- Уникальный номер сотрудников - водителей
select id, surname, name, second_name, driver_license 
from employee e 
where e.driver_license is not null 

-- Выведите номера сотрудников, которые хотя бы за 1 квартал получили оценку D или E
select e.id, e.surname, e.name, e.second_name, e.salary, s.score 
from employee e 
join score s on s.emp_id = e.id and s.score in ('D', 'E')

-- Выведите самую высокую зарплату в компании.
select max(salary) from employee e 

-- * Выведите название самого крупного отдела
select d.id, d.name, count(*) as emp_count
from department d 
join employee e on e.dep_id = d.id 
group by d.id
having count(*) =
	(
		select max ( c ) from ( 
		select d.id, count(*) c 
		from employee e 
		join department d on d.id = e.dep_id
		group by d.id ) as dc
	)

-- * Выведите номера сотрудников от самых опытных до вновь прибывших	
select id, surname, name, second_name, extract(day from NOW() - hire_at) as days_in_company
from employee e
order by days_in_company desc 

-- * Рассчитайте среднюю зарплату для каждого уровня сотрудников
select e.level, sum(e.salary) / count(*)
from employee e 
group by level


-- * Добавьте столбец с информацией о коэффициенте годовой премии к основной таблице. 
-- Коэффициент рассчитывается по такой схеме: базовое значение коэффициента – 1, 
-- каждая оценка действует на коэффициент так:
-- Е – минус 20%
-- D – минус 10%
-- С – без изменений
-- B – плюс 10%
-- A – плюс 20%

-- если без столбца:
select e.id, e.name, e.salary, s.score, 
case
	when s.score = 'A' then e.salary * 1.2
	when s.score = 'B' then e.salary * 1.1
	when s.score = 'D' then e.salary * 0.9
	when s.score = 'E' then e.salary * 0.8
	else e.salary
end

from employee e 
join score s on s.emp_id = e.id 

-- если нужно проставить значения в столбец
update employee e
set benefit_quarter = salary * ( 
	select case
		when s.score = 'A' then 1.2
		when s.score = 'B' then 1.1
		when s.score = 'D' then 0.9
		when s.score = 'E' then 0.8
		else 1
	end
	from score s
	where s.emp_id = e.id 
)
select id, name, salary, benefit_quarter from employee 
