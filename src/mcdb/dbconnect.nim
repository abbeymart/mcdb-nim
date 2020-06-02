#
#              mconnect solutions
#        (c) Copyright 2020 Abi Akindele (mconnect.biz)
#
#    See the file "LICENSE.md", included in this
#    distribution, for details about the copyright / license.
# 
#             Db Connection Constructor
#

## Db Connection constructor for Postgres, MySQL and Sqlite...
## More to be added later - MongoDb...
## 
import db_postgres

type
    Database* = ref object
        db*: DbConn

    DbSecureType* = object
        secureAccess*: bool
        secureCert*: string
        secureKey*: string
    DbOptionType* = object
        fileName*: string
        hostName*: string
        hostUrl*: string
        userName*: string
        password*: string
        dbName*: string
        port*: uint
        dbType*: string
        poolSize*: uint
        secureOption*: DbSecureType

var defaultSecureOption = DbSecureType(secureAccess: false)

var defaultOptions = DbOptionType(fileNaMe: "testdb.db", hostName: "localhost",
                                hostUrl: "localhost:5432",
                                userName: "abbeymart", password: "ab12trust",
                                dbName: "mccentral", port: 5432,
                                dbType: "postgres", poolSize: 20,
                                secureOption: defaultSecureOption )
# database constructor
proc newDatabase*(options: DbOptionType = defaultOptions): Database =
    new result
    case options.dbType
    of ["postgres"]:
      # var dbHostConnection = "host=localhost port=5432 dbname=mydb"
      # var pgHostConnection = "host=" & options.hostName & " port=" & $options.port & " dbname=" & options.dbName
      # TODO: include the TLS/secure and pgdb options
      result.db = open(options.hostUrl, options.userName, options.password, options.dbName )
      # result.db = open(options.hostName, options.userName, options.password, options.dbName)
    of ["mysql"]:
      result.db = open(options.hostName, options.userName, options.password, options.dbName)
    of ["sqlite"]:
      result.db = open(options.fileName, "", "", "")

proc close*(database: Database) =
    database.db.close()

when isMainModule:
  try:
    let dbConnect = newDatabase()
    # echo "db-response-status: ", dbConnect.db.status
    doAssert $dbConnect.db.status ==  "CONNECTION_OK"
    dbConnect.db.close()
  except:
    echo "error opening DB Connection: ", getCurrentExceptionMsg()
