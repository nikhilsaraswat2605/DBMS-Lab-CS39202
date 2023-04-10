import java.sql.*;
import java.util.Scanner;

public class Assgn3_20CS10039_JAVA {
    // write a function init() to initialize the connection

    static void print_table(ResultSet rs, ResultSetMetaData rsmd) {
        // print data in table format as mysql
        try {
            if (!rs.isBeforeFirst()) {
                System.out.println("Empty Set!");
                return;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        try {
            int columnsNumber = rsmd.getColumnCount();
            // take max width of each column
            int max_width[] = new int[columnsNumber];
            for (int i = 1; i <= columnsNumber; i++) {
                max_width[i - 1] = rsmd.getColumnName(i).length();
            }
            while (rs.next()) {
                for (int i = 1; i <= columnsNumber; i++) {
                    String columnValue = rs.getString(i);
                    if (columnValue.length() > max_width[i - 1]) {
                        max_width[i - 1] = columnValue.length();
                    }
                }
            }
            // set cursor to start
            rs.beforeFirst();
            System.out.print("+");
            for (int i = 1; i <= columnsNumber; i++) {
                for (int j = 0; j < max_width[i - 1] + 1; j++) {
                    System.out.print("-");
                }
                System.out.print("+");
            }
            System.out.print("\n|");
            for (int i = 1; i <= columnsNumber; i++) {
                String columnValue = rsmd.getColumnName(i);
                System.out.printf("%-" + (max_width[i - 1] + 1) + "s|", columnValue);
            }
            System.out.print("\n+");
            for (int i = 1; i <= columnsNumber; i++) {
                for (int j = 0; j < max_width[i - 1] + 1; j++) {
                    System.out.print("-");
                }
                System.out.print("+");
            }
            System.out.println();
            while (rs.next()) {
                System.out.print("|");
                for (int i = 1; i <= columnsNumber; i++) {
                    String columnValue = rs.getString(i);
                    System.out.printf("%-" + (max_width[i - 1] + 1) + "s|", columnValue);
                }
                System.out.println();
            }
            System.out.print("+");
            for (int i = 1; i <= columnsNumber; i++) {
                for (int j = 0; j < max_width[i - 1] + 1; j++) {
                    System.out.print("-");
                }
                System.out.print("+");
            }
            System.out.println();
        } catch (Exception e) {
            System.out.println(e);
        }

    }

    public static void main(String args[]) {
        // initialize the connection
        // init();
        Connection c = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            c = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "Nikhil2002#");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            System.exit(0);
        }
        System.out.println("Opened database successfully");
        try (Scanner sc = new Scanner(System.in)) {
            while (true) {
                {
                    System.out.println("Enter the query number (Enter -1 for exit): ");
                    int query = sc.nextInt();
                    // use if else to execute the query
                    if (query == -1) {
                        break;
                    } else if (query == 1) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician FROM Trained_In, `Procedure` WHERE Trained_In.Treatment = `Procedure`.Code AND `Procedure`.Name = 'bypass surgery')");
                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();

                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 2) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician FROM Trained_In, `Procedure` WHERE Trained_In.Treatment = `Procedure`.Code  AND `Procedure`.Name = 'bypass surgery') AND Physician.EmployeeID IN (SELECT Affiliated_with.Physician FROM Affiliated_with, Department WHERE Affiliated_with.Department = Department.DepartmentID AND Department.Name = 'cardiology')");

                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();

                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 3) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "SELECT Nurse.Name FROM Nurse WHERE Nurse.EmployeeID IN (SELECT On_Call.Nurse FROM On_Call, Room, Block WHERE Room.Number = 123 AND Room.BlockFloor = Block.Floor AND Room.BlockCode = Block.Code AND On_Call.BlockCode = Block.Code AND On_Call.BlockFloor = Block.Floor)");

                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 4) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "SELECT Patient.Name, Patient.Address FROM Patient WHERE Patient.SSN IN (SELECT Prescribes.Patient FROM Prescribes, Medication WHERE Prescribes.Medication = Medication.Code AND Medication.Name = 'remdesivir')");

                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 5) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "SELECT Patient.Name, Patient.InsuranceID FROM Patient WHERE Patient.SSN IN (SELECT Stay.Patient FROM Stay, Room WHERE Stay.Room = Room.Number AND Room.Type = 'icu' AND DATEDIFF(Stay.End, Stay.Start)+1 > 15)");

                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 6) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "SELECT Nurse.Name FROM Nurse WHERE Nurse.EmployeeID IN (SELECT Undergoes.AssistingNurse FROM Undergoes, `Procedure` WHERE Undergoes.`Procedure` = `Procedure`.Code  AND `Procedure`.Name = 'bypass surgery')");

                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 7) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "with Assistance as ( SELECT DISTINCT Undergoes.AssistingNurse, Undergoes.Physician FROM Undergoes, `Procedure` WHERE Undergoes.`Procedure` = `Procedure`.Code  AND `Procedure`.Name = 'bypass surgery' ) SELECT Nurse.Name as Nurse_Name, Nurse.Position, Physician.Name as Physician_Name FROM Nurse, Physician, Assistance WHERE Nurse.EmployeeID = Assistance.AssistingNurse AND Physician.EmployeeID = Assistance.Physician");

                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 8) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (SELECT Undergoes.Physician FROM Undergoes, `Procedure` WHERE Undergoes.`Procedure` = `Procedure`.Code  AND `Procedure`.Code NOT IN (SELECT T.Treatment FROM Trained_In T WHERE T.Physician = Undergoes.Physician))");

                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 9) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (SELECT Undergoes.Physician FROM Undergoes, `Procedure`, Trained_In WHERE Physician.EmployeeID = Undergoes.Physician  AND Undergoes.`Procedure` = `Procedure`.Code  AND `Procedure`.Code = Trained_In.Treatment  AND Trained_In.Physician = Physician.EmployeeID  AND Undergoes.Date > Trained_In.CertificationExpires)");

                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 10) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "with T as (SELECT Physician.EmployeeID as ID, `Procedure`.Name, Undergoes.Date, Patient.Name as Patient_Name FROM Physician, Undergoes, `Procedure`, Trained_In, Patient WHERE Physician.EmployeeID = Undergoes.Physician  AND Undergoes.`Procedure` = `Procedure`.Code  AND `Procedure`.Code = Trained_In.Treatment AND Trained_In.Physician = Physician.EmployeeID  AND Undergoes.Date > Trained_In.CertificationExpires AND Patient.SSN = Undergoes.Patient) SELECT Physician.Name as Physician_Name, T.Name as Procedure_Name, T.Date as Date, T.Patient_Name as Patient_Name FROM Physician, T WHERE Physician.EmployeeID IN (SELECT ID FROM T)");

                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 11) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "SELECT Pt.Name as 'Patient Name', PhPCP.Name as 'Physician Name' FROM Patient Pt, Physician PhPCP WHERE Pt.PCP = PhPCP.EmployeeID AND EXISTS ( SELECT * FROM Prescribes Pr WHERE Pr.Patient = Pt.SSN AND Pr.Physician = Pt.PCP ) AND EXISTS ( SELECT * FROM Undergoes U, `Procedure` Pr WHERE U.`Procedure` = Pr.Code AND U.Patient = Pt.SSN AND Pr.Cost > 5000 ) AND 2 <= ( SELECT COUNT(A.AppointmentID) FROM Appointment A, Physician P, Affiliated_with AWF, Department D WHERE A.Patient = Pt.SSN AND A.Physician = P.EmployeeID AND P.EmployeeID = AWF.Physician AND AWF.Department = D.DepartmentID AND D.Name = 'cardiology' ) AND NOT Pt.PCP IN ( SELECT Head FROM Department )");
                            // print the result
                            ResultSetMetaData rsmd = rs.getMetaData();

                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 12) {
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(
                                    "with T as ( SELECT Medication.Name as Name, Medication.Brand as Brand, COUNT(Prescribes.Patient) as Num_Patients FROM Medication, Prescribes WHERE Medication.Code = Prescribes.Medication GROUP BY Medication.Name, Medication.Brand ) SELECT T.Name, T.Brand FROM T WHERE T.Num_Patients >= ALL (SELECT Num_Patients FROM T)");
                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else if (query == 13) {
                        // take procedure name as input
                        System.out.println("Enter procedure name: ");
                        String procedureName = sc.nextLine();
                        procedureName = sc.nextLine();
                        String sql = "SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician FROM Trained_In, `Procedure` WHERE Trained_In.Treatment = `Procedure`.Code AND `Procedure`.Name = '"
                                + procedureName + "')";
                        try {
                            Statement stmt = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                    ResultSet.CONCUR_UPDATABLE);
                            ResultSet rs = stmt.executeQuery(sql);
                            ResultSetMetaData rsmd = rs.getMetaData();
                            print_table(rs, rsmd);
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println(e.getClass().getName() + ": " + e.getMessage());
                            System.exit(0);
                        }
                    } else {
                        System.out.println("Invalid query number");
                    }
                }

            }
        }

    }
}
