-- Remove o banco de dados se ele já existir
DROP DATABASE IF EXISTS azure_company;

-- Cria o banco de dados
CREATE DATABASE azure_company;

-- Seleciona o banco de dados para uso
USE azure_company;

-- Cria o usuário (se ele não existir)
CREATE USER IF NOT EXISTS 'teste_bd_azure'@'%' IDENTIFIED BY '123456789';

-- Concede todos os privilégios apenas ao banco de dados azure_company
GRANT ALL PRIVILEGES ON azure_company.* TO 'teste_bd_azure'@'%';

-- Atualiza as permissões
FLUSH PRIVILEGES;

-- Criando a tabela employee (precisa ser criada antes para evitar erro de referência)
CREATE TABLE employee (
    Fname VARCHAR(20) NOT NULL,
    Minit CHAR(1),
    Lname VARCHAR(20) NOT NULL,
    Ssn CHAR(9) NOT NULL PRIMARY KEY,
    Bdate DATE,
    Address VARCHAR(100),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    Super_ssn CHAR(9),
    Dno INT NOT NULL
);

-- Criando a tabela department (agora pode referenciar employee)
CREATE TABLE department (
    Dname VARCHAR(50) NOT NULL,
    Dnumber INT NOT NULL PRIMARY KEY,
    Mgr_ssn CHAR(9),
    Mgr_start_date DATE,
    FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Alterando a tabela employee para adicionar a chave estrangeira de Dno (referência a department)
ALTER TABLE employee
ADD CONSTRAINT fk_employee_department FOREIGN KEY (Dno) REFERENCES department(Dnumber) ON DELETE CASCADE ON UPDATE CASCADE;

-- Inserindo os departamentos primeiro
INSERT INTO department (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES
    ('Research', 5, NULL, '1988-05-22'),
    ('Administration', 4, NULL, '1995-01-01'),
    ('Headquarters', 1, NULL, '1981-06-19');

-- Inserindo os gerentes primeiro (sem supervisores)
INSERT INTO employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) 
VALUES 
    ('James', 'E', 'Borg', '888665555', '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1),
    ('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, '888665555', 4),
    ('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, '888665555', 5);

-- Atualizando os gerentes na tabela department
UPDATE department SET Mgr_ssn = '888665555' WHERE Dnumber = 1;
UPDATE department SET Mgr_ssn = '987654321' WHERE Dnumber = 4;
UPDATE department SET Mgr_ssn = '333445555' WHERE Dnumber = 5;

-- Inserindo os funcionários subordinados
INSERT INTO employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) 
VALUES 
    ('John', 'B', 'Smith', '123456789', '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, '333445555', 5),
    ('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, '987654321', 4),
    ('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, '333445555', 5),
    ('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, '333445555', 5),
    ('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, '987654321', 4);

create table dependent(
	Essn char(9) not null,
    Dependent_name varchar(15) not null,
    Sex char,
    Bdate date,
    Relationship varchar(8),
    primary key (Essn, Dependent_name),
    constraint fk_dependent foreign key (Essn) references employee(Ssn)
);
insert into dependent values (333445555, 'Alice', 'F', '1986-04-05', 'Daughter'),
							 (333445555, 'Theodore', 'M', '1983-10-25', 'Son'),
                             (333445555, 'Joy', 'F', '1958-05-03', 'Spouse'),
                             (987654321, 'Abner', 'M', '1942-02-28', 'Spouse'),
                             (123456789, 'Michael', 'M', '1988-01-04', 'Son'),
                             (123456789, 'Alice', 'F', '1988-12-30', 'Daughter'),
                             (123456789, 'Elizabeth', 'F', '1967-05-05', 'Spouse');
                             
create table project(
	Pname varchar(15) not null,
	Pnumber int not null,
    Plocation varchar(15),
    Dnum int not null,
    primary key (Pnumber),
    constraint unique_project unique (Pname),
    constraint fk_project foreign key (Dnum) references department(Dnumber)
);
insert into project values ('ProductX', 1, 'Bellaire', 5),
						   ('ProductY', 2, 'Sugarland', 5),
						   ('ProductZ', 3, 'Houston', 5),
                           ('Computerization', 10, 'Stafford', 4),
                           ('Reorganization', 20, 'Houston', 1),
                           ('Newbenefits', 30, 'Stafford', 4);

create table works_on(
	Essn char(9) not null,
    Pno int not null,
    Hours decimal(3,1) not null,
    primary key (Essn, Pno),
    constraint fk_employee_works_on foreign key (Essn) references employee(Ssn),
    constraint fk_project_works_on foreign key (Pno) references project(Pnumber)
);
                           

insert into works_on values (123456789, 1, 32.5),
							(123456789, 2, 7.5),
                            (666884444, 3, 40.0),
                            (453453453, 1, 20.0),
                            (453453453, 2, 20.0),
                            (333445555, 2, 10.0),
                            (333445555, 3, 10.0),
                            (333445555, 10, 10.0),
                            (333445555, 20, 10.0),
                            (999887777, 30, 30.0),
                            (999887777, 10, 10.0),
                            (987987987, 10, 35.0),
                            (987987987, 30, 5.0),
                            (987654321, 30, 20.0),
                            (987654321, 20, 15.0),
                            (888665555, 20, 0.0);

create table dept_locations(
	Dnumber int not null,
	Dlocation varchar(15) not null,
    constraint pk_dept_locations primary key (Dnumber, Dlocation),
    constraint fk_dept_locations foreign key (Dnumber) references department (Dnumber)
);

insert into dept_locations values (1, 'Houston'),
								 (4, 'Stafford'),
                                 (5, 'Bellaire'),
                                 (5, 'Sugarland'),
                                 (5, 'Houston');
CREATE TABLE employee_dependent (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Relationship VARCHAR(10),
    Bdate DATE,
    CONSTRAINT fk_emp_dep_employee FOREIGN KEY (Essn) REFERENCES employee(Ssn) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_emp_dep_dependent FOREIGN KEY (Essn, Dependent_name) REFERENCES dependent(Essn, Dependent_name) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Inserindo alguns registros simulados
INSERT INTO employee_dependent (Essn, Dependent_name, Relationship, Bdate) VALUES
    ('333445555', 'Alice', 'Daughter', '1986-04-05'),
    ('333445555', 'Theodore', 'Son', '1983-10-25'),
    ('333445555', 'Joy', 'Spouse', '1958-05-03'),
    ('987654321', 'Abner', 'Spouse', '1942-02-28'),
    ('123456789', 'Michael', 'Son', '1988-01-04'),
    ('123456789', 'Alice', 'Daughter', '1988-12-30'),
    ('123456789', 'Elizabeth', 'Spouse', '1967-05-05');

-- Consultas SQL para verificar os dados
SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM dependent;
SELECT * FROM project;
SELECT * FROM works_on;
SELECT * FROM dept_locations;
SELECT * FROM employee_dependent;
show tables;

-- Retornar numero de horas por projetos:

SELECT p.Pname AS Nome_Projeto, SUM(w.Hours) AS Total_Horas
	from works_on w 
    join project p ON w.Pno = p.Pnumber
    group by p.Pname
    order by Total_Horas desc;

-- selecionar colaboradores e seus respectivos departamentos
SELECT e.*, d.Dname AS Nome_Departamento
	from employee e
    join department d ON e.Dno = d.Dnumber
    ;
    
 -- Alterar um determinado atributo de uma instância.    
UPDATE employee
SET Address = REPLACE(Address, 'Fire_Oak', 'FireOak')
WHERE Ssn = '666884444';

-- Retorna informações sobre os colaboradores e seus respectivos departamentos,
SELECT 
    CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Nome_Colaborador,
    e.Ssn AS SSN_Colaborador,
    e.Salary AS Salario_Colaborador,
    d.Dname AS Nome_Departamento,
    CONCAT(g.Fname, ' ', g.Minit, ' ', g.Lname) AS Nome_Gerente,
    g.Ssn AS SSN_Gerente,
    g.Salary AS Salario_Gerente
FROM employee e
LEFT JOIN department d ON e.Dno = d.Dnumber
LEFT JOIN employee g ON e.Super_ssn = g.Ssn;

-- Retorna o nome e a localização dos departamentos, juntamente com o nome do gerente responsável por cada departamento, 
SELECT 
    CONCAT(d.Dname, ' - ', dl.Dlocation) AS Departamento_Localizacao,
    CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Nome_Gerente
FROM department d
JOIN dept_locations dl ON d.Dnumber = dl.Dnumber
LEFT JOIN employee e ON d.Mgr_ssn = e.Ssn;
