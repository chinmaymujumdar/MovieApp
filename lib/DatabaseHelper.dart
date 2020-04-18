import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:movies_app/model_classes/FavouriteModel.dart';

class DatabaseHelper{
  static final DatabaseHelper _mInstance=DatabaseHelper._internal();
  Database _db;

  DatabaseHelper._internal();

  factory DatabaseHelper(){
    return _mInstance;
  }

  Future<Database> get db async{
    if(_db==null){
      _db=await _initDB();
    }
    return _db;
  }

  _initDB() async{
    return openDatabase(join(
        await getDatabasesPath(),'favourite_db'),
      onCreate: _create,
      version: 1
    );
  }

  _create(Database db,int version) async{
    await db.execute("CREATE TABLE favourite(id INTEGER PRIMARY KEY,title TEXT,voteAverage REAL,genreIds TEXT,releaseDate TEXT,overview TEXT,posterPath TEXT,backdropPath TEXT)");
  }

  Future<int> insertFavourite(FavouriteModel model) async{
    var dbClient=await db;
    int res=await dbClient.insert('favourite', model.toMap());
    return res;
  }

  Future<List<FavouriteModel>> getFavourites() async{
    var dbClient=await db;
    List<Map> list=await dbClient.rawQuery('SELECT * FROM favourite');
    print(list.toString());
  }
}