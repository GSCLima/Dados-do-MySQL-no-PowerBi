# 📊 Desafio de Projeto DIO - Processamento de Dados Simplificado com Power BI

Este repositório contém um projeto de integração e processamento de dados utilizando **MySQL e Power BI**, com foco na extração, transformação e análise de dados para geração de insights.

## 🚀 Objetivo do Projeto
O objetivo deste projeto é demonstrar o carregamento, transformação e análise de dados de um banco relacional MySQL dentro do Power BI, garantindo a integridade e organização dos dados para visualizações eficientes.

## 🔍 Etapas do Projeto

### 1️⃣ Conexão ao Banco de Dados MySQL via ODBC
A primeira etapa consistiu na configuração da conexão entre o **Power BI** e um banco de dados **MySQL** utilizando o conector **ODBC** para facilitar a extração dos dados.

### 2️⃣ Transformação e Limpeza dos Dados
Após a importação dos dados, aplicamos diversas transformações para garantir consistência e qualidade:
- **Renomeação das colunas** para nomes mais intuitivos.
- **Ajuste dos tipos de dados**, incluindo:
  - Conversão de valores monetários para **decimal**.
  - Ajuste de colunas de soma de horas para o tipo **duração**.
- **Tratamento da coluna de endereço**:
  - Divisão do endereço em colunas separadas utilizando **"-" como delimitador**.
  - Correção de nomes compostos no banco de dados, utilizando a seguinte query:

  ```sql
  UPDATE employee
  SET Address = REPLACE(Address, 'Fire-Oak', 'FireOak')
  WHERE Ssn = '666884444';
  ```

- **Identificação de inconsistências**:
  - Foi encontrado um colaborador sem gerente, porém constatou-se que se trata de um caso específico.

### 3️⃣ Cálculo do Total de Horas por Projeto
Para calcular o total de horas trabalhadas em cada projeto, utilizamos a seguinte consulta SQL:

```sql
SELECT p.Pname AS Nome_Projeto, SUM(w.Hours) AS Total_Horas
FROM works_on w
JOIN project p ON w.Pno = p.Pnumber
GROUP BY p.Pname
ORDER BY Total_Horas DESC;
```

### 4️⃣ Junção de Tabelas para Enriquecimento de Dados

#### 4.1 🔹 Associação de Colaboradores e Departamentos
Para associar cada colaborador ao seu respectivo departamento, utilizamos a seguinte query:

```sql
SELECT e.*, d.Dname AS Nome_Departamento
FROM employee e
JOIN department d ON e.Dno = d.Dnumber;
```

A coluna de **endereço** foi removida dessa tabela, pois já estava disponível em outra transformação.

#### 4.2 🔹 Inclusão dos Gerentes de Cada Colaborador
Para obter o nome dos gerentes de cada colaborador, utilizamos a seguinte consulta SQL:

```sql
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
```

#### 4.3 🔹 Criação de Identificadores Únicos para Departamentos e Localizações
Para garantir que cada combinação **departamento-localização** fosse única, aplicamos a seguinte transformação:

```sql
SELECT
    CONCAT(d.Dname, ' - ', dl.Dlocation) AS Departamento_Localizacao,
    CONCAT(e.Fname, ' ', e.Minit, ' ', e.Lname) AS Nome_Gerente
FROM department d
JOIN dept_locations dl ON d.Dnumber = dl.Dnumber
LEFT JOIN employee e ON d.Mgr_ssn = e.Ssn;
```

## 📌 Conclusão
Com essas transformações, criamos uma base de dados mais limpa e estruturada, pronta para análises e visualizações eficientes dentro do Power BI. Esse processo permite tomadas de decisão mais embasadas e facilita a exploração de insights sobre funcionários, departamentos, projetos e carga de trabalho.

## 🛠 Tecnologias Utilizadas
- **MySQL** para armazenamento e manipulação dos dados
- **Power BI** para conexão, transformação e visualização dos dados
- **ODBC** como conector entre MySQL e Power BI

---

📢 **Se este projeto foi útil para você, não se esqueça de deixar uma ⭐ no repositório!** 🚀

