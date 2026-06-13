COMPANY: CODTECH IT SOLUTIONS

NAME: SOLOMON SHYAM RAJ

INTERN ID: CTIS9521

DURATION: 6 WEEKS

MENTOR: NEELA SANTOSH

# TASK 2 — Data Analysis with Complex SQL Queries
Overview
This task is part of the CODTECH IT Solutions SQL Internship program. The goal of this task is to perform advanced data analysis on a Student Placement System database using three powerful SQL techniques — Subqueries, Window Functions, and Common Table Expressions (CTEs). The database contains information about students, companies, job postings, applications, and placements. Using complex SQL queries, meaningful trends and patterns are discovered from this data and presented as an analytics report.

What This Task Does
The entire task is divided into three sections — Section A covers Subqueries, Section B covers Window Functions, and Section C covers CTEs. Each section solves a real-world analytical problem using the placement database.

Section A — Subqueries
A subquery is a query written inside another query. It is used when the answer to one question depends on the result of another question.
The first query in this section finds all students whose CGPA is above the average CGPA of the entire batch. The inner query calculates the average CGPA first, and the outer query then uses that result to filter students. This is useful for shortlisting high-performing students quickly.

<img width="357" height="110" alt="Image" src="https://github.com/user-attachments/assets/e3fd21e1-212c-49fe-8512-a5eb4ad4e4c6" />

The second query uses an EXISTS subquery to find students who have already been placed. Instead of joining tables directly, it checks whether a matching record exists in the Placements table for each student. This is a more efficient approach when you only need to check for the presence of a record rather than retrieve data from it.

<img width="369" height="106" alt="Image" src="https://github.com/user-attachments/assets/d36bfce8-d247-44fe-a550-434f03d4306b" />

The third query is a correlated subquery that finds the company offering the highest salary package. It uses MAX() inside the WHERE clause to compare each placement record against the overall maximum salary. This helps identify the top-paying company in the current hiring cycle.

<img width="312" height="74" alt="Image" src="https://github.com/user-attachments/assets/9c1373a4-4306-45a2-b80a-bc0ea9f5a940" />

Section B — Window Functions
Window functions perform calculations across a set of related rows without collapsing them into a single result like GROUP BY does. Each row keeps its own identity while also getting an additional calculated value.
The first window function ranks students by CGPA within their own branch using RANK(), DENSE_RANK(), and ROW_NUMBER(). RANK() leaves gaps after ties, DENSE_RANK() does not leave gaps, and ROW_NUMBER() always gives a unique number. This helps placement officers see who the top student is in each branch separately rather than comparing across all branches together.

<img width="580" height="163" alt="Image" src="https://github.com/user-attachments/assets/ff5ebaa8-d1e7-4dd4-860c-3be05b67c40d" />

The second window function calculates a running total of applications over time. As each new application comes in day by day, the count keeps adding up. This shows the growth trend of applications during the placement season and helps identify whether students are applying early or leaving it to the last minute.

<img width="542" height="163" alt="image" src="https://github.com/user-attachments/assets/168bc9ac-7cb8-4e71-845f-61ef0dfd2a45" />

The third window function compares each placed student's salary against the average salary offered by their company. This reveals whether a student was offered above or below the company's average package, which is useful for salary fairness analysis.

<img width="588" height="82" alt="image" src="https://github.com/user-attachments/assets/26123bf6-3d6f-44bf-8d9f-b606bd5833ff" />

Section C — Common Table Expressions (CTEs)
A CTE is a temporary named result set that you define at the beginning of a query using the WITH keyword. It makes complex queries easier to read, understand, and maintain by breaking them into smaller logical steps.
The first CTE calculates the branch-wise placement rate. It uses two separate CTEs — one to count total students per branch and another to count placed students per branch — and then joins them together to calculate the placement percentage. This clearly shows which branch is performing best in placements.

<img width="447" height="106" alt="image" src="https://github.com/user-attachments/assets/3b4528ff-8920-4738-85af-0c396a8a6002" />


The second CTE combines with a Window Function to find the top applicant at each company. It counts how many applications each student submitted to each company, ranks them, and then filters only the top-ranked student per company. This is helpful for companies to identify the most interested candidates.

<img width="278" height="102" alt="image" src="https://github.com/user-attachments/assets/2974ca37-520d-484d-a650-deb74c666b02" />


The third CTE performs an application funnel analysis. It breaks down all applications by their current status — Hired, Shortlisted, Pending, or Rejected — and calculates what percentage of total applications fall into each category. A simple bar chart is also generated using the RPAD function to visually represent the funnel, making the data easier to interpret at a glance.

<img width="300" height="95" alt="image" src="https://github.com/user-attachments/assets/71ed0450-cb46-44c4-aceb-c7c69fefb4b8" />


# Report Summary
At the end of the file, a written analytics report summarizes all the key findings from the queries. The report covers total students, total applications, overall placement percentage, highest CGPA, highest salary package, top branch, application trend, and top hiring company. Key patterns are also highlighted — for example, all placements in this cycle came from the Computer Science branch, and students with a CGPA above 8.5 were more likely to get hired.# DATA-ANALYSIS-WITH-COMPLEX-QUERIES
