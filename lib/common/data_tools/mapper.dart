abstract class Mapper<Data, Domain> {
  Domain toDomain(Data data);

  Data toData(Domain data);

  Data dataFromMap(Map<String, dynamic> data);
}
