import mysql.connector
import prettytable


def print_query_result(query, conn):
    # print formatted query result
    cursor = conn.cursor()
    cursor.execute(query)
    result = cursor.fetchall()
    if len(result) == 0:
        print("Empty set!")
        return
    table = prettytable.PrettyTable()
    table.field_names = [i[0] for i in cursor.description]
    for row in result:
        table.add_row(row)
    print(table)


def main():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            database="mydb",
            user="root",
            password="Nikhil2002#"
        )
        print("Connection successful")
    except Exception as e:
        print("Connection failed due to ", e)
        return
    while True:
        inp = input("Enter Query number (Enter -1 for exit): ")
        # use switch case to call the function
        query = ""
        if inp == "-1":
            exit()
        if inp == "1":
            query = """SELECT Physician.Name
                        FROM Physician
                        WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician
                                                            FROM Trained_In, `Procedure`
                                                            WHERE Trained_In.Treatment = `Procedure`.Code 
                                                            AND `Procedure`.Name = 'bypass surgery');"""
        elif inp == "2":
            query = """SELECT Physician.Name
                        FROM Physician
                        WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician
                                                        FROM Trained_In, `Procedure`
                                                        WHERE Trained_In.Treatment = `Procedure`.Code 
                                                            AND `Procedure`.Name = 'bypass surgery')
                            AND Physician.EmployeeID IN (SELECT Affiliated_with.Physician
                                                            FROM Affiliated_with, Department
                                                            WHERE Affiliated_with.Department = Department.DepartmentID
                                                                AND Department.Name = 'cardiology')"""
        elif inp == "3":
            query = """SELECT Nurse.Name
                        FROM Nurse
                        WHERE Nurse.EmployeeID IN (SELECT On_Call.Nurse
                                                    FROM On_Call, Room, Block
                                                    WHERE Room.Number = 123
                                                        AND Room.BlockFloor = Block.Floor
                                                        AND Room.BlockCode = Block.Code
                                                        AND On_Call.BlockCode = Block.Code
                                                        AND On_Call.BlockFloor = Block.Floor);"""
        elif inp == "4":
            query = """SELECT Patient.Name, Patient.Address
                        FROM Patient
                        WHERE Patient.SSN IN (SELECT Prescribes.Patient
                                                FROM Prescribes, Medication
                                                WHERE Prescribes.Medication = Medication.Code
                                                    AND Medication.Name = 'remdesivir')"""
        elif inp == "5":
            query = """SELECT Patient.Name, Patient.InsuranceID
                        FROM Patient
                        WHERE Patient.SSN IN (SELECT Stay.Patient
                                                FROM Stay, Room
                                                WHERE Stay.Room = Room.Number
                                                    AND Room.Type = 'icu'
                                                    AND DATEDIFF(Stay.End, Stay.Start)+1 > 15)"""
        elif inp == "6":
            query = """SELECT Nurse.Name
                        FROM Nurse
                        WHERE Nurse.EmployeeID IN (SELECT Undergoes.AssistingNurse
                                                    FROM Undergoes, `Procedure`
                                                    WHERE Undergoes.`Procedure` = `Procedure`.Code 
                                                        AND `Procedure`.Name = 'bypass surgery')"""
        elif inp == "7":
            query = """with Assistance as (
                        SELECT DISTINCT Undergoes.AssistingNurse, Undergoes.Physician
                        FROM Undergoes, `Procedure`
                        WHERE Undergoes.`Procedure` = `Procedure`.Code 
                            AND `Procedure`.Name = 'bypass surgery'
                    )
                    SELECT Nurse.Name as Nurse_Name, Nurse.Position, Physician.Name as Physician_Name
                    FROM Nurse, Physician, Assistance
                    WHERE Nurse.EmployeeID = Assistance.AssistingNurse
                        AND Physician.EmployeeID = Assistance.Physician"""
        elif inp == "8":
            query = """SELECT Physician.Name
                        FROM Physician
                        WHERE Physician.EmployeeID IN (SELECT Undergoes.Physician
                                                        FROM Undergoes, `Procedure`
                                                        WHERE Undergoes.`Procedure` = `Procedure`.Code 
                                                            AND `Procedure`.Code NOT IN (SELECT T.Treatment FROM Trained_In T WHERE T.Physician = Undergoes.Physician))"""
        elif inp == "9":
            query = """SELECT Physician.Name
                        FROM Physician
                        WHERE Physician.EmployeeID IN (SELECT Undergoes.Physician
                                                        FROM Undergoes, `Procedure`, Trained_In
                                                        WHERE Physician.EmployeeID = Undergoes.Physician 
                                                            AND Undergoes.`Procedure` = `Procedure`.Code 
                                                            AND `Procedure`.Code = Trained_In.Treatment 
                                                            AND Trained_In.Physician = Physician.EmployeeID 
                                                            AND Undergoes.Date > Trained_In.CertificationExpires)"""
        elif inp == "10":
            query = """with T as (SELECT Physician.EmployeeID as ID, `Procedure`.Name, Undergoes.Date, Patient.Name as Patient_Name
                        FROM Physician, Undergoes, `Procedure`, Trained_In, Patient
                        WHERE Physician.EmployeeID = Undergoes.Physician 
                            AND Undergoes.`Procedure` = `Procedure`.Code 
                            AND `Procedure`.Code = Trained_In.Treatment
                            AND Trained_In.Physician = Physician.EmployeeID 
                            AND Undergoes.Date > Trained_In.CertificationExpires
                            AND Patient.SSN = Undergoes.Patient)
                        SELECT Physician.Name as Physician_Name, T.Name as Procedure_Name, T.Date as Date, T.Patient_Name as Patient_Name
                        FROM Physician, T
                        WHERE Physician.EmployeeID IN (SELECT ID FROM T)"""
        elif inp == "11":
            query = """SELECT Pt.Name as 'Patient Name', PhPCP.Name as 'Physician Name' FROM Patient Pt, Physician PhPCP
                        WHERE Pt.PCP = PhPCP.EmployeeID
                        AND EXISTS
                            (
                                SELECT * FROM Prescribes Pr
                                WHERE Pr.Patient = Pt.SSN
                                    AND Pr.Physician = Pt.PCP
                            )
                        AND EXISTS
                            (
                                SELECT * FROM Undergoes U, `Procedure` Pr
                                WHERE U.`Procedure` = Pr.Code
                                    AND U.Patient = Pt.SSN
                                    AND Pr.Cost > 5000
                            )
                        AND 2 <=
                            (
                                SELECT COUNT(A.AppointmentID) FROM Appointment A, Physician P, Affiliated_with AWF, Department D
                                WHERE A.Patient = Pt.SSN
                                    AND A.Physician = P.EmployeeID
                                    AND P.EmployeeID = AWF.Physician
                                    AND AWF.Department = D.DepartmentID
                                    AND D.Name = 'cardiology'
                            )
                        AND NOT Pt.PCP IN
                            (
                                SELECT Head FROM Department
                            )"""
        elif inp == "12":
            query = """with T as (
                        SELECT Medication.Name as Name, Medication.Brand as Brand, COUNT(Prescribes.Patient) as Num_Patients
                        FROM Medication, Prescribes
                        WHERE Medication.Code = Prescribes.Medication
                        GROUP BY Medication.Name, Medication.Brand
                    )
                    SELECT T.Name, T.Brand
                    FROM T
                    WHERE T.Num_Patients >= ALL (SELECT Num_Patients FROM T)"""

        elif inp == "13":
            procedure = input("Enter procedure name: ")
            query = f"""SELECT Physician.Name
                        FROM Physician
                        WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician
                                                            FROM Trained_In, `Procedure`
                                                            WHERE Trained_In.Treatment = `Procedure`.Code 
                                                            AND `Procedure`.Name = '{procedure}');"""
        else:
            print("Invalid input")
            continue
        # try:
        #     cursor = conn.cursor()
        #     cursor.execute(query)
        #     # fetch all attributes
        #     attr = [desc[0] for desc in cursor.description]
        #     # print(attr)
        #     rows = cursor.fetchall()
        #     for row in rows:
        #         for i in range(len(row)):
        #             print(attr[i] + ": " + str(row[i]), end=", ")
        #         print()
        # except Exception as e:
        #     print(e)
        #     print("Error: unable to fetch data")
        print_query_result(query, conn)


if __name__ == "__main__":
    main()
