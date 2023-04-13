import 'package:flutter_bluesky/db/tables/account.dart';
import 'package:isar/isar.dart';

final Db db = Db();

class Db {
  late Isar isar;

  void open() async {
    isar = await Isar.open([AccountSchema]);
  }

  void close() async {
    isar.close();
  }

  Future<void> saveAccount(String provider, String email, String password,
      Map<String, dynamic> res) async {
    Account account = await findOrCreateAccount(provider, res["did"]);
    account.email = email;
    account.handle = res["handle"];
    account.password = password;
    account.accessJwt = res["accessJwt"];
    account.refreshJwt = res["refreshJwt"];
    await isar.writeTxn(() async {
      await isar.accounts.put(account);
    });
  }

  Future<Account> findOrCreateAccount(String provider, String did) async {
    Account account = Account(provider: provider, did: did);
    Account? find = await findAccount(provider, did);
    if (find != null) {
      account = find;
    }
    return account;
  }

  Future<Account?> findAccount(String provider, String did) async {
    Account? account = await isar.accounts
        .where()
        .filter()
        .providerEqualTo(provider)
        .didEqualTo(did)
        .findFirst();
    return account;
  }

  Future<List<Account>> selectAccounts() async {
    return await isar.accounts.where().findAll();
  }
}
