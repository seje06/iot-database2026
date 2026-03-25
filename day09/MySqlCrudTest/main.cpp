// MySQL CRUD

#define NOMINMAX
#include <iostream>
#include <mysql.h>
#include <Windows.h>
#include <clocale>
#include <string>
#include <limits>

using namespace std;

// 메뉴 출력
void printMenu()
{
	cout << "========================================\n";
	cout << "	MySQL CRUD 예제 \n";
	cout << "========================================\n";
	cout << "1. 조회\n";
	cout << "2. 추가\n";
	cout << "3. 수정\n";
	cout << "4. 삭제\n";
	cout << "5. 종료\n";
	cout << "선택 > ";
}

// 입력 버퍼 클리어
void clearInput()
{
	cin.clear();
	cin.ignore(numeric_limits<streamsize>::max(), '\n');
}

// MySQL 접속
MYSQL* connectDB()
{
	MYSQL* conn = mysql_init(NULL); // CONN
	// 초기화 실패
	if (conn == NULL)
	{
		cerr << "MySQL 초기화 실패" << endl;
		return NULL; // 함수 탈출
	}

	// 접속 시도
	conn = mysql_real_connect(
		conn,
		"127.0.0.1",
		"madang",
		"madang",
		"madangdb",
		3306,
		NULL,
		0
	);
	// 접속실패
	if (conn == NULL)
	{
		cerr << "MySQL 접속 실패 : " << mysql_error(conn) << endl;
		return NULL; // 함수 탈출
	}

	// MySQL 서버 문자셋 생략

	return conn;
}

// SELECT 조회함수
void selectBook(MYSQL* conn)
{
	const char* query = "SELECT bookid, bookname, publisher, price FROM Book";

	if (mysql_query(conn, query) != 0)
	{
		cerr << "SELECT 에러 : " << mysql_error(conn) << endl;
		return;
	}

	MYSQL_RES* result = mysql_store_result(conn);
	if (result == NULL)
	{
		cerr << "Result 에러 : " << mysql_error(conn) << endl;
		return;
	}
	
	MYSQL_ROW row;

	cout << "\n========================================\n";
	cout << "		도서정보\n";
	cout << "\n========================================\n";
	cout << "bookid\tbookname\t\t\tpublisher\t\tprice\n";
	cout << "\n----------------------------------------\n";

	int columnCount = 4;
	while ((row=mysql_fetch_row(result)) != NULL)
	{
		for (int i = 0; i < columnCount; i++)
		{
			cout << (row[i] ? row[i] : "NULL");
			
			if (i != columnCount - 1)
			{
				if (row[i]) for (int j = 0; j <= 3-((strlen(row[i]) -1) / 8); j++) cout << '\t';
				else "\t";
			}
			else
			{
				cout << '\n';
				/*if(row[i])for (int j = 0; j <= (strlen(row[i]) / 8); j++) cout <<;
				else "\n";*/
			}
		}
		//cout << row[0] << '\t' << row[1] << "\t\t\t" << row[2] << "\t\t" << (row[3] ? row[3] : "NULL") << endl;
		
	}
	cout << endl;

}

// INSERT 실행함수
void insertBook(MYSQL* conn)
{
	int bookid; // PK Autoincrement면 필요없음
	string bookname;
	string publisher;
	int price;

	clearInput();
	cout << "\nbookid > ";
	cin >> bookid; clearInput();
	// 숫자 입력시 cin.fail 처리필요

	cout << "bookname > ";
	getline(cin, bookname);

	cout << "publisher > ";
	getline(cin, publisher); 

	cout << "price > ";
	cin >> price; clearInput();

	// bookid, price int형, to_string()으로 형변환
	string query = "INSERT INTO Book VALUES (" + to_string(bookid) + ", '" + bookname + "', '" + publisher + "', " + to_string(price) + ")";

	if (mysql_query(conn, query.c_str()) != 0)
	{
		cerr << "INSERT 에러 : " << mysql_error(conn) << endl;
		return;
	}

	cout << mysql_affected_rows(conn) << "건 INSERT 완료\n\n";
}

// UPDATE 실행함수
void updateBook(MYSQL* conn)
{
	string bookid;
	string bookname;
	string publisher;
	string price;

	clearInput();

	cout << "\nbookid > ";
	getline(cin, bookid);

	cout << "bookname > ";
	getline(cin, bookname);

	cout << "publisher > ";
	getline(cin, publisher);

	cout << "price > ";
	getline(cin, price);

	string query = "UPDATE madangdb.Book SET bookname = '"
		+ bookname + "', publisher = '"
		+ publisher + "', price = "
		+ price + " WHERE bookid = " + bookid;

	if (mysql_query(conn, query.c_str()) != 0)
	{
		cerr << "UPDATE 에러 : " << mysql_error(conn) << endl;
		return;
	}

	uint64_t count = mysql_affected_rows(conn);

	if (count == 0)
	{
		cout << "해당 bookid가 없습니다.";
	}
	else
	{
		cout << count << "건 UPDATE 완료" << endl;
	}
}

// UPDATE 실행함수
void deleteBook(MYSQL* conn)
{
	string bookid;

	clearInput();
	cout << "\nbookid > ";
	getline(cin, bookid);

	string query = "DELETE FROM Book WHERE bookid = " + bookid;

	if (mysql_query(conn, query.c_str()) != 0)
	{
		cerr << "DELETE 에러 : " << mysql_error(conn) << endl;
		return;
	}

	uint64_t count = mysql_affected_rows(conn);

	if (count == 0)
	{
		cout << "해당 bookid 데이터가 없습니다.";
	}
	else
	{
		cout << count << "건 DELETE 완료" << endl;
	}
}

int main()
{
	//콘솔 UTF-8 설정
	SetConsoleOutputCP(CP_UTF8);
	SetConsoleCP(CP_UTF8);
	setlocale(LC_ALL, ".UTF8");

	// DB연결
	MYSQL* conn = connectDB();
	if (conn == NULL) return 1;

	cout << "MySQL 연결 성공!\n";

	while (true)
	{
		int menu = 0;

		// 메뉴출력
		printMenu();
		cin >> menu;

		// 숫자 이외 잘못된 입력
		if (cin.fail())
		{
			clearInput();
			cout << "메뉴는 숫자로 입력\n\n";
			continue;
		}

		switch (menu)
		{
		case 1:
			// SELECT
			//cout << "조회 실행" << endl;
			selectBook(conn);
			break;
		case 2:
			// INSERT
			//cout << "추가 실행" << endl;
			insertBook(conn);
			break;
		case 3:
			// UPDATE
			//cout << "수정 실행" << endl;
			updateBook(conn);
			break;
		case 4:
			// DELETE
			//cout << "삭제 실행" << endl;
			deleteBook(conn);
			break;
		case 5: // 프로그램 종료
			// 접속종료
			cout << "프로그램 종료" << endl;
			mysql_close(conn);
			return 0;
		default:
			cout << "잘못된 메뉴\n\n";
			break;
		}
	}

	// 연결종료
	mysql_close(conn);
	return 0;
}

