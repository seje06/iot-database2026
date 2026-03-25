
#include <iostream>
#include <mysql.h>
#include <windows.h> // 콘솔처리
#include <clocale> // 국가언어관련 Code Page(CP) CP949(한글)

using namespace std;

int main()
{
    // 콘솔을 UTF-8로 설정
    SetConsoleOutputCP(CP_UTF8);
    SetConsoleCP(CP_UTF8);
    setlocale(LC_ALL, ".UTF8");

    // 필요변수 선언
    MYSQL Conn; // DB연결을 위한 구조체
    MYSQL* ConnPtr = NULL; // 연결포인터. 연결이후 사용할 포인터변수
    MYSQL_ROW Row; // 한행 데이터 담는 변수
    MYSQL_RES* Result = NULL; // 한행 결과값 포인터
    int Stat; // 상태값

    // 클라이언트 정보 확인
    cout << mysql_get_client_info() << '\n';

    // MySQL 초기화
    mysql_init(&Conn); // 연결객체를 초기화

    // 아래의 정보로 MySQL 서버에 접속 시도
    ConnPtr = mysql_real_connect(&Conn, "127.0.0.1", "madang", "madang", "madangdb", 3306, NULL, 0);

    // 접속이 실패하면
    if (ConnPtr == NULL)
    {
        cerr << "MySQL 연결 실패 : " << mysql_error(&Conn) << endl;
        return 1;
    }

    cout << "MySQL 연결 성공!" << endl;

    // MySQL 서버쪽 문자셋 UTF-8로 설정
    if (mysql_set_character_set(ConnPtr, "utf8mb4") != 0)
    {
        cerr << "MySQL 문자셋 설정 실패 : " << mysql_error(ConnPtr) << endl;
        mysql_close(ConnPtr); //접속 종료
        return 1;
    }

    // madangdb의 Book 테이블 SELECT
    const char* Query = "SELECT bookid, bookname, publisher, price "
                        "FROM madangdb.Book;";
    Query = R"(SELECT bookid, bookname, publisher, price 
        FROM madangdb.Book;)";
    Stat = mysql_query(ConnPtr, Query);

    // 쿼리실행 오류나면 Stat이 0이외 값이 들어감
    if (Stat != 0)
    {
        cerr << "MySQL쿼리 실패 : " << mysql_error(ConnPtr) << endl;
        mysql_close(ConnPtr); //접속 종료
        return 1;
    }

    cout << "MySQL 쿼리 성공!" << endl;
    
    Result = mysql_store_result(ConnPtr);
    if (Result == NULL)
    {
        cerr << "MySQL 결과저장 실패 : " << mysql_error(ConnPtr) << endl;
        mysql_close(ConnPtr);
        return 1;
    }

    // 커서중 Fetch만 사용 데이터 로드
    while ((Row = mysql_fetch_row(Result)) != NULL)
    {
        for (int i = 0; i < 4; i++) {
            // 데이터가 NULL이면 "NULL" 출력, 아니면 값 출력
            cout << (Row[i] ? Row[i] : "NULL") << (i < 3 ? ", " : "");
        }
        cout << endl;
    }

    mysql_free_result(Result); // 포인터 메모리해제
    mysql_close(ConnPtr); // 서버연결 끊기

    cout << "MySQL 연결 종료!!" << endl;

    return 0;
}
