


CREATE TABLE `employee` (
  `EMPLOYEEID` int NOT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `FIRSTNAME` varchar(60) DEFAULT NULL,
  `LASTNAME` varchar(60) DEFAULT NULL,
  `HIREDATE` date DEFAULT NULL,
  `ROLE` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EMPLOYEEID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;

INSERT INTO `employee` VALUES (1,'ANUSURYA','ANU','SURYA','2023-10-11','Human resirce'),(2,'GOVIND NAIK','GOVIND','NAIK','2022-11-02','Sales Representative'),(3,'ANUSURYA','ANU','SURYA','2021-02-20','Human resirce'),(4,'ANUSURYA','ANU','SURYA','2022-02-16','Human resirce'),(5,'ANISHA NAIK','ANISHA','NAIK','2022-12-11','Sales Representative'),(6,'ANISHA REDDY','ANISHA','REDDY','2022-07-21','Sales Representative'),(7,'GOVIND NAIK','GOVIND','NAIK','2022-03-29','Sales Representative');

