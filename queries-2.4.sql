-- Попробуйте вывести не просто самую высокую зарплату во всей команде, а вывести именно фамилию сотрудника с самой высокой зарплатой.
select id, surname, name, second_name, e.salary 
from employee e
where e.salary = (select max(salary) from employee em)

-- Попробуйте вывести фамилии сотрудников в алфавитном порядке
select id, surname, name, second_name, e.salary 
from employee e
order by e.surname 

-- Рассчитайте средний стаж для каждого уровня сотрудников
select e.level, sum(extract(day from NOW() - hire_at)) / count(*)
from employee e 
group by level

-- Выведите название отдела и фамилию сотрудника с самой высокой зарплатой в данном отделе и саму зарплату также.
select dm.name, e.surname, e.salary
from employee e
join (
select d.id, d.name, max(em.salary) as ms
from department d 
join employee em on em.dep_id = d.id 
group by d.id) dm on dm.id = e.dep_id and dm.ms = e.salary 

-- *Выведите название отдела, сотрудники которого получат наибольшую премию по итогам года. 
select d.id, d.name, sum (
	case
		when s.score = 'A' then e.salary * 0.2
		when s.score = 'B' then e.salary * 0.1
		when s.score = 'D' then e.salary - (e.salary * 1.1)
		when s.score = 'E' then e.salary - (e.salary * 1.2)
		else e.salary - e.salary 
	end) as benefit
from employee e 
join score s on s.emp_id = e.id 
join department d on d.id = e.dep_id 
group by d.id
order by benefit desc

-- * Проиндексируйте зарплаты сотрудников с учетом коэффициента премии. 
-- Для сотрудников с коэффициентом премии больше 1.2 – размер индексации составит 20%, 
-- для сотрудников с коэффициентом премии от 1 до 1.2 размер индексации составит 10%. 
-- Для всех остальных сотрудников индексация не предусмотрена
update employee e
set salary = salary * ( 
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

-- ***По итогам индексации отдел финансов хочет получить следующий отчет: вам необходимо на уровень каждого отдела вывести следующую информацию:
--  +i.     Название отдела
--  +ii.     Фамилию руководителя
--  +iii.     Количество сотрудников
--  +iv.     Средний стаж
--  +v.     Средний уровень зарплаты
--  +vi.     Количество сотрудников уровня junior
--  +vii.     Количество сотрудников уровня middle
--  +viii.     Количество сотрудников уровня senior
--  +ix.     Количество сотрудников уровня lead
--  +x.     Общий размер оплаты труда всех сотрудников до индексации
--  +xi.     Общий размер оплаты труда всех сотрудников после индексации
--  +xii.     Общее количество оценок А
--  +xiii.     Общее количество оценок B
--  +xiv.     Общее количество оценок C
--  +xv.     Общее количество оценок D
--  +xvi.     Общее количество оценок Е
--  +xvii.     Средний показатель коэффициента премии
--  +xviii.     Общий размер премии.
--  +xix.     Общую сумму зарплат(+ премии) до индексации
--  +xx.     Общую сумму зарплат(+ премии) после индексации(премии не индексируются)
--  +xxi.     Разницу в % между предыдущими двумя суммами(первая/вторая)

with dep_level as (
	select dl.id, el.level, count(*) as c from employee el join department dl on dl.id = el.dep_id group by dl.id, el.level
),
dep_emp as (
	select d.id, sum(salary) as salary
		, count(*) as count_of_employee
		, (sum(salary) / count(*)) as avg_salary 
		, sum(extract(day from NOW() - hire_at)) / count(*) as avg_days_in_company
		from employee e join department d on d.id  = e.dep_id  group by d.id
),
dep_score as (
	select es.dep_id as id, ss.score, count(*) c
	from employee es 
	join score ss on ss.emp_id = es.id 
	group by es.dep_id, ss.score 
),
dep_benefit as (
	select dep_id as id
		, sum(benefit) as total_benefit
		, sum(salary) as total_salary
		, sum(indexed_salary) as total_salary_indexed	
		, sum(k_benefit) / count(*) as avg_benefit
		, (sum(salary) + sum(benefit)) as salary_plus_benefit
		, (sum(indexed_salary) + sum(benefit)) as salary_indexed_plus_benefit
		, ((sum(indexed_salary) - sum(salary)) / sum(salary) * 100) as indexing_in_percent
	from (
	
	select e.dep_id, 
	case when s.score = 'A' then 0.2
		 when s.score = 'B' then 0.1
		 when s.score = 'D' then -0.1
		 when s.score = 'E' then -0.2
		 else 0
	end as k_benefit,
	case
	    when s.score = 'A' then e.salary * 0.2
		when s.score = 'B' then e.salary * 0.1
		when s.score = 'D' then e.salary - (e.salary * 1.1)
		when s.score = 'E' then e.salary - (e.salary * 1.2)
		else e.salary - e.salary 
	end as benefit,
	salary,
	case
	    when s.score = 'A' then e.salary * 1.2
		when s.score = 'B' then e.salary * 1.1
		when s.score = 'D' then e.salary * 0.9
		when s.score = 'E' then e.salary * 0.8
		else e.salary
	end as indexed_salary
	
	from employee e 
	join score s on s.emp_id = e.id and s.quarter = 'Q1'
	) as dep_benefit
	group by dep_id
)
select d.name
 , (e.surname || ' ' || e.name || ' ' || e.second_name) as manager
 , de.count_of_employee
 , de.avg_days_in_company
 , de.avg_salary
 , coalesce (dlj.c, 0) as count_of_juniors
 , coalesce (dlm.c, 0) as count_of_middle
 , coalesce (dls.c, 0) as count_of_senior
 , coalesce (dlm.c, 0) + coalesce (dls.c, 0) as count_of_lead
 , de.salary as salary_before_indexing
 , db.total_salary_indexed as salary_after_indexing
 , coalesce (dsa.c, 0) as count_of_A
 , coalesce (dsb.c, 0) as count_of_B
 , coalesce (dsc.c, 0) as count_of_C
 , coalesce (dsd.c, 0) as count_of_D
 , coalesce (dse.c, 0) as count_of_E
 , db.avg_benefit
 , db.total_benefit
 , db.salary_plus_benefit
 , db.salary_indexed_plus_benefit
 , db.indexing_in_percent

from department d
left join employee e on e.id = d.manager 
left join dep_level dlj on dlj.id = d.id and dlj.level = 'junior'
left join dep_level dlm on dlm.id = d.id and dlm.level = 'middle'
left join dep_level dls on dls.id = d.id and dls.level = 'senior'
left join dep_emp de on de.id = d.id
left join dep_score dsa on dsa.id = d.id and dsa.score = 'A'
left join dep_score dsb on dsb.id = d.id and dsb.score = 'B'
left join dep_score dsc on dsc.id = d.id and dsc.score = 'C'
left join dep_score dsd on dsd.id = d.id and dsd.score = 'D'
left join dep_score dse on dse.id = d.id and dse.score = 'E'
left join dep_benefit db on db.id = d.id
