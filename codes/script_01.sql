-- Retrieve all courses and teachers assigned to student James Anderson.
SELECT 
    s.StudentID,
    s.Name AS StudentName,
    c.CourseName,
    t.TeacherName
FROM Student s
JOIN ENROLLMENT e
ON s.StudentID = e.StudentID
JOIN COURSES c
ON c.COURSEID = e.COURSEID
JOIN TEACHERS t
ON t.TEACHERID = c.TEACHERID
where s.NAME = 'James Anderson'
order by s.STUDENTID;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Total student for each teacher 

SELECT t.TeacherName, count(*) As TotalStudent
FROM TEACHERS t
JOIN COURSES c
ON t.TEACHERID = c.TEACHERID
JOIN ENROLLMENT e 
ON c.COURSEID = e.COURSEID
JOIN STUDENT s 
ON e.STUDENTID = s.STUDENTID
Group BY t.TEACHERNAME;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Select all student who are either in Amanda Lee or Steven Green's class 
SELECT s.StudentID, s.Name, t.TEACHERNAME
FROM STUDENT s 
JOIN ENROLLMENT e 
ON s.STUDENTID = e.STUDENTID
JOIN COURSES c 
ON e.COURSEID = c.COURSEID
JOIN TEACHERS t 
ON c.TEACHERID = t.TEACHERID
where t.TEACHERNAME IN ('Amanda Lee', 'Steven Green')
GROUP BY s.STUDENTID, s.NAME, t.TEACHERNAME
ORDER BY t.TEACHERNAME;

-------------------------------------------------------------------------------------------------------------------------------------------

--Retrieve the StudentID, Name, GradeLevel, and GPA of all students.

SELECT StudentID, Name, Gradelevel, GPA
FROM Student;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find all students in Grade 10. 

SELECT *
FROM Student
WHERE GradeLevel = 10;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find students who have a GPA greater than 3.5 and an AttendanceRate greater than 95%. 

SELECT *
FROM Student
WHERE GPA > 3.5 AND Attendancerate > 95;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Retrieve all students and sort them by GPA from highest to lowest.

SELECT *
FROM Student
ORDER BY GPA DESC;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find all distinct grade levels represented in the Student table.

SELECT DISTINCT GradeLevel
FROM Student;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find all students whose names start with the letter J. 

SELECT *
FROM Student
WHERE Name LIKE 'J%';

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find students whose GPA is between 3.0 and 3.5. 

SELECT *
FROM Student
WHERE GPA BETWEEN 3.0 AND 3.5;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the total number of students. 

SELECT COUNT(DISTINCT StudentID) AS NumStudent
FROM Student;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the number of students in each grade level. 

SELECT GradeLevel, COUNT(*) AS TotalStudent
FROM Student
GROUP BY GradeLevel;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average GPA for each grade level.
SELECT GradeLevel, AVG(GPA) AS Avg_GPA
FROM Student
GROUP BY GradeLevel;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average GPA for male and female students.

SELECT Gender, AVG(GPA) AS Avg_GPA
FROM Student
GROUP BY Gender;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the average attendance rate for each grade level. 

SELECT GradeLevel, AVG(AttendanceRate)
FROM Student
GROUP BY GradeLevel;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Count how many students participate in extracurricular activities and how many do not.

SELECT Extracurricular, COUNT(*) AS TotalStudent
FROM Student 
GROUP BY EXTRACURRICULAR;

-- OR
SELECT Extracurricular, COUNT(DISTINCT StudentID) AS TotalStudent
FROM Student
GROUP BY Extracurricular;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find grade levels where the average GPA is greater than 3.5.

SELECT GradeLevel, ROUND(AVG(GPA), 2) AS AVERAGE
FROM Student
Group BY GradeLevel
HAVING AVG(GPA) > 3.5;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the student(s) with the highest GPA.

SELECT StudentID, Name, MAX(GPA) AS Max_GPA
FROM Student
WHERE GPA = (SELECT MAX(GPA)
		  FROM Student)
GROUP BY StudentID, Name;

--OR
SELECT StudentID, Name
FROM Student
WHERE GPA = (SELECT MAX(GPA)
	     FROM Student);


-- Oracle
SELECT *
FROM Student
ORDER BY AttendanceRate
FETCH FIRST 10 ROWS ONLY;


-- MySQL 
SELECT *
FROM Student
ORDER BY AttendanceRate
LIMIT 10;


-- SQL Server
SELECT TOP 10 *
FROM Student
ORDER BY AttendanceRate;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Retrieve each student's name and the courses they are enrolled in.

SELECT Name, CourseID
FROM Student s
JOIN Enrollment e
ON s.StudentID = e.StudentID;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Retrieve each student's name and the total number of courses they are enrolled in.

SELECT Name, COUNT(CourseID)
FROM Student s 
JOIN ENROLLMENT e 
ON s.StudentID = e.StudentID
GROUP BY Name;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Retrieve each course along with the teacher assigned to it.

SELECT CourseName, TeacherName
From Courses c
JOIN Teachers t
ON c.TeacherID = t.TeacherID;

-------------------------------------------------------------------------------------------------------------------------------------------

/*
    Retrieve:

        Student Name
        Course Name
        Teacher Name 
*/
SELECT Name AS StudentName, CourseName, TeacherName
FROM Student s
JOIN Enrollment e
ON s.StudentID = e.StudentID
JOIN Courses c
ON e.CourseID = c.CourseID
JOIN Teachers t
ON c.TeacherID = t.TeacherID;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Retrieve all courses and teachers assigned to James Anderson.

SELECT *
FROM Courses c
JOIN Teachers t
ON c.TeacherID = t.TeacherID
WHERE t.TeacherName = 'Matthew Walker';

--OR 
SELECT *
FROM Courses c, Teachers t
WHERE c.TeacherId = t.TeacherID AND t.TeacherName = 'Matthew Walker';

-------------------------------------------------------------------------------------------------------------------------------------------