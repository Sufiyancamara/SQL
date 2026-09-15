-- I need a report showing all students who were absent more than 4 days.

SELECT name, s.STUDENTID, COUNT(*)
FROM student s
JOIN attendance a 
ON s.StudentID = a.StudentID
WHERE STATUS = 'Absent' --AND Count(*) > 4
GROUP BY name, s.StudentID
HAVING COUNT(*) > 4;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find how many students are assigned to each teacher through their courses.

SELECT TEACHERNAME, COUNT(*) AS STUDENT
FROM Student s 
JOIN ENROLLMENT e
ON s.studentID = e.studentID
JOIN COURSES c 
ON e.COURSEID = c.COURSEID
JOIN TEACHERS t
ON t.TeacherID = c.TEACHERID
GROUP BY TEACHERNAME;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the number of students enrolled in each course.
SELECT c.CourseName, COUNT(*) AS Students
FROM Student s 
JOIN ENROLLMENT e 
ON s.studentID = e.studentID
JOIN Courses c
on e.CourseID = c.CourseID
GROUP BY c.CourseName;



-- Find Students who have assessment record.

SELECT s.studentID, Name, assessmenttype
FROM Student s 
LEFT JOIN assessments a 
ON s.studentID = a.studentID
WHERE s.studentID IS NOT NULL
GROUP BY name, s.studentID, assessmenttype;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the course with the highest number of enrolled students

SELECT CourseName, COUNT(*) AS TOtalStudent
FROM COURSES c
JOIN ENROLLMENT e
ON c.CourseID = e.CourseID
JOIN Student s 
ON e.studentID = s.studentID
GROUP BY CourseName
ORDER BY TotalStudent DESC
FETCH FIRST 1 ROWS ONLY;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find all students taking courses taught by Robert Anderson.

SELECT *
FROM Student s, Enrollment e, courses c, teachers t
WHERE (s.studentID = e.studentID AND e.CourseID = c.CourseID AND  c.TeacherID = t.TeacherID)
AND TeacherName = 'Robert Anderson';

-------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average FinalGrade for each course.

SELECT CourseName, ROUND(AVG(FINALGRADE), 2) AS Average
FROM COURSES c
JOIN ENROLLMENT e 
ON c.COURSEID = e.COURSEID
GROUP BY CourseName;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the course with the highest average final grade.

SELECT CourseName, ROUND(AVG(FINALGRADE), 2) AS highestAverage
FROM Courses c
JOIN ENROLLMENT e 
ON c.COURSEID = e.COURSEID
GROUP BY CourseName
ORDER BY highestAverage DESC
FETCH FIRST 1 ROWS ONLY;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average final grade for each teacher.

SELECT TeacherName, ROUND(AVG(FINALGRADE), 2) AS AvgFinalGrade
FROM Enrollment e, Courses c, Teachers t 
WHERE e.CourseID = c.CourseID AND c.TeacherID = t.TeacherID
GROUP BY TeacherName;

-------------------------------------------------------------------------------------------------------------------------------------------

-- alculate the average final grade for each student across all their courses.

SELECT s.studentID AS "Student ID", Name AS "Student Name", ROUND(Avg(FINALGRADE), 2) AS "Average Final Grade"
FROM Student s 
JOIN Enrollment e 
ON s.studentID = e.studentID
JOIN courses c 
ON e.CourseID = c.CourseID
GROUP BY s.studentID, Name
ORDER BY s.studentID, Name;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the top 10 students based on their average FinalGrade.

SELECT s.studentID, Name, Round(AVG(FinalGrade), 2) AS "Average Student Grade"
FROM Student s, ENROLLMENT e, Courses c 
WHERE s.StudentID = e.StudentID AND e.CourseID = c.CourseID
GROUP BY s.studentID, name
ORDER BY AVG(FinalGrade) DESC
FETCH NEXT 10 ROWS ONLY;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Retrieve Student Name, GPA and Average Final Grade for every student.

SELECT s.STUDENTID, name AS "Student Name", GPA, ROUND(Avg(FinalGrade), 2) AS "Average Final Grade"
FROM Student s, ENROLLMENT e 
WHERE s.studentID = e.studentID
GROUP BY S.studentID, name, GPA;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Retrieve all assessments for James Anderson.

SELECT s.studentID, Name, assessmenttype
FROM Student s 
JOIN assessments a
ON s.studentID = a.studentID
GROUP BY s.studentID, name, assessmenttype;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average assessment score for each student.

SELECT s.studentID AS "Student ID", name AS "Student Name", ROUND(AVG(score), 2) AS "Average SCore"
FROM Student s, assessments a 
WHERE s.studentID = a.studentID
GROUP BY s.studentID, name;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average score for Quiz, Test, Project, and Final Exam.

SELECT assessmenttype AS assessments, Round(Avg(score), 2) AS "Average Score"
FROM assessments
GROUP BY assessmenttype;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the student who received the highest assessment score.

SELECT s.STUDENTID, name, SCORE
FROM Student s, assessments a 
WHERE s.studentID = a.studentID AND 
score = ( SELECT Max(Score)
          FROM assessments);

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the average assessment score for each course.

SELECT CourseName AS "Course Name", ROUND(AVG(score), 2) AS "Average Score"
FROM COURSES c 
JOIN assessments a
ON c.CourseID = a.COURSEID
GROUP BY CourseName;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average assessment score for each teacher.

SELECT TeacherName AS "Teacher Name", ROUND(AVG(Score), 2) AS "Average SCore"
FROM assessments a, courses c, teachers t 
WHERE a.CourseID = c.CourseID AND c.TeacherID = t.TeacherID
GROUP BY TeacherName;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Count how many Present, Absent, and Late records exist.

SELECT status, COUNT(*)
FROM attendance
GROUP BY status;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Retrieve all attendance records for James Anderson.

SELECT * 
FROM attendance
WHERE studentID IN (SELECT studentID
                    FROM Student 
                    WHERE name = 'James Anderson')
ORDER BY studentID;

-------------------------------------------------------------------------------------------------------------------------------------------

/* 
    Calculate each student's attendance percentage based on the Attendance table
    rather than using the Student.AttendanceRate column.
 */

SELECT StudentID,
        COUNT(*) AS TotalAttendance,
        COUNT(CASE WHEN Status='Present' THEN 1 END) AS Days_Present,
        ROUND((COUNT(CASE WHEN Status='Present' THEN 1 END) / COUNT(*)), 2) * 100 AS "Attendance Rate"
FROM Attendance
GROUP BY StudentID;

-------------------------------------------------------------------------------------------------------------------------------------------

/* Display and compare the two values:

   Student Name
   Stored AttendanceRate
   Calculated AttendanceRate

*/

SELECT  s.StudentID, 
        Name AS "Student Name", 
        COUNT(*) AS TOtalAttendance,
        COUNT(CASE WHEN Status='Present' THEN 1 END) AS DaysPresent,
        s.AttendanceRate AS "Stored AttendanceRate",
        ROUND((COUNT(CASE WHEN Status='Present' THEN 1 END) / COUNT(*) * 100), 2) AS "Calculated AttendanceRate"
FROM Student s, Attendance a 
WHERE s.studentID = a.studentID
GROUP BY s.StudentID, s.AttendanceRate, Name;

-------------------------------------------------------------------------------------------------------------------------------------------