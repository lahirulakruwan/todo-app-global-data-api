import ballerinax/mysql;
import ballerinax/mysql.driver as _;

# Database user
configurable string USER = ?;
# Database password
configurable string PASSWORD = ?;
# Database host
configurable string HOST = ?;
# Database port
configurable int PORT = ?;
# Database name
configurable string DATABASE = ?;

# MySQL database client
final mysql:Client db_client = check new (host = HOST, user = USER, password = PASSWORD, port = PORT, database = DATABASE);

// mysql:Client db_client = check new (host = HOST, port = PORT, user = USER, password = PASSWORD, database = DATABASE, options = {
//         ssl: {
//             mode: mysql:SSL_PREFERRED
//         },
//         serverTimezone: "Asia/Calcutta"
//     });

