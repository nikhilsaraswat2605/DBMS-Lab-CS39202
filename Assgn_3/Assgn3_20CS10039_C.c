#include <stdio.h>
#include <mysql/mysql.h>
#include <string.h>
// gcc Assgn3_20CS10039_C.c -lmysqlclient
// ./a.out

void print_table(MYSQL_RES *result)
{
    MYSQL_ROW row;
    int num_fields = mysql_num_fields(result);
    MYSQL_FIELD *fields = mysql_fetch_fields(result);

    // check if the table is empty
    if (mysql_num_rows(result) == 0)
    {
        printf("Empty set!\n");
        return;
    }
    // get the max width of each column
    int widths[num_fields];
    for (int i = 0; i < num_fields; i++)
    {
        int width = fields[i].name_length;
        widths[i] = width;
    }
    while ((row = mysql_fetch_row(result)) != NULL)
    {
        for (int i = 0; i < num_fields; i++)
        {
            int width = strlen(row[i]);
            widths[i] = width > widths[i] ? width : widths[i];
        }
    }
    mysql_data_seek(result, 0);

    printf("+");
    for (int i = 0; i < num_fields; i++)
    {
        for (int j = 0; j < widths[i] + 2; j++)
        {
            printf("-");
        }
        printf("+");
    }
    printf("\n|");
    for (int i = 0; i < num_fields; i++)
    {
        printf(" %-*s |", widths[i], fields[i].name);
    }
    printf("\n+");
    for (int i = 0; i < num_fields; i++)
    {
        for (int j = 0; j < widths[i] + 2; j++)
        {
            printf("-");
        }
        printf("+");
    }
    printf("\n");

    while ((row = mysql_fetch_row(result)) != NULL)
    {
        printf("|");
        for (int i = 0; i < num_fields; i++)
        {
            printf(" %-*s |", widths[i], row[i]);
        }
        printf("\n");
    }

    printf("+");
    for (int i = 0; i < num_fields; i++)
    {
        for (int j = 0; j < widths[i] + 2; j++)
        {
            printf("-");
        }
        printf("+");
    }
    printf("\n");

    mysql_free_result(result);
}

int main(int argc, char **argv)
{
    MYSQL *conn;
    MYSQL_RES *result;
    MYSQL_ROW row;

    char *server = "localhost";
    char *user = "root";
    char *password = "Nikhil2002#";
    char *database = "mydb";

    conn = mysql_init(NULL);

    if (!mysql_real_connect(conn, server, user, password, database, 0, NULL, 0))
    {
        fprintf(stderr, "%s\n", mysql_error(conn));
        return 1;
    }
    while (1)
    {
        printf("Enter the query number (Enter -1 for exit): ");
        int query_num;
        scanf("%d", &query_num);
        if (query_num == -1)
        {
            exit(0);
        }
        else if (query_num == 1)
        {
            char *query = "SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician FROM Trained_In, `Procedure` WHERE Trained_In.Treatment = `Procedure`.Code AND `Procedure`.Name = 'bypass surgery')";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 2)
        {
            char *query = "SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician FROM Trained_In, `Procedure` WHERE Trained_In.Treatment = `Procedure`.Code  AND `Procedure`.Name = 'bypass surgery') AND Physician.EmployeeID IN (SELECT Affiliated_with.Physician FROM Affiliated_with, Department WHERE Affiliated_with.Department = Department.DepartmentID AND Department.Name = 'cardiology')";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 3)
        {
            char *query = "SELECT Nurse.Name FROM Nurse WHERE Nurse.EmployeeID IN (SELECT On_Call.Nurse FROM On_Call, Room, Block WHERE Room.Number = 123 AND Room.BlockFloor = Block.Floor AND Room.BlockCode = Block.Code AND On_Call.BlockCode = Block.Code AND On_Call.BlockFloor = Block.Floor)";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 4)
        {
            char *query = "SELECT Patient.Name, Patient.Address FROM Patient WHERE Patient.SSN IN (SELECT Prescribes.Patient FROM Prescribes, Medication WHERE Prescribes.Medication = Medication.Code AND Medication.Name = 'remdesivir')";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 5)
        {
            char *query = "SELECT Patient.Name, Patient.InsuranceID FROM Patient WHERE Patient.SSN IN (SELECT Stay.Patient FROM Stay, Room WHERE Stay.Room = Room.Number AND Room.Type = 'icu' AND DATEDIFF(Stay.End, Stay.Start)+1 > 15)";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 6)
        {
            char *query = "SELECT Nurse.Name FROM Nurse WHERE Nurse.EmployeeID IN (SELECT Undergoes.AssistingNurse FROM Undergoes, `Procedure` WHERE Undergoes.`Procedure` = `Procedure`.Code  AND `Procedure`.Name = 'bypass surgery')";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 7)
        {
            char *query = "with Assistance as ( SELECT DISTINCT Undergoes.AssistingNurse, Undergoes.Physician FROM Undergoes, `Procedure` WHERE Undergoes.`Procedure` = `Procedure`.Code  AND `Procedure`.Name = 'bypass surgery' ) SELECT Nurse.Name as Nurse_Name, Nurse.Position, Physician.Name as Physician_Name FROM Nurse, Physician, Assistance WHERE Nurse.EmployeeID = Assistance.AssistingNurse AND Physician.EmployeeID = Assistance.Physician";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 8)
        {
            char *query = "SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (SELECT Undergoes.Physician FROM Undergoes, `Procedure` WHERE Undergoes.`Procedure` = `Procedure`.Code  AND `Procedure`.Code NOT IN (SELECT T.Treatment FROM Trained_In T WHERE T.Physician = Undergoes.Physician))";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 9)
        {
            char *query = "SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (SELECT Undergoes.Physician FROM Undergoes, `Procedure`, Trained_In WHERE Physician.EmployeeID = Undergoes.Physician  AND Undergoes.`Procedure` = `Procedure`.Code  AND `Procedure`.Code = Trained_In.Treatment  AND Trained_In.Physician = Physician.EmployeeID  AND Undergoes.Date > Trained_In.CertificationExpires)";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 10)
        {
            char *query = "with T as (SELECT Physician.EmployeeID as ID, `Procedure`.Name, Undergoes.Date, Patient.Name as Patient_Name FROM Physician, Undergoes, `Procedure`, Trained_In, Patient WHERE Physician.EmployeeID = Undergoes.Physician  AND Undergoes.`Procedure` = `Procedure`.Code  AND `Procedure`.Code = Trained_In.Treatment AND Trained_In.Physician = Physician.EmployeeID  AND Undergoes.Date > Trained_In.CertificationExpires AND Patient.SSN = Undergoes.Patient) SELECT Physician.Name as Physician_Name, T.Name as Procedure_Name, T.Date as Date, T.Patient_Name as Patient_Name FROM Physician, T WHERE Physician.EmployeeID IN (SELECT ID FROM T)";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 11)
        {
            char *query = "SELECT Pt.Name as 'Patient Name', PhPCP.Name as 'Physician Name' FROM Patient Pt, Physician PhPCP WHERE Pt.PCP = PhPCP.EmployeeID AND EXISTS ( SELECT * FROM Prescribes Pr WHERE Pr.Patient = Pt.SSN AND Pr.Physician = Pt.PCP ) AND EXISTS ( SELECT * FROM Undergoes U, `Procedure` Pr WHERE U.`Procedure` = Pr.Code AND U.Patient = Pt.SSN AND Pr.Cost > 5000 ) AND 2 <= ( SELECT COUNT(A.AppointmentID) FROM Appointment A, Physician P, Affiliated_with AWF, Department D WHERE A.Patient = Pt.SSN AND A.Physician = P.EmployeeID AND P.EmployeeID = AWF.Physician AND AWF.Department = D.DepartmentID AND D.Name = 'cardiology' ) AND NOT Pt.PCP IN ( SELECT Head FROM Department )";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 12)
        {
            char *query = "with T as ( SELECT Medication.Name as Name, Medication.Brand as Brand, COUNT(Prescribes.Patient) as Num_Patients FROM Medication, Prescribes WHERE Medication.Code = Prescribes.Medication GROUP BY Medication.Name, Medication.Brand ) SELECT T.Name, T.Brand FROM T WHERE T.Num_Patients >= ALL (SELECT Num_Patients FROM T)";
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else if (query_num == 13)
        {
            char procedure_name[100];
            printf("Enter procedure name: ");
            // take until newline
            getchar();
            scanf("%[^\n]%*c", procedure_name);
            char query[] = "SELECT Physician.Name FROM Physician WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician FROM Trained_In, `Procedure` WHERE Trained_In.Treatment = `Procedure`.Code AND `Procedure`.Name = '";
            strcat(query, procedure_name);
            strcat(query, "')");
            if (mysql_query(conn, query))
            {
                fprintf(stderr, "%s", mysql_error(conn));
                return 1;
            }
            result = mysql_store_result(conn);
            print_table(result);
        }
        else
        {
            printf("Invalid query number\n");
        }
    }

    mysql_close(conn);

    return 0;
}
