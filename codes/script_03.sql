                                           /*
                                                        By Sufiyan Camara
                                                        Date: 04/20/2026
                                                                                        */


-- Find students whose calculated attendance rate is below 90%.

SELECT s.studentID,
        Name,
        COUNT(*),
        COUNT(CASE WHEN Status='Present' THEN 1 END) AS "Day Attended",
        ROUND(COUNT(CASE WHEN Status = 'Present' THEN 1 END) / COUNT(*) * 100, 2) AS Calculated_AttendanceRate
FROM Student s
JOIN Attendance a 
ON s.studentID = a.studentID
GROUP BY s.studentID, Name
HAVING Calculated_AttendanceRate < 90;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the student with the highest GPA in each grade level.

SELECT StudentID, 
    Name, GradeLevel,  
    MAX(GPA) AS "Highest GPA"
FROM Student
WHERE GPA = (SELECT MAX(GPA)
             FROM Student)
GROUP BY StudentID, Name, GradeLevel
ORDER BY GradeLevel;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the student with the highest FinalGrade in every course.

SELECT s.StudentID, 
    Name AS "Student Name", 
    CourseName AS "Course Name", 
    MAX(FinalGrade) AS "Highest Final Grade"
FROM Student s 
JOIN Enrollment e 
ON s.studentID = e.studentID 
JOIN Courses c 
ON e.CourseID = c.CourseID
WHERE FinalGrade IN ( SELECT MAX(FinalGrade)
                     FROM ENROLLMENT
                     GROUP BY CourseID)
GROUP BY s.studentID, Name, CourseName
ORDER BY CourseName;

-------------------------------------------------------------------------------------------------------------------------------------------

-- Find the teacher whose students have the highest average FinalGrade.

SELECT TeacherName, 
       ROUND(AVG(FinalGrade), 2) AS HighestAvg_FinalGrade
FROM Teachers t
JOIN Courses c 
ON t.TeacherId = c.TeacherID
JOIN ENROLLMENT e 
ON c.CourseID = e.CourseID
GROUP BY t.TeacherID, TeacherName
ORDER BY HighestAvg_FinalGrade DESC
FETCH NEXT 1 ROWS ONLY;

-------------------------------------------------------------------------------------------------------------------------------------------

/*  
    Students taking multiple courses
    Find students enrolled in more 5 or more courses.
*/

SELECT s.StudentID AS "Student ID", 
    Name As "Student Name", 
    COUNT(c.CourseID) AS "Number Of Courses"
FROM Student s 
JOIN Enrollment e 
ON s.studentID = e.studentID
JOIN Courses c 
ON e.CourseID = c.CourseID
GROUP BY s.studentID, name
HAVING COUNT(c.CourseID) >= 5;

-------------------------------------------------------------------------------------------------------------------------------------------

/* 
    Students with excellent performance
    Find students who have:

    GPA >= 3.8
    AND AttendanceRate >= 95
    AND Average FinalGrade >= 84
*/

SELECT s.StudentID,
        Name,
        GPA,
        AttendanceRate,
        ROUND(AVG(FinalGrade), 2) AS Average_FinalGrade
FROM Student s 
JOIN Enrollment e 
ON s.StudentID = e.StudentID
GROUP BY s.StudentID, Name, GPA, AttendanceRate
HAVING GPA > 3.8 AND 
       AttendanceRate >= 95 AND 
       Average_FinalGrade >= 84;

-------------------------------------------------------------------------------------------------------------------------------------------

/*

    Create a ranking based on a combination of:
    GPA
    Average FinalGrade
    AttendanceRate
*/

SELECT s.StudentID,
        Name,
        GPA,
        ROUND(AVG(FinalGrade), 2) AS Average_FinalGrade,
        AttendanceRate       
FROM Student s 
JOIN Enrollment e 
ON s.StudentID = e.StudentID
GROUP BY s.StudentID, Name, GPA, AttendanceRate
ORDER BY GPA DESC, Average_FinalGrade DESC,AttendanceRate DESC;

-------------------------------------------------------------------------------------------------------------------------------------------

/*
    Course difficulty
    Find courses where the average final grade is below 70.
*/
SELECT  CourseName AS "Course Name",
        ROUND(AVG(FinalGrade), 2) AS Average_FinalGrade
FROM Courses c 
JOIN Enrollment e 
ON c.CourseID = e.CourseID
GROUP BY CourseName
HAVING Average_FinalGrade < 70;

-------------------------------------------------------------------------------------------------------------------------------------------

/*
    Teacher workload ranking
    Rank teachers from highest to lowest based on the number of students they teach.
*/

SELECT  t.TeacherID AS "Teacher ID", 
        TeacherName AS "TEacher Name",
        COUNT(e.StudentID) AS "Total Students"
FROM Teachers t 
JOIN Courses c
ON t.TeacherID = c.TeacherID
JOIN Enrollment e
ON c.CourseID = e.CourseID
GROUP BY t.TeacherID, TeacherName
ORDER BY "Total Students" DESC;

-------------------------------------------------------------------------------------------------------------------------------------------

/*
    Student report card
    For a given student, produce a report containing:

    Student Name
    Grade Level
    GPA
    Attendance Rate
    Course
    Teacher
    Final Grade
    Average Assessment Score
*/

SELECT  Name,
        s.GradeLevel,
        s.GPA,
        s.AttendanceRate,
        c.CourseName,
        t.TeacherName,
        e.FinalGrade,
        AVG(Score)
FROM Student s, 
     Assessments a, 
     Attendance at, 
     Enrollment e,
     Courses c,
     Teachers t 
Where (s.StudentID = a.StudentID AND 
      s.studentID = e.StudentID AND 
      e.CourseID = c.CourseID AND 
      c.TeacherID = t.TeacherID) AND
      s.StudentID = 'ST00101'
GROUP BY s.StudentId,
         Name,
         s.GradeLevel,
         GPA,
         AttendanceRate,
         CourseName,
         TeacherName,
         FinalGrade;


--OR


SELECT  Name,
        s.GradeLevel,
        s.GPA,
        AttendanceRate,
        c.CourseName,
        t.TeacherName,
        e.FinalGrade,
        AVG(Score)
FROM Student s
JOIN Enrollment e 
ON s.StudentID = e.StudentID
JOIN Courses c 
ON e.CourseID = c.CourseID
JOIN Teachers t 
ON c.TeacherID = t.TeacherID
LEFT JOIN assessments a
ON s.StudentID = a.StudentID AND c.CourseID = a.CourseID
WHERE s.StudentID = 'ST00106'
GROUP BY s.StudentId,
         Name,
         s.GradeLevel,
         GPA,
         AttendanceRate,
         CourseName,
         TeacherName,
         FinalGrade;

-------------------------------------------------------------------------------------------------------------------------------------------

/*
    Write a SQL query that displays every student's name, the course they are enrolled in, and the teacher who teaches that course.

    Expected columns:

        StudentName | CourseName | TeacherName
*/

SELECT  Name AS StudentName,
        CourseName,
        TeacherName
FROM Student s, Enrollment e, Courses c, Teachers t
WHERE s.StudentID = e.StudentID AND 
      e.CourseID = c.CourseID AND 
      c.TeacherID = t.TeacherID;


-------------------------------------------------------------------------------------------------------------------------------------------
